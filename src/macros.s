	.file	"foo.c"
	.text
	.global	mybyte1
	.section	.bss,"aw",@nobits
	.type	mybyte1, @object
	.size	mybyte1, 1
mybyte1:
	.zero	1
	.global	mybyte2
	.type	mybyte2, @object
	.size	mybyte2, 1
mybyte2:
	.zero	1
	.global	mybyte3
	.type	mybyte3, @object
	.size	mybyte3, 1
mybyte3:
	.zero	1
	.text
	.p2align	1
	.global	_start
	.type	_start, @function

        .equ ALU_ADD, 4 # supposing 4 is addition...

        .macro alumode k
        mov alusel il   ,\k
        .endm

	.macro plus a, b
        mov alua   \a   ,0
        mov alub   \b  ,0
        .endm

	.macro plusk a, k
        mov alua   \a   ,0
        mov alub   il   ,\k
        .endm

        .macro lad s
	mov     adh il   ,hi8(\s)
	mov	adl il   ,lo8(\s)
        .endm
_start:
# BLOCK 2 seq:0
        # PRED: ENTRY (FALLTHRU)
        mov  r il ,1
        alumode ALU_ADD
        lad mybyte1
        plus    mem r
        plusk   aluc 2
        mov jmph il ,0
        mov jmpl il ,0
        jump
# SUCC: EXIT [always]
	#TODO: implement return	# 18	[c=0 l=2]  returner
	.size	_start, .-_start
	.ident	"GCC: (GNU) 11.1.0"
