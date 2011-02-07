YFLAGS        = -d
PROGRAM       = calc
OBJS          = calc.tab.o lex.yy.o
SRCS          = calc.tab.c lex.yy.c
CC            = gcc 
all:	$(PROGRAM)
.c.o:	$(SRCS)
	$(CC) -c $*.c -o $@ -O
calc.tab.c: calc.y
	bison $(YFLAGS) calc.y
lex.yy.c: calc.lex
	flex calc.lex
calc:	$(OBJS)
	$(CC) $(OBJS)  -o $@ -lfl -lm
clean:
	rm -f $(OBJS) core *~ \#* *.o $(PROGRAM) y.* lex.yy.* calc.tab.*
