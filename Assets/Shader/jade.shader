// Shader created with Shader Forge v1.40 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.40;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,cpap:True,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:33922,y:32870,varname:node_3138,prsc:2|emission-856-OUT,olwid-3834-OUT;n:type:ShaderForge.SFN_Color,id:7241,x:32919,y:32836,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_7241,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5195943,c2:1,c3:0.4103774,c4:1;n:type:ShaderForge.SFN_Tex2d,id:3648,x:32714,y:33144,ptovrint:False,ptlb:rampTex,ptin:_rampTex,varname:node_3648,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:5d28c3cdc9826e24abd2b772afd7e6d1,ntxv:0,isnm:False|UVIN-3251-OUT;n:type:ShaderForge.SFN_Multiply,id:9529,x:33163,y:32836,varname:node_9529,prsc:2|A-7241-RGB,B-8530-OUT;n:type:ShaderForge.SFN_Multiply,id:8530,x:32946,y:33200,varname:node_8530,prsc:2|A-3648-RGB,B-9085-OUT;n:type:ShaderForge.SFN_Slider,id:9085,x:32492,y:33323,ptovrint:False,ptlb:darkness_factor,ptin:_darkness_factor,varname:node_9085,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1.814604,max:3;n:type:ShaderForge.SFN_LightVector,id:7572,x:32136,y:32666,varname:node_7572,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:1953,x:32138,y:32479,prsc:2,pt:False;n:type:ShaderForge.SFN_Dot,id:1351,x:32318,y:32590,varname:node_1351,prsc:2,dt:0|A-1953-OUT,B-7572-OUT;n:type:ShaderForge.SFN_RemapRangeAdvanced,id:5944,x:32590,y:32680,varname:node_5944,prsc:2|IN-1351-OUT,IMIN-6674-X,IMAX-6674-Y,OMIN-6674-Z,OMAX-6674-W;n:type:ShaderForge.SFN_Vector4Property,id:6674,x:32387,y:32759,ptovrint:False,ptlb:remap_range,ptin:_remap_range,varname:node_6674,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:-1,v2:1,v3:0,v4:1;n:type:ShaderForge.SFN_Vector1,id:655,x:32387,y:33021,varname:node_655,prsc:2,v1:0.2;n:type:ShaderForge.SFN_Append,id:3251,x:32600,y:32944,varname:node_3251,prsc:2|A-5944-OUT,B-655-OUT;n:type:ShaderForge.SFN_Slider,id:3834,x:33178,y:33190,ptovrint:False,ptlb:outline_thickness,ptin:_outline_thickness,varname:node_3834,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0.005,cur:0.01475974,max:0.02;n:type:ShaderForge.SFN_Step,id:6335,x:32905,y:32247,cmnt:specular,varname:node_6335,prsc:2|A-6843-OUT,B-9736-OUT;n:type:ShaderForge.SFN_Slider,id:6843,x:32541,y:32187,ptovrint:False,ptlb:specular_rang_1,ptin:_specular_rang_1,varname:node_6843,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0.95,cur:0.9987073,max:1;n:type:ShaderForge.SFN_LightVector,id:6146,x:31760,y:32361,varname:node_6146,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:5357,x:32107,y:32085,prsc:2,pt:False;n:type:ShaderForge.SFN_Dot,id:7677,x:32307,y:32217,varname:node_7677,prsc:2,dt:0|A-5357-OUT,B-2320-OUT;n:type:ShaderForge.SFN_RemapRangeAdvanced,id:9736,x:32579,y:32307,varname:node_9736,prsc:2|IN-7677-OUT,IMIN-7532-X,IMAX-7532-Y,OMIN-7532-Z,OMAX-7532-W;n:type:ShaderForge.SFN_Vector4Property,id:7532,x:32370,y:32400,ptovrint:False,ptlb:remap,ptin:_remap,varname:_node_6674_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:-1,v2:1,v3:0,v4:1;n:type:ShaderForge.SFN_Vector4Property,id:6630,x:31773,y:32188,ptovrint:False,ptlb:specular_offset,ptin:_specular_offset,varname:node_6630,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0,v2:0.3,v3:0,v4:0;n:type:ShaderForge.SFN_Add,id:2096,x:31954,y:32271,varname:node_2096,prsc:2|A-6630-XYZ,B-6146-OUT;n:type:ShaderForge.SFN_Normalize,id:2320,x:32126,y:32271,varname:node_2320,prsc:2|IN-2096-OUT;n:type:ShaderForge.SFN_Max,id:2850,x:33086,y:32455,varname:node_2850,prsc:2|A-6335-OUT,B-579-OUT;n:type:ShaderForge.SFN_Slider,id:9928,x:32540,y:32506,ptovrint:False,ptlb:specular_range_2,ptin:_specular_range_2,varname:_specular_range_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0.95,cur:0.9965448,max:1;n:type:ShaderForge.SFN_Step,id:579,x:32877,y:32538,cmnt:specular,varname:node_579,prsc:2|A-9928-OUT,B-5944-OUT;n:type:ShaderForge.SFN_Fresnel,id:1639,x:33466,y:32574,varname:node_1639,prsc:2|EXP-2111-OUT;n:type:ShaderForge.SFN_Slider,id:2111,x:33387,y:32491,ptovrint:False,ptlb:fresnel,ptin:_fresnel,varname:node_2111,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:7.869565,max:10;n:type:ShaderForge.SFN_Blend,id:9083,x:33815,y:32695,varname:node_9083,prsc:2,blmd:6,clmp:True|SRC-1469-OUT,DST-856-OUT;n:type:ShaderForge.SFN_Vector4,id:5903,x:33466,y:32688,varname:node_5903,prsc:2,v1:1,v2:1,v3:1,v4:1;n:type:ShaderForge.SFN_Multiply,id:1469,x:33629,y:32613,varname:node_1469,prsc:2|A-1639-OUT,B-5903-OUT;n:type:ShaderForge.SFN_Color,id:7019,x:33178,y:33008,ptovrint:False,ptlb:specular_color,ptin:_specular_color,varname:node_7019,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.8812436,c2:0.8867924,c3:0.8324136,c4:1;n:type:ShaderForge.SFN_Lerp,id:856,x:33446,y:32917,varname:node_856,prsc:2|A-9529-OUT,B-7019-RGB,T-2850-OUT;proporder:7241-3648-9085-6674-3834-6843-7532-6630-9928-2111-7019;pass:END;sub:END;*/

