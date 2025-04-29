%{
    #include <stdint.h>
    #include <stdio.h>
    #include <stddef.h>
    #include <string.h>
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
        tok_HL_INC,
        tok_HL_DEC,
        tok_SP,
        tok_SP_PLUS,
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
        tok_LPAR,
        tok_RPAR,

        tok_ERROR_INTEGER_OVERFLOW,
        tok_ERROR_DUPLICATE_LABEL,
        tok_ERROR_UNEXPECTED_SYMBOL,
    } token_type_t;

    typedef struct token {
        token_type_t type;
        void *data;
        uint16_t location;
    } token_t;

    token_t *tokens;
    size_t tokens_capacity = 0x8000;
    size_t tokens_i = 0;

    dict_t *dict;
    uint16_t inst_index = 0;

    void add_token(token_type_t type, void *data);
%}

INST_PRE                              ^[ \t]*
INST_POST                             " "?

REG_POST                              [ \t]*

%%

;                                     {
                                          int c = input();
                                          while (c != '\n' && c != EOF)
                                              c = input();
                                      }

{INST_PRE}NOP{INST_POST}              printf("NOP\n"); add_token(tok_NOP, NULL);
{INST_PRE}LD{INST_POST}               printf("LD\n"); add_token(tok_LD, NULL);
{INST_PRE}INC{INST_POST}              printf("INC\n"); add_token(tok_INC, NULL);
{INST_PRE}DEC{INST_POST}              printf("DEC\n"); add_token(tok_DEC, NULL);
{INST_PRE}RLCA{INST_POST}             printf("RLCA\n"); add_token(tok_RLCA, NULL);
{INST_PRE}ADD{INST_POST}              printf("ADD\n"); add_token(tok_ADD, NULL);
{INST_PRE}RRCA{INST_POST}             printf("RRCA\n"); add_token(tok_RRCA, NULL);
{INST_PRE}STOP{INST_POST}             printf("STOP\n"); add_token(tok_STOP, NULL);
{INST_PRE}RLA{INST_POST}              printf("RLA\n"); add_token(tok_RLA, NULL);
{INST_PRE}JR{INST_POST}               printf("JR\n"); add_token(tok_JR, NULL);
{INST_PRE}RRA{INST_POST}              printf("RRA\n"); add_token(tok_RRA, NULL);
{INST_PRE}DAA{INST_POST}              printf("DAA\n"); add_token(tok_DAA, NULL);
{INST_PRE}CPL{INST_POST}              printf("CPL\n"); add_token(tok_CPL, NULL);
{INST_PRE}SCF{INST_POST}              printf("SCF\n"); add_token(tok_SCF, NULL);
{INST_PRE}CCF{INST_POST}              printf("CCF\n"); add_token(tok_CCF, NULL);
{INST_PRE}HALT{INST_POST}             printf("HALT\n"); add_token(tok_HALT, NULL);
{INST_PRE}ADC{INST_POST}              printf("ADC\n"); add_token(tok_ADC, NULL);
{INST_PRE}SUB{INST_POST}              printf("SUB\n"); add_token(tok_SUB, NULL);
{INST_PRE}SBC{INST_POST}              printf("SBC\n"); add_token(tok_SBC, NULL);
{INST_PRE}AND{INST_POST}              printf("AND\n"); add_token(tok_AND, NULL);
{INST_PRE}XOR{INST_POST}              printf("XOR\n"); add_token(tok_XOR, NULL);
{INST_PRE}OR{INST_POST}               printf("OR\n"); add_token(tok_OR, NULL);
{INST_PRE}CP{INST_POST}               printf("CP\n"); add_token(tok_CP, NULL);
{INST_PRE}RET{INST_POST}              printf("RET\n"); add_token(tok_RET, NULL);
{INST_PRE}POP{INST_POST}              printf("POP\n"); add_token(tok_POP, NULL);
{INST_PRE}JP{INST_POST}               printf("JP\n"); add_token(tok_JP, NULL);
{INST_PRE}CALL{INST_POST}             printf("CALL\n"); add_token(tok_CALL, NULL);
{INST_PRE}PUSH{INST_POST}             printf("PUSH\n"); add_token(tok_PUSH, NULL);
{INST_PRE}RST{INST_POST}              printf("RST\n"); add_token(tok_RST, NULL);
{INST_PRE}RETI{INST_POST}             printf("RETI\n"); add_token(tok_RETI, NULL);
{INST_PRE}DI{INST_POST}               printf("DI\n"); add_token(tok_DI, NULL);
{INST_PRE}EI{INST_POST}               printf("EI\n"); add_token(tok_EI, NULL);
{INST_PRE}RLC{INST_POST}              printf("RLC\n"); add_token(tok_RLC, NULL);
{INST_PRE}RRC{INST_POST}              printf("RRC\n"); add_token(tok_RRC, NULL);
{INST_PRE}RL{INST_POST}               printf("RL\n"); add_token(tok_RL, NULL);
{INST_PRE}RR{INST_POST}               printf("RR\n"); add_token(tok_RR, NULL);
{INST_PRE}SLA{INST_POST}              printf("SLA\n"); add_token(tok_SLA, NULL);
{INST_PRE}SRA{INST_POST}              printf("SRA\n"); add_token(tok_SRA, NULL);
{INST_PRE}SWAP{INST_POST}             printf("SWAP\n"); add_token(tok_SWAP, NULL);
{INST_PRE}SRL{INST_POST}              printf("SRL\n"); add_token(tok_SRL, NULL);
{INST_PRE}BIT{INST_POST}              printf("BIT\n"); add_token(tok_BIT, NULL);
{INST_PRE}RES{INST_POST}              printf("RES\n"); add_token(tok_RES, NULL);
{INST_PRE}SET{INST_POST}              printf("SET\n"); add_token(tok_SET, NULL);

