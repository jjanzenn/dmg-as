%{
#include <stdint.h>
#include <stdio.h>
#include <stddef.h>
#include <ctype.h>
#include "dict.h"

#define BASE_INDEX 0x0100

typedef enum token_type {
    tok_NOP,
    tok_LD,
    tok_INC,
    tok_DEC,
    tok_RLCA,
    tok_ADD,
    tok_RRCA,
    tok_STOP,
    tok_RLA,
    tok_JR,
    tok_RRA,
    tok_DAA,
    tok_CPL,
    tok_SCF,
    tok_CCF,
    tok_HALT,
    tok_ADC,
    tok_SUB,
    tok_SBC,
    tok_AND,
    tok_XOR,
    tok_OR,
    tok_CP,
    tok_RET,
    tok_POP,
    tok_JP,
    tok_CALL,
    tok_PUSH,
    tok_RST,
    tok_RETI,
    tok_DI,
    tok_EI,
    tok_RLC,
    tok_RRC,
    tok_RL,
    tok_RR,
    tok_SLA,
    tok_SRA,
    tok_SWAP,
    tok_SRL,
    tok_BIT,
    tok_RES,
    tok_SET,

    tok_AF,
    tok_BC,
    tok_DE,
    tok_HL,
    tok_SP,
    tok_A,
    tok_B,
    tok_C,
    tok_D,
    tok_E,
    tok_H,
    tok_L,

    tok_INT,
    tok_LABEL,

    tok_COMMA,
} token_type_t;

typedef struct token {
    token_type_t type;
    void *data;
} token_t;

token_t *tokens;
size_t tokens_capacity = 0x8000;
size_t tokens_i = 0;

uint16_t curr_line = 0;
dict_t *dict;

void add_token(token_type_t type, void *data);

%}

INST_PRE                                          ^[ \t]*
INST_POST                                         [ \t\n;]

REG_PRE                                           [ \t]+
REG_POST                                          [ \t]*

HEX_CHAR                                          [0-9A-F]

%%

;                                                 {
                                                      int c = input();
                                                      while (c != '\n' && c != EOF)
                                                          c = input();
                                                  }

{INST_PRE}NOP{INST_POST}                          printf("NOP\n"); add_token(tok_NOP, NULL);
{INST_PRE}LD{INST_POST}                           printf("LD\n"); add_token(tok_LD, NULL);
{INST_PRE}INC{INST_POST}                          printf("INC\n"); add_token(tok_INC, NULL);
{INST_PRE}DEC{INST_POST}                          printf("DEC\n"); add_token(tok_DEC, NULL);
{INST_PRE}RLCA{INST_POST}                         printf("RLCA\n"); add_token(tok_RLCA, NULL);
{INST_PRE}ADD{INST_POST}                          printf("ADD\n"); add_token(tok_ADD, NULL);
{INST_PRE}RRCA{INST_POST}                         printf("RRCA\n"); add_token(tok_RRCA, NULL);
{INST_PRE}STOP{INST_POST}                         printf("STOP\n"); add_token(tok_STOP, NULL);
{INST_PRE}RLA{INST_POST}                          printf("RLA\n"); add_token(tok_RLA, NULL);
{INST_PRE}JR{INST_POST}                           printf("JR\n"); add_token(tok_JR, NULL);
{INST_PRE}RRA{INST_POST}                          printf("RRA\n"); add_token(tok_RRA, NULL);
{INST_PRE}DAA{INST_POST}                          printf("DAA\n"); add_token(tok_DAA, NULL);
{INST_PRE}CPL{INST_POST}                          printf("CPL\n"); add_token(tok_CPL, NULL);
{INST_PRE}SCF{INST_POST}                          printf("SCF\n"); add_token(tok_SCF, NULL);
{INST_PRE}CCF{INST_POST}                          printf("CCF\n"); add_token(tok_CCF, NULL);
{INST_PRE}HALT{INST_POST}                         printf("HALT\n"); add_token(tok_HALT, NULL);
{INST_PRE}ADC{INST_POST}                          printf("ADC\n"); add_token(tok_ADC, NULL);
{INST_PRE}SUB{INST_POST}                          printf("SUB\n"); add_token(tok_SUB, NULL);
{INST_PRE}SBC{INST_POST}                          printf("SBC\n"); add_token(tok_SBC, NULL);
{INST_PRE}AND{INST_POST}                          printf("AND\n"); add_token(tok_AND, NULL);
{INST_PRE}XOR{INST_POST}                          printf("XOR\n"); add_token(tok_XOR, NULL);
{INST_PRE}OR{INST_POST}                           printf("OR\n"); add_token(tok_OR, NULL);
{INST_PRE}CP{INST_POST}                           printf("CP\n"); add_token(tok_CP, NULL);
{INST_PRE}RET{INST_POST}                          printf("RET\n"); add_token(tok_RET, NULL);
{INST_PRE}POP{INST_POST}                          printf("POP\n"); add_token(tok_POP, NULL);
{INST_PRE}JP{INST_POST}                           printf("JP\n"); add_token(tok_JP, NULL);
{INST_PRE}CALL{INST_POST}                         printf("CALL\n"); add_token(tok_CALL, NULL);
{INST_PRE}PUSH{INST_POST}                         printf("PUSH\n"); add_token(tok_PUSH, NULL);
{INST_PRE}RST{INST_POST}                          printf("RST\n"); add_token(tok_RST, NULL);
{INST_PRE}RETI{INST_POST}                         printf("RETI\n"); add_token(tok_RETI, NULL);
{INST_PRE}DI{INST_POST}                           printf("DI\n"); add_token(tok_DI, NULL);
{INST_PRE}EI{INST_POST}                           printf("EI\n"); add_token(tok_EI, NULL);
{INST_PRE}RLC{INST_POST}                          printf("RLC\n"); add_token(tok_RLC, NULL);
{INST_PRE}RRC{INST_POST}                          printf("RRC\n"); add_token(tok_RRC, NULL);
{INST_PRE}RL{INST_POST}                           printf("RL\n"); add_token(tok_RL, NULL);
{INST_PRE}RR{INST_POST}                           printf("RR\n"); add_token(tok_RR, NULL);
{INST_PRE}SLA{INST_POST}                          printf("SLA\n"); add_token(tok_SLA, NULL);
{INST_PRE}SRA{INST_POST}                          printf("SRA\n"); add_token(tok_SRA, NULL);
{INST_PRE}SWAP{INST_POST}                         printf("SWAP\n"); add_token(tok_SWAP, NULL);
{INST_PRE}SRL{INST_POST}                          printf("SRL\n"); add_token(tok_SRL, NULL);
{INST_PRE}BIT{INST_POST}                          printf("BIT\n"); add_token(tok_BIT, NULL);
{INST_PRE}RES{INST_POST}                          printf("RES\n"); add_token(tok_RES, NULL);
{INST_PRE}SET{INST_POST}                          printf("SET\n"); add_token(tok_SET, NULL);

