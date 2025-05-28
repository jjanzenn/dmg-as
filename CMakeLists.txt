cmake_minimum_required(VERSION 3.15)
project(dmg-as C)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(BISON)
find_package(FLEX)

bison_target(dmgParser parser/dmg.y ${CMAKE_CURRENT_BINARY_DIR}/dmg.tab.c
  DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/dmg.tab.h)
flex_target(dmgLexer parser/dmg.l ${CMAKE_CURRENT_BINARY_DIR}/dmg.lex.c)
add_flex_bison_dependency(dmgLexer dmgParser)

include_directories(${CMAKE_CURRENT_BINARY_DIR} include/)

add_executable(${PROJECT_NAME}
  ${BISON_dmgParser_OUTPUTS}
  ${FLEX_dmgLexer_OUTPUTS}
)
target_link_libraries(${PROJECT_NAME}
  ${FLEX_LIBRARIES}
)
