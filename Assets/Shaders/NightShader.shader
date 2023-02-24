Shader "MyShaders/NightShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _VignetteTex("Vignette", 2D) = "white" {}
        _ScanlineTex("Scanline", 2D) = "white" {}
        _NoiseTex("Noise", 2D) = "white" {}
        _NoiseXSpeed("X Speed", float) = 100.0
        _NoiseYSpeed("Y Speed", float) = 100.0
        _ScanLineAmount("Scanline repeat", float) = 4.0
        _NightVisionColor ("Vision color", Color) = (1,1,1,1)
        _Contrast("Contrast", Range(0,4)) = 2
        _Brightness("Brightness", Range(0,2)) = 1
        _RandomValue("Ramdom", float) = 0.2
        _Distortion("Distortion", float) = 0.2
        _Scale("zoom", float) = 1

        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform sampler2D _VignetteTex;
            uniform sampler2D _ScanlineTex;
            uniform sampler2D _NoiseTex;
            fixed4 _NightVisionColor;
            fixed _Contrast;
            fixed _ScanLineAmount;
            fixed _Brightness;
            fixed _RandomValue;
            fixed _NoiseXSpeed;
            fixed _NoiseYSpeed;
            fixed _Distortion;
            fixed _Scale;

            float2 BarrelDistortion(float2 coord){

                float2 h = coord.xy - float2(0.5,0.5);
                float r2 = h.x*h.x + h.y*h.y;
                float f = 1.0+r2*(_Distortion*sqrt(r2));
                return f*_Scale*h+0.5;
            }

            

            fixed4 frag (v2f_img i) : COLOR
            {
                half2 distortedUV = BarrelDistortion(i.uv);
                fixed4 renderTex = tex2D(_MainTex, distortedUV);
                fixed4 VignetteTex = tex2D(_VignetteTex, i.uv);
                half2 nosieUV = half2(i.uv.x + (_RandomValue*_SinTime.z*_NoiseXSpeed), i.uv.y + (_Time.x * _NoiseYSpeed));
                half2 scanlinesUV = half2(i.uv.x* _ScanLineAmount , i.uv.y * _ScanLineAmount);
                fixed4 scanlineTex = tex2D(_ScanlineTex,scanlinesUV);
                fixed4 noiseTex = tex2D(_NoiseTex,nosieUV);
                fixed lum = dot(fixed3(0.299,0.587,0.114), renderTex.rgb);
                lum += _Brightness;
                fixed4 finalColor = (lum*2) + _NightVisionColor;
                finalColor = pow(finalColor, _Contrast);
                finalColor*=VignetteTex;
                finalColor*=scanlineTex*noiseTex;
                return finalColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
