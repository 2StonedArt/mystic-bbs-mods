// TODO (dan#1#): Add user database to store scores

#include "idleballz.h"

struct balls ball[9];
struct PlyrRec Plyr;
double temptime;

void title(void)
{
    int i;
    od_clr_scr();
    od_set_cursor(10,25);
    od_printf("%s v%s %s",PROGRAM_NAME,FULLVERSION_STRING,STATUS);
    od_set_cursor(1,1);
    od_printf("Idle Ballz is now loading");
    for (i=0;i<10;i++)
    {
        od_sleep(500);
        od_printf(".");
    }
    od_clr_scr();
    od_set_cursor(5,5);
    od_printf("In this game, you will get points each time one of the ballz hits");
    od_set_cursor(7,5);
    od_printf("the wall. How fast can you get to 1 million points?");
    od_set_cursor(21,1);
    od_get_key(TRUE);
    od_clr_scr();
}

int drawboard(void)
{
    int i;
    int j;

    for (i=1;i<BOARD_HEIGHT;i++)
    {
        od_set_cursor(i,1);
        od_printf("`blue`X");
        od_set_cursor(i,BOARD_WIDTH);
        od_printf("`blue`X");
    }

    for (j=1;j<BOARD_WIDTH;j++)
    {
        od_set_cursor(1,j);
        od_printf("`blue`X");
        od_set_cursor(BOARD_HEIGHT,j);
        od_printf("`blue`X");
    }
    od_set_cursor(BOARD_HEIGHT,BOARD_WIDTH);
    od_printf("X`white`");
    return 0;
}

void init(void)
{
    ball[1].active=1;
    ball[1].x=BOARD_HEIGHT/2;
    ball[1].y=BOARD_WIDTH/2;
    ball[1].up=1;
    ball[1].down=0;
    ball[1].right=1;
    ball[1].left=0;
    ball[1].price=0;
    ball[2].active=0;
    ball[2].x=BOARD_HEIGHT/2;
    ball[2].y=BOARD_WIDTH/2;
    ball[2].up=0;
    ball[2].down=1;
    ball[2].right=0;
    ball[2].left=1;
    ball[2].price=50;
    ball[3].active=0;
    ball[3].x=BOARD_HEIGHT/2;
    ball[3].y=BOARD_WIDTH/2;
    ball[3].up=0;
    ball[3].down=1;
    ball[3].right=0;
    ball[3].left=1;
    ball[3].price=100;
    ball[4].active=0;
    ball[4].x=BOARD_HEIGHT/2;
    ball[4].y=BOARD_WIDTH/2;
    ball[4].up=1;
    ball[4].down=0;
    ball[4].right=0;
    ball[4].left=1;
    ball[4].price=1000;
    ball[5].active=0;
    ball[5].x=BOARD_HEIGHT/2;
    ball[5].y=BOARD_WIDTH/2;
    ball[5].up=1;
    ball[5].down=0;
    ball[5].right=1;
    ball[5].left=0;
    ball[5].price=5000;
    ball[6].active=0;
    ball[6].x=BOARD_HEIGHT/2;
    ball[6].y=BOARD_WIDTH/2;
    ball[6].up=1;
    ball[6].down=0;
    ball[6].right=0;
    ball[6].left=1;
    ball[6].price=10000;
    ball[7].active=0;
    ball[7].x=BOARD_HEIGHT/2;
    ball[7].y=BOARD_WIDTH/2;
    ball[7].up=0;
    ball[7].down=1;
    ball[7].right=1;
    ball[7].left=0;
    ball[7].price=50000;
    ball[8].active=0;
    ball[8].x=BOARD_HEIGHT/2;
    ball[8].y=BOARD_WIDTH/2;
    ball[8].up=0;
    ball[8].down=1;
    ball[8].right=0;
    ball[8].left=1;
    ball[8].price=500000;
    time_t begin,end;
}

