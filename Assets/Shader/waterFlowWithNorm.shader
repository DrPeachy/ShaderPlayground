Shader "Unlit/waterFlowWithNorm"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "black" {}
        _FlowMap ("FlowMap", 2D) = "white" {}
        _CubeMap ("CubeMap", Cube) = "_Skybox" {}
        _CubeMapMip ("CubeMapMip", Range(0, 7)) = 0
        _FresPow ("Fresnel Power", Range(0, 7)) = 1
        _FlowSpeed ("FlowSpeed", Range(0, 1)) = 0.1
        _Opacity ("Opacity", Range(0, 1)) = 0.5
        [HDR]_FoamCol ("Foam Color", Color) = (1,1,1,1)
        [HDR]_WaterCol ("Water Color", Color) = (1,1,1,1)
        [HDR]_LightCol ("Light Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags 
        { 
            "Queue"="Transparent"
            "IgnoreProjector"="True"    
            "RenderType"="Transparent"
        }

        LOD 100

        
        Pass
        {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma shader_feature _REVERSE_FLOW_ON

            #include "UnityCG.cginc"

            // Properties
            sampler2D _MainTex; float4 _MainTex_ST;
            sampler2D _FlowMap;
            samplerCUBE _CubeMap;
            half _CubeMapMip;
            half _FresPow;
            half _FlowSpeed;
            half3 _FoamCol;
            half3 _WaterCol;
            half3 _LightCol;
            half _Opacity;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv0 : TEXCOORD0;
                float4 vertex : SV_POSITION;
                half3 posWS : TEXCOORD1;
                half3 nDirWS : TEXCOORD2;
                half3 tDirWS : TEXCOORD3;
                half3 bDirWS : TEXCOORD4;
            };

            v2f vert (appdata v)
            {

                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.posWS = mul( unity_ObjectToWorld, v.vertex );
                o.uv0 = TRANSFORM_TEX(v.uv0, _MainTex);
                o.nDirWS = UnityObjectToWorldNormal( v.normal );
                o.tDirWS = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
                o.bDirWS = normalize(cross( o.nDirWS, o.tDirWS ) * v.tangent.w);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half2 var_Flowmap = tex2D(_FlowMap, i.uv0).rg * 2.0 - 1.0; // remap to -1 to 1
                float3x3 tbn = float3x3(i.tDirWS, i.bDirWS, i.nDirWS);
                // flow
                float phase0 = frac(_Time.y * _FlowSpeed);
                float phase1 = frac(_Time.y * _FlowSpeed + 0.5);
                half3 var_Maintex0 = tex2D(_MainTex, i.uv0 - var_Flowmap.xy * phase0).rgb;
                half3 var_Maintex1 = tex2D(_MainTex, i.uv0 - var_Flowmap.xy * phase1).rgb;
                half flowLerp = abs((0.5 - phase0) * 2.0);
                half3 nDirWS = normalize( mul(var_Maintex0, tbn));
                // vector preparation
                half3 lDirWS = normalize(_WorldSpaceLightPos0.xyz);
                half3 lrDirWS = reflect(-lDirWS, nDirWS);
                half3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - i.posWS.xyz);
                half3 vrDirWS = reflect(-vDirWS, nDirWS);

                // 光照
                half3 var_CubeMap = texCUBElod(_CubeMap, float4(vrDirWS, _CubeMapMip)).rgb;
                half fresnel = pow(1.0 - saturate(dot(vDirWS, nDirWS)), _FresPow);

                half3 finalRGB = lerp(var_Maintex0, var_Maintex1, flowLerp);
                finalRGB = lerp(_WaterCol, _FoamCol, finalRGB);
                finalRGB += var_CubeMap * fresnel * _LightCol;
                
                return half4(finalRGB, _Opacity);
            }
            ENDCG
        }
    }
}
