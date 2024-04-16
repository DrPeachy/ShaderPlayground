Shader "Shader/blendMode" {
    Properties {
        _MainTex ("RGB: color, A: Alpha Blend", 2D) = "grey" {}
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", int) = 0
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", int) = 0
        [Enum(UnityEngine.Rendering.BlendOp)] _BlendOp ("Blend Op", int) = 0
    }
    SubShader {
        Tags {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            BlendOp [_BlendOp]
            Blend [_SrcBlend] [_DstBlend]
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0

            // Properties
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.uv0 = TRANSFORM_TEX( v.uv0, _MainTex );
                return o;
            }
            half4 frag(VertexOutput i) : COLOR {
                half4 var_MainTex = tex2D( _MainTex, i.uv0 );
                return var_MainTex;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}