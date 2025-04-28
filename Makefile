CFLAGS="-O2"

all: dmg-as

dmg-as: lex.yy.c dict.o
	${CC} ${CFLAGS} $^ -o $@ -ll

dict.o: dict.c
	${CC} ${CFLAGS} -c $^ -o $@

lex.yy.c: asm.lex
	lex -i $^

clean:
	rm -f dict.o dmg-as lex.yy.c out.gb