AF{REG_POST}                          printf("AF\n"); add_token(tok_AF, NULL);
BC{REG_POST}                          printf("BC\n"); add_token(tok_BC, NULL);
DE{REG_POST}                          printf("DE\n"); add_token(tok_DE, NULL);
HL{REG_POST}                          printf("HL\n"); add_token(tok_HL, NULL);
HL\+{REG_POST}                        printf("HL+\n"); add_token(tok_HL_INC, NULL);
HL-{REG_POST}                         printf("HL-\n"); add_token(tok_HL_DEC, NULL);
SP{REG_POST}                          printf("SP\n"); add_token(tok_SP, NULL);
SP[ \t]*\+[ \t]*                      printf("SP+\n"); add_token(tok_SP_PLUS, NULL);
A{REG_POST}                           printf("A\n"); add_token(tok_A, NULL);
B{REG_POST}                           printf("B\n"); add_token(tok_B, NULL);
C{REG_POST}                           printf("C\n"); add_token(tok_C, NULL);
D{REG_POST}                           printf("D\n"); add_token(tok_D, NULL);
E{REG_POST}                           printf("E\n"); add_token(tok_E, NULL);
H{REG_POST}                           printf("H\n"); add_token(tok_H, NULL);
L{REG_POST}                           printf("L\n"); add_token(tok_L, NULL);

\$[0-9A-F][0-9A-F]?[0-9A-F]?[0-9A-F]? {
                                          uint16_t *data = malloc(sizeof(uint16_t));
                                          *data = strtol(&yytext[1], NULL, 16);
                                          printf("int: 0x%04X\n", *data);
                                          add_token(tok_INT, data);
                                      }
[0-9]+                                {
                                          uint32_t buffer = strtol(yytext, NULL, 10);
                                          if (buffer > 0xFFFF) {
                                              char *data = malloc(yyleng + 1);
                                              memcpy(data, yytext, yyleng + 1);
                                              printf("Integer overflow: %s\n", data);
                                              add_token(tok_ERROR_INTEGER_OVERFLOW, data);
                                          } else {
                                              uint16_t *data = malloc(sizeof(uint16_t));
                                              *data = buffer;
                                              printf("int: 0x%04X\n", *data);
                                              add_token(tok_INT, data);
                                          }
                                      }

^[A-Z_][A-Z0-9_]*:                    {
                                          // copy lowercase label into key
                                          size_t text_length = yyleng - 1;
                                          char *key = malloc(text_length + 1);
                                          for (int i = 0; i < text_length; ++i) {
                                              key[i] = tolower(yytext[i]);
                                          }
                                          key[text_length] = 0;

                                          // check for duplicate label
                                          if (dict_get(dict, key, text_length)) {
                                              char *data = malloc(yyleng + 1);
                                              memcpy(data, yytext, yyleng + 1);
                                              printf("ERROR: duplicate label: \"%s\"\n", key);
                                              free(key);
                                              add_token(tok_ERROR_DUPLICATE_LABEL, data);
                                          } else {
                                              // check for special labels
                                              if (strcmp(key, "_start") == 0) {
                                                  inst_index = 0x0100;
                                              } else if (strcmp(key, "_vblank") == 0) {
                                                  inst_index = 0x0040;
                                              } else if (strcmp(key, "_stat") == 0) {
                                                  inst_index = 0x0048;
                                              } else if (strcmp(key, "_timer") == 0) {
                                                  inst_index = 0x0050;
                                              } else if (strcmp(key, "_serial") == 0) {
                                                  inst_index = 0x0058;
                                              } else if (strcmp(key, "_joypad") == 0) {
                                                  inst_index = 0x0060;
                                              }
                                              uint16_t *data = malloc(sizeof(uint16_t));
                                              *data = inst_index;
                                              dict_put(dict, key, text_length, data);
                                              printf("Label \"%s\" maps to 0x%04X\n", key, *data);
                                              unput('\n');
                                          }
                                      }

