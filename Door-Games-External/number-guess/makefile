CC=gcc
CFLAGS=-Wall

all: numberguess

numberguess: main.o
	$(CC) -o numberguess main.o libODoors.a

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

clean:
	rm *.o numberguess


