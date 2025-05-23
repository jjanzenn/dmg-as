dmg: dmg.tab.o dmg.lex.o
	$(CC) -o $@ dmg.tab.o dmg.lex.o -ly -lfl

dmg.tab.h dmg.tab.c: dmg.y
	bison -d -b dmg $?

dmg.lex.o: dmg.tab.h dmg.lex.c

dmg.lex.c: dmg.l
	$(LEX) -t $? > $@

clean:
	rm -f dmg.lex.c dmg.tab.c dmg.tab.h dmg.tab.o dmg.lex.o
