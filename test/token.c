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

void test_get_each_token(void)
{
    char **tokens = malloc(sizeof(char *) * 40);
    {
        tokens[0] = "_main";
        tokens[1] = ":";
        tokens[2] = "nop";
        tokens[3] = "\n";
        tokens[4] = "ld";
        tokens[5] = "b";
        tokens[6] = ",";
        tokens[7] = "c";
        tokens[8] = "\n";
        tokens[9] = "\n";
        tokens[10] = "label1";
        tokens[11] = ":";
        tokens[12] = "\n";
        tokens[13] = "pop";
        tokens[14] = "bc";
        tokens[15] = "\n";
        tokens[16] = "_vblank";
        tokens[17] = ":";
        tokens[18] = "ld";
        tokens[19] = "b";
        tokens[20] = ",";
        tokens[21] = "label1";
        tokens[22] = "\n";
        tokens[23] = "\n";
        tokens[24] = "nop";
        tokens[25] = "\n";
        tokens[26] = "\n";
        tokens[27] = "label2";
        tokens[28] = ":";
        tokens[29] = "nop";
        tokens[30] = "\n";
        tokens[31] = "ld";
        tokens[32] = "b";
        tokens[33] = ",";
        tokens[34] = "label2";
        tokens[35] = "\n";
        tokens[36] = "label3";
        tokens[37] = ":";
        tokens[38] = "nop";
        tokens[39] = "\n";
    };

    int i = 0;
    char *tok = NULL;
    do {
        tok = next_token(f);
        if (tok) {
            TEST_ASSERT_LESS_THAN(40, i);
            TEST_ASSERT_EQUAL_STRING(tokens[i++], tok);
        }
    } while (tok != NULL);
    TEST_ASSERT_EQUAL_INT(40, i);
    free(tokens);
}

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_get_each_token);
    return UNITY_END();
}
