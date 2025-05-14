#include "labels.h"
#include "dict.h"
#include <regex.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#define DEFAULT_TOKEN_CAP 128

#define INST_REGEX                                                             \
    "(LD|LDH|ADC|ADD|CP|DEC|INC|SBC|SUB|AND|CPL|OR|XOR|BIT|RES|SET|RL|RLA|"    \
    "RLC|RLCA|RR|RRA|RRC|RRCA|SLA|SRA|SRL|SWAP|CALL|JP|JR|RET|RETI|RST|CCF|"   \
    "SCF|POP|PUSH|DI|EI|HALT|DAA|NOP|STOP)"

dict *identify_labels(FILE *file)
{
    rewind(file);
    dict *d = dict_init();

    int token_size = 0;
    int token_cap = DEFAULT_TOKEN_CAP;
    char *token = malloc(token_cap);

    int c;
    while ((c = fgetc(file)) != EOF) {
    }

    return d;
}
