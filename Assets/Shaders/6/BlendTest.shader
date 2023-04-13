Shader "Holistic/BlendTest" {
    Properties {
      _MainTex ("Texture", 2D) = "black" {}
    }
    SubShader {
      Tags{"Queue" = "Transparent"}
      Blend One One  //quadより後ろのものとquadに設定されている色が黒にちかい程透ける
//      Blend SrcAlpha OneMinusSrcAlpha
//      Blend DstColor Zero  //quadより後ろにあるものとquadに設定されている色の乗算
      Pass {
        SetTexture [_MainTex] {combine texture}
      }
    } 
  }