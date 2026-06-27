// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ejer3"
{
	Properties
	{
		_Frequency("Frequency", Float) = 0
		_LineSpeed("Line Speed", Float) = 0
		_WaveLenght("Wave Lenght", Range( 0 , 0.05)) = 0
		_Alpha("Alpha", Range( 0 , 1)) = 0
		_SplashPos("SplashPos", Vector) = (0,0,0,0)
		_SplashForce("SplashForce", Float) = 0
		_WaterColor("WaterColor", Color) = (1,0,0,0)
		_WaterSurface("WaterSurface", Color) = (0,0,0,0)
		_WatervoidColor("Water void Color", Color) = (0.01312745,0.4570561,0.5566038,1)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _LineSpeed;
		uniform float3 _SplashPos;
		uniform float _SplashForce;
		uniform float _Frequency;
		uniform float _WaveLenght;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _WaterSurface;
		uniform float4 _WaterColor;
		uniform float4 _WatervoidColor;
		uniform float _Alpha;


		float2 voronoihash139( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi139( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash139( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.5);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertex3Pos = v.vertex.xyz;
			float mulTime10 = _Time.y * _LineSpeed;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float WaterInteraction115 = saturate( ( distance( ase_worldPos , _SplashPos ) / 4.0 ) );
			float3 Sin175 = ( ( sin( ( ( ase_vertex3Pos.x + mulTime10 + ( WaterInteraction115 * _SplashForce ) ) * ( _Frequency * 6.28318548202515 ) ) ) * 1.0 * _WaveLenght ) * float3(0,1,0) );
			v.vertex.xyz += Sin175;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			o.Normal = tex2D( _TextureSample0, uv_TextureSample0 ).rgb;
			float time139 = _Time.y;
			float2 coords139 = i.uv_texcoord * 10.0;
			float2 id139 = 0;
			float2 uv139 = 0;
			float voroi139 = voronoi139( coords139, time139, id139, uv139, 0 );
			float smoothstepResult160 = smoothstep( 0.0 , 0.001 , voroi139);
			float smoothstepResult161 = smoothstep( 0.0 , 0.05 , smoothstepResult160);
			float4 lerpResult157 = lerp( _WaterSurface , _WaterColor , smoothstepResult161);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float VertexY178 = ase_vertex3Pos.y;
			float smoothstepResult146 = smoothstep( 0.0 , 1.0 , VertexY178);
			float4 lerpResult156 = lerp( lerpResult157 , float4( 0,0,0,0 ) , smoothstepResult146);
			float4 lerpResult147 = lerp( _WaterSurface , _WaterColor , voroi139);
			float smoothstepResult138 = smoothstep( 0.0 , 1.0 , VertexY178);
			float4 lerpResult123 = lerp( lerpResult156 , lerpResult147 , smoothstepResult138);
			float smoothstepResult162 = smoothstep( 0.0 , 1.0 , ( VertexY178 + 0.0 ));
			float4 lerpResult172 = lerp( lerpResult123 , _WatervoidColor , ( 1.0 - smoothstepResult162 ));
			o.Albedo = lerpResult172.rgb;
			o.Alpha = _Alpha;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;672;1465;319;591.8771;-11.90083;1.792085;True;False
Node;AmplifyShaderEditor.Vector3Node;100;-2855.077,135.793;Inherit;False;Property;_SplashPos;SplashPos;4;0;Create;True;0;0;0;False;0;False;0,0,0;-1.594166,-1.303783,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;101;-2850.426,-63.85266;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;102;-2510.188,50.5329;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;103;-2349.341,54.8031;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;104;-2150.471,-0.8187485;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-1913.011,-10.1639;Inherit;False;WaterInteraction;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-2623.484,854.1142;Inherit;False;Property;_SplashForce;SplashForce;5;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2863.722,580.4628;Inherit;False;Property;_LineSpeed;Line Speed;1;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-2620.824,678.3598;Inherit;False;115;WaterInteraction;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-2398.194,676.5457;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-2609.708,585.6627;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;13;-2584.761,395.868;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-2391.673,824.9921;Inherit;False;Property;_Frequency;Frequency;0;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;6;-2389.07,934.9279;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;140;-1556.956,-309.4105;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;139;-1321.736,-318.3479;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-2244.06,804.9601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-2093.546,575.0236;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;160;-1094.864,-62.95269;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1959.823,583.0762;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;178;-2122.297,453.6646;Inherit;False;VertexY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;3;-1815.091,584.4827;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-674.6293,725.2536;Inherit;False;178;VertexY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;181;-629.4092,348.21;Inherit;False;178;VertexY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;109;-777.7425,-36.19973;Inherit;False;Property;_WaterColor;WaterColor;6;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0.7626436,0.9339623,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;136;-791.9073,-503.4318;Inherit;False;Property;_WaterSurface;WaterSurface;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-2075.606,824.1522;Inherit;False;Property;_WaveLenght;Wave Lenght;2;0;Create;True;0;0;0;False;0;False;0;0.05;0;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;161;-803.9738,-291.0562;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;65;-1767.484,828.3372;Inherit;False;Constant;_Limits;Limits;5;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1669.487,582.5911;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;-420.1747,727.3456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;157;-392.8238,-74.1591;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;180;-308.1214,499.8387;Inherit;False;178;VertexY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;146;-395.4297,189.824;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;147;-181.7305,-497.5192;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1398.065,698.2106;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;156;-105.6436,-45.40087;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;162;-190.7668,728.755;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;138;-93.29294,220.5639;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;168;352.035,535.0466;Inherit;False;Property;_WatervoidColor;Water void Color;8;0;Create;True;0;0;0;False;0;False;0.01312745,0.4570561,0.5566038,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;166;138.2986,480.8623;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-1157.463,773.9597;Inherit;False;Sin;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;123;288.5986,151.8202;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;173;586.0386,581.7526;Inherit;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;0;False;0;False;-1;None;d49f07042ee1c824696815005d4e61f3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;172;616.3289,349.4505;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;744.7936,990.2357;Inherit;False;175;Sin;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;67;625.6448,801.9055;Inherit;False;Property;_Alpha;Alpha;3;0;Create;True;0;0;0;False;0;False;0;0.954;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;2;708.9929,1083.849;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;127;989.1984,559.1428;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Ejer3;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;102;0;101;0
WireConnection;102;1;100;0
WireConnection;103;0;102;0
WireConnection;104;0;103;0
WireConnection;115;0;104;0
WireConnection;107;0;116;0
WireConnection;107;1;106;0
WireConnection;10;0;11;0
WireConnection;139;1;140;0
WireConnection;5;0;7;0
WireConnection;5;1;6;0
WireConnection;8;0;13;1
WireConnection;8;1;10;0
WireConnection;8;2;107;0
WireConnection;160;0;139;0
WireConnection;4;0;8;0
WireConnection;4;1;5;0
WireConnection;178;0;13;2
WireConnection;3;0;4;0
WireConnection;161;0;160;0
WireConnection;48;0;3;0
WireConnection;48;2;49;0
WireConnection;164;0;179;0
WireConnection;157;0;136;0
WireConnection;157;1;109;0
WireConnection;157;2;161;0
WireConnection;146;0;181;0
WireConnection;147;0;136;0
WireConnection;147;1;109;0
WireConnection;147;2;139;0
WireConnection;64;0;48;0
WireConnection;64;1;65;0
WireConnection;156;0;157;0
WireConnection;156;2;146;0
WireConnection;162;0;164;0
WireConnection;138;0;180;0
WireConnection;166;0;162;0
WireConnection;175;0;64;0
WireConnection;123;0;156;0
WireConnection;123;1;147;0
WireConnection;123;2;138;0
WireConnection;172;0;123;0
WireConnection;172;1;168;0
WireConnection;172;2;166;0
WireConnection;127;0;172;0
WireConnection;127;1;173;0
WireConnection;127;9;67;0
WireConnection;127;11;176;0
WireConnection;127;14;2;0
ASEEND*/
//CHKSM=79062E5C7F4F7443D8C444442FFB3A90691E41DB