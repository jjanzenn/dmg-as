%{
#define _XOPEN_SOURCE 600
#include <stdlib.h>

int yylex(void);
int yyerror(const char *s);
%}

%union
{
    char *str;
    uint16_t num;
}

%token LD
%token LDH
%token ADC
%token ADD
%token CP
%token DEC
%token INC
%token SBC
%token SUB
%token AND
%token CPL
%token OR
%token XOR
%token BIT
%token RES
%token SET
%token RL
%token RLA
%token RLC
%token RLCA
%token RR
%token RRA
%token RRC
%token RRCA
%token SLA
%token SRA
%token SRL
%token SWAP
%token CALL
%token JP
%token JR
%token RET
%token RETI
%token RST
%token CCF
%token SCF
%token POP
%token PUSH
%token DI
%token EI
%token HALT
%token DAA
%token NOP
%token STOP

%token BC
%token DE
%token HL
%token SP
%token AF
%token A
%token B
%token C
%token D
%token E
%token H
%token L
%token NC
%token Z
%token NZ

%token  <str>           SYMBOL
%token  <num>           NUM
%token NEWLINE


%%

file:           line
        |       file line
        ;

line:           NEWLINE
        |       command NEWLINE
        |       SYMBOL ':' line
        ;

command:        nop
        |       ld_bc_u16
        |       ld_bc_addr_a
        |       inc_bc
        |       inc_b
        |       dec_b
        |       ld_b_u8
        |       rlca
        |       ld_u16_addr_sp
        |       add_hl_bc
        |       ld_a_bc_addr
        |       dec_bc
        |       inc_c
        |       dec_c
        |       ld_c_u8
        |       rrca
        |       stop
        |       ld_de_u16
        |       ld_de_addr_a
        |       inc_de
        |       inc_d
        |       dec_d
        |       ld_d_u8
        |       rla
        |       jr_i8
        |       add_hl_de
        |       ld_a_de_addr
        |       dec_de
        |       inc_e
        |       dec_e
        |       ld_e_u8
        |       rra
        |       jr_nz_i8
        |       ld_hl_u16
        |       ld_hli_addr_a
        |       inc_hl
        |       inc_h
        |       dec_h
        |       ld_h_u8
        |       daa
        |       jr_z_i8
        |       add_hl_hl
        |       ld_a_hli_addr
        |       dec_hl
        |       inc_l
        |       dec_l
        |       ld_l_u8
        |       cpl
        |       jr_nc_i8
        |       ld_sp_u16
        |       ld_hld_addr_a
        |       inc_sp
        |       inc_hl_addr
        |       dec_hl_addr
        |       ld_hl_addr_u8
        |       scf
        |       jr_c_i8
        |       add_hl_sp
        |       ld_a_hld_addr
        |       dec_sp
        |       inc_a
        |       dec_a
        |       ld_a_u8
        |       ccf
        |       ld_b_b
        |       ld_b_c
        |       ld_b_d
        |       ld_b_e
        |       ld_b_h
        |       ld_b_l
        |       ld_b_hl_addr
        |       ld_b_a
        |       ld_c_b
        |       ld_c_c
        |       ld_c_d
        |       ld_c_e
        |       ld_c_h
        |       ld_c_l
        |       ld_c_hl_addr
        |       ld_c_a
        |       ld_d_b
        |       ld_d_c
        |       ld_d_d
        |       ld_d_e
        |       ld_d_h
        |       ld_d_l
        |       ld_d_hl_addr
        |       ld_d_a
        |       ld_e_b
        |       ld_e_c
        |       ld_e_d
        |       ld_e_e
        |       ld_e_h
        |       ld_e_l
        |       ld_e_hl_addr
        |       ld_e_a
        |       ld_h_b
        |       ld_h_c
        |       ld_h_d
        |       ld_h_e
        |       ld_h_h
        |       ld_h_l
        |       ld_h_hl_addr
        |       ld_h_a
        |       ld_l_b
        |       ld_l_c
        |       ld_l_d
        |       ld_l_e
        |       ld_l_h
        |       ld_l_l
        |       ld_l_hl_addr
        |       ld_l_a
        |       ld_hl_addr_b
        |       ld_hl_addr_c
        |       ld_hl_addr_d
        |       ld_hl_addr_e
        |       ld_hl_addr_h
        |       ld_hl_addr_l
        |       halt
        |       ld_hl_addr_a
        |       ld_a_b
        |       ld_a_c
        |       ld_a_d
        |       ld_a_e
        |       ld_a_h
        |       ld_a_l
        |       ld_a_hl_addr
        |       ld_a_a
        |       add_a_b
        |       add_a_c
        |       add_a_d
        |       add_a_e
        |       add_a_h
        |       add_a_l
        |       add_a_hl_addr
        |       add_a_a
        |       adc_a_b
        |       adc_a_c
        |       adc_a_d
        |       adc_a_e
        |       adc_a_h
        |       adc_a_l
        |       adc_a_hl_addr
        |       adc_a_a
        |       sub_a_b
        |       sub_a_c
        |       sub_a_d
        |       sub_a_e
        |       sub_a_h
        |       sub_a_l
        |       sub_a_hl_addr
        |       sub_a_a
        |       sbc_a_b
        |       sbc_a_c
        |       sbc_a_d
        |       sbc_a_e
        |       sbc_a_h
        |       sbc_a_l
        |       sbc_a_hl_addr
        |       sbc_a_a
        |       and_a_b
        |       and_a_c
        |       and_a_d
        |       and_a_e
        |       and_a_h
        |       and_a_l
        |       and_a_hl_addr
        |       and_a_a
        |       xor_a_b
        |       xor_a_c
        |       xor_a_d
        |       xor_a_e
        |       xor_a_h
        |       xor_a_l
        |       xor_a_hl_addr
        |       xor_a_a
        |       or_a_b
        |       or_a_c
        |       or_a_d
        |       or_a_e
        |       or_a_h
        |       or_a_l
        |       or_a_hl_addr
        |       or_a_a
        |       cp_a_b
        |       cp_a_c
        |       cp_a_d
        |       cp_a_e
        |       cp_a_h
        |       cp_a_l
        |       cp_a_hl_addr
        |       cp_a_a
        |       ret_nz
        |       pop_bc
        |       jp_nz_u16
        |       jp_u16
        |       call_nz_u16
        |       push_bc
        |       add_a_u8
        |       rst_u3
        |       ret_z
        |       ret
        |       jp_z_u16
        |       call_z_u16
        |       call_u16
        |       adc_a_u8
        |       ret_nc
        |       pop_de
        |       jp_nc_u16
        |       call_nc_u16
        |       push_de
        |       sub_a_u8
        |       ret_c
        |       reti
        |       jp_c_u16
        |       call_c_u16
        |       sbc_a_u8
        |       ldh_u8_addr_a
        |       pop_hl
        |       ldh_c_addr_a
        |       push_hl
        |       and_a_u8
        |       add_sp_i8
        |       jp_hl
        |       ld_u16_addr_a
        |       xor_a_u8
        |       ldh_a_u8_addr
        |       pop_af
        |       ldh_a_c_addr
        |       di
        |       push_af
        |       or_a_u8
        |       ld_hl_sp_i8
        |       ld_sp_hl
        |       ld_a_u16_addr
        |       ei
        |       cp_a_u8
        |       rlc_b
        |       rlc_c
        |       rlc_d
        |       rlc_e
        |       rlc_h
        |       rlc_l
        |       rlc_hl_addr
        |       rlc_a
        |       rrc_b
        |       rrc_c
        |       rrc_d
        |       rrc_e
        |       rrc_h
        |       rrc_l
        |       rrc_hl_addr
        |       rrc_a
        |       rl_b
        |       rl_c
        |       rl_d
        |       rl_e
        |       rl_h
        |       rl_l
        |       rl_hl_addr
        |       rl_a
        |       rr_b
        |       rr_c
        |       rr_d
        |       rr_e
        |       rr_h
        |       rr_l
        |       rr_hl_addr
        |       rr_a
        |       sla_b
        |       sla_c
        |       sla_d
        |       sla_e
        |       sla_h
        |       sla_l
        |       sla_hl_addr
        |       sla_a
        |       sra_b
        |       sra_c
        |       sra_d
        |       sra_e
        |       sra_h
        |       sra_l
        |       sra_hl_addr
        |       sra_a
        |       swap_b
        |       swap_c
        |       swap_d
        |       swap_e
        |       swap_h
        |       swap_l
        |       swap_hl_addr
        |       swap_a
        |       srl_b
        |       srl_c
        |       srl_d
        |       srl_e
        |       srl_h
        |       srl_l
        |       srl_hl_addr
        |       srl_a
        |       bit_u3_b
        |       bit_u3_c
        |       bit_u3_d
        |       bit_u3_e
        |       bit_u3_h
        |       bit_u3_l
        |       bit_u3_hl_addr
        |       bit_u3_a
        |       res_u3_b
        |       res_u3_c
        |       res_u3_d
        |       res_u3_e
        |       res_u3_h
        |       res_u3_l
        |       res_u3_hl_addr
        |       res_u3_a
        |       set_u3_b
        |       set_u3_c
        |       set_u3_d
        |       set_u3_e
        |       set_u3_h
        |       set_u3_l
        |       set_u3_hl_addr
        |       set_u3_a
        ;