{REG_PRE}AF{REG_POST}                             printf("AF\n"); add_token(tok_AF, NULL);
{REG_PRE}BC{REG_POST}                             printf("BC\n"); add_token(tok_BC, NULL);
{REG_PRE}DE{REG_POST}                             printf("DE\n"); add_token(tok_DE, NULL);
{REG_PRE}HL{REG_POST}                             printf("HL\n"); add_token(tok_HL, NULL);
{REG_PRE}SP{REG_POST}                             printf("SP\n"); add_token(tok_SP, NULL);
{REG_PRE}A{REG_POST}                              printf("A\n"); add_token(tok_A, NULL);
{REG_PRE}B{REG_POST}                              printf("B\n"); add_token(tok_B, NULL);
{REG_PRE}C{REG_POST}                              printf("C\n"); add_token(tok_C, NULL);
{REG_PRE}D{REG_POST}                              printf("D\n"); add_token(tok_D, NULL);
{REG_PRE}E{REG_POST}                              printf("E\n"); add_token(tok_E, NULL);
{REG_PRE}H{REG_POST}                              printf("H\n"); add_token(tok_H, NULL);
{REG_PRE}L{REG_POST}                              printf("L\n"); add_token(tok_L, NULL);

\${HEX_CHAR}{HEX_CHAR}?{HEX_CHAR}?{HEX_CHAR}?     {
                                                      uint16_t *data = malloc(sizeof(uint16_t));
                                                      *data = strtol(&yytext[1], NULL, 16);
                                                      printf("int: 0x%04X\n", *data);
                                                      add_token(tok_INT, data);
                                                  }
[0-9]{1,5}                                        {
                                                      uint16_t *data = malloc(sizeof(uint16_t));
                                                      uint32_t buffer = strtol(yytext, NULL, 10);
                                                      if (buffer > 0xFFFF) {
                                                          printf("Integer out of bounds: %s\n", yytext);
                                                      } else {
                                                          *data = buffer;
                                                          printf("int: 0x%04X\n", *data);
                                                          add_token(tok_INT, data);
                                                      }
                                                  }

{REG_PRE}[A-Z_][A-Z0-9_]*{REG_POST}               {
                                                      char *data = malloc(yyleng + 1);

                                                      int i = 0;
                                                      while (yytext[i] == ' ' || yytext[i] == '\t')
                                                          ++i;

                                                      int offset = i;
                                                      for (i = i; i < yyleng; ++i) {
                                                          data[i - offset] = tolower(yytext[i]);
                                                      }
                                                      data[yyleng] = 0;
                                                      printf("label: \"%s\"\n", data);
                                                      add_token(tok_LABEL, data);
                                                  }

,                                                 printf("COMMA\n"); add_token(tok_COMMA, NULL);

^[A-Z_][A-Z0-9_]*:                                {
                                                      size_t text_length = yyleng - 1;
                                                      uint16_t *data = malloc(sizeof(uint16_t));
                                                      *data = curr_line;
                                                      char *key = malloc(text_length + 1);
                                                      for (int i = 0; i < text_length; ++i) {
                                                          key[i] = tolower(yytext[i]);
                                                      }
                                                      key[text_length] = 0;
                                                      dict_put(dict, key,
                                                               text_length,
                                                               data);
                                                      printf("Label: \"%s\"\n", key);
                                                      unput('\n');
                                                  }

[ \n\t]                                           /* do nothing */
.                                                 {
                                                      printf("Syntax error: ");
                                                      int c = yytext[0];
                                                      while (c != '\n' && c != EOF) {
                                                          putchar(c);
                                                          c = input();
                                                      }
                                                      putchar('\n');
                                                  }

%%

void add_token(token_type_t type, void *data)
{
    token_t tok = {
        .type = type,
        .data = data,
    };

    if (tokens_i == tokens_capacity) {
        tokens_capacity *= 2;
        tokens = realloc(tokens, tokens_capacity);
    }
    tokens[tokens_i] = tok;

    if ((type >= tok_NOP && type <= tok_SET) || type == tok_COMMA) {
        unput(' ');
    }
}

int main(void)
{
    dict = dict_init();
    tokens = malloc(tokens_capacity);

    if (yylex() != 1) {
    }

    dict_deinit(dict);

    for (int i = 0; i < tokens_i; ++i) {
        if (tokens[tokens_i].data) {
           free(tokens[tokens_i].data);
        }
    }
    free(tokens);

    return 0;
}
