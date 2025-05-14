project('dmg-as', 'c', default_options : 'default_library=static')

executable('dmg-as', 'main.c')

conf_data = configuration_data()
conf_data.set('version', '0.0.1')
conf_data.set('project_root', meson.project_source_root())
configure_file(input : 'config.h.in',
               output : 'config.h',
               configuration : conf_data)

unity_dep = dependency('unity', version : '2.6.0')

dict_test = executable('dict_test', 'test/dict.c', 'dict.c', 'hash.c', dependencies : [unity_dep])
test('dictionary works', dict_test)

token_test = executable('token_test', 'test/token.c', 'token.c', dependencies : [unity_dep])
test('dictionary works', token_test)
