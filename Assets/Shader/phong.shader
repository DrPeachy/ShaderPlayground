Shader "Shader/phong" {
    Properties {
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _SpecularPower ("Specular Power", Range(1, 100)) = 16
        _SpecularColor ("Specular Color", Color) = (1,1,1,1)
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
            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0
            float4 _MainColor;
            float _SpecularPower;
            float4 _SpecularColor;

            struct VertexInput {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float3 nDirWS : TEXCOORD0;
                float3 posWS : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.nDirWS = UnityObjectToWorldNormal( v.normal );
                o.posWS = mul( unity_ObjectToWorld, v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3 nDir = normalize(i.nDirWS);
                float3 lDir = normalize(_WorldSpaceLightPos0.xyz);
                float nDotl = dot(nDir, lDir);
                float diffuse = max(nDotl, 0.0);

                float3 r = reflect(-lDir, nDir);
                float3 v = normalize(_WorldSpaceCameraPos.xyz - i.posWS.xyz);
                float rDotv = max(dot(r, v), 0.0);
                float specular = pow(rDotv, _SpecularPower);

                float3 ambient = _MainColor.rgb * 0.1;
                float3 diffuseColor = _MainColor;
                float3 specularColor = _SpecularColor;
                float3 color = ambient + diffuse * diffuseColor + specular * specularColor;
            
                return float4(color, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}