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
    if (c == ':' || c == ',' || c == '\n') {
        string_append(&str, c);
    } else if (c == EOF) {
        free(str.data);
        return NULL;
    } else {
        while ((c == ' ' || c == '\t' || c == '\r' || c == '\f') && c != EOF) {
            c = fgetc(f);
        }
        while (c != EOF && c != ':' && c != ',' && c != '\n' && c != ' ' &&
               c != '\t' && c != '\r' && c != '\f') {
            string_append(&str, tolower(c));
            c = fgetc(f);
        }
        ungetc(c, f);
    }

    string_append(&str, 0);
    return str.data;
}
