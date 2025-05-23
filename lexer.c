#include "lexer.h"
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

#include <ctype.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DEFAULT_STR_SIZE 16

typedef union data_val {
    token *token;
    char character;
} data_val;

typedef struct vec {
    size_t capacity;
    size_t size;
    data_val *data;
} vec;

static void vec_append(vec *v, data_val c)
{
    if (v->size == v->capacity) {
        v->capacity *= 2;
        v->data = realloc(v->data, v->capacity);
    }
    v->data[v->size++] = c;
}

static inline int is_special_token(char c)
{
    return c == ':' || c == ',' || c == '\n' || c == '[' || c == ']' ||
           c == '+' || c == '-';
}

static inline int is_whitespace(char c)
{
    return c == ' ' || c == '\t' || c == '\r' || c == '\f';
}

static int skip_to_newline(FILE *f)
{
    int c = fgetc(f);
    while (c != '\n' && c != EOF)
        c = fgetc(f);

    return c;
}

char *next_token(FILE *f)
{
    if (!f)
        return NULL;

    vec v = {
        .capacity = DEFAULT_STR_SIZE,
        .size = 0,
        .data = malloc(DEFAULT_STR_SIZE * sizeof(data_val)),
    };

    int c = fgetc(f);

    while (c != EOF && is_whitespace(c)) {
        c = fgetc(f);
    }

    if (c == EOF) {
        free(v.data);
        return NULL;
    } else if (is_special_token(c)) {
        data_val character = {.character = c};
        vec_append(&v, character);
    } else if (c == ';') {
        if (skip_to_newline(f) == EOF) {
            free(v.data);
        } else {
            data_val character = {.character = '\n'};
            vec_append(&v, character);
            character.character = 0;
            vec_append(&v, character);
            ungetc('\n', f);
        }
    } else {
        while (c != EOF && !is_special_token(c) && c != '\n' &&
               !is_whitespace(c)) {
            data_val character = {.character = tolower(c)};
            vec_append(&v, character);
            c = fgetc(f);
        }
        ungetc(c, f);
    }

    char *str = malloc(v.size + 1);
    for (int i = 0; i < v.size; ++i) {
        str[i] = v.data[i].character;
    }
    str[v.size] = 0;
    free(v.data);

    return str;
}

token **lex(FILE *f) { return NULL; }
