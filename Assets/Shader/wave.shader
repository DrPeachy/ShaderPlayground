Shader "Unlit/wave"{
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _WarpTex ("Warp Texture", 2D) = "white" {}
        _TexParams ("X: speedx Y: speedy" , vector) = (1, 1, 1, 1)
        _Warp1Params ("X: scale Y: speedx Z: speedy W: intensity", vector) = (1, 1, 1, 1)
        _Warp2Params ("X: scale Y: speedx Z: speedy W: intensity", vector) = (1, 1, 1, 1)

        [HDR]_FoamCol ("Inner Color", Color) = (1,1,1,1)
        [HDR]_WaterCol ("Outer Color", Color) = (1,1,1,1)
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
            uniform sampler2D _WarpTex;
            uniform half4 _TexParams;
            uniform half4 _Warp1Params;
            uniform half4 _Warp2Params;

            uniform half3 _WaterCol;
            uniform half3 _FoamCol;

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
                o.uv0 = v.uv0 * _TexParams.x + frac(_Time.x * _TexParams.xy);
                o.uv1 = o.uv0 * _Warp1Params.x + frac(_Time.x * _Warp1Params.yz);
                o.uv2 = o.uv0 * _Warp2Params.x + frac(_Time.x * _Warp2Params.yz);
                

                return o;
            }
            half4 frag(VertexOutput i) : COLOR {
                half3 var_Warp1 = tex2D(_WarpTex, i.uv1).rgb;
                half3 var_Warp2 = tex2D(_WarpTex, i.uv2).rgb;
                half2 warp = (var_Warp1.xy - 0.5) * _Warp1Params.w + 
                            (var_Warp2.xy - 0.5) * _Warp2Params.w;
                float2 warpUV = i.uv0 + warp.xy;
                half4 var_MainTex = tex2D(_MainTex, warpUV);
                half3 finalRGB = lerp(_FoamCol, _WaterCol, var_MainTex.r);
                return half4(finalRGB, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}