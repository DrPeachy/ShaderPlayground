Shader "Shader/alphaCutout" {
    Properties {
        _MainTex ("RGB: color, A: Alpha Cutout", 2D) = "white" {}
        _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "RenderType"="TransparentCutout"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
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
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Cutoff;

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
                half opacity = var_MainTex.a;
                clip( opacity - _Cutoff );
                return var_MainTex;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}