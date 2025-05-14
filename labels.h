#ifndef _LABELS_H_
#define _LABELS_H_

#include "dict.h"
#include <stdio.h>

dict *identify_labels(FILE *file);
char *replace_labels(char *code);

#endif
