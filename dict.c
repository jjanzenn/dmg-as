#include "dict.h"
#include "hash.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DEFAULT_CAPACITY 1024
#define MAX_LOAD_FACTOR 0.7

dict *dict_init(void)
{
    dict *d = malloc(sizeof(dict));
    if (!d)
        return NULL;

    d->capacity = DEFAULT_CAPACITY;
    d->size = 0;
    d->data = calloc(DEFAULT_CAPACITY, sizeof(ll_node *));
    if (!d->data) {
        free(d);
        return NULL;
    }

    return d;
}

void dict_deinit(dict *d)
{
    if (!d)
        return;
    if (d->data) {
        for (int i = 0; i < d->capacity; ++i) {
            ll_node *prev = NULL;
            ll_node *curr = d->data[i];
            while (curr) {
                prev = curr;
                curr = curr->next;
                free(prev->data);
                free(prev);
            }
        }
        free(d->data);
    }
    free(d);
}

void dict_insert(dict *d, char *key, uint16_t value)
{
    if (!d || !key)
        return;

    uint64_t index = fnv_1a(key, strlen(key)) % d->capacity;

    kvp *k = malloc(sizeof(kvp));
    if (!k)
        return;
    k->key = key;
    k->value = value;

    ll_node *n = malloc(sizeof(ll_node));
    if (!n) {
        free(k);
        return;
    }
    n->next = NULL;
    n->data = k;

    ++(d->size);
    if (!(d->data[index])) {
        d->data[index] = n;
    } else {
        ll_node *prev = NULL;
        ll_node *curr = d->data[index];
        while (curr) {
            prev = curr;
            curr = curr->next;
            if (strcmp(prev->data->key, key) == 0) {
                prev->data->value = value;
                --(d->size);
                free(n->data);
                free(n);
                return;
            }
        }
        prev->next = n;
    }
}

uint16_t *dict_get(dict *d, char *key)
{
    if (!d || !key)
        return NULL;

    uint64_t index = fnv_1a(key, strlen(key)) % d->capacity;

    ll_node *curr = d->data[index];
    while (curr) {
        if (strcmp(key, curr->data->key) == 0) {
            return &curr->data->value;
        }
    }

    return NULL;
}
