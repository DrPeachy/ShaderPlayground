Shader "Shader/shadow" {
    Properties {
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
            struct VertexInput {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float3 nDirWS : TEXCOORD0;
                LIGHTING_COORDS(1, 2)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.nDirWS = UnityObjectToWorldNormal( v.normal );
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float shadow = LIGHT_ATTENUATION(i);
                
                return float4(shadow, shadow, shadow, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}