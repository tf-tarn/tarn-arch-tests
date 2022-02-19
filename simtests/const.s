        .include "simtests/testutils.inc"

        /*
        Program follows.
        */

        .text

        mov r zero
        storeg 0x7000 r
        mov r one
        storeg 0x7001 r
        mov r one
        storeg 0x7002 r
        mov r zero
        storeg 0x7003 r

        mov r il ,0x99
        storeg 0x7004 r
        mov ara il ,0x01
        mov arb il ,0x20
        storeg 0x7005 arc
        halt
