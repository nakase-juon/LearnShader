Shader "Unlit/ColorVF"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;

            //ワールドスペースの座標を用いて計算
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // o.color.r = (v.vertex.x + 10) / 10; //MeshDataから最大値が5と読み取った
                // o.color.g = (v.vertex.z + 10) / 10; //MeshDataから最大値が5と読み取った
                return o;
            }

            //クリッピングスペース(スクリーンスペース)の座標を用いて計算
            //したがってこちらで色などを指定するとオブジェクトの位置によって色などが変化する。
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col;
                // float4 col = fixed4(0, 1, 0, 1);
                // float4 col = i.color;
                // col.r = (i.vertex.x + 10) / 10;
                // col.g = (i.vertex.z + 10) / 10;
                //上のコードはvertexShaderとfragmentShaderで同じでかかれているが結果が違う。ワールド空間においてスクリーンスペースのｘの値は0-1080とかになったりするから
                //したがって下のようにさらに大きな値で割ることで似たような結果が求められるかもしれない
                col.r = i.vertex.x / 1000;
                // col.g = i.vertex.z / 1000;
                //でも上のコードでもまだプレーンが赤くなってvertexShaderで処理した時と同じような結果にならない。
                //スクリーンスペース(UnityのSceneView)ではxとyしかないからzをyに書き換える必要がある。
                col.g = i.vertex.y / 1000;
                return col;
            }
            ENDCG
        }
    }
}
