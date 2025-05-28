#ifndef _PARSER_H_
#define _PARSER_H_

#include "dict.h"
#include <stdint.h>

typedef struct dmg_int_container {
    union {
        int num;
        char *label;
    } value;
    enum {
        DMG_INT_CONTAINER_NUM,
        DMG_INT_CONTAINER_LABEL,
    } type;
} dmg_int_container;

typedef struct dmg_instruction {
    int prefix;
    uint8_t opcode;
    uint32_t position;
    dmg_int_container *suffix;
} dmg_instruction;

typedef struct dmg_parse_result {
    dict *labels;
    dmg_instruction **insts;
    size_t capacity;
    size_t size;
} dmg_parse_result;

void dmg_parse_result_append(dmg_parse_result *result, dmg_instruction *inst);

#endif
