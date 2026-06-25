// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DrunkEffect"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_MainTex("_MainTex", 2D) = "white" {}
		_DrunkAmount("_DrunkAmount", Range( 0 , 1)) = 0

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _DrunkAmount;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 texCoord2 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break19_g2 = float2( -0.5,0.5 );
				float2 temp_output_1_0_g2 = ( ( texCoord2 * 15.0 ) + ( _Time.y * 3.0 ) );
				float2 sinIn7_g2 = sin( temp_output_1_0_g2 );
				float2 sinInOffset6_g2 = sin( ( temp_output_1_0_g2 + 1.0 ) );
				float lerpResult20_g2 = lerp( break19_g2.x , break19_g2.y , frac( ( sin( ( ( sinIn7_g2 - sinInOffset6_g2 ) * 91.2228 ) ) * 43758.55 ) ).x);
				float smoothstepResult21 = smoothstep( 0.3 , 0.8 , length( ( texCoord2 - float2( 0.5,0.5 ) ) ));
				float lerpResult23 = lerp( 1.0 , ( 1.0 - smoothstepResult21 ) , _DrunkAmount);
				

				finalColor = ( tex2D( _MainTex, ( texCoord2 + ( ( ( lerpResult20_g2 + sinIn7_g2 ) * 0.02 ) * _DrunkAmount ) ) ) * lerpResult23 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
300;73;1178;621;1165.748;180.4598;1.719721;True;False
Node;AmplifyShaderEditor.CommentaryNode;26;-1047.131,118.2792;Inherit;False;1514.386;487.096;Grupo1 - Ondulacion;14;17;16;14;1;13;12;11;9;5;8;6;3;7;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-970.531,423.5753;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-961.2301,489.3752;Inherit;False;Constant;_WaveSpeed;_WaveSpeed;1;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-997.1313,199.8752;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-980.1313,316.8754;Inherit;False;Constant;_WaveFrequency;_WaveFrequency;1;0;Create;True;0;0;0;False;0;False;15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-804.329,440.6404;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-791.5308,269.0258;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;24;-557.4611,-210.1474;Inherit;False;733.9735;230.3539;Grupo2 - Viñeta;5;19;21;20;22;23;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-665.7285,344.4404;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;11;-558.5262,345.3406;Inherit;False;Noise Sine Wave;-1;;2;a6eff29f739ced848846e3b648af87bd;0;2;1;FLOAT2;0,0;False;2;FLOAT2;-0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-507.4597,-140.9387;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-552.3266,448.8416;Inherit;False;Constant;_WaveStrength;_WaveStrength;1;0;Create;True;0;0;0;False;0;False;0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-370.7266,349.1411;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;20;-389.2478,-139.7938;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-365.4313,448.775;Float;False;Property;_DrunkAmount;_DrunkAmount;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-92.02711,373.8412;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;21;-280.2482,-138.7938;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;22;-136.8727,-137.4179;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;23.31049,200.5348;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;17;147.2543,168.2792;Inherit;True;Property;_MainTex;_MainTex;0;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;23;-5.486724,-160.1476;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;463.6104,-42.71563;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;578.6187,-40.19787;Float;False;True;-1;2;ASEMaterialInspector;0;2;DrunkEffect;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;5;0;2;0
WireConnection;5;1;3;0
WireConnection;9;0;5;0
WireConnection;9;1;8;0
WireConnection;11;1;9;0
WireConnection;19;0;2;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;20;0;19;0
WireConnection;14;0;13;0
WireConnection;14;1;1;0
WireConnection;21;0;20;0
WireConnection;22;0;21;0
WireConnection;16;0;2;0
WireConnection;16;1;14;0
WireConnection;17;1;16;0
WireConnection;23;1;22;0
WireConnection;23;2;1;0
WireConnection;25;0;17;0
WireConnection;25;1;23;0
WireConnection;0;0;25;0
ASEEND*/
//CHKSM=3A28B365DAC22BEF7B4034463C154D5A76559E1C