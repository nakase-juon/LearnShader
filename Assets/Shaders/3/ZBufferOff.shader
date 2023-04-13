Shader "Holistic/ZBufferOff" 
{
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader {
        Tags {"Queue" = "Geometry+100"}
        ZWrite Off
      CGPROGRAM
        #pragma surface surf Lambert
        
        sampler2D _MainTex;

        struct Input {
            float2 uv_MainTex;
        };
        
        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
      
      ENDCG
    }
    Fallback "Diffuse"
  }
