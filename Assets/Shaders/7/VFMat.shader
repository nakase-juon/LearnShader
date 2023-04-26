Shader "Holistic/VFMat"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ScaleUVX ("Scale X", Range(1,10)) = 1
		_ScaleUVY ("Scale Y", Range(1,10)) = 1
	}
	SubShader
	{
		//QueueをTransparentに設定することで再帰的な描写(合わせ鏡みたいな描写)を止めることができる。
		//なぜ→Transparentは奥から手前の順に描画する最後のrenderだから
		Tags{ "Queue" = "Transparent"}
		GrabPass{}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _GrabTexture;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _ScaleUVX;
			float _ScaleUVY;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv.x = sin(o.uv.x * _ScaleUVX);
				o.uv.y = sin(o.uv.y * _ScaleUVY);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col = tex2D(_GrabTexture, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
