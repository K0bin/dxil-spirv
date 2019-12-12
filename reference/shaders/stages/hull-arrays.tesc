#version 460
layout(vertices = 2) out;

layout(location = 0) in float VSValue[][3];
layout(location = 0) out float HSValue[2][3];
layout(location = 0) patch out float PATCH[2];

void hull_main()
{
    float _39 = (VSValue[1u][1u] + VSValue[0u][0u]) + VSValue[2u][2u];
    HSValue[gl_InvocationID][0u] = _39;
    HSValue[gl_InvocationID][1u] = _39 + 1.0;
    HSValue[gl_InvocationID][2u] = _39 + 2.0;
}

void patch_main()
{
    gl_TessLevelInner[0u] = HSValue[1u][2u] + HSValue[0u][1u];
    gl_TessLevelOuter[0u] = VSValue[0u][2u];
    gl_TessLevelOuter[1u] = VSValue[1u][1u];
    gl_TessLevelOuter[2u] = VSValue[2u][0u];
    PATCH[0u] = VSValue[3u][2u];
    PATCH[1u] = VSValue[4u][1u];
}

void main()
{
    hull_main();
    barrier();
    if (gl_InvocationID == 0u)
    {
        patch_main();
    }
}


#if 0
// LLVM disassembly
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

define void @main() {
  %1 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0)
  %2 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 1, i8 0, i32 1)
  %3 = fadd fast float %2, %1
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 2, i8 0, i32 2)
  %5 = fadd fast float %3, %4
  %6 = fadd fast float %5, 1.000000e+00
  %7 = fadd fast float %5, 2.000000e+00
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %5)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 1, i8 0, float %6)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 2, i8 0, float %7)
  ret void
}

define void @"\01?main_patch@@YA?AUPatchConstant@@V?$OutputPatch@UHSControlPoint@@$01@@V?$InputPatch@UVSControlPoint@@$04@@@Z"() {
  %1 = call float @dx.op.loadOutputControlPoint.f32(i32 103, i32 0, i32 1, i8 0, i32 0)
  %2 = call float @dx.op.loadOutputControlPoint.f32(i32 103, i32 0, i32 2, i8 0, i32 1)
  %3 = fadd fast float %2, %1
  call void @dx.op.storePatchConstant.f32(i32 106, i32 1, i32 0, i8 0, float %3)
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 2, i8 0, i32 0)
  call void @dx.op.storePatchConstant.f32(i32 106, i32 0, i32 0, i8 0, float %4)
  %5 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 1, i8 0, i32 1)
  call void @dx.op.storePatchConstant.f32(i32 106, i32 0, i32 1, i8 0, float %5)
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 2)
  call void @dx.op.storePatchConstant.f32(i32 106, i32 0, i32 2, i8 0, float %6)
  %7 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 2, i8 0, i32 3)
  call void @dx.op.storePatchConstant.f32(i32 106, i32 2, i32 0, i8 0, float %7)
  %8 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 1, i8 0, i32 4)
  call void @dx.op.storePatchConstant.f32(i32 106, i32 2, i32 1, i8 0, float %8)
  ret void
}

; Function Attrs: nounwind readnone
declare float @dx.op.loadInput.f32(i32, i32, i32, i8, i32) #0

; Function Attrs: nounwind
declare void @dx.op.storeOutput.f32(i32, i32, i32, i8, float) #1

; Function Attrs: nounwind
declare void @dx.op.storePatchConstant.f32(i32, i32, i32, i8, float) #1

; Function Attrs: nounwind readnone
declare float @dx.op.loadOutputControlPoint.f32(i32, i32, i32, i8, i32) #0

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind }

!llvm.ident = !{!0}
!dx.version = !{!1}
!dx.valver = !{!2}
!dx.shaderModel = !{!3}
!dx.viewIdState = !{!4}
!dx.entryPoints = !{!5}

