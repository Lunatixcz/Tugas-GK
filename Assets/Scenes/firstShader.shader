Shader "Custom/NewSurfaceShader" 
{
    Properties
    {
        _LineColor ("Line", Color) = (1,1,1,1)
        _PrimaryColor ("Primary color", Color) = (1,1,1,1)
        _SecondaryColor ("Secondary color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _DeltaTime ("Delta Time", Range(0.1, 10.0)) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        half _DeltaTime;
        fixed4 _LineColor;
        fixed4 _PrimaryColor;
        fixed4 _SecondaryColor;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 primary = tex2D(_MainTex, IN.uv_MainTex) * _PrimaryColor;
            fixed4 secondary = tex2D(_MainTex, IN.uv_MainTex) * _SecondaryColor;
            fixed4 LineColor = tex2D(_MainTex, IN.uv_MainTex) * _LineColor;
            o.Albedo = primary.xyz;
    
            float deltaTime = _DeltaTime;
            float currPos = (_Time.y % deltaTime) / deltaTime;
                float currPos2 = (1 - ((_Time.y % deltaTime) / deltaTime) * 2);
                float currPos2_abs = abs(currPos2);
                if (IN.worldPos.y + 0.5 < currPos2_abs)
                {
                    if (currPos2 > 0)
                    {
                        o.Albedo = primary;
                    }
                    else
                    {
                        o.Albedo = secondary;
                    }
                }
                else
                {
        
                    if (currPos2 > 0)
                    {
                        o.Albedo = secondary;
                    }
                    else{
                        o.Albedo = primary;
                    }
                }
                if (abs(IN.worldPos.y + 0.5 - currPos2_abs) < 0.05)
                {
                o.Albedo = LineColor;
            }
                
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = primary.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}