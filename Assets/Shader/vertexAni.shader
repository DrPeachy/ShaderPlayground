Shader "Shader/vertexAni" {
    Properties {
        _MainTex ("RGB: color, A: Alpha Blend", 2D) = "black" {}
        _HeadScaleParams ("Head scale: Amp, Freq, Phase", Vector) = (0.1, 1, 0, 0.0)
        _TailRotParams ("Tail rot: Amp, Freq, Phase", Vector) = (0.1, 1, 0, 0.0)
        _BodyTransParams ("Body swing: Amp, Freq, Phase", Vector) = (0.1, 1, 0, 0.0)
        _BodyRotParams ("Body rot: Amp, Freq, Phase", Vector) = (0.1, 1, 0, 0.0)
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
            
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "cginc/utils.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0

            // Properties
            uniform sampler2D _MainTex;
            uniform float4 _HeadScaleParams;
            uniform float4 _TailRotParams;
            uniform float4 _BodyTransParams;
            uniform float4 _BodyRotParams;

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
                OscillateScale( v.vertex.xyz, _HeadScaleParams.x * v.color.g, _HeadScaleParams.y, _HeadScaleParams.z);
                OscillateRot( v.vertex.xyz, _TailRotParams.x * v.color.r, _TailRotParams.y, _TailRotParams.z);
                OscillateTrans( v.vertex.xyz, _BodyTransParams.x, _BodyTransParams.y, _BodyTransParams.z);
                OscillateRot( v.vertex.xyz, _BodyRotParams.x * v.color.b, _BodyRotParams.y, _BodyRotParams.z);
                o.pos = UnityObjectToClipPos( v.vertex );
                o.uv0 = v.uv0;
                o.color = v.color;
                return o;
            }
            half4 frag(VertexOutput i) : COLOR {
                half4 var_MainTex = tex2D( _MainTex, i.uv0 );
                return var_MainTex;
            }
            ENDCG
        }
    }

}
