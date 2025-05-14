_main:  nop
        ld b,c

label1:
        pop bc
_vblank:        ld [label1],sp

        nop

label2: nop
        ld b,label2
label3: nop