Shader "Shader Forge/jade" {
    Properties {
        _Color ("Color", Color) = (0.5195943,1,0.4103774,1)
        _rampTex ("rampTex", 2D) = "white" {}
        _darkness_factor ("darkness_factor", Range(0, 3)) = 1.814604
        _remap_range ("remap_range", Vector) = (-1,1,0,1)
        _outline_thickness ("outline_thickness", Range(0.005, 0.02)) = 0.01475974
        _specular_rang_1 ("specular_rang_1", Range(0.95, 1)) = 0.9987073
        _remap ("remap", Vector) = (-1,1,0,1)
        _specular_offset ("specular_offset", Vector) = (0,0.3,0,0)
        _specular_range_2 ("specular_range_2", Range(0.95, 1)) = 0.9965448
        _fresnel ("fresnel", Range(0, 10)) = 7.869565
        _specular_color ("specular_color", Color) = (0.8812436,0.8867924,0.8324136,1)
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
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma target 3.0
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float, _outline_thickness)
            UNITY_INSTANCING_BUFFER_END( Props )
            struct VertexInput {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                float _outline_thickness_var = UNITY_ACCESS_INSTANCED_PROP( Props, _outline_thickness );
                o.pos = UnityObjectToClipPos( float4(v.vertex.xyz + v.normal*_outline_thickness_var,1) );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
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
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0
            uniform sampler2D _rampTex; uniform float4 _rampTex_ST;
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float4, _Color)
                UNITY_DEFINE_INSTANCED_PROP( float, _darkness_factor)
                UNITY_DEFINE_INSTANCED_PROP( float4, _remap_range)
                UNITY_DEFINE_INSTANCED_PROP( float, _specular_rang_1)
                UNITY_DEFINE_INSTANCED_PROP( float4, _remap)
                UNITY_DEFINE_INSTANCED_PROP( float4, _specular_offset)
                UNITY_DEFINE_INSTANCED_PROP( float, _specular_range_2)
                UNITY_DEFINE_INSTANCED_PROP( float4, _specular_color)
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
                LIGHTING_COORDS(2,3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
////// Emissive:
                float4 _Color_var = UNITY_ACCESS_INSTANCED_PROP( Props, _Color );
                float4 _remap_range_var = UNITY_ACCESS_INSTANCED_PROP( Props, _remap_range );
                float node_5944 = (_remap_range_var.b + ( (dot(i.normalDir,lightDirection) - _remap_range_var.r) * (_remap_range_var.a - _remap_range_var.b) ) / (_remap_range_var.g - _remap_range_var.r));
                float2 node_3251 = float2(node_5944,0.2);
                float4 _rampTex_var = tex2D(_rampTex,TRANSFORM_TEX(node_3251, _rampTex));
                float _darkness_factor_var = UNITY_ACCESS_INSTANCED_PROP( Props, _darkness_factor );
                float3 node_9529 = (_Color_var.rgb*(_rampTex_var.rgb*_darkness_factor_var));
                float4 _specular_color_var = UNITY_ACCESS_INSTANCED_PROP( Props, _specular_color );
                float _specular_rang_1_var = UNITY_ACCESS_INSTANCED_PROP( Props, _specular_rang_1 );
                float4 _specular_offset_var = UNITY_ACCESS_INSTANCED_PROP( Props, _specular_offset );
                float4 _remap_var = UNITY_ACCESS_INSTANCED_PROP( Props, _remap );
                float _specular_range_2_var = UNITY_ACCESS_INSTANCED_PROP( Props, _specular_range_2 );
                float node_2850 = max(step(_specular_rang_1_var,(_remap_var.b + ( (dot(i.normalDir,normalize((_specular_offset_var.rgb+lightDirection))) - _remap_var.r) * (_remap_var.a - _remap_var.b) ) / (_remap_var.g - _remap_var.r))),step(_specular_range_2_var,node_5944));
                float3 node_856 = lerp(node_9529,_specular_color_var.rgb,node_2850);
                float3 emissive = node_856;
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
            uniform sampler2D _rampTex; uniform float4 _rampTex_ST;
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float4, _Color)
                UNITY_DEFINE_INSTANCED_PROP( float, _darkness_factor)
                UNITY_DEFINE_INSTANCED_PROP( float4, _remap_range)
                UNITY_DEFINE_INSTANCED_PROP( float, _specular_rang_1)
                UNITY_DEFINE_INSTANCED_PROP( float4, _remap)
                UNITY_DEFINE_INSTANCED_PROP( float4, _specular_offset)
                UNITY_DEFINE_INSTANCED_PROP( float, _specular_range_2)
                UNITY_DEFINE_INSTANCED_PROP( float4, _specular_color)
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
                LIGHTING_COORDS(2,3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
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
