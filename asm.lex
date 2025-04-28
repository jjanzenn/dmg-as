%{
#include <stdint.h>
#include <stdio.h>
#include <stddef.h>
#include <ctype.h>
#include "dict.h"

#define BASE_INDEX 0x0100

uint16_t curr_line = 0;
uint8_t ROM[0x8000];
dict_t *dict;

void set_next_byte(uint8_t byte);
%}

%%

[ \n\t]                                        /* do nothing */
;                                              {
                                                   int c = input();
                                                   while (c != '\n' && c != EOF)
                                                       c = input();
                                               }

NOP(\n|[ \t;].*\n)                             set_next_byte(0x00);
RLCA(\n|[ \t;].*\n)                            set_next_byte(0x07);
RRCA(\n|[ \t;].*\n)                            set_next_byte(0x0F);
STOP(\n|[ \t;].*\n)                            set_next_byte(0x10); set_next_byte(0x00);
RLA(\n|[ \t;].*\n)                             set_next_byte(0x17);
RRA(\n|[ \t;].*\n)                             set_next_byte(0x1F);
DAA(\n|[ \t;].*\n)                             set_next_byte(0x27);
CPL(\n|[ \t;].*\n)                             set_next_byte(0x2F);
SCF(\n|[ \t;].*\n)                             set_next_byte(0x37);
CCF(\n|[ \t;].*\n)                             set_next_byte(0x3F);
HALT(\n|[ \t;].*\n)                            set_next_byte(0x76);
RETI(\n|[ \t;].*\n)                            set_next_byte(0xD9);
DI(\n|[ \t;].*\n)                              set_next_byte(0xF3);
EI(\n|[ \t;].*\n)                              set_next_byte(0xFB);

LD[ \t]+"(BC)"[ \t]*,[ \t]*A(\n|[ \t;].*\n)    set_next_byte(0x02);
LD[ \t]+"(DE)"[ \t]*,[ \t]*A(\n|[ \t;].*\n)    set_next_byte(0x12);
LD[ \t]+"(HL+)"[ \t]*,[ \t]*A(\n|[ \t;].*\n)   set_next_byte(0x22);
LD[ \t]+"(HL-)"[ \t]*,[ \t]*A(\n|[ \t;].*\n)   set_next_byte(0x32);

LD[ \t]+A[ \t]*,[ \t]*"(BC)"(\n|[ \t;].*\n)    set_next_byte(0x0A);
LD[ \t]+A[ \t]*,[ \t]*"(DE)"(\n|[ \t;].*\n)    set_next_byte(0x1A);
LD[ \t]+A[ \t]*,[ \t]*"(HL+)"(\n|[ \t;].*\n)   set_next_byte(0x2A);
LD[ \t]+A[ \t]*,[ \t]*"(HL-)"(\n|[ \t;].*\n)   set_next_byte(0x3A);

INC[ \t]+BC(\n|[ \t;].*\n)                     set_next_byte(0x03);
INC[ \t]+DE(\n|[ \t;].*\n)                     set_next_byte(0x13);
INC[ \t]+HL(\n|[ \t;].*\n)                     set_next_byte(0x23);
INC[ \t]+SP(\n|[ \t;].*\n)                     set_next_byte(0x33);

INC[ \t]+B(\n|[ \t;].*\n)                      set_next_byte(0x04);
INC[ \t]+D(\n|[ \t;].*\n)                      set_next_byte(0x14);
INC[ \t]+H(\n|[ \t;].*\n)                      set_next_byte(0x24);
INC[ \t]+"(HL)"(\n|[ \t;].*\n)                 set_next_byte(0x34);

DEC[ \t]+B(\n|[ \t;].*\n)                      set_next_byte(0x05);
DEC[ \t]+D(\n|[ \t;].*\n)                      set_next_byte(0x15);
DEC[ \t]+H(\n|[ \t;].*\n)                      set_next_byte(0x25);
DEC[ \t]+"(HL)"(\n|[ \t;].*\n)                 set_next_byte(0x35);

ADD[ \t]+BC(\n|[ \t;].*\n)                     set_next_byte(0x09);
ADD[ \t]+DE(\n|[ \t;].*\n)                     set_next_byte(0x19);
ADD[ \t]+HL(\n|[ \t;].*\n)                     set_next_byte(0x29);
ADD[ \t]+SP(\n|[ \t;].*\n)                     set_next_byte(0x39);

DEC[ \t]+BC(\n|[ \t;].*\n)                     set_next_byte(0x0B);
DEC[ \t]+DE(\n|[ \t;].*\n)                     set_next_byte(0x1B);
DEC[ \t]+HL(\n|[ \t;].*\n)                     set_next_byte(0x2B);
DEC[ \t]+SP(\n|[ \t;].*\n)                     set_next_byte(0x3B);

INC[ \t]+C(\n|[ \t;].*\n)                      set_next_byte(0x0C);
INC[ \t]+E(\n|[ \t;].*\n)                      set_next_byte(0x1C);
INC[ \t]+L(\n|[ \t;].*\n)                      set_next_byte(0x2C);
INC[ \t]+A(\n|[ \t;].*\n)                      set_next_byte(0x3C);

DEC[ \t]+C(\n|[ \t;].*\n)                      set_next_byte(0x0D);
DEC[ \t]+E(\n|[ \t;].*\n)                      set_next_byte(0x1D);
DEC[ \t]+L(\n|[ \t;].*\n)                      set_next_byte(0x2D);
DEC[ \t]+A(\n|[ \t;].*\n)                      set_next_byte(0x3D);

[A-Za-z_][A-Za-z0-9_]*:                        {
                                                   size_t text_length = strlen(yytext) - 1;
                                                   uint16_t *data = malloc(sizeof(uint16_t));
                                                   *data = curr_line;
                                                   char *key = malloc(text_length + 1);
                                                   for (int i = 0; i < text_length; ++i) {
                                                       key[i] = tolower(yytext[i]);
                                                   }
                                                   key[text_length] = 0;
                                                   dict_put(dict, key, text_length, data);
                                               }
.                                              {
                                                   printf("Syntax error: ");
                                                   int c = yytext[0];
                                                   while (c != '\n' && c != EOF) {
                                                       putchar(c);
                                                       c = input();
                                                   }
                                                   putchar('\n');
                                               }

%%

void set_next_byte(uint8_t byte)
{
    ROM[BASE_INDEX+curr_line] = byte;
    curr_line++;
}

int main(void)
{
    dict = dict_init();
    if (yylex() != 1) {
        FILE *fp = fopen("out.gb", "wb");
        fwrite(ROM, 0x8000, 1, fp);
        fclose(fp);
    }

    dict_deinit(dict);

    return 0;
}
