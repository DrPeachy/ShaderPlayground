Shader "Shader/normalMap" {
    Properties {
        _NormalMap ("NormalMap", 2D) = "bump" {}
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
            // Properties
            uniform sampler2D _NormalMap;


            struct VertexInput {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 nDirWS : TEXCOORD1;
                float3 tDirWS : TEXCOORD2;
                float3 bDirWS : TEXCOORD3;
            };

            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.uv0 = v.uv0;
                o.nDirWS = UnityObjectToWorldNormal( v.normal );
                o.tDirWS = UnityObjectToWorldDir( v.tangent.xyz );
                o.bDirWS = cross( o.nDirWS, o.tDirWS ) * v.tangent.w;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3 nDirTS = UnpackNormal(tex2D(_NormalMap, i.uv0)); 
                float3x3 tbn = float3x3(i.tDirWS, i.bDirWS, i.nDirWS);
                float3 nDirWS = normalize( mul(nDirTS, tbn));

                float3 lDir = normalize(_WorldSpaceLightPos0.xyz);
                float nDotl = dot(nDirWS, lDir);
                float lambert = max(0.0, nDotl);
                return lambert;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}