void game(void)
{
    int quit=0;
    init();
    char ch;
    int sleeptimer=1000;
    score=0;
    int activeball=1;
    title();
    drawboard();
    od_set_cursor(ball[1].x,ball[1].y);
    od_printf("`bright red`*");
    od_clear_keybuffer();
    time_t begin=time(NULL);
    while (!quit)
    {
        od_sleep(sleeptimer);
        od_set_cursor(ball[1].x,ball[1].y);
        od_printf(" ");
        od_set_cursor(ball[2].x,ball[2].y);
        od_printf(" ");
        od_set_cursor(ball[3].x,ball[3].y);
        od_printf(" ");
        od_set_cursor(ball[4].x,ball[4].y);
        od_printf(" ");
        od_set_cursor(ball[5].x,ball[5].y);
        od_printf(" ");
        od_set_cursor(ball[6].x,ball[6].y);
        od_printf(" ");
        od_set_cursor(ball[7].x,ball[7].y);
        od_printf(" ");
        od_set_cursor(ball[8].x,ball[8].y);
        od_printf(" ");
        if (ball[1].up) ball[1].x+=2;
        if (ball[1].down) ball[1].x-=2;
        if (ball[1].right) ball[1].y+=2;
        if (ball[1].left) ball[1].y-=2;
        if (ball[2].active==1)
        {
            if (ball[2].up) ball[2].x+=2;
            if (ball[2].down) ball[2].x-=2;
            if (ball[2].right) ball[2].y+=2;
            if (ball[2].left) ball[2].y-=2;
        }
        if (ball[3].active==1)
        {
            if (ball[3].up) ball[3].x+=2;
            if (ball[3].down) ball[3].x-=2;
            if (ball[3].right) ball[3].y+=2;
            if (ball[3].left) ball[3].y-=2;
        }
        if (ball[4].active==1)
        {
            if (ball[4].up) ball[4].x+=2;
            if (ball[4].down) ball[4].x-=2;
            if (ball[4].right) ball[4].y+=2;
            if (ball[4].left) ball[4].y-=2;
        }
        if (ball[5].active==1)
        {
            if (ball[5].up) ball[5].x+=1;
            if (ball[5].down) ball[5].x-=1;
            if (ball[5].right) ball[5].y+=1;
            if (ball[5].left) ball[5].y-=1;
        }
        if (ball[6].active==1)
        {
            if (ball[6].up) ball[6].x+=1;
            if (ball[6].down) ball[6].x-=1;
            if (ball[6].right) ball[6].y+=1;
            if (ball[6].left) ball[6].y-=1;
        }
        if (ball[7].active==1)
        {
            if (ball[7].up) ball[7].x+=1;
            if (ball[7].down) ball[7].x-=1;
            if (ball[7].right) ball[7].y+=1;
            if (ball[7].left) ball[7].y-=1;
        }
        if (ball[8].active==1)
        {
            if (ball[8].up) ball[8].x+=1;
            if (ball[8].down) ball[8].x-=1;
            if (ball[8].right) ball[8].y+=1;
            if (ball[8].left) ball[8].y-=1;
        }
        if (ball[1].x==2) {ball[1].up=1; ball[1].down=0; score+=10;}
        if (ball[1].y==2) {ball[1].left=0; ball[1].right=1; score+=10;}
        if (ball[1].x>=BOARD_HEIGHT-1) {ball[1].up=0; ball[1].down=1; score+=10;}
        if (ball[1].y>=BOARD_WIDTH-1) {ball[1].left=1; ball[1].right=0; score+=10;}

        if (ball[2].active==1) {
            if (ball[2].x==2) {ball[2].up=1; ball[2].down=0; score+=25;}
            if (ball[2].y==2) {ball[2].left=0; ball[2].right=1; score+=25;}
            if (ball[2].x>=BOARD_HEIGHT-1) {ball[2].up=0; ball[2].down=1; score+=25;}
            if (ball[2].y>=BOARD_WIDTH-1) {ball[2].left=1; ball[2].right=0; score+=25;}
            if (ball[1].x==ball[2].x && ball[1].y==ball[2].y) {score+=50;}
        }
        if (ball[3].active==1) {
            if (ball[3].x==2) {ball[3].up=1; ball[3].down=0; score+=50;}
            if (ball[3].y==2) {ball[3].left=0; ball[3].right=1; score+=50;}
            if (ball[3].x>=BOARD_HEIGHT-1) {ball[3].up=0; ball[3].down=1; score+=50;}
            if (ball[3].y>=BOARD_WIDTH-1) {ball[3].left=1; ball[3].right=0; score+=50;}
            if ((ball[1].x==ball[3].x && ball[1].y==ball[3].y) || (ball[2].x==ball[3].x && ball[2].y==ball[3].y)) {score+=100;}
        }
        if (ball[4].active==1)
        {
            if (ball[4].x==2) {ball[4].up=1; ball[4].down=0; score+=100;}
            if (ball[4].y==2) {ball[4].left=0; ball[4].right=1; score+=100;}
            if (ball[4].x>=BOARD_HEIGHT-1) {ball[4].up=0; ball[4].down=1; score+=100;}
            if (ball[4].y>=BOARD_WIDTH-1) {ball[4].left=1; ball[4].right=0; score+=100;}
            if ((ball[1].x==ball[4].x && ball[1].y==ball[4].y) || (ball[2].x==ball[4].x && ball[2].y==ball[4].y) || (ball[3].x==ball[4].x && ball[3].y==ball[4].y)) {score+=500;}
        }
        if (ball[5].active==1)
        {
            if (ball[5].x==2) {ball[5].up=1; ball[5].down=0; score+=500;}
            if (ball[5].y==2) {ball[5].left=0; ball[5].right=1; score+=500;}
            if (ball[5].x>=BOARD_HEIGHT-1) {ball[5].up=0; ball[5].down=1; score+=500;}
            if (ball[5].y>=BOARD_WIDTH-1) {ball[5].left=1; ball[5].right=0; score+=500;}
            if ((ball[1].x==ball[5].x && ball[1].y==ball[5].y) || (ball[2].x==ball[5].x && ball[2].y==ball[5].y) || (ball[3].x==ball[5].x && ball[3].y==ball[5].y) || (ball[4].x==ball[5].x && ball[4].y==ball[5].y)) {score+=1000;}
        }
        if (ball[6].active==1)
        {
            if (ball[6].x==2) {ball[6].up=1; ball[6].down=0; score+=750;}
            if (ball[6].y==2) {ball[6].left=0; ball[6].right=1; score+=750;}
            if (ball[6].x>=BOARD_HEIGHT-1) {ball[6].up=0; ball[6].down=1; score+=750;}
            if (ball[6].y>=BOARD_WIDTH-1) {ball[6].left=1; ball[6].right=0; score+=750;}
            if ((ball[1].x==ball[6].x && ball[1].y==ball[6].y) || (ball[2].x==ball[6].x && ball[2].y==ball[6].y) || (ball[3].x==ball[6].x && ball[3].y==ball[6].y) || (ball[4].x==ball[6].x && ball[4].y==ball[6].y) || (ball[5].x==ball[6].x && ball[5].y==ball[6].y)) {score+=2000;}
        }
        if (ball[7].active==1)
        {
            if (ball[7].x==2) {ball[7].up=1; ball[7].down=0; score+=1000;}
            if (ball[7].y==2) {ball[7].left=0; ball[7].right=1; score+=1000;}
            if (ball[7].x>=BOARD_HEIGHT-1) {ball[7].up=0; ball[7].down=1; score+=1000;}
            if (ball[7].y>=BOARD_WIDTH-1) {ball[7].left=1; ball[7].right=0; score+=1000;}
            if ((ball[1].x==ball[7].x && ball[1].y==ball[7].y) || (ball[2].x==ball[7].x && ball[2].y==ball[7].y) || (ball[3].x==ball[7].x && ball[3].y==ball[7].y) || (ball[4].x==ball[7].x && ball[4].y==ball[7].y) || (ball[5].x==ball[7].x && ball[5].y==ball[7].y) || (ball[6].x==ball[7].x && ball[6].y==ball[7].y)) {score+=5000;}
        }
        if (ball[8].active==1)
        {
            if (ball[8].x==2) {ball[8].up=1; ball[8].down=0; score+=5000;}
            if (ball[8].y==2) {ball[8].left=0; ball[8].right=1; score+=5000;}
            if (ball[8].x>=BOARD_HEIGHT-1) {ball[8].up=0; ball[8].down=1; score+=5000;}
            if (ball[8].y>=BOARD_WIDTH-1) {ball[8].left=1; ball[8].right=0; score+=5000;}
            if ((ball[1].x==ball[8].x && ball[1].y==ball[8].y) || (ball[2].x==ball[8].x && ball[2].y==ball[8].y) || (ball[3].x==ball[8].x && ball[3].y==ball[8].y) || (ball[4].x==ball[8].x && ball[4].y==ball[8].y) || (ball[5].x==ball[8].x && ball[5].y==ball[8].y) || (ball[6].x==ball[8].x && ball[6].y==ball[8].y) || (ball[7].x==ball[8].x && ball[7].y==ball[8].y)) {score+=10000;}
        }
        od_set_cursor(ball[1].x,ball[1].y);
        od_printf("`bright red`*");
        od_set_cursor(ball[2].x,ball[2].y);
        if (ball[2].active==1) od_printf("`bright red`*");
        od_set_cursor(ball[3].x,ball[3].y);
        if (ball[3].active==1) od_printf("`bright red`*");
        od_set_cursor(ball[4].x,ball[4].y);
        if (ball[4].active==1) od_printf("`bright red`*");
        od_set_cursor(ball[5].x,ball[5].y);
        if (ball[5].active==1) od_printf("`bright red`*");
        od_set_cursor(ball[6].x,ball[6].y);
        if (ball[6].active==1) od_printf("`bright red`*");
        od_set_cursor(ball[7].x,ball[7].y);
        if (ball[7].active==1) od_printf("`bright red`*");
        od_set_cursor(ball[8].x,ball[8].y);
        if (ball[8].active==1) od_printf("`bright red`*");
        od_set_cursor(2,63);
        od_printf("`white`Current Score: ");
        od_set_cursor(3,63);
        od_clr_line();
        od_printf("%d",score);
        od_set_cursor(5,63);
        od_clr_line();
        od_printf("1 - Delay: %d",sleeptimer);
        od_set_cursor(6,63);
        od_printf("Cost: %d",upgrade);
        od_set_cursor(8,63);
        od_printf("2 - Buy ball %d?",activeball+1);
        od_set_cursor(9,63);
        od_printf("Cost: %d",ball[activeball+1].price);
        od_set_cursor(9,69);
        if (activeball==8) od_printf("Not yet...");
        od_set_cursor(11,63);
        od_printf("Q - Quit game");
        od_set_cursor(23,1);
        for (int x=1;x<=activeball;x++) ball[x].active=1;
        ch=od_get_key(FALSE);
        if (ch=='q' || ch=='Q' || score>=1000000) {quit=1;}
        if (ch=='1' && score>=upgrade && sleeptimer>50) {score=score-upgrade; sleeptimer=sleeptimer-20; upgrade=upgrade*1.1;}
        if (ch=='2' && score>=ball[2].price && ball[2].active==0 && ball[1].active==1) {score-=ball[2].price; ball[2].active=1; activeball=2;}
        if (ch=='2' && score>=ball[3].price && ball[3].active==0 && ball[2].active==1) {score-=ball[3].price; ball[3].active=1; activeball=3;}
        if (ch=='2' && score>=ball[4].price && ball[4].active==0 && ball[3].active==1) {score-=ball[4].price; ball[4].active=1; activeball=4;}
        if (ch=='2' && score>=ball[5].price && ball[5].active==0 && ball[4].active==1) {score-=ball[5].price; ball[5].active=1; activeball=5;}
        if (ch=='2' && score>=ball[6].price && ball[6].active==0 && ball[5].active==1) {score-=ball[6].price; ball[6].active=1; activeball=6;}
        if (ch=='2' && score>=ball[7].price && ball[7].active==0 && ball[6].active==1) {score-=ball[7].price; ball[7].active=1; activeball=7;}
        if (ch=='2' && score>=ball[8].price && ball[8].active==0 && ball[7].active==1) {score-=ball[8].price; ball[8].active=1; activeball=8;}
    }
    time_t end=time(NULL);
    //od_set_cursor(22,1);
    //od_printf("%f",difftime(end,begin));
    temptime=difftime(end,begin);
    //od_get_key(TRUE);
    od_set_cursor(22,1);
}

