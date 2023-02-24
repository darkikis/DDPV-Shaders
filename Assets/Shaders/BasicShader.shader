Shader "MyShaders/BasicShader"
{
    Properties{
        //Nombre eb Puedes ser numero, Color, Vector etc.,
        _Color("MainColor", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white" {}
    }

    SubShader{
        //
        Pass{
            CGPROGRAM

                //verificacion de errores en shader
                #pragma vertex vertexShader
                #pragma fragment fragmentShader
                #include "UnityCG.cginc"

                //son bytes reconocidos de forma lineal
                uniform sampler2D _MainTex;
                uniform float4 _MainTex_ST;

                //Vertex input
                struct vertexInput {
                    //geomtetry
                    float4 vertex:POSITION;

                    //coord uv de texturas
                    float2 uv:TEXCOORD0;
                };

                struct vertexOutput{
                    float4 position:SV_POSITION;
                    float2 uv:TEXCOORD0;
                };

                vertexOutput vertexShader(vertexInput i){
                    vertexOutput o;
                    o.position = UnityObjectToClipPos(i.vertex);
                    
                    //manual
                    //o.uv = i.uv;
                    //zw offset
                    //o.uv = (i.uv*_MainTex_ST.xy + _MainTex_ST.zw);
                    
                    //no tan manual
                    o.uv = TRANSFORM_TEX(i.uv,_MainTex);

                    
                    return o;
                }
                fixed4 fragmentShader(vertexOutput i) : SV_Target{

                    fixed4 col = tex2D(_MainTex, i.uv);
                    return col;
                }
            ENDCG
        }
    }
    //Por si no funciona algun shader
    FallBack "Default"    
}
