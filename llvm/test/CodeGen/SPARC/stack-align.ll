; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc -mtriple=sparc < %s | FileCheck %s --check-prefixes=CHECK32
; RUN: llc -mtriple=sparcv9 < %s | FileCheck %s --check-prefixes=CHECK64
declare void @stack_realign_helper(i32 %a, ptr %b)

;; This is a function where we have a local variable of 64-byte
;; alignment.  We want to see that the stack is aligned (the initial add/and),
;; that the local var is accessed via stack pointer (to %o1), and that
;; the argument is accessed via frame pointer not stack pointer (to %o0).

define void @stack_realign(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g) nounwind {
; CHECK32-LABEL: stack_realign:
; CHECK32:       ! %bb.0: ! %entry
; CHECK32-NEXT:    save %sp, -96, %sp
; CHECK32-NEXT:    ld [%fp+92], %o0
; CHECK32-NEXT:    add %sp, 80, %i0
; CHECK32-NEXT:    and %i0, -64, %o1
; CHECK32-NEXT:    call stack_realign_helper
; CHECK32-NEXT:    add %o1, -96, %sp
; CHECK32-NEXT:    ret
; CHECK32-NEXT:    restore
;
; CHECK64-LABEL: stack_realign:
; CHECK64:       ! %bb.0: ! %entry
; CHECK64-NEXT:    save %sp, -128, %sp
; CHECK64-NEXT:    add %sp, 2159, %i0
; CHECK64-NEXT:    and %i0, -64, %o1
; CHECK64-NEXT:    add %o1, -2175, %sp
; CHECK64-NEXT:    add %sp, -48, %sp
; CHECK64-NEXT:    call stack_realign_helper
; CHECK64-NEXT:    ld [%fp+2227], %o0
; CHECK64-NEXT:    add %sp, 48, %sp
; CHECK64-NEXT:    ret
; CHECK64-NEXT:    restore
entry:
  %aligned = alloca i32, align 64
  call void @stack_realign_helper(i32 %g, ptr %aligned)
  ret void
}
