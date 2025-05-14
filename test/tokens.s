_main:  nop
        ld B,C

label1:
        pop bc
_vblank:        ld B,label1

        nop

label2: nop
        ld B,label2
label3: nop
