Shader "Shader/ogre/ogre_base" {
    Properties {
        [Header(Texture)][Space(10)]
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _MaskTex ("R: TintByBase G: Rim B: Spec Pow[0, 1] A: Spec Mask", 2D) = "black" {}
            _FresWrapTex ("fresnel R: Col G: Rim B: Spec A: Diff", 2D) = "grey" {}
            _DiffWrapTex ("DiffWrap", 2D) = "grey" {}
            [NORMAL]_NormalTex ("NormalMap", 2D) = "bump" {}
            _MetalMask ("MetalMask", 2D) = "black" {}
            _EmitMask ("EmitMask", 2D) = "black" {}
            _CubeMap ("CubeMap", Cube) = "_Skybox" {}
        
        [Header(DirDiffuse)][Space(10)]
            _LightCol ("Light Color", Color) = (1,1,1,1)

        [Header(DirSpecular)][Space(10)]
            _SpecInt ("Specular Intensity高光强弱", Range(0, 10)) = 0.5
            [PowerSlider(2.0)]_SpecPow ("Specular Power高光次幂（范围）", Range(0, 100)) = 16
        
        [Header(EnvDiffuse)][Space(10)]
            _EnvDiffInt ("Env Diff Intensity", Range(0, 1)) = 0.2

        [Header(EnvSpecular)][Space(10)]
            _EnvSpecInt ("Env Spec Intensity", Range(0, 5)) = 0.5
            _FresnelPow ("Fresnel Power", Range(0, 5)) = 1

        [Header(Emission)][Space(10)]
            _EmitInt ("Emission Intensity", Range(0, 1)) = 0.5

        [Header(RimLight)][Space(10)]
            [HDR]_RimCol ("Rim Color", Color) = (1,1,1,1)

    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "../cginc/utils.cginc"

            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0

            // Properties
            sampler2D _MainTex;
            sampler2D _MaskTex;
            sampler2D _FresWrapTex;
            sampler2D _DiffWrapTex;
            sampler2D _NormalTex;
            sampler2D _MetalMask;
            sampler2D _EmitMask;
            samplerCUBE _CubeMap;

            // direct lighting diffuse
            uniform half3 _LightCol;

            // direct lighting specular
            uniform half _SpecInt;
            uniform half _SpecPow;
            
            // env lighting diffuse
            uniform half3 _EnvCol;
            uniform half _EnvDiffInt;

            // env lighting specular
            uniform half3 _EnvSpecInt;

            // rim lighting
            uniform half3 _RimCol;

            // emission
            uniform half _EmitInt;

            struct VertexInput {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 posWS : TEXCOORD1;
                half3 nDirWS : TEXCOORD2;
                half3 tDirWS : TEXCOORD3;
                half3 bDirWS : TEXCOORD4;
                LIGHTING_COORDS(5, 6)
            };


            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.posWS = mul( unity_ObjectToWorld, v.vertex );
                o.uv0 = v.uv0;
                o.nDirWS = UnityObjectToWorldNormal( v.normal );
                o.tDirWS = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
                o.bDirWS = normalize(cross( o.nDirWS, o.tDirWS ) * v.tangent.w);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            float4 frag(VertexOutput i) : COLOR {
                // Preparation
                half3 nDirTS = UnpackNormal(tex2D(_NormalTex, i.uv0)).rgb;
                half3x3 tbn = float3x3(i.tDirWS, i.bDirWS, i.nDirWS);
                half3 nDirWS = normalize( mul(nDirTS, tbn));

                half3 lDirWS = normalize(_WorldSpaceLightPos0.xyz);
                half3 lrDirWS = reflect(-lDirWS, nDirWS);
                half3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - i.posWS.xyz);
                half3 vrDirWS = reflect(-vDirWS, nDirWS);

                // dot products
                half nDotl = max(dot(nDirWS, lDirWS), 0.0);
                half lrDotv = max(dot(lrDirWS, vDirWS), 0.0);
                half nDotv = dot(nDirWS, vDirWS);

                // texture sampling
                half3 var_MainTex = tex2D(_MainTex, i.uv0);
                half4 var_MaskTex = tex2D(_MaskTex, i.uv0);
                half3 var_FresWrapTex = tex2D(_FresWrapTex, nDotv).rgb;
                half var_MetalMask = tex2D(_MetalMask, i.uv0).r;
                half var_EmitMask = tex2D(_EmitMask, i.uv0).r;
                half3 var_Cubemap = texCUBElod(_CubeMap, float4(vrDirWS, lerp(8.0, 0.0, var_MaskTex.b))).rgb;
                
                // color pass extraction
                half metalic = var_MetalMask;
                half3 baseCol = var_MainTex.rgb;
                half specTint = var_MaskTex.r;
                half rim = var_MaskTex.g;
                half specPow = var_MaskTex.b;
                half specInt = var_MaskTex.a;
                half3 fresnel = lerp(var_FresWrapTex, 0, metalic); // 金属质感越强，fresnel越弱
                half fresCol = fresnel.r;
                half fresRim = fresnel.g;
                half fresSpec = fresnel.b;
                half shadow = LIGHT_ATTENUATION(i);
                
                
                /// 光照模型
                // phong
                half3 diffuseCol = lerp(baseCol, half3(0.0, 0.0, 0.0), metalic);
                half3 specularCol = lerp(half3(0.0, 0.0, 0.0), baseCol, specTint) * specInt;
                
                half halfLambert = 0.5 * nDotl + 0.5; // to sample the ramptex
                half3 var_DiffWrap = tex2D(_DiffWrapTex, half2(tex2D(_DiffWrapTex, halfLambert).r, 0.1));
                half3 diffuse = var_DiffWrap;

                half3 specular = pow(lrDotv, specPow * _SpecPow);
                specular *= max(nDotl, 0.0);
                specular = max(specular, fresSpec);
                specular *= _SpecInt;
                
                half3 dirLighting = (diffuse * diffuseCol + specularCol * specular) * shadow * _LightCol;

                /// environment lighting
                // env diffuse环境漫反射
                half3 envDiff = _EnvCol * diffuseCol * _EnvDiffInt;

                // env specular环境镜面反射
                // float fresnel = pow(1.0 - max(dot(nDirWS, vDirWS), 0.0), _FresnelPow);
                // float3 envSpec = var_Cubemap * _EnvSpecInt * fresnel;
                
                // // env lighting
                // float3 envLighting = (envDiff + envSpec) * var_Occlusion;

                // // emission
                // float3 emission = var_EmitTex * _EmitInt;
                
                // // final color
                // float3 finalColor = dirLighting + envLighting + emission;
                return half4(dirLighting, 1.0);
                
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}