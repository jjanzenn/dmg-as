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

%token  <str>           SYMBOL
%token  <num>           NUM
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

%%
