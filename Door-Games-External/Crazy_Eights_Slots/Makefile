CC=gcc
CFLAGS=-Wall
dbg = -O -g
VERSION_MAJOR:=0
VERSION_MINOR:=5
VERSION_TYPE=a

all: slotmachine

slotmachine: main.o
	$(CC) $(dbg) -o slotmachine main.o libODoors.a

main.o: main.c numbers.h
	$(CC) $(CFLAGS) $(dbg) -c main.c

.PHONY: clean help check-syntax distribution
clean:
	rm *.o slotmachine

distribution:
	mkdir -p dist
	zip dist/c8sm$(VERSION_MAJOR)$(VERSION_MINOR)$(VERSION_TYPE).zip file_id.diz libODoors.a LICENSE main.c makefile numbers.h ODoors62.dll OpenDoor.h README.md slotin.ans slotmachine.exe slots.ans sysop.txt

check-syntax:
	-$(CC) main.c $(CFLAGS) -O null -Wall libODoors.a
	-$(RM) null

help:
	@echo Make rules
	@echo all...............Builds Linux binaries
	@echo slotmachine.......Builds Linux binaries
	@echo clean.............Removes build files and binaries
	@echo check-syntax......Checks the syntax of the source files
	@echo distribution......Create Distribution archive
	@echo help..............You are reading it
