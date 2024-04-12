Shader "Shader/oldFashion2" {
    Properties {
        [Header(Texture)]
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _NormalTex ("NormalMap", 2D) = "bump" {}
            _SpecTex ("SpecularMap", 2D) = "grey" {}
            [Toggle(_isSpecOn)] _isSpecOn("is Specular Color on", Float) = 1
            _EmitTex ("EmitMap", 2D) = "black" {}
            [Toggle(_isEmitOn)] _isEmitOn("is Emit on", Float) = 0
            _CubeMap ("CubeMap", Cube) = "_Skybox" {}
            _Occlusion("Occlusion", 2D) = "white" {}
        
        [Header(Diffuse)]
            _MainCol ("Main Color", Color) = (1,1,1,1)
            _EnvDiffInt ("Env Diff Intensity", Range(0, 1)) = 0.2
            _EnvUpCol("Up Color", Color) = (1,1,1,1)
            _EnvDownCol("Down Color", Color) = (1,1,1,1)
            _EnvSideCol("Side Color", Color) = (1,1,1,1)
            _EnColWeakness("3 Color var_MainTex Weakness", Range(0, 1)) = 0.5

        [Header(Specular)]
            _SpecPow ("Specular Power", Range(1, 100)) = 16
            _SpecCol ("Specular Color", Color) = (1,1,1,1)
            _EnvSpecInt ("Env Spec Intensity", Range(0, 5)) = 0.5
            _FresnelPow ("Fresnel Power", Range(0, 5)) = 1
            _CubeMapMip ("CubeMapMip", Range(0, 7)) = 0

        [Header(Emission)]
            _EmitCol ("Emission Color", Color) = (1,1,1,1)
            _EmitInt ("Emission Intensity", Range(0, 1)) = 0.5
        [Header(Shadow)]
            _ShadowInt("Shadow Intensity", Range(0, 0.5)) = 0
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

            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0

            // Properties
            uniform sampler2D _Occlusion;
            uniform sampler2D _MainTex;
            uniform sampler2D _NormalTex;
            uniform sampler2D _SpecTex;
            uniform sampler2D _EmitTex;
            uniform samplerCUBE _CubeMap;

            uniform float4 _EnvUpCol;
            uniform float4 _EnvDownCol;
            uniform float4 _EnvSideCol;
            uniform float _EnColWeakness;

            uniform float4 _MainCol;
            uniform float _SpecPow;
            uniform float4 _SpecCol;

            uniform float _CubeMapMip;
            uniform float _FresnelPow;
            uniform float _EnvSpecInt;

            uniform float _ShadowInt;

            uniform float _EmitInt;
            uniform float4 _EmitCol;

            uniform float _EnvDiffInt;

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
                float3 nDirWS : TEXCOORD2;
                float3 tDirWS : TEXCOORD3;
                float3 bDirWS : TEXCOORD4;
                LIGHTING_COORDS(4, 5)
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
                float3 nDirTS = UnpackNormal(tex2D(_NormalTex, i.uv0)).rgb;
                float3x3 tbn = float3x3(i.tDirWS, i.bDirWS, i.nDirWS);
                float3 nDirWS = normalize( mul(nDirTS, tbn));

                float3 lDirWS = normalize(_WorldSpaceLightPos0.xyz);
                float3 lrDirWS = reflect(-lDirWS, nDirWS);
                float3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - i.posWS.xyz);
                float3 vrDirWS = reflect(-vDirWS, nDirWS);

                // dot products
                float nDotl = max(dot(nDirWS, lDirWS), 0.0);
                float lrDotv = max(dot(lrDirWS, vDirWS), 0.0);
                float nDotv = dot(nDirWS, vDirWS);
                float nDotV = dot(nDirWS, vDirWS);

                // texture sampling
                float3 var_MainTex = tex2D(_MainTex, i.uv0);
                float4 var_SpecTex = _SpecCol;
                float3 var_EmitTex = tex2D(_EmitTex, i.uv0);
                float var_Occlusion = tex2D(_Occlusion, i.uv0);
                float cubemapMip = lerp(_CubeMapMip, 1.0, var_SpecTex.a);
                float3 var_Cubemap = texCUBElod(_CubeMap, float4(vrDirWS, _CubeMapMip)).rgb;

                /// Emission
                // phong光源漫反射
                float diffuse = max(nDotl, 0.0);
                float3 diffuseCol = var_MainTex * _MainCol.rgb;
                float specPow = lerp(1.0, _SpecPow, var_SpecTex.a);
                float specular = pow(lrDotv, specPow);
                float specularCol = var_SpecTex.rgb;
                float shadow = clamp( LIGHT_ATTENUATION(i), _ShadowInt, 1.0 );
                float3 dirLighting = (diffuse * diffuseCol + specularCol * specular) * shadow * _LightColor0;

                // 3 color ambient, 环境漫反射
                float upMask = max(0.0, nDirWS.y);
                float downMask = max(0.0, -nDirWS.y);
                float sideMask  = 1 - upMask - downMask;

                float3 envCol = _EnvUpCol * upMask + 
                                _EnvDownCol * downMask + 
                                _EnvSideCol * sideMask;
                envCol = lerp(envCol, float3(1, 1, 1), _EnColWeakness);
                float3 envDiff = envCol * diffuseCol * _EnvDiffInt;

                // env specular环境镜面反射
                float fresnel = pow(1.0 - max(dot(nDirWS, vDirWS), 0.0), _FresnelPow);
                float3 envSpec = var_Cubemap * _EnvSpecInt * fresnel;
                
                // env lighting
                float3 envLighting = (envDiff + envSpec) * var_Occlusion;

                // emission
                float3 emission = var_EmitTex * _EmitInt;
                
                // final color
                float3 finalColor = dirLighting + envLighting + emission;
                return float4(finalColor, 1.0);
                
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}