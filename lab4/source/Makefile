LEX=lex
YACC=yacc
CC=gcc

LFLAGS=
CFLAGS=-Wall -Wno-unused-label -Wno-unused -g

all: lexer

lexer: lexer.lex.o
	$(CC) -o $@ $+

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.lex.c: %.l
	$(LEX) $(LFLAGS) -o $@ $<

%.out: %.c lexer
	./lexer < $< > $@

test: test.out
		diff test.out test_result.out

demo: demo.out
		diff demo.out demo_result.out

clean:
	$(RM) *.o
	$(RM) *.lex.c
	$(RM) test.out demo.out
	$(RM) *.log *.aux
	$(RM) lexer

.PHONY: clean all test
