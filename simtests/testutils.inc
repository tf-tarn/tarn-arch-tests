        .macro halt
        ;; Stop simulated execution with a bad jump instruction.
        .byte 0x99
        .byte 0x99
        .endm
