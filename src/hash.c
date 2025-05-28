#include "hash.h"
#include <stdint.h>

#define FNV_OFFSET_BASIS 0xcbf29ce484222325
#define FNV_PRIME 0x100000001b3

uint64_t fnv_1a(char *input, size_t size)
{
    uint64_t hash = FNV_OFFSET_BASIS;

    for (int i = 0; i < size; ++i) {
        hash ^= input[i];
        hash *= FNV_PRIME;
    }

    return hash;
}