void add_player_idx(void)
{
  FILE *fptr;

  fptr = fopen(PlyrIdxFile, "a");
  if (!fptr)
    {
      fprintf(stderr, "ERROR OPENING %s!\n",PlyrIdxFile);
      gameExit(-1);
    }
  fprintf(fptr, "%s+%s\n", od_control_get()->user_name, od_control_get()->user_handle);
  fclose(fptr);
}

int get_player_idx(void)
{
    FILE *fptr;
    char buffer[256];
    char savefile[256];
    int idx = 0;
    fptr = fopen(PlyrIdxFile, "r");

    snprintf(savefile, 255, "%s+%s", od_control_get()->user_name, od_control_get()->user_handle);

    if (fptr != NULL)
    {
        fgets(buffer, 256, fptr);
        while (!feof(fptr))
        {
            if (strncmp(buffer, savefile, strlen(savefile)) == 0)
        {
        fclose(fptr);
        return idx;
    }
    idx++;
    fgets(buffer, 256, fptr);
    }
    fclose(fptr);
  }
  return -1;
}

int get_total_idx(void)
{
    FILE *fptr;
    char buffer[256];
    int idx = 0;
    fptr = fopen(PlyrIdxFile,"r");
    if (fptr != NULL)
    {
        fgets(buffer, 256, fptr);
        while(!feof(fptr))
        {
            idx++;
            fgets(buffer, 256, fptr);
        }
        fclose(fptr);
        return idx;
    }
    return -1;
}

