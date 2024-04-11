Shader "Shader/oldFashion2" {
    Properties {
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
        [Toggle(_isTextureOn)] _isTextureOn("is Texture on", Float) = 1
        _SpecularPower ("Specular Power", Range(1, 100)) = 16
        _SpecularColor ("Specular Color", Color) = (1,1,1,1)

        _EnvUpCol("Up Color", Color) = (1,1,1,1)
        _EnvDownCol("Down Color", Color) = (1,1,1,1)
        _EnvSideCol("Side Color", Color) = (1,1,1,1)
        _Occlusion("Occlusion", 2D) = "white" {}
        [Toggle(_AOon)] _AOon("is AO on", Float) = 1
        _EnColWeakness("AO Weakness", Range(0, 1)) = 0.5

        _CubeMap ("CubeMap", Cube) = "_Skybox" {}
        _CubeMapMip ("CubeMapMip", Range(0, 7)) = 0
        _NormalMap ("NormalMap", 2D) = "bump" {}
        _FresnelPower ("Fresnel Power", Range(0, 5)) = 1
        _EnvSpecIntensity ("Env Spec Intensity", Range(0, 5)) = 0.5

        _ShadowIntensity("Shadow Intensity", Range(0, 0.5)) = 0
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
            uniform float4 _EnvUpCol;
            uniform float4 _EnvDownCol;
            uniform float4 _EnvSideCol;
            uniform float _AOon;
            uniform float _EnColWeakness;

            uniform float4 _MainColor;
            uniform sampler2D _MainTex;
            uniform float _isTextureOn;
            uniform float _SpecularPower;
            uniform float4 _SpecularColor;

            uniform samplerCUBE _CubeMap;
            uniform float _CubeMapMip;
            uniform sampler2D _NormalMap;
            uniform float _FresnelPower;
            uniform float _EnvSpecIntensity;

            uniform float _ShadowIntensity;


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
                float3 nDirTS = UnpackNormal(tex2D(_NormalMap, i.uv0)).rgb;
                float3x3 tbn = float3x3(i.tDirWS, i.bDirWS, i.nDirWS);
                float3 nDirWS = normalize( mul(nDirTS, tbn));

                float3 lDirWS = normalize(_WorldSpaceLightPos0.xyz);
                float3 lrDirWS = reflect(-lDirWS, nDirWS);
                float3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - i.posWS.xyz);
                float3 vrDirWS = reflect(-vDirWS, nDirWS);

                float nDotl = max(dot(nDirWS, lDirWS), 0.0);
                float lrDotv = max(dot(lrDirWS, vDirWS), 0.0);
                float nDotv = dot(nDirWS, vDirWS);
                float nDotV = dot(nDirWS, vDirWS);

                // phong
                float3 ambient = _MainColor.rgb;
                if(_isTextureOn > 0.5){
                    ambient = tex2D(_MainTex, i.uv0);
                }
                float diffuse = max(nDotl, 0.0);
                float specular = pow(lrDotv, _SpecularPower);
                float3 diffuseCol = ambient;
                float3 specularCol = _SpecularColor;
                float3 phongCol = ambient + diffuse * diffuseCol + specularCol * specular;

                // Ambient Occlusion
                float upMask = max(0.0, nDirWS.y);
                float downMask = max(0.0, -nDirWS.y);
                float sideMask  = 1 - upMask - downMask;

                float3 envCol = _EnvUpCol * upMask + _EnvDownCol * downMask + _EnvSideCol * sideMask;
                envCol = lerp(envCol, float3(1, 1, 1), _EnColWeakness);
                float ao = 1.0;
                if(_AOon > 0.5){
                    ao = tex2D(_Occlusion, i.uv0);
                }

                // shadow
                float shadow = clamp( LIGHT_ATTENUATION(i), _ShadowIntensity, 1.0 );
                float4 finalColor = float4(phongCol, 1.0);

                // fresnel
                float fresnel = pow(1.0 - max(dot(nDirWS, vDirWS), 0.0), _FresnelPower) * _EnvSpecIntensity;
                float3 reflection = texCUBElod(_CubeMap, float4(vrDirWS, _CubeMapMip));
                finalColor.rgb = lerp(finalColor.rgb, reflection, fresnel);

                // final color
                finalColor.rgb *= ao;

                // Combine with environmental colors based on the direction of the normals
                finalColor.rgb *= envCol;

                // Apply shadow
                finalColor.rgb *= shadow;

                return float4(finalColor.rgb, 1.0); // Assuming non-transparent material
                
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}