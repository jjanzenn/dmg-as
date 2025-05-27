%define parse.error verbose

%{
#define _XOPEN_SOURCE 600
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#include "../parser.h"

int yylex(void);
int yyerror(const char *s);

unsigned int position = 0;
%}

%union
{
    char *str;
    uint16_t num;
    struct dmg_int_container *int_container;
    struct dmg_instruction *instruction;
}

%type   <int_container> integer;
%type   <instruction>   command;

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
        |       SYMBOL ':'
        ;

integer:        NUM {
                    $$ = calloc(sizeof(dmg_int_container), 1);
                    $$->value.num = yylval.num;
                    $$->type = DMG_INT_CONTAINER_NUM;
                }
        |       SYMBOL {
                    $$ = calloc(sizeof(dmg_int_container), 1);
                    $$->value.label = yylval.str;
                    $$->type = DMG_INT_CONTAINER_LABEL;
                }
        ;

command:        NOP {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x00;
                    position += 1;
                }
        |       LD BC ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x01;
                    $$->suffix = $4;
                    position += 3;
                }
        |       LD '(' BC ')' ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x02;
                    position += 1;
                }
        |       INC BC {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x03;
                    position += 1;
                }
        |       INC B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x04;
                    position += 1;
                }
        |       DEC B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x05;
                    position += 1;
                }
        |       LD B ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x06;
                    $$->suffix = $4;
                    position += 2;
                }
        |       RLCA {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x07;
                    position += 1;
                }
        |       LD '(' integer ')' ',' SP {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x08;
                    position += 1;
                }
        |       ADD HL ',' BC {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x09;
                    position += 1;
                }
        |       LD A ',' '(' BC ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x0A;
                    position += 1;
                }
        |       DEC BC {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x0B;
                    position += 1;
                }
        |       INC C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x0C;
                    position += 1;
                }
        |       DEC C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x0D;
                    position += 1;
                }
        |       LD C ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x0E;
                    position += 1;
                }
        |       RRCA {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x0F;
                    position += 1;
                }
        |       STOP {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x10;
                    $$->suffix = calloc(sizeof(dmg_int_container), 1);
                    $$->suffix->value.num = 0x00;
                    $$->suffix->type = DMG_INT_CONTAINER_NUM;
                    position += 2;
                }
        |       LD DE ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x11;
                    $$->suffix = $4;
                    position += 3;
                }
        |       LD '(' DE ')' ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x12;
                    position += 1;
                }
        |       INC DE {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x13;
                    position += 1;
                }
        |       INC D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x14;
                    position += 1;
                }
        |       DEC D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x15;
                    position += 1;
                }
        |       LD D ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x16;
                    $$->suffix = $4;
                    position += 2;
                }
        |       RLA {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x17;
                    position += 1;
                }
        |       JR integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x18;
                    $$->suffix = $2;
                    position += 2;
                }
        |       ADD HL ',' DE {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x19;
                    position += 1;
                }
        |       LD A ',' '(' DE ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x1A;
                    position += 1;
                }
        |       DEC DE {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x1B;
                    position += 1;
                }
        |       INC E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x1C;
                    position += 1;
                }
        |       DEC E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x1D;
                    position += 1;
                }
        |       LD E ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x1E;
                    $$->suffix = $4;
                    position += 2;
                }
        |       RRA {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x1F;
                    position += 1;
                }
        |       JR NZ ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x20;
                    $$->suffix = $4;
                    position += 2;
                }
        |       LD HL ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x21;
                    $$->suffix = $4;
                    position += 3;
                }
        |       LD '(' HL '+' ')' ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x22;
                    position += 1;
                }
        |       INC HL {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x23;
                    position += 1;
                }
        |       INC H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x24;
                    position += 1;
                }
        |       DEC H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x25;
                    position += 1;
                }
        |       LD H ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x26;
                    $$->suffix = $4;
                    position += 2;
                }
        |       DAA {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x27;
                    position += 1;
                }
        |       JR Z ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x28;
                    $$->suffix = $4;
                    position += 2;
                }
        |       ADD HL ',' HL {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x29;
                    position += 1;
                }
        |       LD A ',' '(' HL '+' ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x2A;
                    position += 1;
                }
        |       DEC HL {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x2B;
                    position += 1;
                }
        |       INC L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x2C;
                    position += 1;
                }
        |       DEC L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x2D;
                    position += 1;
                }
        |       LD L ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x2E;
                    position += 2;
                }
        |       CPL {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x2F;
                    position += 1;
                }
        |       JR NC ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x30;
                    $$->suffix = $4;
                    position += 2;
                }
        |       LD SP ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x31;
                    $$->suffix = $4;
                    position += 3;
                }
        |       LD '(' HL '-' ')' ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x32;
                    position += 1;
                }
        |       INC SP {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x33;
                    position += 1;
                }
        |       INC '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x34;
                    position += 1;
                }
        |       DEC '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x35;
                    position += 1;
                }
        |       LD '(' HL ')' ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x36;
                    $$->suffix = $6;
                    position += 2;
                }
        |       SCF {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x37;
                    position += 1;
                }
        |       JR C ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x38;
                    $$->suffix = $4;
                    position += 2;
                }
        |       ADD HL ',' SP {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x39;
                    position += 1;
                }
        |       LD A ',' '(' HL '-' ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x3A;
                    position += 1;
                }
        |       DEC SP {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x3B;
                    position += 1;
                }
        |       INC A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x3C;
                    position += 1;
                }
        |       DEC A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x3D;
                    position += 1;
                }
        |       LD A ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x3E;
                    $$->suffix = $4;
                    position += 2;
                }
        |       CCF {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x3F;
                    position += 1;
                }
        |       LD B ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x40;
                    position += 1;
                }
        |       LD B ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x41;
                    position += 1;
                }
        |       LD B ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x42;
                    position += 1;
                }
        |       LD B ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x43;
                    position += 1;
                }
        |       LD B ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x44;
                    position += 1;
                }
        |       LD B ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x45;
                    position += 1;
                }
        |       LD B ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x46;
                    position += 1;
                }
        |       LD B ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x47;
                    position += 1;
                }
        |       LD C ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x48;
                    position += 1;
                }
        |       LD C ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x49;
                    position += 1;
                }
        |       LD C ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x4A;
                    position += 1;
                }
        |       LD C ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x4B;
                    position += 1;
                }
        |       LD C ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x4C;
                    position += 1;
                }
        |       LD C ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x4D;
                    position += 1;
                }
        |       LD C ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x4E;
                    position += 1;
                }
        |       LD C ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x4F;
                    position += 1;
                }
        |       LD D ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x50;
                    position += 1;
                }
        |       LD D ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x51;
                    position += 1;
                }
        |       LD D ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x52;
                    position += 1;
                }
        |       LD D ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x53;
                    position += 1;
                }
        |       LD D ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x54;
                    position += 1;
                }
        |       LD D ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x55;
                    position += 1;
                }
        |       LD D ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x56;
                    position += 1;
                }
        |       LD D ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x57;
                    position += 1;
                }
        |       LD E ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x58;
                    position += 1;
                }
        |       LD E ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x59;
                    position += 1;
                }
        |       LD E ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x5A;
                    position += 1;
                }
        |       LD E ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x5B;
                    position += 1;
                }
        |       LD E ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x5C;
                    position += 1;
                }
        |       LD E ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x5D;
                    position += 1;
                }
        |       LD E ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x5E;
                    position += 1;
                }
        |       LD E ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x5F;
                    position += 1;
                }
        |       LD H ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x60;
                    position += 1;
                }
        |       LD H ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x61;
                    position += 1;
                }
        |       LD H ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x62;
                    position += 1;
                }
        |       LD H ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x63;
                    position += 1;
                }
        |       LD H ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x64;
                    position += 1;
                }
        |       LD H ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x65;
                    position += 1;
                }
        |       LD H ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x66;
                    position += 1;
                }
        |       LD H ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x67;
                    position += 1;
                }
        |       LD L ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x68;
                    position += 1;
                }
        |       LD L ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x69;
                    position += 1;
                }
        |       LD L ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x6A;
                    position += 1;
                }
        |       LD L ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x6B;
                    position += 1;
                }
        |       LD L ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x6C;
                    position += 1;
                }
        |       LD L ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x6D;
                    position += 1;
                }
        |       LD L ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x6E;
                    position += 1;
                }
        |       LD L ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x6F;
                    position += 1;
                }
        |       LD '(' HL ')' ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x70;
                    position += 1;
                }
        |       LD '(' HL ')' ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x71;
                    position += 1;
                }
        |       LD '(' HL ')' ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x72;
                    position += 1;
                }
        |       LD '(' HL ')' ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x73;
                    position += 1;
                }
        |       LD '(' HL ')' ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x74;
                    position += 1;
                }
        |       LD '(' HL ')' ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x75;
                    position += 1;
                }
        |       HALT {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x76;
                    position += 1;
                }
        |       LD '(' HL ')' ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x77;
                    position += 1;
                }
        |       LD A ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x78;
                    position += 1;
                }
        |       LD A ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x79;
                    position += 1;
                }
        |       LD A ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x7A;
                    position += 1;
                }
        |       LD A ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x7B;
                    position += 1;
                }
        |       LD A ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x7C;
                    position += 1;
                }
        |       LD A ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x7D;
                    position += 1;
                }
        |       LD A ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x7E;
                    position += 1;
                }
        |       LD A ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x7F;
                    position += 1;
                }
        |       ADD A ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x80;
                    position += 1;
                }
        |       ADD A ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x81;
                    position += 1;
                }
        |       ADD A ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x82;
                    position += 1;
                }
        |       ADD A ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x83;
                    position += 1;
                }
        |       ADD A ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x84;
                    position += 1;
                }
        |       ADD A ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x85;
                    position += 1;
                }
        |       ADD A ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x86;
                    position += 1;
                }
        |       ADD A ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x87;
                    position += 1;
                }
        |       ADC A ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x88;
                    position += 1;
                }
        |       ADC A ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x89;
                    position += 1;
                }
        |       ADC A ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x8A;
                    position += 1;
                }
        |       ADC A ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x8B;
                    position += 1;
                }
        |       ADC A ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x8C;
                    position += 1;
                }
        |       ADC A ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x8D;
                    position += 1;
                }
        |       ADC A ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x8E;
                    position += 1;
                }
        |       ADC A ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x8F;
                    position += 1;
                }
        |       SUB A ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x90;
                    position += 1;
                }
        |       SUB A ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x91;
                    position += 1;
                }
        |       SUB A ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x92;
                    position += 1;
                }
        |       SUB A ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x93;
                    position += 1;
                }
        |       SUB A ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x94;
                    position += 1;
                }
        |       SUB A ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x95;
                    position += 1;
                }
        |       SUB A ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x96;
                    position += 1;
                }
        |       SUB A ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x97;
                    position += 1;
                }
        |       SBC A ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x98;
                    position += 1;
                }
        |       SBC A ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x99;
                    position += 1;
                }
        |       SBC A ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x9A;
                    position += 1;
                }
        |       SBC A ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x9B;
                    position += 1;
                }
        |       SBC A ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x9C;
                    position += 1;
                }
        |       SBC A ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x9D;
                    position += 1;
                }
        |       SBC A ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x9E;
                    position += 1;
                }
        |       SBC A ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x9F;
                    position += 1;
                }
        |       AND A ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xA0;
                    position += 1;
                }
        |       AND A ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xA1;
                    position += 1;
                }
        |       AND A ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xA2;
                    position += 1;
                }
        |       AND A ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xA3;
                    position += 1;
                }
        |       AND A ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xA4;
                    position += 1;
                }
        |       AND A ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xA5;
                    position += 1;
                }
        |       AND A ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xA6;
                    position += 1;
                }
        |       AND A ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xA7;
                    position += 1;
                }
        |       XOR A ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xA8;
                    position += 1;
                }
        |       XOR A ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xA9;
                    position += 1;
                }
        |       XOR A ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xAA;
                    position += 1;
                }
        |       XOR A ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xAB;
                    position += 1;
                }
        |       XOR A ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xAC;
                    position += 1;
                }
        |       XOR A ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xAD;
                    position += 1;
                }
        |       XOR A ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xAE;
                    position += 1;
                }
        |       XOR A ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xAF;
                    position += 1;
                }
        |       OR A ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xB0;
                    position += 1;
                }
        |       OR A ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xB1;
                    position += 1;
                }
        |       OR A ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xB2;
                    position += 1;
                }
        |       OR A ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xB3;
                    position += 1;
                }
        |       OR A ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xB4;
                    position += 1;
                }
        |       OR A ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xB5;
                    position += 1;
                }
        |       OR A ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xB6;
                    position += 1;
                }
        |       OR A ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xB7;
                    position += 1;
                }
        |       CP A ',' B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xB8;
                    position += 1;
                }
        |       CP A ',' C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xB9;
                    position += 1;
                }
        |       CP A ',' D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xBA;
                    position += 1;
                }
        |       CP A ',' E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xBB;
                    position += 1;
                }
        |       CP A ',' H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xBC;
                    position += 1;
                }
        |       CP A ',' L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xBD;
                    position += 1;
                }
        |       CP A ',' '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xBE;
                    position += 1;
                }
        |       CP A ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xBF;
                    position += 1;
                }
        |       RET NZ {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC0;
                    position += 1;
                }
        |       POP BC {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC1;
                    position += 1;
                }
        |       JP NZ ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC2;
                    $$->suffix = $4;
                    position += 3;
                }
        |       JP integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC3;
                    $$->suffix = $2;
                    position += 3;
                }
        |       CALL NZ ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC4;
                    $$->suffix = $4;
                    position += 3;
                }
        |       PUSH BC {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC5;
                    position += 1;
                }
        |       ADD A ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC6;
                    $$->suffix = $4;
                    position += 2;
                }
        |       RST NUM {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("RST argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    switch ($2) {
                        case 0: $$->opcode = 0xC7; break;
                        case 1: $$->opcode = 0xCF; break;
                        case 2: $$->opcode = 0xD7; break;
                        case 3: $$->opcode = 0xDF; break;
                        case 4: $$->opcode = 0xE7; break;
                        case 5: $$->opcode = 0xEF; break;
                        case 6: $$->opcode = 0xF7; break;
                        case 7: $$->opcode = 0xFF; break;
                    }
                    position += 1;
                }
        |       RET Z {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC8;
                    position += 1;
                }
        |       RET {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC9;
                    position += 1;
                }
        |       JP Z ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xCA;
                    $$->suffix = $4;
                    position += 3;
                }
        |       CALL Z ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xCC;
                    $$->suffix = $4;
                    position += 3;
                }
        |       CALL integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xCD;
                    $$->suffix = $2;
                    position += 3;
                }
        |       ADC A ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xCE;
                    $$->suffix = $4;
                    position += 2;
                }
        |       RET NC {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xD0;
                    position += 1;
                }
        |       POP DE {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xD1;
                    position += 1;
                }
        |       JP NC ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xD2;
                    $$->suffix = $4;
                    position += 3;
                }
        |       CALL NC ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xD4;
                    $$->suffix = $4;
                    position += 3;
                }
        |       PUSH DE {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xD5;
                    position += 1;
                }
        |       SUB A ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xD6;
                    $$->suffix = $4;
                    position += 2;
                }
        |       RET C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xD8;
                    position += 1;
                }
        |       RETI {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xD9;
                    position += 1;
                }
        |       JP C ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xDA;
                    $$->suffix = $4;
                    position += 3;
                }
        |       CALL C ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xDC;
                    $$->suffix = $4;
                    position += 3;
                }
        |       SBC A ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xDE;
                    $$->suffix = $4;
                    position += 2;
                }
        |       LDH '(' integer ')' ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xE0;
                    $$->suffix = $3;
                    position += 3;
                }
        |       POP HL {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xE1;
                    position += 1;
                }
        |       LDH '(' C ')' ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xE3;
                    position += 1;
                }
        |       PUSH HL {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xE5;
                    position += 1;
                }
        |       AND A ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xE6;
                    $$->suffix = $4;
                    position += 2;
                }
        |       ADD SP ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xE8;
                    $$->suffix = $4;
                    position += 2;
                }
        |       JP HL {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xE9;
                    position += 1;
                }
        |       LD '(' integer ')' ',' A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xEA;
                    $$->suffix = $3;
                    position += 3;
                }
        |       XOR A ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xEE;
                    $$->suffix = $4;
                    position += 2;
                }
        |       LDH A ',' '(' integer ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xF0;
                    $$->suffix = $5;
                    position += 3;
                }
        |       POP AF {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xF1;
                    position += 1;
                }
        |       LDH A ',' '(' C ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xF2;
                    position += 1;
                }
        |       DI {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xF3;
                    position += 1;
                }
        |       PUSH AF {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xF5;
                    position += 1;
                }
        |       OR A ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xF6;
                    $$->suffix = $4;
                    position += 2;
                }
        |       LD HL ',' SP '+' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xF8;
                    $$->suffix = $6;
                    position += 2;
                }
        |       LD SP ',' HL {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xF9;
                    position += 1;
                }
        |       LD A '(' integer ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xFA;
                    $$->suffix = $4;
                    position += 3;
                }
        |       EI {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xFB;
                    position += 1;
                }
        |       CP A ',' integer {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xFE;
                    $$->suffix = $4;
                    position += 2;
                }
        |       RLC B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x00;
                    position += 2;
                }
        |       RLC C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x01;
                    position += 2;
                }
        |       RLC D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x02;
                    position += 2;
                }
        |       RLC E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x03;
                    position += 2;
                }
        |       RLC H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x04;
                    position += 2;
                }
        |       RLC L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x05;
                    position += 2;
                }
        |       RLC '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x06;
                    position += 2;
                }
        |       RLC A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x07;
                    position += 2;
                }
        |       RRC B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x08;
                    position += 2;
                }
        |       RRC C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x09;
                    position += 2;
                }
        |       RRC D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x0A;
                    position += 2;
                }
        |       RRC E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x0B;
                    position += 2;
                }
        |       RRC H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x0C;
                    position += 2;
                }
        |       RRC L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x0D;
                    position += 2;
                }
        |       RRC '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x0E;
                    position += 2;
                }
        |       RRC A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x0F;
                    position += 2;
                }
        |       RL B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x10;
                    position += 2;
                }
        |       RL C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x11;
                    position += 2;
                }
        |       RL D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x12;
                    position += 2;
                }
        |       RL E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x13;
                    position += 2;
                }
        |       RL H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x14;
                    position += 2;
                }
        |       RL L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x15;
                    position += 2;
                }
        |       RL '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x16;
                    position += 2;
                }
        |       RL A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x17;
                    position += 2;
                }
        |       RR B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x18;
                    position += 2;
                }
        |       RR C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x19;
                    position += 2;
                }
        |       RR D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x1A;
                    position += 2;
                }
        |       RR E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x1B;
                    position += 2;
                }
        |       RR H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x1C;
                    position += 2;
                }
        |       RR L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x1D;
                    position += 2;
                }
        |       RR '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x1E;
                    position += 2;
                }
        |       RR A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x1F;
                    position += 2;
                }
        |       SLA B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x20;
                    position += 2;
                }
        |       SLA C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x21;
                    position += 2;
                }
        |       SLA D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x22;
                    position += 2;
                }
        |       SLA E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x23;
                    position += 2;
                }
        |       SLA H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x24;
                    position += 2;
                }
        |       SLA L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x25;
                    position += 2;
                }
        |       SLA '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x26;
                    position += 2;
                }
        |       SLA A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x27;
                    position += 2;
                }
        |       SRA B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x28;
                    position += 2;
                }
        |       SRA C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x29;
                    position += 2;
                }
        |       SRA D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x2A;
                    position += 2;
                }
        |       SRA E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x2B;
                    position += 2;
                }
        |       SRA H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x2C;
                    position += 2;
                }
        |       SRA L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x2D;
                    position += 2;
                }
        |       SRA '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x2E;
                    position += 2;
                }
        |       SRA A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x2F;
                    position += 2;
                }
        |       SWAP B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x30;
                    position += 2;
                }
        |       SWAP C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x31;
                    position += 2;
                }
        |       SWAP D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x32;
                    position += 2;
                }
        |       SWAP E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x33;
                    position += 2;
                }
        |       SWAP H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x34;
                    position += 2;
                }
        |       SWAP L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x35;
                    position += 2;
                }
        |       SWAP '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x36;
                    position += 2;
                }
        |       SWAP A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x37;
                    position += 2;
                }
        |       SRL B {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x38;
                    position += 2;
                }
        |       SRL C {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x39;
                    position += 2;
                }
        |       SRL D {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x3A;
                    position += 2;
                }
        |       SRL E {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x3B;
                    position += 2;
                }
        |       SRL H {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x3C;
                    position += 2;
                }
        |       SRL L {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x3D;
                    position += 2;
                }
        |       SRL '(' HL ')' {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x3E;
                    position += 2;
                }
        |       SRL A {
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->prefix = 1;
                    $$->opcode = 0x3F;
                    position += 2;
                }
        |       BIT NUM ',' B {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("BIT argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x40 + ($2 * 0x08);
                    position += 2;
                }
        |       BIT NUM ',' C {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("BIT argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x41 + ($2 * 0x08);
                    position += 2;
                }
        |       BIT NUM ',' D {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("BIT argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x42 + ($2 * 0x08);
                    position += 2;
                }
        |       BIT NUM ',' E {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("BIT argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x43 + ($2 * 0x08);
                    position += 2;
                }
        |       BIT NUM ',' H {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("BIT argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x44 + ($2 * 0x08);
                    position += 2;
                }
        |       BIT NUM ',' L {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("BIT argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x45 + ($2 * 0x08);
                    position += 2;
                }
        |       BIT NUM ',' '(' HL ')' {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("BIT argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x46 + ($2 * 0x08);
                    position += 2;
                }
        |       BIT NUM ',' A {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("BIT argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x47 + ($2 * 0x08);
                    position += 2;
                }
        |       RES NUM ',' B {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("RES argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x80 + ($2 * 0x08);
                    position += 2;
                }
        |       RES NUM ',' C {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("RES argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x81 + ($2 * 0x08);
                    position += 2;
                }
        |       RES NUM ',' D {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("RES argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x82 + ($2 * 0x08);
                    position += 2;
                }
        |       RES NUM ',' E {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("RES argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x83 + ($2 * 0x08);
                    position += 2;
                }
        |       RES NUM ',' H {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("RES argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x84 + ($2 * 0x08);
                    position += 2;
                }
        |       RES NUM ',' L {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("RES argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x85 + ($2 * 0x08);
                    position += 2;
                }
        |       RES NUM ',' '(' HL ')' {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("RES argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x86 + ($2 * 0x08);
                    position += 2;
                }
        |       RES NUM ',' A {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("RES argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0x87 + ($2 * 0x08);
                    position += 2;
                }
        |       SET NUM ',' B {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("SET argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC0 + ($2 * 0x08);
                    position += 2;
                }
        |       SET NUM ',' C {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("SET argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC1 + ($2 * 0x08);
                    position += 2;
                }
        |       SET NUM ',' D {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("SET argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC2 + ($2 * 0x08);
                    position += 2;
                }
        |       SET NUM ',' E {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("SET argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC3 + ($2 * 0x08);
                    position += 2;
                }
        |       SET NUM ',' H {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("SET argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC4 + ($2 * 0x08);
                    position += 2;
                }
        |       SET NUM ',' L {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("SET argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC5 + ($2 * 0x08);
                    position += 2;
                }
        |       SET NUM ',' '(' HL ')' {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("SET argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC6 + ($2 * 0x08);
                    position += 2;
                }
        |       SET NUM ',' A {
                    if ($2 >= 8 || $2 < 0) {
                        yyerror("SET argument out of bounds");
                        YYERROR;
                    }
                    $$ = calloc(sizeof(dmg_instruction), 1);
                    $$->opcode = 0xC7 + ($2 * 0x08);
                    position += 2;
                }
        ;