int load_player(void)
{
    FILE *fptr;
    Plyr.Index = get_player_idx();
    if (Plyr.Index == -1) return 0;
    fptr = fopen(PlyrFile, "rb");
    if (!fptr)
    {
        fprintf(stderr, "%s missing! please reset.\n",PlyrFile);
        od_exit(0, FALSE);
    }
    fseek(fptr, sizeof(struct PlyrRec) * Plyr.Index, SEEK_SET);
    if (fread(&Plyr, sizeof(struct PlyrRec), 1, fptr) < 1)
    {
        fclose(fptr);
        return 0;
    }
    fclose(fptr);
    return 1;
}

int scan_for_player(char *username, struct PlyrRec *Plyr)
{
    FILE *fptr;
    fptr = fopen(PlyrFile, "rb");
    if (!fptr) return 0;
    while (fread(Plyr, sizeof(struct PlyrRec), 1, fptr) == 1)
    {
    if (strcasecmp(Plyr->Name, username) == 0)
    {
        fclose(fptr);
        return 1;
    }
    }
    fclose(fptr);
    return 0;
}

void SavePlyr(void)
{
    #if defined(_MSC_VER) || defined(WIN32)
    int fno = open("PlyrFile", O_WRONLY | O_CREAT | O_BINARY, 0644);
    #else
    int fno = open(PlyrFile, O_WRONLY | O_CREAT, 0644);
    #endif // defined
    if (fno < 0) gameExit(-1);
    lseek(fno, sizeof(struct PlyrRec) * Plyr.Index, SEEK_SET);
    write(fno, &Plyr, sizeof(struct PlyrRec));
    close(fno);
}

