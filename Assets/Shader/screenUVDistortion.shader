Shader "Shader/screenUVDistortion" {
    Properties {
        _MainTex ("RGB: color, A: Alpha Blend", 2D) = "grey" {}
        _Opacity ("Opacity", Range(0, 1)) = 0.5
        _WarpMidVal ("Warp Mid Value", Range(0, 1)) = 0.5
        _WarpInt ("Warp Intensity", Range(0, 2)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
        }
        GrabPass {
            "_BGTex"
        }
        // Forward rendering
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
            uniform float _Opacity;
            uniform float _WarpMidVal;
            uniform float _WarpInt;
            uniform sampler2D _BGTex;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 grabPos : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.uv0 = v.uv0;
                o.grabPos = ComputeGrabScreenPos( o.pos );
                return o;
            }
            half4 frag(VertexOutput i) : COLOR {
                half4 var_MainTex = tex2D( _MainTex, i.uv0 );
                i.grabPos.xy += (var_MainTex.b - _WarpMidVal) * _WarpInt * _Opacity;
                half3 var_BGTex = tex2Dproj( _BGTex, i.grabPos ).rgb;
                half3 finalRGB = lerp( 1.0, var_MainTex.rgb, _Opacity) * var_BGTex;
                half opacity = var_MainTex.a;
                return half4(finalRGB * opacity, opacity);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}