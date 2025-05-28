#include "dict.h"
#include "dmg.tab.h"
#include "parser.h"
#include <stddef.h>
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

void print_binary(uint8_t *bin, size_t size)
{
    for (int i = 0; i < size; ++i) {
        if (i % 16 == 0) {
            printf("\n%04x: ", i);
        }
        printf("%02x ", bin[i]);
    }
}

int write_to_binary(uint8_t *bin, size_t size, size_t position, uint8_t value)
{
    if (position > size || bin[position] != 0x00) {
        fprintf(stderr, "Assembled binary would overwrite itself\n");
        return 1;
    }
    bin[position] = value;
    return 0;
}

uint32_t fetch_int(dict *d, dmg_int_container *container)
{
    if (!container)
        return 0x10000;

    uint32_t result;
    if (container->type == DMG_INT_CONTAINER_LABEL) {
        if (!container->value.label)
            return 0x10000;

        uint16_t *res_ptr = dict_get(d, container->value.label);
        if (!res_ptr)
            return 0x10000;
        result = *res_ptr;
    } else {
        result = container->value.num;
    }

    if (result > 0xFFFF)
        result = 0x10000;

    return result;
}

int populate_binary(uint8_t *bin, size_t size, dmg_parse_result *result)
{
    for (int i = 0; i < result->size; ++i) {
        uint16_t position = result->insts[i]->position;
        uint8_t opcode = result->insts[i]->opcode;
        if (result->insts[i]->prefix) {
            if (write_to_binary(bin, size, position++, 0xCB) != 0) {
                return 1;
            }
        }
        if (write_to_binary(bin, size, position++, opcode) != 0) {
            return 1;
        }

        if (result->insts[i]->prefix) {
            return 0;
        }

        switch (opcode) {
        case 0x01:
        case 0x08:
        case 0x11:
        case 0x21:
        case 0x31:
        case 0xC2:
        case 0xC3:
        case 0xC4:
        case 0xCA:
        case 0xCC:
        case 0xCD:
        case 0xD2:
        case 0xD4:
        case 0xDA:
        case 0xDC:
        case 0xEA: {
            uint32_t suffix =
                fetch_int(result->labels, result->insts[i]->suffix);
            if (suffix > 0xFFFF) {
                return 1;
            }

            if (write_to_binary(bin, size, position++, suffix & 0xFF)) {
                return 1;
            }

            if (write_to_binary(bin, size, position++, suffix >> 8)) {
                return 1;
            }

            break;
        }
        case 0x06:
        case 0x0E:
        case 0x10:
        case 0x16:
        case 0x18:
        case 0x1E:
        case 0x20:
        case 0x26:
        case 0x28:
        case 0x2E:
        case 0x30:
        case 0x36:
        case 0x38:
        case 0x3E:
        case 0xC6:
        case 0xCE:
        case 0xD6:
        case 0xDE:
        case 0xE0:
        case 0xE6:
        case 0xE8:
        case 0xEE:
        case 0xF0:
        case 0xF6:
        case 0xF8:
        case 0xFE: {
            uint32_t suffix =
                fetch_int(result->labels, result->insts[i]->suffix);
            if (suffix > 0xFF) {
                return 1;
            }

            if (write_to_binary(bin, size, position++, suffix)) {
                return 1;
            }

            break;
        }
        }
    }

    return 0;
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

    if (populate_binary(output, OUTPUT_SIZE, &result) != 0) {
        return 1;
    }

    print_binary(output, OUTPUT_SIZE);

    return 0;
}
