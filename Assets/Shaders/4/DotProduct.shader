Shader "Holistic/DotProduct"
{
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert
        
        struct Input
        {
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            half dotp = 1 - dot(IN.viewDir, o.Normal);
            // o.Albedo = float3(dotp, 1, 1);
            // o.Albedo = float3(1, dotp, 1);
            // o.Albedo.r = 1 - dotp;
            o.Albedo.r = dotp;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
