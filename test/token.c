#include "token.h"
#include "config.h"
#include "unity.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *f;

void setUp(void)
{
    int pathsize = strlen("/test/tokens.s") + strlen(PROJECT_ROOT);
    char *filename = malloc(pathsize + 1);
    snprintf(filename, pathsize + 1, "%s%s", PROJECT_ROOT, "/test/tokens.s");
    f = fopen(filename, "r");
    free(filename);
}

void tearDown(void) { fclose(f); };

void test_thing(void) { TEST_ASSERT_EQUAL_INT(4, 4); }

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_thing);
    return UNITY_END();
}
