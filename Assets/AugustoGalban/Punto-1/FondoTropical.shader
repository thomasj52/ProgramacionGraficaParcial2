// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FondoTropical"
{
	Properties
	{
		_TimeX("Time X", Float) = 2
		_TimeY("Time Y", Float) = 0
		_Velocidad("Velocidad", Range( 0 , 1)) = 0.3
		_VelocidadY("Velocidad Y", Range( 0 , 1)) = 0.3
		_ColorA("Color A", Color) = (1,0.5490196,0,0)
		_ColorB("Color B", Color) = (0,0.7843137,0.3254902,0)
		_ColorC("Color C", Color) = (1,0.8392157,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		ZTest Always
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _ColorB;
		uniform float4 _ColorA;
		uniform float _TimeX;
		uniform float _Velocidad;
		uniform float4 _ColorC;
		uniform float _TimeY;
		uniform float _VelocidadY;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime2 = _Time.y * _TimeX;
			float4 lerpResult13 = lerp( _ColorB , _ColorA , (0.0 + (sin( ( i.uv_texcoord.x + ( mulTime2 * _Velocidad ) ) ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)));
			float mulTime16 = _Time.y * _TimeY;
			float4 lerpResult20 = lerp( lerpResult13 , _ColorC , (0.0 + (sin( ( i.uv_texcoord.x + ( mulTime16 * _VelocidadY ) ) ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)));
			o.Emission = lerpResult20.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;843;1954;508;2233.403;352.4375;1.717049;True;False
Node;AmplifyShaderEditor.RangedFloatNode;3;-1271.791,175.394;Inherit;False;Property;_TimeX;Time X;0;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-949.5507,282.9771;Inherit;False;Property;_Velocidad;Velocidad;2;0;Create;True;0;0;0;False;0;False;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-1058.155,179.9096;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-684.1501,406.3772;Inherit;False;Property;_TimeY;Time Y;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-888.3325,65.63694;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;16;-511.4499,411.6771;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;25;-713.0035,-52.02377;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-806.7501,182.177;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-407.7614,510.7024;Inherit;False;Property;_VelocidadY;Velocidad Y;3;0;Create;True;0;0;0;False;0;False;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-593.8503,52.77699;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;14;-252.7501,294.177;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-260.8611,410.6025;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-18.75012,291.177;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;8;-439.9502,52.877;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-298.7501,-138.823;Inherit;False;Property;_ColorA;Color A;4;0;Create;True;0;0;0;False;0;False;1,0.5490196,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;18;139.1398,291.2832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;9;-285.7501,42.177;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-300.1501,-319.4235;Inherit;False;Property;_ColorB;Color B;5;0;Create;True;0;0;0;False;0;False;0,0.7843137,0.3254902,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;298.1406,118.3831;Inherit;False;Property;_ColorC;Color C;6;0;Create;True;0;0;0;False;0;False;1,0.8392157,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;19;325.8397,291.2832;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;243.6498,-154.623;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;20;807.0389,98.48322;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;28;1111.771,97.456;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;FondoTropical;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;2;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;3;0
WireConnection;16;0;17;0
WireConnection;25;0;6;0
WireConnection;4;0;2;0
WireConnection;4;1;5;0
WireConnection;7;0;25;0
WireConnection;7;1;4;0
WireConnection;14;0;6;0
WireConnection;23;0;16;0
WireConnection;23;1;24;0
WireConnection;15;0;14;0
WireConnection;15;1;23;0
WireConnection;8;0;7;0
WireConnection;18;0;15;0
WireConnection;9;0;8;0
WireConnection;19;0;18;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;13;2;9;0
WireConnection;20;0;13;0
WireConnection;20;1;21;0
WireConnection;20;2;19;0
WireConnection;28;2;20;0
ASEEND*/
//CHKSM=4C9740C98ED3CA3CA30781DBBC245F40171F328E