CC=gcc
CFLAGS=-Wall

all: idleballz

idleballz: main.o
	$(CC) -o idleballz main.o libODoors.a

main.o: main.c idleballz.h
	$(CC) $(CFLAGS) -c main.c

clean:
	rm *.o idleballz


