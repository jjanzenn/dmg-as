#include "dict.h"
#include "hash.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define _XOPEN_SOURCE 600

#define DEFAULT_CAPACITY 1024
#define MAX_LOAD_FACTOR 0.7

static void free_dict_data(dict *d)
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
                free(prev->data->key);
                free(prev->data);
                free(prev);
            }
        }
        free(d->data);
    }
}

static void rehash(dict *d)
{
    if (!d)
        return;

    dict *newd = dict_init();
    newd->capacity = d->capacity * 2;
    newd->data = realloc(newd->data, sizeof(ll_node *) * newd->capacity);
    for (int i = 0; i < newd->capacity; ++i) {
        newd->data[i] = NULL;
    }

    for (int i = 0; i < d->capacity; ++i) {
        ll_node *curr = d->data[i];
        while (curr) {
            if (curr->data) {
                dict_insert(newd, curr->data->key, curr->data->value);
            }
            curr = curr->next;
        }
    }

    free_dict_data(d);

    d->capacity *= 2;
    d->data = newd->data;
    free(newd);
}

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
    free_dict_data(d);
    free(d);
}

void dict_insert(dict *d, char *key, uint16_t value)
{
    if (!d || !key)
        return;

    size_t keylen = strlen(key);

    uint64_t index = fnv_1a(key, keylen) % d->capacity;

    kvp *k = malloc(sizeof(kvp));
    if (!k)
        return;
    k->key = strdup(key);
    if (!k->key) {
        free(k);
        return;
    }
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
            if (strncmp(prev->data->key, key, keylen) == 0) {
                prev->data->value = value;
                --(d->size);
                free(n->data->key);
                free(n->data);
                free(n);
                return;
            }
        }

        prev->next = n;
    }

    if ((double)d->size / (double)d->capacity > MAX_LOAD_FACTOR) {
        rehash(d);
    }
}

uint16_t *dict_get(dict *d, char *key)
{
    if (!d || !key)
        return NULL;

    uint64_t index = fnv_1a(key, strlen(key)) % d->capacity;

    ll_node *curr = d->data[index];
    uint16_t *out = NULL;
    while (curr) {
        if (strcmp(key, curr->data->key) == 0) {
            out = &curr->data->value;
            break;
        }
        curr = curr->next;
    }

    return out;
}
