Shader "Shader/cubemap" {
    Properties {
        _CubeMap ("CubeMap", Cube) = "_Skybox" {}
        _CubeMapMip ("CubeMapMip", Range(0, 7)) = 0
        _NormalMap ("NormalMap", 2D) = "bump" {}
        _FresnelPower ("Fresnel Power", Range(0, 5)) = 1
        _EnvSpecIntensity ("Env Spec Intensity", Range(0, 5)) = 0.5
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
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma target 3.0
            // Properties
            uniform samplerCUBE _CubeMap;
            uniform float _CubeMapMip;
            uniform sampler2D _NormalMap;
            uniform float _FresnelPower;
            uniform float _EnvSpecIntensity;

            struct VertexInput {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 posWS : TEXCOORD1;
                float3 nDirWS : TEXCOORD2;
                float3 tDirWS : TEXCOORD3;
                float3 bDirWS : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.posWS = mul( unity_ObjectToWorld, v.vertex );
                o.uv0 = v.uv0;
                o.nDirWS = UnityObjectToWorldNormal( v.normal );
                o.tDirWS = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
                o.bDirWS = normalize(cross( o.nDirWS, o.tDirWS ) * v.tangent.w);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3 nDirTS = UnpackNormal(tex2D(_NormalMap, i.uv0)).rgb;
                float3x3 tbn = float3x3(i.tDirWS, i.bDirWS, i.nDirWS);
                float3 nDirWS = normalize( mul(nDirTS, tbn));
                float3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - i.posWS.xyz);
                float3 vrDirWS = reflect(-vDirWS, nDirWS);
                
                float ndotv = dot(nDirWS, vDirWS);

                float3 cubemap = texCUBElod(_CubeMap, float4(vrDirWS, _CubeMapMip));
                float fresnel = pow(1.0- max(0, ndotv), _FresnelPower);
                float3 envSpecLight = cubemap * _EnvSpecIntensity * fresnel;
                return float4(envSpecLight, 1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}