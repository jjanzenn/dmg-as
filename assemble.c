#include "assemble.h"
#include "dict.h"
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define STATUS_NO_COMMAND 0
#define STATUS_OK 1
#define STATUS_UNDEFINED_LABEL 2

static int handle_NOP(const dict_t *dict, const token_t *tokens, size_t i,
                      size_t num_tokens, uint8_t *rom, uint16_t location)
{
    (void)dict;
    (void)tokens;
    (void)i;
    (void)num_tokens;
    rom[location] = 0x00;

    return STATUS_OK;
}

static int handle_LD_r16_n16(const dict_t *dict, const token_t *tokens,
                             size_t i, size_t num_tokens, uint8_t *rom,
                             uint16_t location)
{
    int status = 1;
    if (i + 3 < num_tokens && tokens[i + 2].type == tok_COMMA &&
        (tokens[i + 3].type == tok_INT || tokens[i + 3].type == tok_LABEL)) {
        // unpack the literal
        uint16_t literal;
        if (tokens[i + 3].type == tok_INT) {
            literal = *(uint16_t *)tokens[i + 3].data;
        } else {
            uint16_t *ptr =
                dict_get(dict, tokens[i + 3].data, strlen(tokens[i + 3].data));
            if (ptr) {
                literal = *ptr;
            } else {
                status = STATUS_UNDEFINED_LABEL;
            }
        }

        // find the command
        if (status == STATUS_OK) {
            switch (tokens[i + 1].type) {
            case tok_BC:
                rom[location] = 0x01;
                break;
            case tok_DE:
                rom[location] = 0x11;
                break;
            case tok_HL:
                rom[location] = 0x21;
                break;
            case tok_SP:
                rom[location] = 0x31;
                break;
            default:
                status = STATUS_NO_COMMAND;
            }
        }

        if (status == STATUS_OK) {
            rom[location + 1] = literal & 0xFF;
            rom[location + 2] = literal >> 8;
        }
    }

    return status;
}

static int handle_LD_ar16_A(const dict_t *dict, const token_t *tokens, size_t i,
                            size_t num_tokens, uint8_t *rom, uint16_t location)
{
    (void)dict;
    int status = STATUS_OK;

    if (i + 5 < num_tokens && tokens[i + 1].type == tok_LPAR &&
        tokens[i + 3].type == tok_RPAR && tokens[i + 4].type == tok_COMMA &&
        tokens[i + 5].type == tok_A) {
        switch (tokens[i + 2].type) {
        case tok_BC:
            rom[location] = 0x02;
            break;
        case tok_DE:
            rom[location] = 0x12;
            break;
        case tok_HL_INC:
            rom[location] = 0x22;
            break;
        case tok_HL_DEC:
            rom[location] = 0x32;
            break;
        default:
            status = STATUS_NO_COMMAND;
        }
    }

    return status;
}

static int handle_LD_aHL_r8(const dict_t *dict, const token_t *tokens, size_t i,
                            size_t num_tokens, uint8_t *rom, uint16_t location)
{
    (void)dict;
    int status = STATUS_OK;

    if (i + 5 < num_tokens && tokens[i + 1].type == tok_LPAR &&
        tokens[i + 2].type == tok_HL && tokens[i + 3].type == tok_RPAR &&
        tokens[i + 4].type == tok_COMMA) {
        switch (tokens[i + 5].type) {
        case tok_B:
            rom[location] = 0x70;
            break;
        case tok_C:
            rom[location] = 0x71;
            break;
        case tok_D:
            rom[location] = 0x72;
            break;
        case tok_E:
            rom[location] = 0x73;
            break;
        case tok_H:
            rom[location] = 0x74;
            break;
        case tok_L:
            rom[location] = 0x75;
            break;
        case tok_A:
            rom[location] = 0x77;
            break;
        default:
            status = STATUS_NO_COMMAND;
        }
    }

    return status;
}

static int handle_LD_A_ar16(const dict_t *dict, const token_t *tokens, size_t i,
                            size_t num_tokens, uint8_t *rom, uint16_t location)
{
    (void)dict;
    int status = STATUS_OK;
    if (i + 5 < num_tokens && tokens[i + 1].type == tok_A &&
        tokens[i + 2].type == tok_COMMA && tokens[i + 3].type == tok_LPAR &&
        tokens[i + 5].type == tok_RPAR) {
        switch (tokens[i + 4].type) {
        case tok_BC:
            rom[location] = 0x0A;
            break;
        case tok_DE:
            rom[location] = 0x1A;
            break;
        case tok_HL_INC:
            rom[location] = 0x2A;
            break;
        case tok_HL_DEC:
            rom[location] = 0x3A;
            break;
        default:
            status = STATUS_NO_COMMAND;
        }
    }

    return status;
}

