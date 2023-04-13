Shader "Holistic/Challenge4-1" {
    Properties {
        _diffuseTex ("diffuse Texture", 2D) = "white" {}
      _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
      _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
      _stripeRange ("Stripe Range", Range(1, 20)) = 10
    }
    SubShader {
      CGPROGRAM
      #pragma surface surf Lambert
      struct Input {
          float3 viewDir;
          float3 worldPos;
          float2 uv_diffuseTex;
      };

      float4 _RimColor;
      float _RimPower;
      sampler2D _diffuseTex;
      float _stripeRange;

      void surf (Input IN, inout SurfaceOutput o) {
          o.Albedo = tex2D(_diffuseTex, IN.uv_diffuseTex);
          half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
          o.Emission = frac(IN.worldPos.y * _stripeRange * 0.5) > 0.4 ?
                        float3(0, 1, 0) * rim : float3(1, 0, 0) * rim;
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }