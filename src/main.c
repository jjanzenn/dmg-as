#include "dict.h"
#include "dmg.tab.h"
#include "parser.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define DEFAULT_INST_CAP 1024
#define OUTPUT_SIZE 0x10000

void dmg_parse_result_append(dmg_parse_result *result, dmg_instruction *inst)
{
    if (result->size == result->capacity) {
        result->capacity *= 2;
        result->insts = realloc(result->insts, result->capacity);
    }
    result->insts[result->size++] = inst;
}

int main(void)
{
    dmg_parse_result result = {
        .labels = dict_init(),
        .insts = malloc(sizeof(dmg_instruction) * DEFAULT_INST_CAP),
        .capacity = DEFAULT_INST_CAP,
        .size = 0,
    };
    yyparse(&result);

    uint8_t output[OUTPUT_SIZE];
    for (int i = 0; i < OUTPUT_SIZE; ++i)
        output[i] = 0x00;

    for (int i = 0; i < result.size; ++i) {
        uint16_t position = result.insts[i]->position;
        if (result.insts[i]->prefix) {
            output[position++] = 0xCB;
        }
        output[position++] = result.insts[i]->opcode;
    }

    for (int i = 0; i < OUTPUT_SIZE; ++i) {
        if (i % 16 == 0) {
            printf("\n%04x: ", i);
        }
        printf("%02x ", output[i]);
    }

    return 0;
}
