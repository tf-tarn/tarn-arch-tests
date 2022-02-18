        .include "simtests/testutils.inc"

        .equ offset, 0x6000     ; Checkpoint counter
        .equ output, 0x7000     ; Output segment

        .macro lad s
	mov     adh il   ,hi8(\s)
	mov	adl il   ,lo8(\s)
        .endm

        .macro increment a
        mov ara   \a   ,0
        mov arb   il   ,1
        mov \a    arc  ,0
        .endm

        ;; Increment offset and store the provided value at that
	;; location in the output segment.
        .macro checkpoint value
        lad offset
        increment mem
        mov     adl mem
	mov     adh il   ,hi8(output)
        mov mem il ,\value
        .endm

        ;; Start offset at 0xff so that the first checkpoint is at output+0.
        .macro initialize
        lad offset
        mov mem il ,0xff
        .endm

        /*
        Program follows.
        This test is designed to check that jumps are executed
        correctly. When the simulation halts, checkpoint values should
	be written in memory in ascending order.
        */

        .text
        initialize
        checkpoint 1
	mov     jmph il   ,hi8(jump_target1)
	mov	jmpl il   ,lo8(jump_target1)
        checkpoint 2
        jump
        nop
	.global	jump_target2
jump_target2:
        checkpoint 5
        halt
	.global	jump_target1
jump_target1:
        checkpoint 3
	mov     jmph il   ,hi8(jump_target2)
	mov	jmpl il   ,lo8(jump_target2)
        checkpoint 4
        nop
        jump
