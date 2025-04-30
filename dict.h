#ifndef _DICT_H
#define _DICT_H

#include <stddef.h>
#include <stdint.h>

typedef struct node {
    void *key;
    size_t keysize;
    void *data;
    struct node *next;
} node_t;

typedef struct dict {
    uint32_t capacity;
    uint32_t size;
    node_t **data;
} dict_t;

node_t *node_init(void *key, size_t keysize, void *data);
void node_deinit(node_t *n);

dict_t *dict_init(void);
void dict_deinit(dict_t *d);

void dict_put(dict_t *d, void *key, size_t keysize, void *data);
void *dict_get(const dict_t *d, const void *key, size_t keysize);

#endif
