# These are the production settings
CC=gcc -O2 -s -Wall
STRIP=strip
LIBS=-lncurses

# I use these to debug
# CC=g++ -g -O0
# STRIP=ls
# LIBS=-lncurses_g

all:	ansi

ansi:	cleanansi
	$(CC) -o ansi ansi.c $(LIBS)
	$(STRIP) ansi

cleanansi:	
	rm -f ansi

clean:	cleanansi
	rm -f *~
	rm -f *.swp
