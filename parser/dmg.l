%{
#include <stdlib.h>
#include <string.h>

#include "dmg.tab.h"

extern YYSTYPE yylval;
%}

%%

LD { return LD; }
LDH { return LDH; }
ADC { return ADC; }
ADD { return ADD; }
CP { return CP; }
DEC { return DEC; }
INC { return INC; }
SBC { return SBC; }
SUB { return SUB; }
AND { return AND; }
CPL { return CPL; }
OR { return OR; }
XOR { return XOR; }
BIT { return BIT; }
RES { return RES; }
SET { return SET; }
RL { return RL; }
RLA { return RLA; }
RLC { return RLC; }
RLCA { return RLCA; }
RR { return RR; }
RRA { return RRA; }
RRC { return RRC; }
RRCA { return RRCA; }
SLA { return SLA; }
SRA { return SRA; }
SRL { return SRL; }
SWAP { return SWAP; }
CALL { return CALL; }
JP { return JP; }
JR { return JR; }
RET { return RET; }
RETI { return RETI; }
RST { return RST; }
CCF { return CCF; }
SCF { return SCF; }
POP { return POP; }
PUSH { return PUSH; }
DI { return DI; }
EI { return EI; }
HALT { return HALT; }
DAA { return DAA; }
NOP { return NOP; }
STOP { return STOP; }

BC { return BC; }
DE { return DE; }
HL { return HL; }
SP { return SP; }
AF { return AF; }
A { return A; }
B { return B; }
C { return C; }
D { return D; }
E { return E; }
H { return H; }
L { return L; }
NC { return NC; }
Z { return Z; }
NZ { return NZ; }

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str = calloc(yyleng + 1, 1);
    if (!yylval.str) return SYMBOL;
    memcpy(yylval.str, yytext, yyleng);
    return SYMBOL;
}

'$'[0-9a-fA-F]+ {
    yylval.num = strtol(&yytext[1], NULL, 16);
    return NUM;
}

[0-9]+ {
    yylval.num = strtol(yytext, NULL, 10);
    return NUM;
}

';' {
    int c = input();
    while (c != EOF && c != '\n' && c != '\r')
        c = input();
    unput(c);
    continue;
}

[ \t\f]* { continue; }
\n|\r\n { return NEWLINE; }
. { return *yytext; }