static int handle_LD_r8_aHL(const dict_t *dict, const token_t *tokens, size_t i,
                            size_t num_tokens, uint8_t *rom, uint16_t location)
{
    (void)dict;
    int status = STATUS_OK;

    if (i + 5 < num_tokens && tokens[i + 2].type == tok_COMMA &&
        tokens[i + 3].type == tok_LPAR && tokens[i + 4].type == tok_HL &&
        tokens[i + 5].type == tok_RPAR) {
        switch (tokens[i + 1].type) {
        case tok_B:
            rom[location] = 0x46;
            break;
        case tok_C:
            rom[location] = 0x4E;
            break;
        case tok_D:
            rom[location] = 0x56;
            break;
        case tok_E:
            rom[location] = 0x5E;
            break;
        case tok_H:
            rom[location] = 0x66;
            break;
        case tok_L:
            rom[location] = 0x6E;
            break;
        case tok_A:
            rom[location] = 0x7E;
            break;
        default:
            status = STATUS_NO_COMMAND;
        }
    }

    return status;
}

static int handle_LD_r8_n8(const dict_t *dict, const token_t *tokens, size_t i,
                           size_t num_tokens, uint8_t *rom, uint16_t location)
{
    int status = STATUS_OK;

    if (i + 3 < num_tokens && tokens[i + 2].type == tok_COMMA &&
        (tokens[i + 3].type == tok_INT || tokens[i + 3].type == tok_LABEL)) {

        // unpack the literal
        uint16_t literal;
        if (tokens[i + 3].type == tok_INT) {
            literal = *(uint16_t *)tokens[i + 3].data;
        } else {
            uint16_t *ptr =
                dict_get(dict, tokens[i + 3].data, strlen(tokens[i + 3].data));
            if (ptr) {
                literal = *ptr;
            } else {
                status = STATUS_UNDEFINED_LABEL;
            }
        }

        if (status == STATUS_OK) {
            switch (tokens[i + 1].type) {
            case tok_B:
                rom[location] = 0x06;
                break;
            case tok_C:
                rom[location] = 0x0E;
                break;
            case tok_D:
                rom[location] = 0x16;
                break;
            case tok_E:
                rom[location] = 0x1E;
                break;
            case tok_H:
                rom[location] = 0x26;
                break;
            case tok_L:
                rom[location] = 0x2E;
                break;
            case tok_A:
                rom[location] = 0x3E;
                break;
            default:
                status = STATUS_NO_COMMAND;
            }
        }

        if (status == STATUS_OK) {
            rom[location + 1] = literal & 0xFF;
        }
    }

    return status;
}

static int handle_LD_aHL_n8(const dict_t *dict, const token_t *tokens, size_t i,
                            size_t num_tokens, uint8_t *rom, uint16_t location)
{
    int status = STATUS_OK;

    if (i + 5 < num_tokens && tokens[i + 1].type == tok_LPAR &&
        tokens[i + 2].type == tok_HL && tokens[i + 3].type == tok_RPAR &&
        tokens[i + 4].type == tok_COMMA &&
        (tokens[i + 5].type == tok_INT || tokens[i + 5].type == tok_LABEL)) {

        // unpack the literal
        uint16_t literal;
        if (tokens[i + 5].type == tok_INT) {
            literal = *(uint16_t *)tokens[i + 5].data;
        } else {
            uint16_t *ptr =
                dict_get(dict, tokens[i + 5].data, strlen(tokens[i + 5].data));
            if (ptr) {
                literal = *ptr;
            } else {
                status = STATUS_UNDEFINED_LABEL;
            }
        }

        if (status == STATUS_OK) {
            rom[location] = 0x36;
            rom[location + 1] = literal & 0xFF;
        }
    }

    return status;
}

static int handle_LD_r8_r8(const dict_t *dict, const token_t *tokens, size_t i,
                           size_t num_tokens, uint8_t *rom, uint16_t location)
{
    int status = STATUS_OK;

    if (i + 3 < num_tokens && tokens[i + 2].type == tok_COMMA) {
        uint8_t cmd = 0x00;
        if (tokens[i + 1].type >= tok_B && tokens[i + 1].type <= tok_L) {
            cmd = 0x40 + 8 * (tokens[i + 1].type - tok_B);
        } else if (tokens[i + 1].type == tok_A) {
            cmd = 0x78;
        }

        if (tokens[i + 3].type >= tok_B && tokens[i + 3].type <= tok_L) {
            cmd += (tokens[i + 1].type - tok_B);
        } else if (tokens[i + 3].type == tok_A) {
            cmd += 6;
        }
    }

    return status;
}

