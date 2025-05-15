#include "lexer.h"
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
    char **tokens = malloc(sizeof(char *) * 67);
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
        tokens[19] = "[";
        tokens[20] = "label1";
        tokens[21] = "]";
        tokens[22] = ",";
        tokens[23] = "sp";
        tokens[24] = "\n";
        tokens[25] = "\n";
        tokens[26] = "nop";
        tokens[27] = "\n";
        tokens[28] = "\n";
        tokens[29] = "label2";
        tokens[30] = ":";
        tokens[31] = "nop";
        tokens[32] = "\n";
        tokens[33] = "ld";
        tokens[34] = "b";
        tokens[35] = ",";
        tokens[36] = "label2";
        tokens[37] = "\n";
        tokens[38] = "label3";
        tokens[39] = ":";
        tokens[40] = "nop";
        tokens[41] = "\n";
        tokens[42] = "ld";
        tokens[43] = "[";
        tokens[44] = "hl";
        tokens[45] = "+";
        tokens[46] = "]";
        tokens[47] = ",";
        tokens[48] = "a";
        tokens[49] = "\n";
        tokens[50] = "ld";
        tokens[51] = "[";
        tokens[52] = "hl";
        tokens[53] = "-";
        tokens[54] = "]";
        tokens[55] = ",";
        tokens[56] = "a";
        tokens[57] = "\n";
        tokens[58] = "ld";
        tokens[59] = "[";
        tokens[60] = "hl";
        tokens[61] = "]";
        tokens[62] = ",";
        tokens[63] = "sp";
        tokens[64] = "+";
        tokens[65] = "$10";
        tokens[66] = "\n";
    };

    int i = 0;
    char *tok = NULL;
    do {
        tok = next_token(f);
        if (tok) {
            TEST_ASSERT_LESS_THAN(67, i);
            TEST_ASSERT_EQUAL_STRING(tokens[i++], tok);
        }
    } while (tok != NULL);
    TEST_ASSERT_EQUAL_INT(67, i);
    free(tokens);
}

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_get_each_token);
    return UNITY_END();
}
