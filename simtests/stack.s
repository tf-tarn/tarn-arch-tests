        .include "simtests/testutils.inc"

        .equ SP,    0x6000     ; stack pointer address

        .macro initialize       ; set SP to 0 (it's a pre-dec stack)
        lad SP
        mov mem il ,0
        .endm

        .macro _push
        lad SP
        decrement mem
        mov adl mem
        mov adh il ,0xff
        .endm

        .macro pushk value
        _push
        mov mem il ,\value
        .endm

        .macro pop
        lad SP
        increment mem
        .endm

        .macro pop_into reg
        lad SP
        mov adl mem
        mov adh il ,0xff
        mov r mem
        lad SP
        increment mem
        mov \reg r
        .endm

        /*
        Program follows.
        */

        .text
        initialize

        pushk 0x15
        pushk 0x20
        pushk 0x40
        pushk 0x60
        pop                     ; erase 0x60
        pushk 0x30
        pushk 0x10
        pushk 0x05
        pop                     ; go back to 0x10
        pop                     ; go back to 0x30
        pop_into r              ; get top value
        storeg 0x7000 r         ; put it here

        loadg ara SP            ; sanity check
        mov arb il ,2           ; add 2 to SP
        storeg 0x7001 arc       ; if SP is 0xfd (as it should be)
        nop                     ; the sum will be 0xff

        halt
