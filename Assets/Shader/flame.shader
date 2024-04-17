Shader "Unlit/flame"{
    Properties {
        _Mask ("R: out flame G: inner flame a: alpha", 2D) = "blue" {}
        _Noise ("R: Noise1 G: Noise2 ", 2D) = "grey" {}
        _Noise1Params ("X: scale Y: speed Z: intensity", vector) = (1, 0.03, 1, 1)
        _Noise2Params ("X: scale Y: speed Z: intensity", vector) = (1, 0.03, 1, 1)

        [HDR]_InnerCol ("Inner Color", Color) = (1,1,1,1)
        [HDR]_OuterCol ("Outer Color", Color) = (1,1,1,1)
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
            uniform sampler2D _Mask;
            uniform sampler2D _Noise;
            uniform half3 _Noise1Params;
            uniform half3 _Noise2Params;

            uniform half4 _InnerCol;
            uniform half4 _OuterCol;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0; // for mask
                float2 uv1 : TEXCOORD1; // for noise1
                float2 uv2 : TEXCOORD2; // for noise2
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.uv0 = v.uv0;
                o.uv1 = o.uv0 * _Noise1Params.x + float2(0.0, frac(_Time.x * _Noise1Params.y)) ;
                o.uv2 = o.uv0 * _Noise2Params.x + float2(0.0, frac(_Time.x * _Noise2Params.y)) ;
                

                return o;
            }
            half4 frag(VertexOutput i) : COLOR {
                half var_Noise1 = tex2D(_Noise, i.uv1).r;
                half var_Noise2 = tex2D(_Noise, i.uv2).g;
                half noiseStrength = saturate(lerp(-0.01, 0.6, i.uv0.y));
                half noise = (var_Noise1 * _Noise1Params.z + var_Noise2 * _Noise2Params.z ) * noiseStrength;

                float2 warpUV = i.uv0 - float2(0.0, noise);
                half3 var_Mask = tex2D(_Mask, warpUV).rgb;
                half3 finalRGB = var_Mask.g * _InnerCol + var_Mask.r * _OuterCol;
                half opacity = var_Mask.b;
                return half4(finalRGB, 1- opacity);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}