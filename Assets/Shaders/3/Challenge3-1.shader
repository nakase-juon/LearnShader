Shader "Holistic/Challenge3-1" 
{
    Properties {
        _myDiffuse ("Diffuse Texture", 2D) = "white" {}
        _myBump ("Bump Texture", 2D) = "bump" {}
        _myBumpSlider ("Bump Amount", Range(0,10)) = 1
        _myTexSlider ("Texture Bump Scale", Range(0.5,2)) = 1
    }
    SubShader {

      CGPROGRAM
        #pragma surface surf Lambert
        
        sampler2D _myDiffuse;
        sampler2D _myBump;
        half _myBumpSlider;
        half _myTexSlider;

        struct Input {
            float2 uv_myDiffuse;
            float2 uv_myBump;
        };
        
        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = (tex2D(_myDiffuse, IN.uv_myDiffuse) * _myTexSlider).rgb;
            o.Normal = UnpackNormal(tex2D(_myBump, IN.uv_myBump));
            o.Normal *= float3(_myBumpSlider, _myBumpSlider, 1); //x,y,z = (_mySlider, _mySlider, 1)
        }
      
      ENDCG
    }
    Fallback "Diffuse"
  }