!0 = !{!"clang version 3.7 (tags/RELEASE_370/final)"}
!1 = !{i32 1, i32 0}
!2 = !{i32 1, i32 5}
!3 = !{!"hs", i32 6, i32 0}
!4 = !{[21 x i32] [i32 9, i32 9, i32 273, i32 0, i32 0, i32 0, i32 273, i32 0, i32 0, i32 0, i32 273, i32 13, i32 6144, i32 0, i32 0, i32 0, i32 4240, i32 0, i32 0, i32 0, i32 4105]}
!5 = !{void ()* @main, !"main", !6, null, !19}
!6 = !{!7, !11, !13}
!7 = !{!8}
!8 = !{i32 0, !"VSValue", i8 9, i8 0, !9, i8 2, i32 3, i8 1, i32 0, i8 0, !10}
!9 = !{i32 0, i32 1, i32 2}
!10 = !{i32 3, i32 1}
!11 = !{!12}
!12 = !{i32 0, !"HSValue", i8 9, i8 0, !9, i8 2, i32 3, i8 1, i32 0, i8 0, !10}
!13 = !{!14, !15, !17}
!14 = !{i32 0, !"SV_TessFactor", i8 9, i8 25, !9, i8 0, i32 3, i8 1, i32 0, i8 3, !10}
!15 = !{i32 1, !"SV_InsideTessFactor", i8 9, i8 26, !16, i8 0, i32 1, i8 1, i32 3, i8 0, !10}
!16 = !{i32 0}
!17 = !{i32 2, !"PATCH", i8 9, i8 0, !18, i8 0, i32 2, i8 1, i32 0, i8 0, !10}
!18 = !{i32 0, i32 1}
!19 = !{i32 3, !20}
!20 = !{void ()* @"\01?main_patch@@YA?AUPatchConstant@@V?$OutputPatch@UHSControlPoint@@$01@@V?$InputPatch@UVSControlPoint@@$04@@@Z", i32 5, i32 2, i32 2, i32 1, i32 4, float 6.400000e+01}
#endif
#if 0
// SPIR-V disassembly
; SPIR-V
; Version: 1.3
; Generator: Unknown(30017); 21022
; Bound: 87
; Schema: 0
OpCapability Shader
OpCapability Tessellation
OpMemoryModel Logical GLSL450
OpEntryPoint TessellationControl %3 "main" %12 %16 %20 %23 %24 %47
OpExecutionMode %3 Triangles
OpExecutionMode %3 SpacingEqual
OpExecutionMode %3 VertexOrderCcw
OpExecutionMode %3 OutputVertices 2
OpName %3 "main"
OpName %12 "VSValue"
OpName %16 "HSValue"
OpName %20 "SV_TessFactor"
OpName %23 "SV_InsideTessFactor"
OpName %24 "PATCH"
OpName %25 "hull_main"
OpName %27 "patch_main"
OpDecorate %12 Location 0
OpDecorate %16 Location 0
OpDecorate %20 BuiltIn TessLevelOuter
OpDecorate %20 Patch
OpDecorate %23 BuiltIn TessLevelInner
OpDecorate %23 Patch
OpDecorate %24 Location 0
OpDecorate %24 Patch
OpDecorate %47 BuiltIn InvocationId
%1 = OpTypeVoid
%2 = OpTypeFunction %1
%5 = OpTypeFloat 32
%6 = OpTypeInt 32 0
%7 = OpConstant %6 3
%8 = OpTypeArray %5 %7
%9 = OpConstant %6 5
%10 = OpTypeArray %8 %9
%11 = OpTypePointer Input %10
%12 = OpVariable %11 Input
%13 = OpConstant %6 2
%14 = OpTypeArray %8 %13
%15 = OpTypePointer Output %14
%16 = OpVariable %15 Output
%17 = OpConstant %6 4
%18 = OpTypeArray %5 %17
%19 = OpTypePointer Output %18
%20 = OpVariable %19 Output
%21 = OpTypeArray %5 %13
%22 = OpTypePointer Output %21
%23 = OpVariable %22 Output
%24 = OpVariable %22 Output
%29 = OpTypePointer Input %5
%31 = OpConstant %6 0
%34 = OpConstant %6 1
%41 = OpConstant %5 1
%43 = OpConstant %5 2
%44 = OpTypePointer Output %5
%46 = OpTypePointer Input %6
%47 = OpVariable %46 Input
%76 = OpTypeBool
%3 = OpFunction %1 None %2
%4 = OpLabel
OpBranch %79
%79 = OpLabel
%74 = OpFunctionCall %1 %25
%75 = OpLoad %6 %47
%77 = OpIEqual %76 %75 %31
OpControlBarrier %13 %17 %31
OpSelectionMerge %81 None
OpBranchConditional %77 %80 %81
%80 = OpLabel
%78 = OpFunctionCall %1 %27
OpBranch %81
%81 = OpLabel
OpReturn
OpFunctionEnd
%25 = OpFunction %1 None %2
%26 = OpLabel
OpBranch %83
%83 = OpLabel
%30 = OpAccessChain %29 %12 %31 %31
%32 = OpLoad %5 %30
%33 = OpAccessChain %29 %12 %34 %34
%35 = OpLoad %5 %33
%36 = OpFAdd %5 %35 %32
%37 = OpAccessChain %29 %12 %13 %13
%38 = OpLoad %5 %37
%39 = OpFAdd %5 %36 %38
%40 = OpFAdd %5 %39 %41
%42 = OpFAdd %5 %39 %43
%48 = OpLoad %6 %47
%45 = OpAccessChain %44 %16 %48 %31
OpStore %45 %39
%50 = OpLoad %6 %47
%49 = OpAccessChain %44 %16 %50 %34
OpStore %49 %40
%52 = OpLoad %6 %47
%51 = OpAccessChain %44 %16 %52 %13
OpStore %51 %42
OpReturn
OpFunctionEnd
%27 = OpFunction %1 None %2
%28 = OpLabel
OpBranch %85
%85 = OpLabel
%53 = OpAccessChain %44 %16 %31 %34
%54 = OpLoad %5 %53
%55 = OpAccessChain %44 %16 %34 %13
%56 = OpLoad %5 %55
%57 = OpFAdd %5 %56 %54
%58 = OpAccessChain %44 %23 %31
OpStore %58 %57
%59 = OpAccessChain %29 %12 %31 %13
%60 = OpLoad %5 %59
%61 = OpAccessChain %44 %20 %31
OpStore %61 %60
%62 = OpAccessChain %29 %12 %34 %34
%63 = OpLoad %5 %62
%64 = OpAccessChain %44 %20 %34
OpStore %64 %63
%65 = OpAccessChain %29 %12 %13 %31
%66 = OpLoad %5 %65
%67 = OpAccessChain %44 %20 %13
OpStore %67 %66
%68 = OpAccessChain %29 %12 %7 %13
%69 = OpLoad %5 %68
%70 = OpAccessChain %44 %24 %31
OpStore %70 %69
%71 = OpAccessChain %29 %12 %17 %34
%72 = OpLoad %5 %71
%73 = OpAccessChain %44 %24 %34
OpStore %73 %72
OpReturn
OpFunctionEnd
#endif