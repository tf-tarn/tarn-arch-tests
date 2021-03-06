        .include "simtests/testutils.inc"

        .equ result16, 0x6030       ; product

        .equ a16, 0x5012            ; first multiplicand
        .equ b16, 0x5014            ; second multiplicand

        .equ temp_space,     0x4000 ; temporary storage
        .equ temp_sum_lo,    0x4000
        .equ temp_sum_hi,    0x4001
        .equ temp_carry,     0x4002


        .macro ljmp s
	mov     jmph il   ,hi8(\s)
	mov	jmpl il   ,lo8(\s)
        .endm

        .macro storek addr k
        mov adl il ,lo8(\addr)
        mov mem il ,\k
        .endm

        .macro storegk addr k
        lad \addr
        mov mem il ,\k
        .endm

        .macro loadnext dest addr
        mov adl   il ,lo8(1+\addr)
        mov \dest mem
        .endm

        .macro storenext addr src
        mov adl   il ,lo8(1+\addr)
        mov mem \src
        .endm

        .macro plus16 sa, sb, result

        ;; work in input space, so we only have to change adl
        mov adh il, hi8(\sa)
        ;; load sa low byte
        load ara \sa+1
        ;; load sb low byte
        load arb \sb+1

        ;; work in temp space
        mov adh il, hi8(temp_space)

        ;; record the sum
        store temp_sum_lo arc

        ;; get carry bit and store it
        update_status
        store temp_carry status

        ;; work in input space
        mov adh il, hi8(\sa)
        ;; load sa high byte
        load ara \sa
        ;; load sb high byte
        load arb \sb

        ;; work in temp space
        mov adh il, hi8(temp_space)
        ;; save the sum
        mov r arc
	;; now add the sum and the carry
        mov ara r
        load arb temp_carry
        load r temp_sum_lo

        ;; work in output space
        mov adh il, hi8(\result)
        ;; save result
	store \result   arc
        store \result+1 r

        .endm

;;; program follows

	.text
	.global	_start
_start:
        storegk a16   0x12
        storegk a16+1 0x34
        storegk b16   0x56
        storegk b16+1 0xd8

        plus16 a16 b16 result16

        halt
