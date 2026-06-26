// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "New Amplify Shader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPosition;
			float3 worldPos;
		};

		uniform float4 _PlayerViewportPos;
		uniform float _Cutoff = 0.5;


		inline float Dither4x4Bayer( int x, int y )
		{
			const float dither[ 16 ] = {
				 1,  9,  3, 11,
				13,  5, 15,  7,
				 4, 12,  2, 10,
				16,  8, 14,  6 };
			int r = y * 4 + x;
			return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color36 = IsGammaSpace() ? float4(0.3301887,0.3301887,0.3301887,0) : float4(0.08908623,0.08908623,0.08908623,0);
			o.Albedo = color36.rgb;
			o.Alpha = 1;
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 clipScreen27 = ase_screenPosNorm.xy * _ScreenParams.xy;
			float dither27 = Dither4x4Bayer( fmod(clipScreen27.x, 4), fmod(clipScreen27.y, 4) );
			float smoothstepResult19 = smoothstep( 0.15 , 0.25 , length( ( (ase_screenPosNorm).xy - (_PlayerViewportPos).xy ) ));
			float3 ase_worldPos = i.worldPos;
			float lerpResult26 = lerp( 1.0 , smoothstepResult19 , step( distance( ase_worldPos , _WorldSpaceCameraPos ) , (_PlayerViewportPos).z ));
			dither27 = step( dither27, lerpResult26 );
			clip( dither27 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;73;1920;920;1861.06;220.6791;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;32;-1578.05,-195.6696;Inherit;False;865.2039;432.6638;Dibujar el círculo en la pantalla;7;33;15;9;7;31;30;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;29;-1528.05,-145.6695;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;30;-1535.396,46.99432;Inherit;False;Global;_PlayerViewportPos;_PlayerViewportPos;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4665999,0.3411229,6.282617,2.12369;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;31;-1253.615,55.12448;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;7;-1278.777,-71.0074;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;25;-1153.85,307.8087;Inherit;False;677;381.4419;Que solo agujeree lo que está adelante;4;23;21;22;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;21;-1064.138,357.8087;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;22;-1103.85,506.2506;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;-1035.718,0.1402788;Inherit;False;2;0;FLOAT2;20,20;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;15;-868.8466,10.18731;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;23;-794.85,441.2506;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;33;-1254.422,151.5047;Inherit;False;False;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;20;-664.6207,14.00762;Inherit;False;239;209;El Borde Suave del Agujero;1;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;19;-615.6207,65.00762;Inherit;False;3;0;FLOAT;0.5;False;1;FLOAT;0.15;False;2;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;24;-628.85,424.2506;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;-337.724,244.6052;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;-309.7661,-88.91953;Inherit;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;0.3301887,0.3301887,0.3301887,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DitheringNode;27;-189.2655,239.5737;Inherit;False;0;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;58,-10;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;30;0
WireConnection;7;0;29;0
WireConnection;9;0;7;0
WireConnection;9;1;31;0
WireConnection;15;0;9;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;33;0;30;0
WireConnection;19;0;15;0
WireConnection;24;0;23;0
WireConnection;24;1;33;0
WireConnection;26;1;19;0
WireConnection;26;2;24;0
WireConnection;27;0;26;0
WireConnection;0;0;36;0
WireConnection;0;10;27;0
ASEEND*/
//CHKSM=22C8EB6652B6F64CEC13715A70759D77AE44FE3D