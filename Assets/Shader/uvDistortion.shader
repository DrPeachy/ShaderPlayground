Shader "Unlit/uvDistortion"{
    Properties {
        _MainTex ("RGB: color, A: Alpha Blend", 2D) = "grey" {}
        _Opacity ("Opacity", Range(0, 1)) = 0.5
        _WarpTex ("Warp Texture - distort", 2D) = "grey" {}
        _WarpInt ("Warp Intensity", Range(0, 1)) = 0.5
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
            uniform sampler2D _WarpTex; uniform float4 _WarpTex_ST;
            uniform half _WarpInt;
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
                o.uv1 = TRANSFORM_TEX(v.uv0, _WarpTex);
                o.uv1.y += frac(_Time.x * _FlowSpeed);
                return o;
            }
            half4 frag(VertexOutput i) : COLOR {
                half3 var_WarpTex = tex2D( _WarpTex, i.uv1 ).rgb;
                float2 uvBias = (var_WarpTex.rg - 0.21) * _WarpInt;
                float2 uv = i.uv0 + uvBias;
                half4 var_MainTex = tex2D( _MainTex, uv );

                half3 finalRGB = var_MainTex.rgb;
                half noise = lerp(1.0, var_WarpTex.b * 2.0, _NoiseInt);
                noise = max(0.0, noise);
                half opacity = var_MainTex.a * _Opacity * noise;
                return half4(finalRGB * opacity, opacity);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}