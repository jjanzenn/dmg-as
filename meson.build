project('dmg-as', 'c', default_options : 'default_library=static')

executable('dmg-as', 'main.c')

unity_dep = dependency('unity', version : '2.6.0')

dict_test = executable('dict_test', 'test/dict.c', 'dict.c', 'hash.c', dependencies : [unity_dep])
test('dictionary works', dict_test)