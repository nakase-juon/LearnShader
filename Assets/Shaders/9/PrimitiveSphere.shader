Shader "Holistic/PrimitiveSphere"
{
    SubShader
    {
        Tags { 
//            "LightMode" = "ForwardBase"
            "Queue"="Transparent" 
            }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                // float3 normal : NORMAL; //法線がライトの方向を決定するため、光の情報が必要なときは法線を定義する
            };

            struct v2f
            {
                float3 wPos : TEXCOORD0;
                float4 pos : SV_POSITION;
                // float4 diff : COLOR0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                UNITY_TRANSFER_FOG(o,o.vertex);
                /*
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0;
                */
                return o;
            }

            #define STEPS 128 //cubeの大きさを大きくするときはここの値も大きくする
            #define STEP_SIZE 0.01

            bool SphereHit(float3 p, float3 center, float radius)
            {
                return distance(p, center) < radius;
            }

            ///return Depth
            float3 RaymarchHit(float3 position, float3 direction)
            {
                for(int i = 0; i < STEPS; i++)
                {
                    if(SphereHit(position, float3(0,0,0), 0.5))
                        return position;
                    position += direction * STEP_SIZE;
                }
                return float3(0, 0, 0);
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
                float3 worldPosition = i.wPos;
                float3 depth = RaymarchHit(worldPosition, viewDirection);

                half3 worldNormal = depth - float3(0, 0, 0); //depth-オブジェクトの中心
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));

                if(length(depth) != 0)// lengthを使うことでdepthのベクトルを取得している
                {
                    // depth *= i.diff; vertexシェーダーを使う場合
                    depth *= nl * _LightColor0 * 2; //*2で明るくしてる
                    return fixed4(depth, 1);
                }
                else
                    return fixed4(1,1,1,0);
            }
            ENDCG
        }
    }
}