void centerText(char *text, int fieldWidth, int printrow)  //center text on the screen
{
    od_set_cursor(printrow,1);
    od_clr_line();
    int padlen=(fieldWidth - strlen(text))/2;
    od_printf("%*s%s%*s\n\r",padlen,"",text,padlen,"");
}

void centerTextfile(char *text, int fieldWidth, FILE* name)  //center text to write to text file
{
    char x[80];
    int padlen=(fieldWidth - strlen(text))/2;
    sprintf(x,"%*s%s%*s\r\n",padlen,"",text,padlen,"");
    fprintf(name,x);
}

void bubble_sort(struct PlyrRec list[], int s)
{
    int i, j;
    struct PlyrRec temp;

    for (i = 0; i < s - 1; i++)
    {
        for (j = 0; j < (s - 1-i); j++)
        {
            if (list[j].time > list[j+1].time)
            {
                temp=list[j];
                list[j]=list[j+1];
                list[j+1]=temp;
            }
        }
    }
}

void listplayers(void) //Creates list to show of other players - Also creates ascii file with same info
{
  int x=1;
  int y=0;
  int total_records=0;
  struct PlyrRec PlyrInfo;
  struct PlyrRec Players[30];
  FILE *fptr;
  FILE *fptr2;
  char s[80];
  char v[80];
  fptr = fopen(PlyrFile,"rb");
  fptr2 = fopen(PlyrScoreFile,"w");
  if (!fptr || !fptr2) gameExit(-1);
  while (fread(&PlyrInfo, sizeof(struct PlyrRec), 1, fptr) == 1)
  {
      strcpy(Players[y].Name,PlyrInfo.Name);
      Players[y].time=PlyrInfo.time;
      y++;
  }
  od_clr_scr();
  od_printf("`blue`");
  sprintf(s,"Lowest Time per Player in %s",PROGRAM_NAME);
  centerText(s,78,1);
  sprintf(v,"Ver %s %s",FULLVERSION_STRING,STATUS);
  centerText(v,78,2);
  centerTextfile(s,78,fptr2);
  centerTextfile(v,78,fptr2);
  od_printf("\n\r -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n");
  fprintf(fptr2,"\r\n -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n");
  od_printf("  Name                                       Time\r\n");
  fprintf(fptr2,"  Name                                       Time\r\n");
  od_printf(" -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n");
  fprintf(fptr2," -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n");
  if (get_total_idx() > 15) total_records=15;
  else total_records=get_total_idx();
  if (total_records>1) bubble_sort(Players,get_total_idx());
  for (x=0;x<total_records;x++)
  {
    if (Plyr.time!=0) od_printf("`blue`  %-42s %5.2f seconds\r\n`white`",Players[x].Name,Players[x].time);
    if (Plyr.time!=0) fprintf(fptr2,"  %-42s %5.2f seconds\r\n",Players[x].Name,Players[x].time);
  }
  fclose(fptr);
  fclose(fptr2);
}

void gameExit(int errorlevel)
{
    //od_get_key(TRUE);
    if (((temptime<Plyr.time) || (Plyr.time==0)) && (score>=1000000))
    {
        Plyr.time=temptime;
        SavePlyr();
    }
    listplayers();
    od_get_key(TRUE);
    od_exit(errorlevel,FALSE);
}

#ifdef ODPLAT_WIN32
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
   LPSTR lpszCmdLine, int nCmdShow)
#else
int main(int argc, char *argv[])
#endif
{
#ifdef ODPLAT_WIN32
   /* In Windows, pass in nCmdShow value to OpenDoors. */
   od_control.od_cmd_show = nCmdShow;
#endif
#ifdef ODPLAT_WIN32
   od_parse_cmd_line(lpszCmdLine);
#else
   od_parse_cmd_line(argc, argv);
#endif
    //od_control.od_force_local=TRUE;
    od_printf("%s","\x1B[25l");
    od_clr_scr();
    strcpy(Plyr.Name,od_control_get()->user_name);
    if (!load_player())
    {
        add_player_idx();
        Plyr.Index=get_player_idx();
        SavePlyr();
    }
    game();
    gameExit(0);
    return 0;
}