[A-Z_][A-Z0-9_]*{REG_POST}            {
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

,                                      printf("COMMA\n"); add_token(tok_COMMA, NULL);
"("                                    printf("LPAR\n"); add_token(tok_LPAR, NULL);
")"                                    printf("RPAR\n"); add_token(tok_RPAR, NULL);

[ \n\t]                                /* do nothing */
.                                      {
                                           int capacity = 0x100;
                                           char *data = malloc(capacity);

                                           int i = 0;
                                           int c = yytext[0];
                                           while (c != '\n' && c != EOF) {
                                               if (i == capacity) {
                                                   capacity *= 2;
                                                   data = realloc(data, capacity);
                                               }
                                               data[i++] = c;
                                               c = input();
                                           }

                                           printf("Unexpected symbol: \"%s\"\n", data);
                                           add_token(tok_ERROR_UNEXPECTED_SYMBOL, data);
                                       }

%%

void add_token(token_type_t type, void *data)
{
    token_t tok = {
        .type = type,
        .data = data,
        .location = inst_index,
    };

    if (tokens_i == tokens_capacity) {
        tokens_capacity *= 2;
        tokens = realloc(tokens, tokens_capacity);
    }
    tokens[tokens_i] = tok;

    if (type >= tok_NOP && type <= tok_EI) {
        inst_index += 1;
    } else if (type >= tok_RLC && type <= tok_SET) {
        inst_index += 2;
    } else if (type == tok_COMMA) {
        unput(' ');
    } else if (type == tok_INT || type == tok_LABEL) {
        if (tokens_i >= 5 &&
            tokens[tokens_i-5].type == tok_LD &&
            tokens[tokens_i-4].type == tok_LPAR &&
            tokens[tokens_i-3].type == tok_HL &&
            tokens[tokens_i-2].type == tok_RPAR &&
            tokens[tokens_i-1].type == tok_COMMA) {
            inst_index += 1;
        } else if (tokens_i >= 4 &&
                   tokens[tokens_i-4].type == tok_LD &&
                   tokens[tokens_i-3].type == tok_HL &&
                   tokens[tokens_i-2].type == tok_COMMA &&
                   tokens[tokens_i-1].type == tok_SP_PLUS) {
            inst_index += 1;
        } else if (tokens_i >= 3 &&
                   tokens[tokens_i-3].type == tok_LD &&
                   (tokens[tokens_i-2].type == tok_A ||
                    tokens[tokens_i-2].type == tok_B ||
                    tokens[tokens_i-2].type == tok_C ||
                    tokens[tokens_i-2].type == tok_D ||
                    tokens[tokens_i-2].type == tok_E ||
                    tokens[tokens_i-2].type == tok_H ||
                    tokens[tokens_i-2].type == tok_L) &&
                   tokens[tokens_i-1].type == tok_COMMA) {
            inst_index += 1;
        } else if (tokens_i >= 3 &&
                   (tokens[tokens_i-3].type == tok_ADC ||
                    tokens[tokens_i-3].type == tok_ADD ||
                    tokens[tokens_i-3].type == tok_CP ||
                    tokens[tokens_i-3].type == tok_SBC ||
                    tokens[tokens_i-3].type == tok_SUB ||
                    tokens[tokens_i-3].type == tok_AND ||
                    tokens[tokens_i-3].type == tok_OR ||
                    tokens[tokens_i-3].type == tok_XOR) &&
                   tokens[tokens_i-2].type == tok_A &&
                   tokens[tokens_i-1].type == tok_COMMA) {
            inst_index += 1;
        } else if (tokens_i >= 3 &&
                   tokens[tokens_i-3].type == tok_ADD &&
                   tokens[tokens_i-2].type == tok_SP &&
                   tokens[tokens_i-1].type == tok_COMMA) {
            inst_index += 1;
        }
    }

    ++tokens_i;
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
