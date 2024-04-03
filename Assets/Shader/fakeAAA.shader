// Shader created with Shader Forge v1.40 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.40;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,cpap:True,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:33346,y:32824,varname:node_3138,prsc:2|emission-583-RGB,olwid-5073-OUT;n:type:ShaderForge.SFN_NormalVector,id:3289,x:32022,y:32768,prsc:2,pt:False;n:type:ShaderForge.SFN_LightVector,id:7976,x:32022,y:32944,varname:node_7976,prsc:2;n:type:ShaderForge.SFN_Dot,id:230,x:32271,y:32858,varname:node_230,prsc:2,dt:0|A-3289-OUT,B-7976-OUT;n:type:ShaderForge.SFN_Add,id:1975,x:32634,y:32942,varname:node_1975,prsc:2|A-4042-OUT,B-4452-OUT;n:type:ShaderForge.SFN_Vector1,id:4452,x:32344,y:33072,varname:node_4452,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Multiply,id:4042,x:32454,y:32885,varname:node_4042,prsc:2|A-230-OUT,B-4452-OUT;n:type:ShaderForge.SFN_Posterize,id:1428,x:32933,y:32853,varname:node_1428,prsc:2|IN-1975-OUT,STPS-3121-OUT;n:type:ShaderForge.SFN_Vector1,id:3121,x:32807,y:32957,varname:node_3121,prsc:2,v1:9;n:type:ShaderForge.SFN_Vector1,id:5073,x:33002,y:33303,varname:node_5073,prsc:2,v1:0.01;n:type:ShaderForge.SFN_Vector1,id:2207,x:32672,y:33136,varname:node_2207,prsc:2,v1:0.2;n:type:ShaderForge.SFN_Tex2d,id:583,x:33015,y:33069,ptovrint:False,ptlb:node_583,ptin:_node_583,varname:node_583,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:10eb3827d611c474a82220f478192289,ntxv:0,isnm:False|UVIN-986-OUT;n:type:ShaderForge.SFN_Append,id:986,x:32829,y:33053,varname:node_986,prsc:2|A-1975-OUT,B-2207-OUT;n:type:ShaderForge.SFN_If,id:5222,x:32787,y:32698,varname:node_5222,prsc:2;proporder:583;pass:END;sub:END;*/

Shader "Shader Forge/fakeAAA" {
    Properties {
        _node_583 ("node_583", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "Outline"
            Tags {
            }
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma target 3.0
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float node_5073 = 0.01;
                o.pos = UnityObjectToClipPos( float4(v.vertex.xyz + v.normal*node_5073,1) );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                return fixed4(float3(0,0,0),0);
            }
            ENDCG
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
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0
            uniform sampler2D _node_583; uniform float4 _node_583_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                LIGHTING_COORDS(2,3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
////// Emissive:
                float node_4452 = 0.5;
                float node_1975 = ((dot(i.normalDir,lightDirection)*node_4452)+node_4452);
                float2 node_986 = float2(node_1975,0.2);
                float4 _node_583_var = tex2D(_node_583,TRANSFORM_TEX(node_986, _node_583));
                float3 emissive = _node_583_var.rgb;
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma target 3.0
            uniform sampler2D _node_583; uniform float4 _node_583_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                LIGHTING_COORDS(2,3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
////// Lighting:
                float3 finalColor = 0;
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
