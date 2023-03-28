Shader "Custom/SquareWaves"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Tint("Tint", Color) = (1,1,1,1)
        _Freq("Frequency", Range(0,5)) = 3
        _Speed("Speed", Range(0,10)) = 10
        _Amp("Amplitude", Range(0,1)) = 0.5
        _Offset("Offset", Range(0,5)) = 0.5
    }
        SubShader
        {
            CGPROGRAM
            #pragma surface surf Lambert vertex:vert
            struct Input
            {
                float2 uv_MainTex;
                float3 vertColor;
            };

            float4 _Tint;
            float _Freq;
            float _Speed;
            float _Amp;
            float _Offset;

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 prevVertex : TEXCOORD3;
            };
            void vert(inout appdata v, out Input o)
            {
                UNITY_INITIALIZE_OUTPUT(Input, o);
                float t = _Time * _Speed;
                float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp + sin(t + v.vertex.z * _Freq) * _Amp;
                if (waveHeight > 0) waveHeight = 1;
                else waveHeight = -1;
                v.vertex.y = v.vertex.y + waveHeight;
                v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));

                if ((v.prevVertex.y == 0 && v.prevVertex.x == 0) && v.prevVertex.y != v.vertex.y)
                {
                    v.vertex.x = v.prevVertex.x;
                }

                o.vertColor = waveHeight + 2;
            }
            /*void vert(inout appdata v, out Input o)
            {
                UNITY_INITIALIZE_OUTPUT(Input, o);
                float t = _Time * _Speed;
                if (t > 0) t = 1;
                else t = -1;
                float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp + sin(t + v.vertex.z * _Freq) * _Amp;
                v.vertex.y = v.vertex.y + waveHeight;
                v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
                o.vertColor = waveHeight + 2;
            }*/


            sampler2D _MainTex;
            void surf(Input IN, inout SurfaceOutput o)
            {
                float4 c = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = c * IN.vertColor.rgb;
            }
            ENDCG
        }
            FallBack "Diffuse"
}
