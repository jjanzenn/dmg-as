#include "dict.h"
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

#define DEFAULT_CAPACITY 1024

static uint32_t adler32(const void *buf, size_t buflength)
{
    const uint8_t *buffer = (const uint8_t *)buf;

    uint32_t s1 = 1;
    uint32_t s2 = 0;

    for (size_t n = 0; n < buflength; n++) {
        s1 = (s1 + buffer[n]) % 65521;
        s2 = (s2 + s1) % 65521;
    }
    return (s2 << 16) | s1;
}

static int keyequal(void *key, size_t keysize, node_t *other)
{
    int equal = other->keysize == keysize;
    for (int i = 0; equal && i < keysize; ++i) {
        equal = ((char *)key)[i] == ((char *)other->key)[i];
    }

    return equal;
}

node_t *node_init(void *key, size_t keysize, void *data)
{
    node_t *n = malloc(sizeof(node_t));
    n->key = key;
    n->keysize = keysize;
    n->data = data;
    n->next = NULL;

    return n;
}

void node_deinit(node_t *n)
{
    if (!n)
        return;
    node_deinit(n->next);
    free(n);
}

dict_t *dict_init(void)
{
    dict_t *d = malloc(sizeof(dict_t));
    d->capacity = DEFAULT_CAPACITY;
    d->size = 0;
    d->data = malloc(sizeof(void *) * DEFAULT_CAPACITY);

    return d;
}

void dict_deinit(dict_t *d)
{
    if (!d)
        return;
    for (int i = 0; i < d->capacity; ++i) {
        node_deinit(d->data[i]);
    }

    free(d->data);
    free(d);
}

void dict_put(dict_t *d, void *key, size_t keysize, void *data)
{
    node_t *n = node_init(key, keysize, data);
    uint32_t index = adler32(key, keysize) % d->capacity;

    node_t *curr = d->data[index];
    if (!curr) {
        d->data[index] = n;
    } else {
        while (curr->next) {
            curr = curr->next;
        }
        curr->next = n;
    }
}

void *dict_get(dict_t *d, void *key, size_t keysize)
{
    uint32_t index = adler32(key, keysize) % d->capacity;

    node_t *curr = d->data[index];
    while (curr && !keyequal(key, keysize, curr)) {
        curr = curr->next;
    }

    return curr ? curr->data : NULL;
}
