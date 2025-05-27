#ifndef _PARSER_H_
#define _PARSER_H_

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
    dmg_int_container *suffix;
} dmg_instruction;

#endif
