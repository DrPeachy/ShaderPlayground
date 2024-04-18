Shader "Shader/sequence" {
    Properties {
        _MainTex ("RGB: color, A: Alpha Blend", 2D) = "grey" {}
        _Opacity ("Opacity", Range(0, 1)) = 1
        _Sequence ("Sequence", 2D) = "black" {}
        _RowNum ("Row Count", Int) = 1
        _ColNum ("Column Count", Int) = 1
        _Speed ("Speed", Range(-10, 10)) = 1
    }
    SubShader {
        Tags {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "ForceNoShadowCasting"="True"
            "IgnoreProjector"="True"
        }
        Pass {
            Name "FORWARD_AB"
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

        Pass {
            Name "FORWARD_AD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            Blend One One
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0

            // Properties
            uniform sampler2D _Sequence; uniform float4 _Sequence_ST;
            uniform half _RowNum;
            uniform half _ColNum;
            uniform half _Opacity;
            uniform half _Speed;

            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                v.vertex.xyz += v.normal * 0.01;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.uv0 = TRANSFORM_TEX( v.uv0, _Sequence );
                float id = floor(frac(_Time.y * _Speed) * _RowNum * _ColNum);
                float row = floor(id / _ColNum);
                float col = id - row * _ColNum;
                float stepU= 1.0 / _ColNum;
                float stepV = 1.0 / _RowNum;
                float2 initialUV = o.uv0 * float2(stepU, stepV) + float2(0.0, stepV * (_RowNum - 1));
                o.uv0 = initialUV + float2(stepU * col, -stepV * row);
                return o;
            }
            half4 frag(VertexOutput i) : COLOR {

                half4 var_Sequence = tex2D( _Sequence, i.uv0 );
                half opacity = var_Sequence.a * _Opacity;
                return half4(var_Sequence.rgb * opacity, opacity);
            }
            ENDCG
        }
    }

}