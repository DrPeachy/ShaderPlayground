Shader "Unlit/3ColAmbient"{
    Properties {
        _EnvUpCol("Up Color", Color) = (1,1,1,1)
        _EnvDownCol("Down Color", Color) = (1,1,1,1)
        _EnvSideCol("Side Color", Color) = (1,1,1,1)
        _Occlusion("Occlusion", 2D) = "white" {}
        [Toggle(_AOon)] _AOon("is AO on", Float) = 1
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
            uniform sampler2D _Occlusion;
            uniform float4 _EnvUpCol;
            uniform float4 _EnvDownCol;
            uniform float4 _EnvSideCol;
            uniform float _AOon;

            struct VertexInput {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float2 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float3 nDirWS : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.nDirWS = UnityObjectToWorldNormal( v.normal );
                o.uv = v.uv0;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3 nDir = normalize(i.nDirWS);

                float upMask = max(0.0, nDir.y);
                float downMask = max(0.0, -nDir.y);
                float sideMask  = 1 - upMask - downMask;

                float3 envCol = _EnvUpCol * upMask + _EnvDownCol * downMask + _EnvSideCol * sideMask;
                float ao = 1.0;
                // Ambient Occlusion
                if(_AOon > 0.5){
                    ao = tex2D(_Occlusion, i.uv);
                }

                return float4(envCol * ao, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}