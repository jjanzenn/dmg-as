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
} token_type_t;

typedef struct token {
    token_type_t type;
} token_t;

token_t *tokens;
size_t tokens_capacity = 0x8000;
size_t tokens_i = 0;

uint16_t curr_line = 0;
dict_t *dict;

void add_token(token_type_t type);

%}

INST_DEL                                          [ \t\n;]
INST_PRE                                          ^[ \t]*

%%

;                                                 {
                                                      int c = input();
                                                      while (c != '\n' && c != EOF)
                                                          c = input();
                                                  }

{INST_PRE}NOP{INST_DEL}                           printf("NOP\n"); add_token(tok_NOP);
{INST_PRE}LD{INST_DEL}                            printf("LD\n"); add_token(tok_LD);
{INST_PRE}INC{INST_DEL}                           printf("INC\n"); add_token(tok_INC);
{INST_PRE}DEC{INST_DEL}                           printf("DEC\n"); add_token(tok_DEC);
{INST_PRE}RLCA{INST_DEL}                          printf("RLCA\n"); add_token(tok_RLCA);
{INST_PRE}ADD{INST_DEL}                           printf("ADD\n"); add_token(tok_ADD);
{INST_PRE}RRCA{INST_DEL}                          printf("RRCA\n"); add_token(tok_RRCA);
{INST_PRE}STOP{INST_DEL}                          printf("STOP\n"); add_token(tok_STOP);
{INST_PRE}RLA{INST_DEL}                           printf("RLA\n"); add_token(tok_RLA);
{INST_PRE}JR{INST_DEL}                            printf("JR\n"); add_token(tok_JR);
{INST_PRE}RRA{INST_DEL}                           printf("RRA\n"); add_token(tok_RRA);
{INST_PRE}DAA{INST_DEL}                           printf("DAA\n"); add_token(tok_DAA);
{INST_PRE}CPL{INST_DEL}                           printf("CPL\n"); add_token(tok_CPL);
{INST_PRE}SCF{INST_DEL}                           printf("SCF\n"); add_token(tok_SCF);
{INST_PRE}CCF{INST_DEL}                           printf("CCF\n"); add_token(tok_CCF);
{INST_PRE}HALT{INST_DEL}                          printf("HALT\n"); add_token(tok_HALT);
{INST_PRE}ADC{INST_DEL}                           printf("ADC\n"); add_token(tok_ADC);
{INST_PRE}SUB{INST_DEL}                           printf("SUB\n"); add_token(tok_SUB);
{INST_PRE}SBC{INST_DEL}                           printf("SBC\n"); add_token(tok_SBC);
{INST_PRE}AND{INST_DEL}                           printf("AND\n"); add_token(tok_AND);
{INST_PRE}XOR{INST_DEL}                           printf("XOR\n"); add_token(tok_XOR);
{INST_PRE}OR{INST_DEL}                            printf("OR\n"); add_token(tok_OR);
{INST_PRE}CP{INST_DEL}                            printf("CP\n"); add_token(tok_CP);
{INST_PRE}RET{INST_DEL}                           printf("RET\n"); add_token(tok_RET);
{INST_PRE}POP{INST_DEL}                           printf("POP\n"); add_token(tok_POP);
{INST_PRE}JP{INST_DEL}                            printf("JP\n"); add_token(tok_JP);
{INST_PRE}CALL{INST_DEL}                          printf("CALL\n"); add_token(tok_CALL);
{INST_PRE}PUSH{INST_DEL}                          printf("PUSH\n"); add_token(tok_PUSH);
{INST_PRE}RST{INST_DEL}                           printf("RST\n"); add_token(tok_RST);
{INST_PRE}RETI{INST_DEL}                          printf("RETI\n"); add_token(tok_RETI);
{INST_PRE}DI{INST_DEL}                            printf("DI\n"); add_token(tok_DI);
{INST_PRE}EI{INST_DEL}                            printf("EI\n"); add_token(tok_EI);
{INST_PRE}RLC{INST_DEL}                           printf("RLC\n"); add_token(tok_RLC);
{INST_PRE}RRC{INST_DEL}                           printf("RRC\n"); add_token(tok_RRC);
{INST_PRE}RL{INST_DEL}                            printf("RL\n"); add_token(tok_RL);
{INST_PRE}RR{INST_DEL}                            printf("RR\n"); add_token(tok_RR);
{INST_PRE}SLA{INST_DEL}                           printf("SLA\n"); add_token(tok_SLA);
{INST_PRE}SRA{INST_DEL}                           printf("SRA\n"); add_token(tok_SRA);
{INST_PRE}SWAP{INST_DEL}                          printf("SWAP\n"); add_token(tok_SWAP);
{INST_PRE}SRL{INST_DEL}                           printf("SRL\n"); add_token(tok_SRL);
{INST_PRE}BIT{INST_DEL}                           printf("BIT\n"); add_token(tok_BIT);
{INST_PRE}RES{INST_DEL}                           printf("RES\n"); add_token(tok_RES);
{INST_PRE}SET{INST_DEL}                           printf("SET\n"); add_token(tok_SET);

^[A-Za-z_][A-Za-z0-9_]*:                          {
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

void add_token(token_type_t type)
{
    token_t tok = {
        .type = type,
    };

    if (tokens_i == tokens_capacity) {
        tokens_capacity *= 2;
        tokens = realloc(tokens, tokens_capacity);
    }
    tokens[tokens_i] = tok;
}

int main(void)
{
    dict = dict_init();
    tokens = malloc(tokens_capacity);

    if (yylex() != 1) {
    }

    dict_deinit(dict);
    free(tokens);

    return 0;
}
