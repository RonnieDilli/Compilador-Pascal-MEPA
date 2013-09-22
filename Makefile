CC=gcc
CC_DEBUG=gcc -g -DDEBUG
PROG=compilador
LEX_C=lex.yy.c
BISON_C=y.tab.c

PROG_REQ=$(LEX_C) $(BISON_C) $(PROG).o $(PROG).h
PROG_CC_PARAMS=$(LEX_C) $(PROG).tab.c $(PROG).o tabelasimb.c pilha.c -o $(PROG) -ll -ly -lc

default	:	$(PROG)

debug	:	$(PROG_REQ)
	CC='$(CC_DEBUG)'
	$(CC_DEBUG) $(PROG_CC_PARAMS)

$(PROG)	: $(PROG_REQ)
	$(CC) $(PROG_CC_PARAMS)

$(LEX_C)	: $(PROG).l $(PROG).h
	flex $(PROG).l

$(BISON_C)	: $(PROG).y $(PROG).h
	bison $(PROG).y -d -v

$(PROG).o : $(PROG).h $(PROG)F.c
	$(CC) -c $(PROG)F.c -o $@

clean :
	rm -rf $(PROG).tab.* $(LEX_C) *.o $(PROG) $(PROG).output $(PROG).dSYM
