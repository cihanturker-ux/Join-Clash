Shader "FlatKit/Stylized Surface With Outline"
{
    Properties
    {
        [MainColor] _Color ("Color", Color) = (1,1,1,1)
        
        [Space(10)]
        [KeywordEnum(None, Single, Steps, Curve)]_CelPrimaryMode("Cel Shading Mode", Float) = 1
        _ColorDim ("[_CELPRIMARYMODE_SINGLE]Color Shaded", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _ColorDimSteps ("[_CELPRIMARYMODE_STEPS]Color Shaded", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _ColorDimCurve ("[_CELPRIMARYMODE_CURVE]Color Shaded", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _SelfShadingSize ("[_CELPRIMARYMODE_SINGLE]Self Shading Size", Range(0, 1)) = 0.5
        _ShadowEdgeSize ("[_CELPRIMARYMODE_SINGLE]Shadow Edge Size", Range(0, 0.5)) = 0.05
        _Flatness ("[_CELPRIMARYMODE_SINGLE]Localized Shading", Range(0, 1)) = 1.0

        [IntRange]_CelNumSteps ("[_CELPRIMARYMODE_STEPS]Number Of Steps", Range(1, 10)) = 3.0
        _CelStepTexture ("[_CELPRIMARYMODE_STEPS][LAST_PROP_STEPS]Cel steps", 2D) = "black" {}
        _CelCurveTexture ("[_CELPRIMARYMODE_CURVE][LAST_PROP_CURVE]Ramp", 2D) = "black" {}

        [Space(10)]
        [Toggle(DR_CEL_EXTRA_ON)] _CelExtraEnabled("Enable Extra Cel Layer", Int) = 0
        _ColorDimExtra ("[DR_CEL_EXTRA_ON]Color Shaded", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _SelfShadingSizeExtra ("[DR_CEL_EXTRA_ON]Self Shading Size", Range(0, 1)) = 0.6
        _ShadowEdgeSizeExtra ("[DR_CEL_EXTRA_ON]Shadow Edge Size", Range(0, 0.5)) = 0.05
        _FlatnessExtra ("[DR_CEL_EXTRA_ON]Localized Shading", Range(0, 1)) = 1.0

        [Space(10)]
        [Toggle(DR_SPECULAR_ON)] _SpecularEnabled("Enable Specular", Int) = 0
        [HDR] _FlatSpecularColor("[DR_SPECULAR_ON]Specular Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _FlatSpecularSize("[DR_SPECULAR_ON]Specular Size", Range(0.0, 1.0)) = 0.1
        _FlatSpecularEdgeSmoothness("[DR_SPECULAR_ON]Specular Edge Smoothness", Range(0.0, 1.0)) = 0

        [Space(10)]
        [Toggle(DR_RIM_ON)] _RimEnabled("Enable Rim", Int) = 0
        [HDR] _FlatRimColor("[DR_RIM_ON]Rim Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _FlatRimLightAlign("[DR_RIM_ON]Light Align", Range(0.0, 1.0)) = 0
        _FlatRimSize("[DR_RIM_ON]Rim Size", Range(0, 1)) = 0.5
        _FlatRimEdgeSmoothness("[DR_RIM_ON]Rim Edge Smoothness", Range(0, 1)) = 0.5

        [Space(10)]
        [Toggle(DR_GRADIENT_ON)] _GradientEnabled("Enable Height Gradient", Int) = 0
        [HDR] _ColorGradient("[DR_GRADIENT_ON]Gradient Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _GradientCenterX("[DR_GRADIENT_ON]Center X", Float) = 0
        _GradientCenterY("[DR_GRADIENT_ON]Center Y", Float) = 0
        _GradientSize("[DR_GRADIENT_ON]Size", Float) = 10.0
        _GradientAngle("[DR_GRADIENT_ON]Gradient Angle", Range(0, 360)) = 0

        [Space(10)]
        [Toggle(DR_VERTEX_COLORS_ON)] _VertexColorsEnabled("Enable Vertex Colors", Int) = 0
        
        _LightContribution("[FOLDOUT(Advanced Lighting){1}]Light Color Contribution", Range(0, 1)) = 0
        
        [KeywordEnum(None, Multiply, Color)] _UnityShadowMode ("[FOLDOUT(Unity Built-in Shadows){4}]Mode", Float) = 0
        _UnityShadowPower("[_UNITYSHADOWMODE_MULTIPLY]Power", Range(0, 1)) = 0.2
        _UnityShadowColor("[_UNITYSHADOWMODE_COLOR]Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _UnityShadowSharpness("Sharpness", Range(1, 10)) = 1.0

        [Space(10)]
        [MainTexture] _MainTex ("[FOLDOUT(Texture maps){4}]Albedo", 2D) = "white" {}
        [KeywordEnum(Multiply, Add)]_TextureBlendingMode("Blending Mode", Float) = 0
        _TextureImpact("Texture Impact", Range(0, 1)) = 1.0

        [Space(10)]
        _BumpMap ("Bump Map", 2D) = "bump" {}

        [Space(25)]
        _OutlineColor("Outline Color", Color) = (0.85023, 0.85034, 0.85045, 0.85056)
        _OutlineWidth("Outline Width", Float) = 0.01
        _OutlineDepthOffset("Outline Depth Offset", Range(0, 1)) = 0.0

        // Blending state
        [HideInInspector] _Surface("__surface", Float) = 0.0
        [HideInInspector] _Blend("__blend", Float) = 0.0
        [HideInInspector] _AlphaClip("__clip", Float) = 0.0
        [HideInInspector] _SrcBlend("__src", Float) = 1.0
        [HideInInspector] _DstBlend("__dst", Float) = 0.0
        [HideInInspector] _ZWrite("__zw", Float) = 1.0
        [HideInInspector] _Cull("__cull", Float) = 2.0

        // Editmode props
        [HideInInspector] _QueueOffset("Queue offset", Float) = 0.0
    }

    /*
    // -----------------------------------------------
    // --------------------- URP ---------------------
    // -----------------------------------------------
    SubShader
    {
        Tags{"RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "IgnoreProjector" = "True"}
        LOD 300

        Pass
        {
            Name "ForwardLit"
            Tags {"LightMode" = "UniversalForward"}

            Blend[_SrcBlend][_DstBlend]
            ZWrite[_ZWrite]
            Cull[_Cull]

            HLSLPROGRAM

            #pragma shader_feature_local __ _CELPRIMARYMODE_SINGLE _CELPRIMARYMODE_STEPS _CELPRIMARYMODE_CURVE
            #pragma shader_feature_local DR_CEL_EXTRA_ON
            #pragma shader_feature_local DR_GRADIENT_ON
            #pragma shader_feature_local DR_SPECULAR_ON
            #pragma shader_feature_local DR_RIM_ON
            #pragma shader_feature_local DR_VERTEX_COLORS_ON
            #pragma shader_feature_local __ _UNITYSHADOWMODE_MULTIPLY _UNITYSHADOWMODE_COLOR
            #pragma shader_feature_local _TEXTUREBLENDINGMODE_MULTIPLY _TEXTUREBLENDINGMODE_ADD

            #pragma skip_variants POINT_COOKIE DIRECTIONAL_COOKIE

            // Required to compile gles 2.0 with standard SRP library
            // All shaders must be compiled with HLSLcc and currently only gles is not using HLSLcc by default
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            // -------------------------------------
            // Material Keywords
            // #pragma shader_feature _NORMALMAP
            #pragma shader_feature _ALPHATEST_ON
            #pragma shader_feature _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _EMISSION
            #pragma shader_feature _METALLICSPECGLOSSMAP
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature _OCCLUSIONMAP

            #pragma shader_feature _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature _ENVIRONMENTREFLECTIONS_OFF
            #pragma shader_feature _SPECULAR_SETUP
            #pragma shader_feature _RECEIVE_SHADOWS_OFF

            // -------------------------------------
            // Universal Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile_fog

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex LitPassVertex
            #pragma fragment LitPassFragment

            // TODO: Toggle _NORMALMAP from the editor script.
            #define _NORMALMAP
            #define BUMP_SCALE_NOT_SUPPORTED 1

            #include "LibraryUrp/LitInput_DR.hlsl"
            #include "LibraryUrp/StylizedInput.hlsl"
            #include "LibraryUrp/LitForwardPass_DR.hlsl"
            #include "LibraryUrp/Lighting_DR.hlsl"
            
            ENDHLSL
        }

        Pass {
            Cull Front

            CGPROGRAM
            #include "UnityInstancing.cginc"

            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram

            UNITY_INSTANCING_BUFFER_START(OutlineProps)
            UNITY_DEFINE_INSTANCED_PROP(half4, _OutlineColor)
            UNITY_DEFINE_INSTANCED_PROP(half, _OutlineWidth)
            UNITY_DEFINE_INSTANCED_PROP(half, _OutlineDepthOffset)
            UNITY_INSTANCING_BUFFER_END(OutlineProps)

            float4 VertexProgram(float4 position : POSITION, float3 normal : NORMAL) : SV_POSITION {
                float4 clipPosition = UnityObjectToClipPos(position);
                float3 clipNormal = mul((float3x3) UNITY_MATRIX_VP, mul((float3x3) UNITY_MATRIX_M, normal));
                half outlineWidth = UNITY_ACCESS_INSTANCED_PROP(OutlineProps, _OutlineWidth);
                float2 offset = normalize(clipNormal.xy) / _ScreenParams.xy * outlineWidth * clipPosition.w * 2.0;
                clipPosition.xy += offset;
                half outlineDepthOffset = UNITY_ACCESS_INSTANCED_PROP(OutlineProps, _OutlineDepthOffset);
                clipPosition.z -= outlineDepthOffset;
                return clipPosition;
            }

            half4 FragmentProgram() : SV_TARGET {
                return UNITY_ACCESS_INSTANCED_PROP(OutlineProps, _OutlineColor);
            }

            ENDCG
        }

        Pass
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual
            Cull[_Cull]

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature _ALPHATEST_ON

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "LibraryUrp/LitInput_DR.hlsl"
            #include "LibraryUrp/ShadowCasterPass_DR.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite On
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0

            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature _ALPHATEST_ON
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #include "LibraryUrp/LitInput_DR.hlsl"
            #include "LibraryUrp/DepthOnlyPass_DR.hlsl"
            ENDHLSL
        }

        UsePass "Universal Render Pipeline/Lit/Meta"
    }
    */
    // /*
    // ------------------------------------------------
    // ------------------- Built-in -------------------
    // ------------------------------------------------
    SubShader
    {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 200

        CGPROGRAM
        #include "DustyroomStylizedLighting.cginc"
        // Doc: https://docs.unity3d.com/Manual/SL-SurfaceShaders.html
        #pragma surface surfObject DustyroomStylized vertex:vertObject fullforwardshadows
        #pragma require interpolators15
        #pragma target 3.0
        #define Input InputObject

        #pragma shader_feature_local __ _CELPRIMARYMODE_SINGLE _CELPRIMARYMODE_STEPS _CELPRIMARYMODE_CURVE
        #pragma shader_feature_local DR_CEL_EXTRA_ON
        #pragma shader_feature_local DR_GRADIENT_ON
        #pragma shader_feature_local DR_SPECULAR_ON
        #pragma shader_feature_local DR_RIM_ON
        #pragma shader_feature_local DR_VERTEX_COLORS_ON
        #pragma shader_feature_local __ _UNITYSHADOWMODE_MULTIPLY _UNITYSHADOWMODE_COLOR
        #pragma shader_feature_local _TEXTUREBLENDINGMODE_MULTIPLY _TEXTUREBLENDINGMODE_ADD

        #pragma skip_variants POINT_COOKIE DIRECTIONAL_COOKIE

        ENDCG

        Pass {
            Cull Front

            CGPROGRAM
            #include "UnityInstancing.cginc"

            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram

            UNITY_INSTANCING_BUFFER_START(OutlineProps)
            UNITY_DEFINE_INSTANCED_PROP(half4, _OutlineColor)
            UNITY_DEFINE_INSTANCED_PROP(half, _OutlineWidth)
            UNITY_DEFINE_INSTANCED_PROP(half, _OutlineDepthOffset)
            UNITY_INSTANCING_BUFFER_END(OutlineProps)

            float4 VertexProgram(float4 position : POSITION, float3 normal : NORMAL) : SV_POSITION {
                float4 clipPosition = UnityObjectToClipPos(position);
                float3 clipNormal = mul((float3x3) UNITY_MATRIX_VP, mul((float3x3) UNITY_MATRIX_M, normal));
                half outlineWidth = UNITY_ACCESS_INSTANCED_PROP(OutlineProps, _OutlineWidth);
                float2 offset = normalize(clipNormal.xy) / _ScreenParams.xy * outlineWidth * clipPosition.w * 2.0;
                clipPosition.xy += offset;
                half outlineDepthOffset = UNITY_ACCESS_INSTANCED_PROP(OutlineProps, _OutlineDepthOffset);
                clipPosition.z -= outlineDepthOffset;
                return clipPosition;
            }

            half4 FragmentProgram() : SV_TARGET {
                return UNITY_ACCESS_INSTANCED_PROP(OutlineProps, _OutlineColor);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
    // */

    CustomEditor "StylizedSurfaceEditor"
}
