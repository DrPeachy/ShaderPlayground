Shader "Shader/oldFashion" {
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

            uniform float _ShadowIntensity;


            struct VertexInput {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float2 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWS : TEXCOORD1;
                float3 nDirWS : TEXCOORD2;
                float2 uv : TEXCOORD3;
                LIGHTING_COORDS(4, 5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.posWS = mul( unity_ObjectToWorld, v.vertex );
                o.nDirWS = UnityObjectToWorldNormal( v.normal );
                o.uv = v.uv0;
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3 nDir = normalize(i.nDirWS);
                float3 lDir = normalize(_WorldSpaceLightPos0.xyz);
                float nDotl = max(dot(nDir, lDir), 0.0);

                float3 r = reflect(-lDir, nDir);
                float3 v = normalize(_WorldSpaceCameraPos.xyz - i.posWS.xyz);
                float rDotv = max(dot(r, v), 0.0);

                // phong
                float3 ambient = _MainColor.rgb;
                if(_isTextureOn > 0.5){
                    ambient = tex2D(_MainTex, i.uv);
                }
                float diffuse = max(nDotl, 0.0);
                float specular = pow(rDotv, _SpecularPower);
                float3 diffuseCol = ambient;
                float3 specularCol = _SpecularColor;
                float3 phongCol = ambient + diffuse * diffuseCol + specularCol * specular;

                // Ambient Occlusion
                float upMask = max(0.0, nDir.y);
                float downMask = max(0.0, -nDir.y);
                float sideMask  = 1 - upMask - downMask;

                float3 envCol = _EnvUpCol * upMask + _EnvDownCol * downMask + _EnvSideCol * sideMask;
                envCol = lerp(envCol, float3(1, 1, 1), _EnColWeakness);
                float ao = 1.0;
                if(_AOon > 0.5){
                    ao = tex2D(_Occlusion, i.uv);
                }

                // shadow
                float shadow = clamp( LIGHT_ATTENUATION(i), _ShadowIntensity, 1.0 );

                // final color
                float4 finalColor = float4(phongCol, 1.0) * shadow;
                // Apply ambient occlusion
                finalColor.rgb *= ao;

                // Combine with environmental colors based on the direction of the normals
                finalColor.rgb *= envCol;

                return float4(finalColor.rgb, 1.0); // Assuming non-transparent material
                
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}