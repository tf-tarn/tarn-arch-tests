        .include "simtests/testutils.inc"

        .equ variables, 0x6000     ; variable region
        .equ offset, 0x6000        ; Checkpoint offset/counter
        .equ counter, 0x6001       ; loop counter
        .equ output, 0x7000        ; Output region

        ;; Increment offset and store the provided value at that
	;; location in the output segment.
        .macro checkpoint value
        lad offset
        mov     adl mem
	mov     adh il   ,hi8(output)
        mov mem il ,\value
        lad offset
        increment mem
        .endm

        .macro initialize n_loops
        ;; Set counter appropriately for the given number of iterations
        lad counter
        mov mem il ,0xff-\n_loops+1
        lad offset
        mov mem il ,0
        .endm

        /*
        Program follows.
        This will loop 20 times, writing into memory each time.
        */

        .text
        initialize 20

	mov     jmph il   ,hi8(loop_start)
	mov	jmpl il   ,lo8(loop_start)
        jump                    ; enter loop
        .org 100                ;
        .global stop
stop:
        halt
	.global	loop_start
loop_start:
        checkpoint 0xee

        lad counter
        plusk mem 1
        mov mem arc

        ;; Count up till arithmetic carry
        update_status
        quadruple r status
        ;; add to branch1 address
        ;; it is either branch1 or branch1+4 which is branch2
        mov ara il ,lo8(branch1)
        mov arb r
        mov jmpl arc
        jump

        .global branch1
branch1:
        mov jmpl il ,lo8(loop_start)
        jump
branch2:
	mov     jmph il   ,hi8(stop)
	mov	jmpl il   ,lo8(stop)
        jump
        nop
        halt
break:
