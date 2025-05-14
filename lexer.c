#include "lexer.h"
#include "dict.h"

lexer lex(FILE *f)
{
    dict *d = dict_init();

    lexer result = {
        .d = d,
        .tokens = NULL,
    };

    return result;
}