integer:        NUM
        |       SYMBOL
        ;

nop:            NOP
        ;

ld_bc_u16:      LD BC ',' integer
        ;

ld_bc_addr_a:   LD '(' BC ')' ',' A
        ;

inc_bc:         INC BC
        ;

inc_b:          INC B
        ;

dec_b:          DEC B
        ;

ld_b_u8:        LD B ',' integer
        ;

rlca:           RLCA
        ;

ld_u16_addr_sp: LD '(' integer ')' ',' SP
        ;

add_hl_bc:      ADD HL ',' BC
        ;

ld_a_bc_addr:   LD A ',' '(' BC ')'
        ;

dec_bc:         DEC BC
        ;

inc_c:          INC C
        ;

dec_c:          DEC C
        ;

ld_c_u8:        LD C ',' integer
        ;

rrca:           RRCA
        ;

stop:           STOP
        ;

ld_de_u16:      LD DE ',' integer
        ;

ld_de_addr_a:   LD '(' DE ')' ',' A
        ;

inc_de:         INC DE
        ;

inc_d:          INC D
        ;

dec_d:          DEC D
        ;

ld_d_u8:        LD D integer
        ;

rla:            RLA
        ;

jr_i8:          JR integer
        ;

add_hl_de:      ADD HL ',' DE
        ;

