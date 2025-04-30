%{
    #include <stdint.h>
    #include <stdio.h>
    #include <stddef.h>
    #include <string.h>
    #include <ctype.h>
    #include "dict.h"
    #include "assemble.h"

    token_t *tokens;
    size_t tokens_capacity = 0x8000;
    size_t tokens_i = 0;

    dict_t *dict;
    uint16_t inst_index = 0;
    int line_number = 1;
    int fake_line_number = 0;

    static void add_token(token_type_t type, void *data);
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
{INST_PRE}LDH{INST_POST}              printf("LDH\n"); add_token(tok_LDH, NULL);
{INST_PRE}INC{INST_POST}              printf("INC\n"); add_token(tok_INC, NULL);
{INST_PRE}DEC{INST_POST}              printf("DEC\n"); add_token(tok_DEC, NULL);
{INST_PRE}RLCA{INST_POST}             printf("RLCA\n"); add_token(tok_RLCA, NULL);
{INST_PRE}ADD{INST_POST}              printf("ADD\n"); add_token(tok_ADD, NULL);
{INST_PRE}RRCA{INST_POST}             printf("RRCA\n"); add_token(tok_RRCA, NULL);
{INST_PRE}STOP{INST_POST}             printf("STOP\n"); add_token(tok_STOP, NULL);
{INST_PRE}RLA{INST_POST}              printf("RLA\n"); add_token(tok_RLA, NULL);
{INST_PRE}JR{INST_POST}               printf("JR\n"); add_token(tok_JR, NULL);
{INST_PRE}JRNZ{INST_POST}             printf("JRNZ\n"); add_token(tok_JRNZ, NULL);
{INST_PRE}JRZ{INST_POST}              printf("JRZ\n"); add_token(tok_JRZ, NULL);
{INST_PRE}JRNC{INST_POST}             printf("JRNC\n"); add_token(tok_JRNC, NULL);
{INST_PRE}JRC{INST_POST}              printf("JRC\n"); add_token(tok_JRC, NULL);
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
{INST_PRE}RETNZ{INST_POST}            printf("RETNZ\n"); add_token(tok_RETNZ, NULL);
{INST_PRE}RETZ{INST_POST}             printf("RETZ\n"); add_token(tok_RETZ, NULL);
{INST_PRE}RETNC{INST_POST}            printf("RETNC\n"); add_token(tok_RETNC, NULL);
{INST_PRE}RETC{INST_POST}             printf("RETC\n"); add_token(tok_RETC, NULL);
{INST_PRE}POP{INST_POST}              printf("POP\n"); add_token(tok_POP, NULL);
{INST_PRE}JP{INST_POST}               printf("JP\n"); add_token(tok_JP, NULL);
{INST_PRE}JPNZ{INST_POST}             printf("JPNZ\n"); add_token(tok_JPNZ, NULL);
{INST_PRE}JPZ{INST_POST}              printf("JPZ\n"); add_token(tok_JPZ, NULL);
{INST_PRE}JPNC{INST_POST}             printf("JPNC\n"); add_token(tok_JPNC, NULL);
{INST_PRE}JPC{INST_POST}              printf("JPC\n"); add_token(tok_JPC, NULL);
{INST_PRE}CALL{INST_POST}             printf("CALL\n"); add_token(tok_CALL, NULL);
{INST_PRE}CALLNZ{INST_POST}           printf("CALLNZ\n"); add_token(tok_CALLNZ, NULL);
{INST_PRE}CALLZ{INST_POST}            printf("CALLZ\n"); add_token(tok_CALLZ, NULL);
{INST_PRE}CALLNC{INST_POST}           printf("CALLNC\n"); add_token(tok_CALLNC, NULL);
{INST_PRE}CALLC{INST_POST}            printf("CALLC\n"); add_token(tok_CALLC, NULL);
{INST_PRE}PUSH{INST_POST}             printf("PUSH\n"); add_token(tok_PUSH, NULL);
{INST_PRE}RST[0-7]{INST_POST}         {
                                          int end = yytext[yyleng-1] == ' ' ? yytext[yyleng-2] : yytext[yyleng-1];
                                          printf("RST%c\n", end);
                                          switch (end) {
                                              case '0':
                                                  add_token(tok_RST0, NULL);
                                                  break;
                                              case '1':
                                                  add_token(tok_RST1, NULL);
                                                  break;
                                              case '2':
                                                  add_token(tok_RST2, NULL);
                                                  break;
                                              case '3':
                                                  add_token(tok_RST3, NULL);
                                                  break;
                                              case '4':
                                                  add_token(tok_RST4, NULL);
                                                  break;
                                              case '5':
                                                  add_token(tok_RST5, NULL);
                                                  break;
                                              case '6':
                                                  add_token(tok_RST6, NULL);
                                                  break;
                                              case '7':
                                                  add_token(tok_RST7, NULL);
                                                  break;
                                          }
                                      }
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
{INST_PRE}BIT[0-7]{INST_POST}         {
                                          int end = yytext[yyleng-1] == ' ' ? yytext[yyleng-2] : yytext[yyleng-1];
                                          printf("BIT%c\n", end);
                                          switch (end) {
                                              case '0':
                                                  add_token(tok_BIT0, NULL);
                                                  break;
                                              case '1':
                                                  add_token(tok_BIT1, NULL);
                                                  break;
                                              case '2':
                                                  add_token(tok_BIT2, NULL);
                                                  break;
                                              case '3':
                                                  add_token(tok_BIT3, NULL);
                                                  break;
                                              case '4':
                                                  add_token(tok_BIT4, NULL);
                                                  break;
                                              case '5':
                                                  add_token(tok_BIT5, NULL);
                                                  break;
                                              case '6':
                                                  add_token(tok_BIT6, NULL);
                                                  break;
                                              case '7':
                                                  add_token(tok_BIT7, NULL);
                                                  break;
                                          }
                                      }
{INST_PRE}RES[0-7]{INST_POST}         {
                                          int end = yytext[yyleng-1] == ' ' ? yytext[yyleng-2] : yytext[yyleng-1];
                                          printf("RES%c\n", end);
                                          switch (end) {
                                              case '0':
                                                  add_token(tok_RES0, NULL);
                                                  break;
                                              case '1':
                                                  add_token(tok_RES1, NULL);
                                                  break;
                                              case '2':
                                                  add_token(tok_RES2, NULL);
                                                  break;
                                              case '3':
                                                  add_token(tok_RES3, NULL);
                                                  break;
                                              case '4':
                                                  add_token(tok_RES4, NULL);
                                                  break;
                                              case '5':
                                                  add_token(tok_RES5, NULL);
                                                  break;
                                              case '6':
                                                  add_token(tok_RES6, NULL);
                                                  break;
                                              case '7':
                                                  add_token(tok_RES7, NULL);
                                                  break;
                                          }
                                      }
{INST_PRE}SET[0-7]{INST_POST}         {
                                          int end = yytext[yyleng-1] == ' ' ? yytext[yyleng-2] : yytext[yyleng-1];
                                          printf("SET%c\n", end);
                                          switch (end) {
                                              case '0':
                                                  add_token(tok_SET0, NULL);
                                                  break;
                                              case '1':
                                                  add_token(tok_SET1, NULL);
                                                  break;
                                              case '2':
                                                  add_token(tok_SET2, NULL);
                                                  break;
                                              case '3':
                                                  add_token(tok_SET3, NULL);
                                                  break;
                                              case '4':
                                                  add_token(tok_SET4, NULL);
                                                  break;
                                              case '5':
                                                  add_token(tok_SET5, NULL);
                                                  break;
                                              case '6':
                                                  add_token(tok_SET6, NULL);
                                                  break;
                                              case '7':
                                                  add_token(tok_SET7, NULL);
                                                  break;
                                          }
                                      }

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
                                              int c = input();
                                              if (c != '\n')
                                                  fake_line_number = 1;
                                              unput('\n');
                                              unput(c);
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

[ \t]                                  /* do nothing */
\n                                     {
                                           printf("line: %d\n", line_number);
                                           if (fake_line_number) {
                                               fake_line_number = 0;
                                           } else {
                                               ++line_number;
                                           }
                                       }
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
        .line_number = line_number,
    };

    if (tokens_i == tokens_capacity) {
        tokens_capacity *= 2;
        tokens = realloc(tokens, tokens_capacity);
    }
    tokens[tokens_i] = tok;

    if (type >= tok_NOP && type <= tok_EI) {
        inst_index += 1;
    } else if ((type >= tok_RLC && type <= tok_SET7) || type == tok_STOP) {
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
        } else if (tokens_i >= 3 &&
                   tokens[tokens_i-3].type == tok_LD &&
                   (tokens[tokens_i-2].type == tok_BC ||
                    tokens[tokens_i-2].type == tok_DE ||
                    tokens[tokens_i-2].type == tok_HL ||
                    tokens[tokens_i-2].type == tok_DE ||
                    tokens[tokens_i-2].type == tok_SP) &&
                   tokens[tokens_i-1].type == tok_COMMA) {
            inst_index += 2;
        } else if (tokens_i >= 2 &&
                   tokens[tokens_i-2].type == tok_LD &&
                   tokens[tokens_i-1].type == tok_LPAR) {
            inst_index += 2;
        } else if (tokens_i >= 2 &&
                   tokens[tokens_i-2].type == tok_LDH &&
                   tokens[tokens_i-1].type == tok_LPAR) {
            inst_index += 1;
        } else if (tokens_i >= 4 &&
                   tokens[tokens_i-4].type == tok_LD &&
                   tokens[tokens_i-3].type == tok_A &&
                   tokens[tokens_i-2].type == tok_COMMA &&
                   tokens[tokens_i-1].type == tok_LPAR) {
            inst_index += 2;
        } else if (tokens_i >= 4 &&
                   tokens[tokens_i-4].type == tok_LDH &&
                   tokens[tokens_i-3].type == tok_A &&
                   tokens[tokens_i-2].type == tok_COMMA &&
                   tokens[tokens_i-1].type == tok_LPAR) {
            inst_index += 1;
        } else if (tokens_i >= 1 &&
                   ((tokens[tokens_i-1].type >= tok_CALL &&
                    tokens[tokens_i-1].type <= tok_CALLC) ||
                    (tokens[tokens_i-1].type >= tok_JP &&
                    tokens[tokens_i-1].type <= tok_JPC) ||
                    (tokens[tokens_i-1].type >= tok_JR &&
                    tokens[tokens_i-1].type <= tok_JRC))) {
            inst_index += 2;
        }
    }

    ++tokens_i;
}

int main(int argc, char **argv)
{
    FILE *fp;
    if (argc >= 2) {
        fp = fopen(argv[1], "r");
        fseek(fp, 0, SEEK_END);
        int size = ftell(fp);
        rewind(fp);
        yy_switch_to_buffer(yy_create_buffer(fp, size));
    }
    dict = dict_init();
    tokens = malloc(tokens_capacity);

    yylex();

    dict_deinit(dict);
    for (int i = 0; i < tokens_i; ++i) {
        if (tokens[tokens_i].data) {
           free(tokens[tokens_i].data);
        }
    }
    free(tokens);

    return 0;
}
