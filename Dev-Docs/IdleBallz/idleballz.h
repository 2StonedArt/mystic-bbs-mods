#ifndef IDLEBALLZ_H_INCLUDED
#define IDLEBALLZ_H_INCLUDED

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include "OpenDoor.h"
#include "version.h"

unsigned long int score=100;
int upgrade=10;

#define PROGRAM_NAME "IdleBallz"

#define BOARD_WIDTH 61
#define BOARD_HEIGHT 21

void add_player_idx(void);
int get_player_idx(void);
int get_total_idx(void);
int load_player(void);
//void bubble_sort(struct PlyrRec list[80], int s);
//int scan_for_player(char *username, struct PlyrRec *Plyr);
void SavePlyr(void);
void gameExit(int erorlevel);

struct PlyrRec {
    int Index;
    char Name[32];
    float time;
}Plyr;

struct balls {
    int active;
    int x;
    int y;
    int up;
    int down;
    int left;
    int right;
    int price;
};

char PlyrFile[15]="player.dat";
char PlyrIdxFile[15]="player.idx";
char PlyrScoreFile[15]="player.txt";

#endif // IDLEBALLZ_H_INCLUDED