ld_a_de_addr:   LD A ',' '(' DE ')'
        ;

dec_de:         DEC DE
        ;

inc_e:          INC E
        ;

dec_e:          DEC E
        ;

ld_e_u8:        LD E ',' integer
        ;

rra:            RRA
        ;

jr_nz_i8:       JR NZ ',' integer
        ;

ld_hl_u16:      LD HL ',' integer
        ;

ld_hli_addr_a:  LD '(' HL '+' ')' ',' A
        ;

inc_hl:         INC HL
        ;

inc_h:          INC H
        ;

dec_h:          DEC H
        ;

ld_h_u8:        LD H ',' integer
        ;

daa:            DAA
        ;

jr_z_i8:        JR Z ',' integer
        ;

add_hl_hl:      ADD HL ',' HL
        ;

ld_a_hli_addr:  LD A ',' '(' HL '+' ')'
        ;

dec_hl:         DEC HL
        ;

inc_l:          INC L
        ;

dec_l:          DEC L
        ;

ld_l_u8:        LD L ',' integer
        ;

cpl:            CPL
        ;

jr_nc_i8:       JR NC ',' integer
        ;

ld_sp_u16:      LD SP ',' integer
        ;

ld_hld_addr_a:  LD '(' HL '-' ')' ',' A
        ;

inc_sp:         INC SP
        ;

inc_hl_addr:    INC '(' HL ')'
        ;

dec_hl_addr:    DEC '(' HL ')'
        ;

ld_hl_addr_u8:  LD '(' HL ')' ',' integer
        ;

scf:            SCF
        ;

jr_c_i8:        JR C ',' integer
        ;

add_hl_sp:      ADD HL ',' SP
        ;

ld_a_hld_addr:  LD A ',' '(' HL '-' ')'
        ;

dec_sp:         DEC SP
        ;

inc_a:          INC A
        ;

dec_a:          DEC A
        ;

ld_a_u8:        LD A ',' integer
        ;

ccf:            CCF
        ;

ld_b_b:         LD B ',' B
        ;

ld_b_c:         LD B ',' C
        ;

ld_b_d:         LD B ',' D
        ;

ld_b_e:         LD B ',' E
        ;

ld_b_h:         LD B ',' H
        ;

ld_b_l:         LD B ',' L
        ;

