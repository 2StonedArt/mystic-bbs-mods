#ifndef SLOTMACHINE_H_INCLUDED
#define SLOTMACHINE_H_INCLUDED

#define PROGRAM_NAME "Crazy Eights Slot Machine"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <fcntl.h>
#if !defined(_MSC_VER) && !defined(WIN32)
#include <unistd.h>
#endif
#include <time.h>
#include <ctype.h>
#include "numbers.h"
#include "OpenDoor.h"
#include "version.h"

struct PlyrRec {
    int Index;
    char Name[32];
    int Score;
};

struct PlyrRec Plyr;
char PlyrFile[15]="player.dat";
void slot(int* ax, int* bx, int* cx, int* dx);
void slotPrint(int sum, int bet, int s1, int s2, int s3, int s4, int winPrint);
int bidMaker(int sumT);
int slotWinning(int s1, int s2, int s3, int s4, int betA, int* winSum);
int sumStart(void);
char* goldconvert(int x);
int findtotaldigits(unsigned long int no);
void insert_substring(char *a, char *b, int position);
char *substring(char *string, int position, int length);
void gameExit(int errorlevel);
void add_player_idx();
int get_player_idx();
int load_player();
int scan_for_player(char *username, struct PlyrRec *Plyr);
void SavePlyr();
void SaveUser();
int get_total_idx();
void centerText(char *text, int fieldWidth);
void bubble_sort(struct PlyrRec list[80], int s);

char comma[20];

#endif // SLOTMACHINE_H_INCLUDED