static int handle_LD_a16_A(const dict_t *dict, const token_t *tokens, size_t i,
                           size_t num_tokens, uint8_t *rom, uint16_t location)
{
    int status = STATUS_OK;

    if (i + 5 < num_tokens && tokens[i + 1].type == tok_LPAR &&
        (tokens[i + 2].type == tok_INT || tokens[i + 2].type == tok_LABEL) &&
        tokens[i + 3].type == tok_RPAR && tokens[i + 4].type == tok_COMMA &&
        tokens[i + 5].type == tok_A) {

        // unpack the literal
        uint16_t literal;
        if (tokens[i + 2].type == tok_INT) {
            literal = *(uint16_t *)tokens[i + 2].data;
        } else {
            uint16_t *ptr =
                dict_get(dict, tokens[i + 2].data, strlen(tokens[i + 2].data));
            if (ptr) {
                literal = *ptr;
            } else {
                status = STATUS_UNDEFINED_LABEL;
            }
        }

        if (status == STATUS_OK) {
            rom[location] = 0xEA;
            rom[location + 1] = literal & 0xFF;
            rom[location + 2] = literal >> 8;
        }
    }

    return status;
}

static int handle_LD_A_a16(const dict_t *dict, const token_t *tokens, size_t i,
                           size_t num_tokens, uint8_t *rom, uint16_t location)
{
    int status = STATUS_OK;

    if (i + 5 < num_tokens && tokens[i + 1].type == tok_A &&
        tokens[i + 2].type == tok_COMMA && tokens[i + 3].type == tok_LPAR &&
        (tokens[i + 4].type == tok_INT || tokens[i + 4].type == tok_LABEL) &&
        tokens[i + 5].type == tok_RPAR) {
        // unpack the literal
        uint16_t literal;
        if (tokens[i + 4].type == tok_INT) {
            literal = *(uint16_t *)tokens[i + 4].data;
        } else {
            uint16_t *ptr =
                dict_get(dict, tokens[i + 4].data, strlen(tokens[i + 4].data));
            if (ptr) {
                literal = *ptr;
            } else {
                status = STATUS_UNDEFINED_LABEL;
            }
        }

        if (status == STATUS_OK) {
            rom[location] = 0xFA;
            rom[location + 1] = literal & 0xFF;
            rom[location + 2] = literal >> 8;
        }
    }

    return status;
}

static int handle_LD(const dict_t *dict, const token_t *tokens, size_t i,
                     size_t num_tokens, uint8_t *rom, uint16_t location)
{
    int status;

    status = handle_LD_r16_n16(dict, tokens, i, num_tokens, rom, location);
    if (status == STATUS_OK)
        return STATUS_OK;

    status = handle_LD_ar16_A(dict, tokens, i, num_tokens, rom, location);
    if (status == STATUS_OK)
        return STATUS_OK;

    status = handle_LD_aHL_r8(dict, tokens, i, num_tokens, rom, location);
    if (status == STATUS_OK)
        return STATUS_OK;

    status = handle_LD_A_ar16(dict, tokens, i, num_tokens, rom, location);
    if (status == STATUS_OK)
        return STATUS_OK;

    status = handle_LD_r8_aHL(dict, tokens, i, num_tokens, rom, location);
    if (status == STATUS_OK)
        return STATUS_OK;

    status = handle_LD_r8_n8(dict, tokens, i, num_tokens, rom, location);
    if (status == STATUS_OK)
        return STATUS_OK;

    status = handle_LD_aHL_n8(dict, tokens, i, num_tokens, rom, location);
    if (status == STATUS_OK)
        return STATUS_OK;

    status = handle_LD_r8_r8(dict, tokens, i, num_tokens, rom, location);
    if (status == STATUS_OK)
        return STATUS_OK;

    status = handle_LD_a16_A(dict, tokens, i, num_tokens, rom, location);
    if (status == STATUS_OK)
        return STATUS_OK;

    status = handle_LD_A_a16(dict, tokens, i, num_tokens, rom, location);
    if (status == STATUS_OK)
        return STATUS_OK;

    return STATUS_NO_COMMAND;
}

uint8_t *assemble(const dict_t *dict, const token_t *tokens, size_t num_tokens)
{
    uint8_t *rom = calloc(1, MAX_ROM_SIZE);

    for (int i = 0; i < num_tokens; ++i) {
        uint16_t location = tokens[i].location;

        switch (tokens[i].type) {
        case tok_NOP:
            handle_NOP(dict, tokens, i, num_tokens, rom, location);
            break;
        case tok_LD: {
            handle_LD(dict, tokens, i, num_tokens, rom, location);
            break;
        }
        default:
            break;
        }
    }

    return rom;
}
