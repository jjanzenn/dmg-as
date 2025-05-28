#include "dict.h"
#include "dmg.tab.h"
#include "parser.h"
#include <stdlib.h>

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
        .insts = malloc(sizeof(dmg_instruction) * 1000),
        .capacity = 1000,
        .size = 0,
    };
    yyparse(&result);

    return 0;
}
