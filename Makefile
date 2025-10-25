CC      = gcc
LEX     = /opt/homebrew/opt/flex/bin/flex
YACC    = /opt/homebrew/opt/bison/bin/bison
CFLAGS  = -Wall -Wextra -O2
LDFLAGS =

all: cashflow

cashflow: bison.tab.o lex.yy.o
	$(CC) $(CFLAGS) -o $@ bison.tab.o lex.yy.o $(LDFLAGS)

bison.tab.c bison.tab.h: bison.y
	$(YACC) -d -o bison.tab.c bison.y

lex.yy.c: flex.l bison.tab.h
	$(LEX) -o lex.yy.c flex.l

clean:
	rm -f cashflow *.o *.tab.* lex.yy.c

.PHONY: all clean
