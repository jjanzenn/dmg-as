#ifndef _DICT_H_
#define _DICT_H_

#include <stddef.h>
#include <stdint.h>

typedef struct kvp {
    char *key;
    uint16_t value;
} kvp;

typedef struct ll_node {
    struct ll_node *next;
    kvp *data;
} ll_node;

typedef struct dict {
    ll_node **data;
    size_t size;
    size_t capacity;
} dict;

dict *dict_init(void);
void dict_deinit(dict *d);

void dict_insert(dict *d, char *key, uint16_t value);
uint16_t *dict_get(dict *d, char *key);

#endif
