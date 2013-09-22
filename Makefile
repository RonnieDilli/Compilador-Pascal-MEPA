CC=gcc
CCDEBUG=gcc -g
PROG=compilador

default	:	$(PROG)

$(PROG)	: lex.yy.c y.tab.c $(PROG).o $(PROG).h
	$(CC) lex.yy.c $(PROG).tab.c $(PROG).o tabelasimb.c pilha.c -o $@ -ll -ly -lc

lex.yy.c	: $(PROG).l $(PROG).h
	flex $(PROG).l

y.tab.c	: $(PROG).y $(PROG).h
	bison $(PROG).y -d -v

$(PROG).o : $(PROG).h $(PROG)F.c
	$(CC) -c $(PROG)F.c -o $@

clean :
	rm -f $(PROG).tab.* lex.yy.c *.o $(PROG) $(PROG).output
