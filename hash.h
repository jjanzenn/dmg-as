#ifndef _HASH_H_
#define _HASH_H_

#include <stddef.h>
#include <stdint.h>

uint64_t fnv_1a(char *input, size_t size);

#endif
