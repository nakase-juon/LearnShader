Shader "Holistic/Transparent" {
Properties{
		_MainTex ("MainTex", 2D) = "black" {}
}
	SubShader{
		Tags{
			"Queue" = "Transparent"
		}
		Blend SrcAlpha OneMinusSrcAlpha
		Cull off //背面表示
		Pass {
			SetTexture [_MainTex] {combine texture}
			}
	}
}