ld_b_hl_addr:   LD B ',' '(' HL ')'
        ;

ld_b_a:         LD B ',' A
        ;

ld_c_b:         LD C ',' B
        ;

ld_c_c:         LD C ',' C
        ;

ld_c_d:         LD C ',' D
        ;

ld_c_e:         LD C ',' E
        ;

ld_c_h:         LD C ',' H
        ;

ld_c_l:         LD C ',' L
        ;

ld_c_hl_addr:   LD C ',' '(' HL ')'
        ;

ld_c_a:         LD C ',' A
        ;

ld_d_b:         LD D ',' B
        ;

ld_d_c:         LD D ',' C
        ;

ld_d_d:         LD D ',' D
        ;

ld_d_e:         LD D ',' E
        ;

ld_d_h:         LD D ',' H
        ;

ld_d_l:         LD D ',' L
        ;

ld_d_hl_addr:   LD D ',' '(' HL ')'
        ;

ld_d_a:         LD D ',' A
        ;

ld_e_b:         LD E ',' B
        ;

ld_e_c:         LD E ',' C
        ;

ld_e_d:         LD E ',' D
        ;

ld_e_e:         LD E ',' E
        ;

ld_e_h:         LD E ',' H
        ;

ld_e_l:         LD E ',' L
        ;

ld_e_hl_addr:   LD E ',' '(' HL ')'
        ;

ld_e_a:         LD E ',' A
        ;

ld_h_b:         LD H ',' B
        ;

ld_h_c:         LD H ',' C
        ;

ld_h_d:         LD H ',' D
        ;

ld_h_e:         LD H ',' E
        ;

ld_h_h:         LD H ',' H
        ;

ld_h_l:         LD H ',' L
        ;

ld_h_hl_addr:   LD H ',' '(' HL ')'
        ;

ld_h_a:         LD H ',' A
        ;

ld_l_b:         LD L ',' B
        ;

ld_l_c:         LD L ',' C
        ;

ld_l_d:         LD L ',' D
        ;

ld_l_e:         LD L ',' E
        ;

ld_l_h:         LD L ',' H
        ;

ld_l_l:         LD L ',' L
        ;

ld_l_hl_addr:   LD L ',' '(' HL ')'
        ;

ld_l_a:         LD L ',' A
        ;

ld_hl_addr_b:         LD '(' HL ')' ',' B
        ;

ld_hl_addr_c:         LD '(' HL ')' ',' C
        ;

ld_hl_addr_d:         LD '(' HL ')' ',' D
        ;

ld_hl_addr_e:         LD '(' HL ')' ',' E
        ;

ld_hl_addr_h:         LD '(' HL ')' ',' H
        ;

ld_hl_addr_l:         LD '(' HL ')' ',' L
        ;

halt:           HALT
        ;

ld_hl_addr_a:         LD '(' HL ')' ',' A
        ;

ld_a_b:         LD A ',' B
        ;

ld_a_c:         LD A ',' C
        ;

ld_a_d:         LD A ',' D
        ;

ld_a_e:         LD A ',' E
        ;

ld_a_h:         LD A ',' H
        ;

ld_a_l:         LD A ',' L
        ;

ld_a_hl_addr:   LD A ',' '(' HL ')'
        ;

ld_a_a:         LD A ',' A
        ;

add_a_b:        ADD A ',' B
        ;

add_a_c:        ADD A ',' C
        ;

add_a_d:        ADD A ',' D
        ;

add_a_e:        ADD A ',' E
        ;

add_a_h:        ADD A ',' H
        ;

add_a_l:        ADD A ',' L
        ;

add_a_hl_addr:  ADD A ',' '(' HL ')'
        ;

add_a_a:        ADD A ',' A
        ;

adc_a_b:        ADC A ',' B
        ;

adc_a_c:        ADC A ',' C
        ;

adc_a_d:        ADC A ',' D
        ;

adc_a_e:        ADC A ',' E
        ;

adc_a_h:        ADC A ',' H
        ;

adc_a_l:        ADC A ',' L
        ;

adc_a_hl_addr:  ADC A ',' '(' HL ')'
        ;

adc_a_a:        ADC A ',' A
        ;

sub_a_b:        SUB A ',' B
        ;

sub_a_c:        SUB A ',' C
        ;

sub_a_d:        SUB A ',' D
        ;

sub_a_e:        SUB A ',' E
        ;

