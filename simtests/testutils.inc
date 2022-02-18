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
