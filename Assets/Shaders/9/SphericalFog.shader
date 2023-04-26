Shader "Holistic/SphericalFog"
{
    Properties
    {
        _FogCenter("Fog Center/Radius", Vector) = (0, 0, 0, 0.5) //wの値は半径
        _FogColor("Fog Color", Color) = (1, 1, 1, 1)
        _InnerRatio ("Inner Ratio", Range(0.0, 0.9)) = 0.5
        _Density("Density", Range (0.0, 1.0)) = 0.5 //密度
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off Lighting Off ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float CalculateFogIntensity(
                float3 sphereCenter,
                float sphereRadius,
                float innerRatio,
                float density,
                float3 cameraPosition,
                float3 viewDirection,
                float maxDistance)
            {
                //calculate ray-sphere intersection
                //x = (-b±√(b^2-4ac))/2a 解の公式
                //a = D^2 viewDirection
                //b = 2 * camera * D
                //c = camera^2 - R^2
                float3 localCam = cameraPosition - sphereCenter;
                float a = dot(viewDirection, viewDirection);
                float b = 2 * dot(viewDirection, localCam);
                float c = dot(localCam, localCam) - sphereRadius * sphereRadius;
                float d = b * b - 4 * a * c;

                if(d <= 0.0f)
                {
                    return 0;
                }

                float DSqrt = sqrt(d);
                float dist = max((-b - DSqrt)/2*a, 0);
                float dist2 = max((-b + DSqrt)/2*a, 0);

                float backDepth = min(maxDistance, dist2);//カメラが見える距離と球面の背面のどちらが近いか
                float sample = dist;
                float step_distance = (backDepth - dist) / 10;
                float step_contribution = density; //各ステップでどれだけ多くのフォグが発生するか

                float centerValur = 1 / (1 - innerRatio);

                //以下で中心ほど霧が濃くて中心から遠いほど霧が薄くなるようにする
                float clarity = 1;
                for(int seg = 0; seg < 10; seg++) // seg<10の値はstep_distanceで割った値
                {
                    float3 position = localCam + viewDirection * sample;
                    float val = saturate(centerValur * (1 - length(position)/sphereRadius));
                    float fog_amount = saturate(val * step_contribution);
                    clarity *= (1 - fog_amount);
                    sample += step_distance;
                }
                return 1 - clarity;
            }

            struct v2f
            {
                float3 view : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 projPos : TEXCOORD1;
            };

            float4 _FogCenter;
            fixed4 _FogColor;
            float _InnerRatio;
            float _Density;
            sampler2D _CameraDepthTexture; //画面上の現在のシーンの深度

            v2f vert (appdata_base v)
            {
                v2f o;
                float4 wPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.view = wPos.xyz - _WorldSpaceCameraPos;
                o.projPos = ComputeScreenPos(o.pos);

                float inFrontOf = (o.pos.z / o.pos.w) > 0;
                o.pos.z *= inFrontOf;
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 color = half4(1, 1, 1, 1);
                float depth = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj (_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos))));//ピクセルごとにカメラから得られる最大の深度
                float3 viewDir = normalize(i.view);

                float fog = CalculateFogIntensity(
                    _FogCenter.xyz,
                    _FogCenter.w,
                    _InnerRatio,
                    _Density,
                    _WorldSpaceCameraPos,
                    viewDir,
                    depth);

                color.rgb = _FogColor.rgb;
                color.a = fog;
                return color;
            }
            ENDCG
        }
    }
}
