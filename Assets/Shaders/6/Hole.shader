Shader "Holistic/Hole" {
	Properties {
		_MainTex ("Diffuse", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue"="Geometry-1" }
//		Tags { "Queue"="Geometry" }

		ColorMask 0 //ステンシルバッファ上で色をオフに
		ZWrite off //Holeは深度バッファをもたないから書き込みをオフに
		
		Stencil
		{
			Ref 1 //ステンシルバッファにすでに値を入れることでそれより上のバッファで描写をなくす
			Comp always	 //常に1を入れる
			Pass replace  //フレームバッファへの描画に関してステンシルバッファに属するピクセルで何をするか　この場合はフレームバッファにあるものをすべてこのピクセルパスで置き換えるからreplace
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
