Shader "Holistic/Wall" {
	Properties {
		_MainTex ("Diffuse", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue"="Geometry" }		
		
		Stencil
		{
			Ref 1
			Comp notequal  //WallのStencilRef(1)が既にあるステンシルバッファに等しくない場合、以下の動作
			Pass keep  //ステンシルバッファに1があった場合、描写しない
		}

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
