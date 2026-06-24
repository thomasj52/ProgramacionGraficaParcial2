// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HandycamEffect"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_MainTex("_MainTex", 2D) = "white" {}
		_CameraOn("_CameraOn", Range( 0 , 1)) = 0

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
			
			uniform float _CameraOn;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			


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
				float2 texCoord16 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 break19_g1 = float2( -0.5,0.5 );
				float temp_output_1_0_g1 = ( _Time.y * 8.0 );
				float sinIn7_g1 = sin( temp_output_1_0_g1 );
				float sinInOffset6_g1 = sin( ( temp_output_1_0_g1 + 1.0 ) );
				float lerpResult20_g1 = lerp( break19_g1.x , break19_g1.y , frac( ( sin( ( ( sinIn7_g1 - sinInOffset6_g1 ) * 91.2228 ) ) * 43758.55 ) ));
				float2 break19_g2 = float2( -0.5,0.5 );
				float temp_output_1_0_g2 = ( 0.0 + 1.7 );
				float sinIn7_g2 = sin( temp_output_1_0_g2 );
				float sinInOffset6_g2 = sin( ( temp_output_1_0_g2 + 1.0 ) );
				float lerpResult20_g2 = lerp( break19_g2.x , break19_g2.y , frac( ( sin( ( ( sinIn7_g2 - sinInOffset6_g2 ) * 91.2228 ) ) * 43758.55 ) ));
				float4 appendResult13 = (float4(( lerpResult20_g1 + sinIn7_g1 ) , ( lerpResult20_g2 + sinIn7_g2 ) , 0.0 , 0.0));
				float4 color21 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
				float4 color2 = IsGammaSpace() ? float4(0.8207547,0.704138,0.5691082,0) : float4(0.6396053,0.4539039,0.2836729,0);
				float4 lerpResult20 = lerp( color21 , color2 , _CameraOn);
				float simplePerlin2D27 = snoise( ( ( texCoord16 * 700.0 ) + _Time.y ) );
				simplePerlin2D27 = simplePerlin2D27*0.5 + 0.5;
				float smoothstepResult35 = smoothstep( 0.3 , 0.8 , length( ( texCoord16 - float2( 0.5,0.5 ) ) ));
				float lerpResult37 = lerp( 1.0 , ( 1.0 - smoothstepResult35 ) , _CameraOn);
				

				finalColor = ( ( ( tex2D( _MainTex, ( float4( texCoord16, 0.0 , 0.0 ) + ( ( appendResult13 * 0.004 ) * _CameraOn ) ).xy ) * lerpResult20 ) + ( ( ( simplePerlin2D27 - 0.5 ) * 0.08 ) * _CameraOn ) ) * lerpResult37 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
300;73;1178;621;416.1349;-766.4565;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;19;-664.14,721.0271;Inherit;False;1609.126;433.3561;Grupo1 - Temblor;14;1;15;14;5;10;16;13;11;9;6;12;17;18;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;8;-598.9944,798.6448;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-614.14,896.3802;Inherit;False;Constant;_ShakeSpeed;_ShakeSpeed ;0;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-331.1996,788.3154;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-448.9944,874.6449;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;42.9882,353.2859;Inherit;False;1268.561;275.8366;Grupo3 - Grano;10;30;29;28;27;25;26;24;4;3;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;10;-263.1996,893.3153;Inherit;False;Noise Sine Wave;-1;;1;a6eff29f739ced848846e3b648af87bd;0;2;1;FLOAT;0;False;2;FLOAT2;-0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;12;-213.5941,787.1;Inherit;False;Noise Sine Wave;-1;;2;a6eff29f739ced848846e3b648af87bd;0;2;1;FLOAT;0;False;2;FLOAT2;-0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;224.9483,762.5777;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;92.98816,436.4621;Inherit;False;Constant;_GrainScale;_GrainScale ;0;0;Create;True;0;0;0;False;0;False;700;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;315.9215,510.9925;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;314.1223,403.2859;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-47.54792,1038.383;Inherit;False;Constant;_ShakeAmount;_ShakeAmount ;0;0;Create;True;0;0;0;False;0;False;0.004;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-23.59412,888.1;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;455.0108,412.4752;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1;137.4218,1021.022;Inherit;False;Property;_CameraOn;_CameraOn;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;154.9638,901.973;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;39;1096.792,793.5775;Inherit;False;896.366;231.1687;Grupo4 - Viñeta;6;38;33;35;37;34;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;1146.792,855.5782;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;23;177.9548,1185.934;Inherit;False;769.6848;449.2482;Grupo2 - Tinte Cálido;4;2;20;21;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;27;570.8724,413.5192;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;340.9149,905.5356;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LengthOpNode;34;1267.351,857.3331;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;244.0445,1235.934;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;678.2868,513.123;Inherit;False;Constant;_GrainStrength;_GrainStrength ;0;0;Create;True;0;0;0;False;0;False;0.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;481.9864,871.0271;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;2;227.955,1423.182;Inherit;False;Constant;_TintColor;_TintColor ;0;0;Create;True;0;0;0;False;0;False;0.8207547,0.704138,0.5691082,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;745.7115,421.7861;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;624.9864,861.0271;Inherit;True;Property;_MainTex;_MainTex;0;0;Fetch;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;35;1378.351,857.3331;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;515.4003,1278.975;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;874.2779,425.4942;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;785.6394,1270.993;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;1014.278,425.648;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;36;1519.351,857.3331;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;1159.551,479.8967;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;37;1658.946,865.7462;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;1831.158,843.5775;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2029.13,839.9257;Float;False;True;-1;2;ASEMaterialInspector;0;2;HandycamEffect;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;9;0;8;0
WireConnection;9;1;6;0
WireConnection;10;1;9;0
WireConnection;12;1;11;0
WireConnection;24;0;16;0
WireConnection;24;1;4;0
WireConnection;13;0;10;0
WireConnection;13;1;12;0
WireConnection;25;0;24;0
WireConnection;25;1;26;0
WireConnection;14;0;13;0
WireConnection;14;1;5;0
WireConnection;33;0;16;0
WireConnection;27;0;25;0
WireConnection;15;0;14;0
WireConnection;15;1;1;0
WireConnection;34;0;33;0
WireConnection;17;0;16;0
WireConnection;17;1;15;0
WireConnection;28;0;27;0
WireConnection;18;1;17;0
WireConnection;35;0;34;0
WireConnection;20;0;21;0
WireConnection;20;1;2;0
WireConnection;20;2;1;0
WireConnection;29;0;28;0
WireConnection;29;1;3;0
WireConnection;22;0;18;0
WireConnection;22;1;20;0
WireConnection;30;0;29;0
WireConnection;30;1;1;0
WireConnection;36;0;35;0
WireConnection;31;0;22;0
WireConnection;31;1;30;0
WireConnection;37;1;36;0
WireConnection;37;2;1;0
WireConnection;38;0;31;0
WireConnection;38;1;37;0
WireConnection;0;0;38;0
ASEEND*/
//CHKSM=B08734497880DB959F07605B55AF530B22FFCF6C