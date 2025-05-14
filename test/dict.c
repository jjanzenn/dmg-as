#include "dict.h"
#include "unity.h"
#include <stdint.h>
#include <stdio.h>

dict *d;

void setUp(void) { d = dict_init(); }

void tearDown(void) { dict_deinit(d); }

void test_basic_insert_and_get_data(void)
{
    char *key = "key";
    uint16_t data = 0xABCD;

    uint16_t *newdata = dict_get(d, key);
    TEST_ASSERT_NULL_MESSAGE(newdata, "Expected to not receive any data");
    dict_insert(d, key, data);
    newdata = dict_get(d, key);
    TEST_ASSERT_NOT_NULL(newdata);
    TEST_ASSERT_EQUAL_UINT16(data, *newdata);
}

void test_reinsertion_replaces_old_value(void)
{
    char *key = "key";
    uint16_t data1 = 123;
    uint16_t data2 = 456;

    TEST_ASSERT_EQUAL_UINT(0, d->size);

    uint16_t *newdata = dict_get(d, key);
    dict_insert(d, key, data1);
    newdata = dict_get(d, key);
    TEST_ASSERT_NOT_NULL(newdata);
    TEST_ASSERT_EQUAL_UINT16(data1, *newdata);
    TEST_ASSERT_EQUAL_UINT(1, d->size);

    dict_insert(d, key, data2);
    newdata = dict_get(d, key);
    TEST_ASSERT_NOT_NULL(newdata);
    TEST_ASSERT_EQUAL_UINT(1, d->size);
    TEST_ASSERT_EQUAL_UINT16(data2, *newdata);
}

void test_rehash_when_past_load_factor(void)
{
    char keys[1024][1025];
    for (int i = 0; i < 1024; ++i) {
        for (int j = 0; j < 1024; ++j) {
            keys[i][j] = 'a';
        }
        keys[i][i] = 'b';
        keys[i][1024] = 0;
    }

    TEST_ASSERT_EQUAL_UINT(0, d->size);

    for (int i = 0; i < 1024; ++i) {
        dict_insert(d, keys[i], i);
        TEST_ASSERT_EQUAL_UINT(i + 1, d->size);
    }
    TEST_ASSERT_EQUAL_UINT(2048, d->capacity);

    uint16_t *newdata = NULL;
    for (uint16_t i = 0; i < 1024; ++i) {
        newdata = dict_get(d, keys[i]);
        TEST_ASSERT_NOT_NULL(newdata);
        TEST_ASSERT_EQUAL_UINT16(i, *newdata);
    }
}

// not needed when using generate_test_runner.rb
int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_basic_insert_and_get_data);
    RUN_TEST(test_reinsertion_replaces_old_value);
    RUN_TEST(test_rehash_when_past_load_factor);
    return UNITY_END();
}
