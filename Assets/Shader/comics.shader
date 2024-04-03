// Shader created with Shader Forge v1.40 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.40;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,cpap:True,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:33107,y:33146,varname:node_3138,prsc:2|emission-885-OUT;n:type:ShaderForge.SFN_Color,id:7241,x:32471,y:32812,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_7241,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.07843138,c2:0.3921569,c3:0.7843137,c4:1;n:type:ShaderForge.SFN_Depth,id:5568,x:32124,y:33055,varname:node_5568,prsc:2;n:type:ShaderForge.SFN_Multiply,id:2388,x:32304,y:32986,varname:node_2388,prsc:2|A-4684-UVOUT,B-5568-OUT;n:type:ShaderForge.SFN_ScreenPos,id:4684,x:32124,y:32899,varname:node_4684,prsc:2,sctp:1;n:type:ShaderForge.SFN_Tex2d,id:8392,x:32472,y:33008,ptovrint:False,ptlb:strip,ptin:_strip,varname:node_8392,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:40d86147ccea9d84189a5364031e7254,ntxv:0,isnm:False|UVIN-2388-OUT;n:type:ShaderForge.SFN_NormalVector,id:3042,x:32118,y:33420,prsc:2,pt:False;n:type:ShaderForge.SFN_LightVector,id:4222,x:32118,y:33566,varname:node_4222,prsc:2;n:type:ShaderForge.SFN_Dot,id:8289,x:32283,y:33505,varname:node_8289,prsc:2,dt:0|A-3042-OUT,B-4222-OUT;n:type:ShaderForge.SFN_RemapRangeAdvanced,id:5927,x:32542,y:33564,varname:node_5927,prsc:2|IN-8289-OUT,IMIN-1548-X,IMAX-1548-Y,OMIN-1548-Z,OMAX-1548-W;n:type:ShaderForge.SFN_Vector4Property,id:1548,x:32333,y:33658,ptovrint:False,ptlb:node_1548,ptin:_node_1548,varname:node_1548,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:-1,v2:1,v3:0,v4:1;n:type:ShaderForge.SFN_Step,id:5434,x:32586,y:33323,varname:node_5434,prsc:2|A-8392-RGB,B-8289-OUT;n:type:ShaderForge.SFN_Lerp,id:885,x:32924,y:33242,varname:node_885,prsc:2|A-2717-RGB,B-8736-RGB,T-2007-OUT;n:type:ShaderForge.SFN_Color,id:8736,x:32681,y:33167,ptovrint:False,ptlb:light_color,ptin:_light_color,varname:node_8736,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.9245283,c2:0.8678355,c3:0.8678355,c4:1;n:type:ShaderForge.SFN_Color,id:2717,x:32706,y:32993,ptovrint:False,ptlb:dark_color,ptin:_dark_color,varname:_light_color_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.245283,c2:0.1029726,c3:0.1029726,c4:1;n:type:ShaderForge.SFN_Step,id:9441,x:32758,y:33518,varname:node_9441,prsc:2|A-2244-OUT,B-5927-OUT;n:type:ShaderForge.SFN_Slider,id:2244,x:32486,y:33736,ptovrint:False,ptlb:specular_range,ptin:_specular_range,varname:node_2244,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.9288961,max:1;n:type:ShaderForge.SFN_Max,id:2007,x:32924,y:33447,varname:node_2007,prsc:2|A-5434-OUT,B-9441-OUT;proporder:7241-8392-1548-8736-2717-2244;pass:END;sub:END;*/

Shader "Shader Forge/comics" {
    Properties {
        _Color ("Color", Color) = (0.07843138,0.3921569,0.7843137,1)
        _strip ("strip", 2D) = "white" {}
        _node_1548 ("node_1548", Vector) = (-1,1,0,1)
        _light_color ("light_color", Color) = (0.9245283,0.8678355,0.8678355,1)
        _dark_color ("dark_color", Color) = (0.245283,0.1029726,0.1029726,1)
        _specular_range ("specular_range", Range(0, 1)) = 0.9288961
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0
            uniform sampler2D _strip; uniform float4 _strip_ST;
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float4, _node_1548)
                UNITY_DEFINE_INSTANCED_PROP( float4, _light_color)
                UNITY_DEFINE_INSTANCED_PROP( float4, _dark_color)
                UNITY_DEFINE_INSTANCED_PROP( float, _specular_range)
            UNITY_INSTANCING_BUFFER_END( Props )
            struct VertexInput {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                float4 projPos : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
////// Emissive:
                float4 _dark_color_var = UNITY_ACCESS_INSTANCED_PROP( Props, _dark_color );
                float4 _light_color_var = UNITY_ACCESS_INSTANCED_PROP( Props, _light_color );
                float2 node_2388 = (float2((sceneUVs.x * 2 - 1)*(_ScreenParams.r/_ScreenParams.g), sceneUVs.y * 2 - 1).rg*partZ);
                float4 _strip_var = tex2D(_strip,TRANSFORM_TEX(node_2388, _strip));
                float node_8289 = dot(i.normalDir,lightDirection);
                float3 node_5434 = step(_strip_var.rgb,node_8289);
                float _specular_range_var = UNITY_ACCESS_INSTANCED_PROP( Props, _specular_range );
                float4 _node_1548_var = UNITY_ACCESS_INSTANCED_PROP( Props, _node_1548 );
                float3 emissive = lerp(_dark_color_var.rgb,_light_color_var.rgb,max(node_5434,step(_specular_range_var,(_node_1548_var.b + ( (node_8289 - _node_1548_var.r) * (_node_1548_var.a - _node_1548_var.b) ) / (_node_1548_var.g - _node_1548_var.r)))));
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
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma target 3.0
            uniform sampler2D _strip; uniform float4 _strip_ST;
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float4, _node_1548)
                UNITY_DEFINE_INSTANCED_PROP( float4, _light_color)
                UNITY_DEFINE_INSTANCED_PROP( float4, _dark_color)
                UNITY_DEFINE_INSTANCED_PROP( float, _specular_range)
            UNITY_INSTANCING_BUFFER_END( Props )
            struct VertexInput {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                float4 projPos : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
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
