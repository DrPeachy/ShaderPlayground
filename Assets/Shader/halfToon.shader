// Shader created with Shader Forge v1.40 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.40;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,cpap:True,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:33140,y:33086,varname:node_3138,prsc:2|emission-5314-OUT;n:type:ShaderForge.SFN_ScreenPos,id:2804,x:31615,y:32685,varname:node_2804,prsc:2,sctp:1;n:type:ShaderForge.SFN_Multiply,id:8209,x:32070,y:32728,varname:node_8209,prsc:2|A-1858-OUT,B-6757-OUT;n:type:ShaderForge.SFN_Slider,id:6757,x:31743,y:32799,ptovrint:False,ptlb:dot_density,ptin:_dot_density,varname:node_6757,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:10,cur:10,max:100;n:type:ShaderForge.SFN_Fmod,id:8195,x:32391,y:32799,varname:node_8195,prsc:2|A-8209-OUT,B-6422-OUT;n:type:ShaderForge.SFN_Length,id:4814,x:32552,y:33009,varname:node_4814,prsc:2|IN-823-OUT;n:type:ShaderForge.SFN_RemapRange,id:823,x:32341,y:33009,varname:node_823,prsc:2,frmn:0,frmx:1,tomn:-0.5,tomx:0.5|IN-8195-OUT;n:type:ShaderForge.SFN_Power,id:8534,x:32499,y:33204,varname:node_8534,prsc:2|VAL-4814-OUT,EXP-3529-OUT;n:type:ShaderForge.SFN_Slider,id:3529,x:32114,y:33261,ptovrint:False,ptlb:dot_size,ptin:_dot_size,varname:_node_8620_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.3310865,max:5;n:type:ShaderForge.SFN_Step,id:5295,x:32670,y:33272,varname:node_5295,prsc:2|A-8534-OUT,B-5869-OUT;n:type:ShaderForge.SFN_Slider,id:5869,x:32342,y:33366,ptovrint:False,ptlb:step_factor,ptin:_step_factor,varname:node_5869,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.7342763,max:1;n:type:ShaderForge.SFN_RemapRange,id:1858,x:31822,y:32618,varname:node_1858,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-2804-UVOUT;n:type:ShaderForge.SFN_OneMinus,id:5314,x:32852,y:33294,varname:node_5314,prsc:2|IN-5295-OUT;n:type:ShaderForge.SFN_Vector1,id:6422,x:32203,y:32879,varname:node_6422,prsc:2,v1:1;proporder:6757-3529-5869;pass:END;sub:END;*/

Shader "Shader Forge/halfToon" {
    Properties {
        _dot_density ("dot_density", Range(10, 100)) = 10
        _dot_size ("dot_size", Range(0, 5)) = 0.3310865
        _step_factor ("step_factor", Range(0, 1)) = 0.7342763
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
            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float, _dot_density)
                UNITY_DEFINE_INSTANCED_PROP( float, _dot_size)
                UNITY_DEFINE_INSTANCED_PROP( float, _step_factor)
            UNITY_INSTANCING_BUFFER_END( Props )
            struct VertexInput {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 projPos : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
////// Lighting:
////// Emissive:
                float _dot_density_var = UNITY_ACCESS_INSTANCED_PROP( Props, _dot_density );
                float _dot_size_var = UNITY_ACCESS_INSTANCED_PROP( Props, _dot_size );
                float _step_factor_var = UNITY_ACCESS_INSTANCED_PROP( Props, _step_factor );
                float node_5314 = (1.0 - step(pow(length((fmod(((float2((sceneUVs.x * 2 - 1)*(_ScreenParams.r/_ScreenParams.g), sceneUVs.y * 2 - 1).rg*0.5+0.5)*_dot_density_var),1.0)*1.0+-0.5)),_dot_size_var),_step_factor_var));
                float3 emissive = float3(node_5314,node_5314,node_5314);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
