#include "token.h"
#include <ctype.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#define DEFAULT_STR_SIZE 16

struct token_string {
    size_t capacity;
    size_t size;
    char *data;
};

static void string_append(struct token_string *str, char c)
{
    if (str->size == str->capacity) {
        str->capacity *= 2;
        str->data = realloc(str->data, str->capacity);
    }
    str->data[str->size++] = c;
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

    struct token_string str = {
        .capacity = DEFAULT_STR_SIZE,
        .size = 0,
        .data = malloc(DEFAULT_STR_SIZE),
    };

    int c = fgetc(f);

    while (c != EOF && is_whitespace(c)) {
        c = fgetc(f);
    }

    if (c == EOF) {
        free(str.data);
        return NULL;
    } else if (is_special_token(c)) {
        string_append(&str, c);
    } else if (c == ';') {
        if (skip_to_newline(f) == EOF) {
            free(str.data);
        } else {
            string_append(&str, '\n');
            string_append(&str, 0);
            ungetc('\n', f);
        }
    } else {
        while (c != EOF && !is_special_token(c) && c != '\n' &&
               !is_whitespace(c)) {
            string_append(&str, tolower(c));
            c = fgetc(f);
        }
        ungetc(c, f);
    }

    string_append(&str, 0);
    return str.data;
}