sub_a_h:        SUB A ',' H
        ;

sub_a_l:        SUB A ',' L
        ;

sub_a_hl_addr:  SUB A ',' '(' HL ')'
        ;

sub_a_a:        SUB A ',' A
        ;

sbc_a_b:        SBC A ',' B
        ;

sbc_a_c:        SBC A ',' C
        ;

sbc_a_d:        SBC A ',' D
        ;

sbc_a_e:        SBC A ',' E
        ;

sbc_a_h:        SBC A ',' H
        ;

sbc_a_l:        SBC A ',' L
        ;

sbc_a_hl_addr:  SBC A ',' '(' HL ')'
        ;

sbc_a_a:        SBC A ',' A
        ;

and_a_b:        AND A ',' B
        ;

and_a_c:        AND A ',' C
        ;

and_a_d:        AND A ',' D
        ;

and_a_e:        AND A ',' E
        ;

and_a_h:        AND A ',' H
        ;

and_a_l:        AND A ',' L
        ;

and_a_hl_addr:  AND A ',' '(' HL ')'
        ;

and_a_a:        AND A ',' A
        ;

xor_a_b:        XOR A ',' B
        ;

xor_a_c:        XOR A ',' C
        ;

xor_a_d:        XOR A ',' D
        ;

xor_a_e:        XOR A ',' E
        ;

xor_a_h:        XOR A ',' H
        ;

xor_a_l:        XOR A ',' L
        ;

xor_a_hl_addr:  XOR A ',' '(' HL ')'
        ;

xor_a_a:        XOR A ',' A
        ;

or_a_b:         OR A ',' B
        ;

or_a_c:         OR A ',' C
        ;

or_a_d:         OR A ',' D
        ;

or_a_e:         OR A ',' E
        ;

or_a_h:         OR A ',' H
        ;

or_a_l:         OR A ',' L
        ;

or_a_hl_addr:   OR A ',' '(' HL ')'
        ;

or_a_a:         OR A ',' A
        ;

cp_a_b:         CP A ',' B
        ;

cp_a_c:         CP A ',' C
        ;

cp_a_d:         CP A ',' D
        ;

cp_a_e:         CP A ',' E
        ;

cp_a_h:         CP A ',' H
        ;

cp_a_l:         CP A ',' L
        ;

cp_a_hl_addr:   CP A ',' '(' HL ')'
        ;

cp_a_a:         CP A ',' A
        ;

ret_nz:         RET NZ
        ;

pop_bc:         POP BC
        ;

jp_nz_u16:      JP NZ ',' integer
        ;

jp_u16:         JP integer
        ;

call_nz_u16:    CALL NZ ',' integer
        ;

push_bc:        PUSH BC
        ;

add_a_u8:       ADD A integer
        ;

rst_u3:         RST NUM
        ;

ret_z:          RET Z
        ;

ret:            RET
        ;

jp_z_u16:       JP Z ',' integer
        ;

call_z_u16:     CALL Z ',' integer
        ;

call_u16:       CALL integer
        ;

adc_a_u8:       ADC A ',' integer
        ;

ret_nc:         RET NC
        ;

pop_de:         POP DE
        ;

jp_nc_u16:      JP NC ',' integer
        ;

call_nc_u16:    CALL NC ',' integer
        ;

push_de:        PUSH DE
        ;

sub_a_u8:       SUB A ',' integer
        ;

ret_c:          RET C
        ;

reti:           RETI
        ;

jp_c_u16:       JP C ',' integer
        ;

call_c_u16:     CALL C ',' integer
        ;

sbc_a_u8:       SBC A ',' integer
        ;

ldh_u8_addr_a:  LDH '(' integer ')' ',' A
        ;

pop_hl:         POP HL
        ;

ldh_c_addr_a:   LDH '(' C ')' ',' A
        ;

push_hl:        PUSH HL
        ;

and_a_u8:       AND A ',' integer
        ;

add_sp_i8:      ADD SP ',' integer
        ;

jp_hl:          JP HL
        ;

ld_u16_addr_a:  LD '(' integer ')' ',' A
        ;

xor_a_u8:       XOR A ',' integer
        ;

ldh_a_u8_addr:  LDH A ',' '(' integer ')'
        ;

pop_af:         POP AF
        ;

ldh_a_c_addr:   LDH A ',' '(' C ')'
        ;

