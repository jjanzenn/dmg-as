#include "labels.h"
#include "dict.h"
#include <regex.h>
#include <stddef.h>
#include <stdio.h>

#define DEFAULT_TOKEN_CAP 128

dict *identify_labels(FILE *file)
{
    rewind(file);
    dict *d = dict_init();

    return d;
}
