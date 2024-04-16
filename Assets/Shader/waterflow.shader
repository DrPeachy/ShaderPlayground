Shader "Shader/waterflow" {
    Properties {
        _MainTex ("RGB: color, A: Alpha Blend", 2D) = "grey" {}
        _Opacity ("Opacity", Range(0, 1)) = 0.5
        _NoiseTex ("Noise Texture", 2D) = "grey" {}
        _NoiseInt ("Noise Intensity", Range(0, 5)) = 0.5
        _FlowSpeed ("Flow Speed", Range(-10, 10)) = 0.5
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
            Blend One OneMinusSrcAlpha
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0

            // Properties
            uniform sampler2D _MainTex;
            uniform half _Opacity;
            uniform sampler2D _NoiseTex; uniform float4 _NoiseTex_ST;
            uniform half _NoiseInt;
            uniform half _FlowSpeed;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0; // for main texture
                float2 uv1 : TEXCOORD1; // for noise
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.uv0 = v.uv0;
                o.uv1 = TRANSFORM_TEX(v.uv0, _NoiseTex);
                o.uv1.x = o.uv1.x + frac(_Time.x * _FlowSpeed);
                return o;
            }
            half4 frag(VertexOutput i) : COLOR {
                half4 var_MainTex = tex2D( _MainTex, i.uv0 );
                half4 var_NoiseTex = tex2D( _NoiseTex, i.uv1 );

                half noise = lerp(1.0, var_NoiseTex * 2.0, _NoiseInt);
                half opacity = var_MainTex.a * _Opacity * noise;
                return half4(var_MainTex.rgb * opacity, opacity);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}