di:             DI
        ;

push_af:        PUSH AF
        ;

or_a_u8:        OR A ',' integer
        ;

ld_hl_sp_i8:    LD HL ',' SP '+' integer
        ;

ld_sp_hl:       LD SP ',' HL
        ;

ld_a_u16_addr:  LD A '(' integer ')'
        ;

ei:             EI
        ;

cp_a_u8:        CP A ',' integer
        ;

rlc_b:          RLC B
        ;

rlc_c:          RLC C
        ;

rlc_d:          RLC D
        ;

rlc_e:          RLC E
        ;

rlc_h:          RLC H
        ;

rlc_l:          RLC L
        ;

rlc_hl_addr:    RLC '(' HL ')'
        ;

rlc_a:          RLC A
        ;

rrc_b:          RRC B
        ;

rrc_c:          RRC C
        ;

rrc_d:          RRC D
        ;

rrc_e:          RRC E
        ;

rrc_h:          RRC H
        ;

rrc_l:          RRC L
        ;

rrc_hl_addr:    RRC '(' HL ')'
        ;

rrc_a:          RRC A
        ;

rl_b:          RL B
        ;

rl_c:          RL C
        ;

rl_d:          RL D
        ;

rl_e:          RL E
        ;

rl_h:          RL H
        ;

rl_l:          RL L
        ;

rl_hl_addr:    RL '(' HL ')'
        ;

rl_a:          RL A
        ;

rr_b:          RR B
        ;

rr_c:          RR C
        ;

rr_d:          RR D
        ;

rr_e:          RR E
        ;

rr_h:          RR H
        ;

rr_l:          RR L
        ;

rr_hl_addr:    RR '(' HL ')'
        ;

rr_a:          RR A
        ;

sla_b:          SLA B
        ;

sla_c:          SLA C
        ;

sla_d:          SLA D
        ;

sla_e:          SLA E
        ;

sla_h:          SLA H
        ;

sla_l:          SLA L
        ;

sla_hl_addr:    SLA '(' HL ')'
        ;

sla_a:          SLA A
        ;

sra_b:          SRA B
        ;

sra_c:          SRA C
        ;

sra_d:          SRA D
        ;

sra_e:          SRA E
        ;

sra_h:          SRA H
        ;

sra_l:          SRA L
        ;

sra_hl_addr:    SRA '(' HL ')'
        ;

sra_a:          SRA A
        ;

swap_b:          SWAP B
        ;

swap_c:          SWAP C
        ;

swap_d:          SWAP D
        ;

swap_e:          SWAP E
        ;

swap_h:          SWAP H
        ;

swap_l:          SWAP L
        ;

swap_hl_addr:    SWAP '(' HL ')'
        ;

swap_a:          SWAP A
        ;

srl_b:          SRL B
        ;

srl_c:          SRL C
        ;

srl_d:          SRL D
        ;

srl_e:          SRL E
        ;

srl_h:          SRL H
        ;

srl_l:          SRL L
        ;

srl_hl_addr:    SRL '(' HL ')'
        ;

srl_a:          SRL A
        ;

bit_u3_b:          BIT NUM B
        ;

bit_u3_c:          BIT NUM C
        ;

bit_u3_d:          BIT NUM D
        ;

bit_u3_e:          BIT NUM E
        ;

bit_u3_h:          BIT NUM H
        ;

bit_u3_l:          BIT NUM L
        ;

bit_u3_hl_addr:    BIT NUM '(' HL ')'
        ;

bit_u3_a:          BIT NUM A
        ;

res_u3_b:          RES NUM B
        ;

res_u3_c:          RES NUM C
        ;

res_u3_d:          RES NUM D
        ;

res_u3_e:          RES NUM E
        ;

res_u3_h:          RES NUM H
        ;

res_u3_l:          RES NUM L
        ;

res_u3_hl_addr:    RES NUM '(' HL ')'
        ;

res_u3_a:          RES NUM A
        ;

set_u3_b:          SET NUM B
        ;

set_u3_c:          SET NUM C
        ;

set_u3_d:          SET NUM D
        ;

set_u3_e:          SET NUM E
        ;

set_u3_h:          SET NUM H
        ;

set_u3_l:          SET NUM L
        ;

set_u3_hl_addr:    SET NUM '(' HL ')'
        ;

set_u3_a:          SET NUM A
        ;
