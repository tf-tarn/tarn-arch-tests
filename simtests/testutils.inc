        .macro update_status
        ;;  Just a hack, because status isn't loaded automatically.
        mov status p0
        .endm

        .macro double dest src
        ;; dest = 2 * src
        mov ara \src
        mov arb \src
        mov \dest arc
        .endm

	.macro plusk a, k
        ;; Add a register and a constant
        mov ara   \a   ,0
        mov arb   il   ,\k
        .endm

	.macro plus a, b
        ;; Add two registers
        mov ara   \a   ,0
        mov arb   \b  ,0
        .endm

        .macro triple dest src
        ;; dest = 3 * src
        double \dest \src
        plus \dest \src
        mov \dest arc
        .endm

        .macro quadruple dest src
        ;; dest = 4 * src
        double r \src
        double \dest r
        .endm

        .macro increment reg
        ;; Increment the specified register
        mov ara   \reg ,0
        mov arb   il   ,1
        mov \reg  arc  ,0
        .endm

        .macro decrement reg
        ;; Decrement the specified register
        mov ara   \reg ,0
        mov arb   il   ,0xff
        mov \reg  arc  ,0
        .endm

        .macro store addr reg
        ;; Store the value of register reg in memory at address addr
        ;; Don't change ADH.
        mov adl il ,lo8(\addr)
        mov mem \reg
        .endm

        .macro storeg addr reg
        ;; Store the value of register reg in memory at address addr
        ;; Set both ADL and ADH.
        lad \addr
        mov mem \reg
        .endm

        .macro load dest addr
        ;; Load dest with value in memory at address addr
        ;; Don't change ADH.
        mov adl il ,lo8(\addr)
        mov \dest mem
        .endm

        .macro loadg dest addr
        ;; Load dest with value in memory at address addr
        ;; Set both ADL and ADH.
        lad \addr
        mov \dest mem
        .endm

        .macro lad addr
        ;; Load address registers with 16-bit address value
	mov     adh il   ,hi8(\addr)
	mov	adl il   ,lo8(\addr)
        .endm

        .macro halt
        ;; Stop simulated execution with a bad jump instruction.
        .byte 0x99
        .byte 0x99
        .endm
