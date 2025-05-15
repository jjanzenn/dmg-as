#ifndef _LEXER_H_
#define _LEXER_H_

#include <stdint.h>
#include <stdio.h>

typedef enum inst {
    inst_LD,
    inst_LDH,
    inst_ADC,
    inst_ADD,
    inst_CP,
    inst_DEC,
    inst_INC,
    inst_SBC,
    inst_SUB,
    inst_AND,
    inst_CPL,
    inst_OR,
    inst_XOR,
    inst_BIT,
    inst_RES,
    inst_SET,
    inst_RL,
    inst_RLA,
    inst_RLC,
    inst_RLCA,
    inst_RR,
    inst_RRA,
    inst_RRC,
    inst_RRCA,
    inst_SLA,
    inst_SRA,
    inst_SRL,
    inst_SWAP,
    inst_CALL,
    inst_JP,
    inst_JR,
    inst_RET,
    inst_RETI,
    inst_RST,
    inst_CCF,
    inst_SCF,
    inst_POP,
    inst_PUSH,
    inst_DI,
    inst_EI,
    inst_HALT,
    inst_DAA,
    inst_NOP,
    inst_STOP,
} inst_t;

typedef enum reg {
    reg_A,
    reg_F,
    reg_B,
    reg_C,
    reg_D,
    reg_E,
    reg_H,
    reg_L,
    reg_BC,
    reg_DE,
    reg_HL,
    reg_SP,
} reg_t;

typedef enum condition {
    cond_C,
    cond_NC,
    cond_Z,
    cond_NZ,
} cond_t;

typedef union token_val {
    uint16_t integer;
    reg_t reg;
    cond_t cond;
    inst_t inst;
    char *label;
    char *labeldef;
} token_val;

typedef enum token_type {
    toktype_INTEGER,
    toktype_REG,
    toktype_COND,
    toktype_INST,
    toktype_LABEL,
    toktype_LABELDEF,
} token_type;

typedef struct token {
    token_val value;
    token_type type;
} token;

typedef struct lexer {
    token *tokens;
} lexer;

lexer lex(FILE *f);

char *next_token(FILE *f);

#endif
