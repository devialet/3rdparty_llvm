; RUN: opt < %s -instcombine -sample-profile -sample-profile-file=%S/Inputs/einline.prof -S | FileCheck %s

; Checks if both call and invoke can be inlined early if their inlined
; instances are hot in profile.

target triple = "x86_64-unknown-linux-gnu"

@_ZTIi = external constant i8*

; Function Attrs: uwtable
define void @_Z3foov() #0 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) !dbg !6 {
  %1 = alloca i8*
  %2 = alloca i32
  %3 = alloca i32, align 4
; CHECK-NOT: call
  call void @_ZL3barv(), !dbg !9
; CHECK-NOT: invoke
  invoke void @_ZL3barv()
          to label %4 unwind label %5, !dbg !10

; <label>:4:
  ret void

; <label>:5:
  %6 = landingpad { i8*, i32 }
          catch i8* bitcast (i8** @_ZTIi to i8*)
  ret void
}

; Function Attrs: nounwind uwtable
define internal void @_ZL3barv() !dbg !12 {
  ret void
}

declare i32 @__gxx_personality_v0(...)

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1)
!1 = !DIFile(filename: "a", directory: "b/")
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!6 = distinct !DISubprogram(linkageName: "_Z3foov", scope: !1, line: 5, scopeLine: 5, unit: !0)
!9 = !DILocation(line: 6, column: 3, scope: !6)
!10 = !DILocation(line: 8, column: 5, scope: !11)
!11 = distinct !DILexicalBlock(scope: !6, file: !1, line: 7, column: 7)
!12 = distinct !DISubprogram(linkageName: "_ZL3barv", scope: !1, line: 20, scopeLine: 20, unit: !0)
