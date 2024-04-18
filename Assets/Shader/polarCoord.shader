Shader "Shader/polarCoord" {
    Properties {
        _MainTex ("RGB: color, A: Alpha Blend", 2D) = "grey" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Opacity ("Opacity", Range(0,1)) = 1
        _Speed ("Speed", Range(-5,5)) = 1
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
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float4 _Color;
            uniform float _Opacity;
            uniform float _Speed;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float4 color : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 color : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.uv0 = TRANSFORM_TEX( v.uv0, _MainTex );
                o.color = v.color;
                return o;
            }
            half4 frag(VertexOutput i) : COLOR {
                // turn uv into polar coordinates
                i.uv0 = i.uv0 - float2(0.5, 0.5);
                float theta = atan2(i.uv0.y, i.uv0.x);
                theta = theta / 3.1415926535897932384626433832795 * 0.5 + 0.5;
                float r = length(i.uv0) + frac(_Time.x * _Speed);
                i.uv0 = float2(theta, r);
                
                half4 var_MainTex = tex2D( _MainTex, i.uv0 );
                half3 finalRGB = (1 - var_MainTex.rgb) * _Color;
                half opacity = (1 - var_MainTex.r) * _Opacity * i.color.r;
                return half4(finalRGB * opacity, opacity);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}