# These are the production settings
#CC=gcc -O0 -s -Wall
#CC=g++ -O2 -s
#STRIP=strip
LIBS=-lncurses

# I use these to debug
CC=g++ -g -O0
STRIP=ls
#LIBS=-lncurses_g

all:	ansiview

ansiview:	cleanansiview
	$(CC) -o ansiview ansiview.c $(LIBS)
	$(STRIP) ansiview

cleanansiview:	
	rm -f ansiview

clean:	cleanansiview
	rm -f *~
	rm -f *.swp
