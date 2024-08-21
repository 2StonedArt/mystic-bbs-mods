/*
    Crazy Eights Slot Machine door game for ANSI BBSs
    Copyright (C) 2020  Dan Richter(RCS)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

	-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    Original code written by Camron Conway - Used without permission
*/

#include "slotmachine.h"

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
    od_init();
    char action;
    int playerBet, betWinning, winType, sumTotal;
    int slot1, slot2, slot3, slot4;
    char temp[40];
    srand(time(NULL));
    od_send_file("slotin");
    od_set_cursor(17,1);
    centerText(PROGRAM_NAME,78);
    sprintf(temp,"ver %s",FULLVERSION_STRING);
    od_set_cursor(19,1);
    centerText(temp,78);
    sprintf(temp,"Compiled %s %s %s",DAY,MONTH,YEAR);
    od_set_cursor(20,1);
    centerText(temp,78);
    strncpy(Plyr.Name,od_control_get()->user_name, 32);
    if (!load_player())
    {
        add_player_idx();
        Plyr.Score=0;
        Plyr.Index=get_player_idx();
        SavePlyr();
    }
    od_get_key(TRUE);
    od_clr_scr();
    sumTotal = 1000;
    od_send_file("slots");
    od_set_cursor(20,1);
    playerBet = 0;

    while((sumTotal > 0) && (sumTotal < 1000000000))
    {
    

    od_set_cursor(20, 1);
    goldconvert(sumTotal);
    od_printf("Your current total is $%s, Your current bet is ", comma);
    goldconvert(playerBet);
    od_printf("$%s", comma);
    od_clr_line();
    od_set_cursor(21,1);
    od_printf("Press SPACE to spin, P to Place Bet or Q to Cash Out");
    od_clr_line();

    action = od_get_key(TRUE);

    od_set_cursor(22, 1);
    od_clr_line();
    od_set_cursor(23, 1);
    od_clr_line();

    if (tolower(action) == 'p') {
        playerBet = bidMaker(sumTotal);
    } else if (tolower(action) == 'q') {
        if (Plyr.Score<sumTotal) Plyr.Score=sumTotal;
        SavePlyr();
        od_printf("\r\n");
        od_printf("Cash out: $%d. ", sumTotal);
        od_printf("Hope you enjoy monopoly money.\r\n");
        od_printf("Exiting\r\n");
        gameExit(0);
    } else if (action == ' ') {
        if (playerBet == 0) {
            od_set_cursor(22, 1);
            od_printf("Place a bet first!");
            od_clr_line();
        } else if (playerBet > sumTotal) {
            od_set_cursor(22, 1);
            od_printf("You can't afford that!");
            od_clr_line();
        } else {
            sumTotal -= playerBet;
            slot(&slot1, &slot2, &slot3, &slot4);
            //slot1=slot2=slot3=slot4=7;   //testing
            //slot1=slot2;                 //testing
            //slot3=4;                     //testing
            betWinning = slotWinning(slot1, slot2, slot3, slot4, playerBet, &winType);
            sumTotal = sumTotal+betWinning;
            slotPrint(sumTotal, betWinning, slot1, slot2, slot3, slot4, winType);
        }
    }
    }
    if (sumTotal == 0)
    {
        if (Plyr.Score<sumTotal) Plyr.Score=sumTotal;
        SavePlyr();
        od_set_cursor(22,1);
        od_printf("Too bad, you ran out of money. Better luck next time.");
        od_clr_line();
        gameExit(0);
        
    }
    if (sumTotal >= 1000000000) //avoid people breaking the game because of int limitations
    {
        if (Plyr.Score<sumTotal) Plyr.Score=sumTotal;
        SavePlyr();
        od_set_cursor(21,1);
        od_printf("You broke the bank! They will need to refill the machine now.");
        od_clr_line();
        goldconvert(sumTotal);
        od_set_cursor(22,1);
        od_printf("You cashed out a total of $%s! GREAT JOB!!!",comma);
        od_clr_line();
        gameExit(0);
        
    }
}

void centerText(char *text, int fieldWidth)  //center text on the screen
{
    int padlen=(fieldWidth - strlen(text))/2;
    od_printf("%*s%s%*s\r\n",padlen,"",text,padlen,"");
}

void centerTextfile(char *text, int fieldWidth, FILE* name)  //center text to write to text file
{
    char x[80];
    int padlen=(fieldWidth - strlen(text))/2;
    sprintf(x,"%*s%s%*s\r\n",padlen,"",text,padlen,"");
    fprintf(name,x);
}

int bidMaker(int sumT)
{
    int checkBid = 0;
    int betAmount;
    char betstring[7];
    while (checkBid == 0)
        {
        od_set_cursor(22, 1);
        od_clr_line();
        od_printf("How much would you like to bet? ");
        od_input_str(betstring,6,'0','9');
        betAmount=atoi(betstring);
        od_set_cursor(22, 1);
        od_clr_line();        
        if (betAmount < 0)
            od_printf("That is an incorrect bid");
        else if (betAmount > sumT)
            {
            od_printf("Your bid is higher than what you have.");
            }
        else if (betAmount == 0)
            {
            od_printf("You've got to bid something!");
            }
        else
            {
            checkBid++;
            }
    }
    return betAmount;
}

void slot(int* ax, int* bx, int* cx, int* dx)
{
    *ax = rand()%9+1;
    *bx = rand()%9+1;
    *cx = rand()%9+1;
    *dx = rand()%9+1;
    return ;
}

void displaynumbers(int num,int x,int y)
{
    switch (num)
    {
    case 1:
        {
            od_set_cursor(x,y);
            od_printf("`white dark black`%s",number11);
            od_set_cursor(x+1,y);
            od_printf(number12);
            od_set_cursor(x+2,y);
            od_printf(number13);
            od_set_cursor(x+3,y);
            od_printf(number14);
            od_set_cursor(x+4,y);
            od_printf("%s`white dark black`",number15);
            break;
        }
    case 2:
        {
            od_set_cursor(x,y);
            od_printf("`white dark black`%s",number21);
            od_set_cursor(x+1,y);
            od_printf(number22);
            od_set_cursor(x+2,y);
            od_printf(number23);
            od_set_cursor(x+3,y);
            od_printf(number24);
            od_set_cursor(x+4,y);
            od_printf("%s`white dark black`",number25);
            break;
        }
    case 3:
        {
            od_set_cursor(x,y);
            od_printf("`green dark black`%s",number31);
            od_set_cursor(x+1,y);
            od_printf(number32);
            od_set_cursor(x+2,y);
            od_printf(number33);
            od_set_cursor(x+3,y);
            od_printf(number34);
            od_set_cursor(x+4,y);
            od_printf("%s`white dark black`",number35);
            break;
        }
    case 4:
        {
            od_set_cursor(x,y);
            od_printf("`white dark black`%s",number41);
            od_set_cursor(x+1,y);
            od_printf(number42);
            od_set_cursor(x+2,y);
            od_printf(number43);
            od_set_cursor(x+3,y);
            od_printf(number44);
            od_set_cursor(x+4,y);
            od_printf("%s`white dark black`",number45);
            break;
        }
    case 5:
        {
            od_set_cursor(x,y);
            od_printf("`white dark black`%s",number51);
            od_set_cursor(x+1,y);
            od_printf(number52);
            od_set_cursor(x+2,y);
            od_printf(number53);
            od_set_cursor(x+3,y);
            od_printf(number54);
            od_set_cursor(x+4,y);
            od_printf("%s`white dark black`",number55);
            break;
        }
    case 6:
        {
            od_set_cursor(x,y);
            od_printf("`white dark black`%s",number61);
            od_set_cursor(x+1,y);
            od_printf(number62);
            od_set_cursor(x+2,y);
            od_printf(number63);
            od_set_cursor(x+3,y);
            od_printf(number64);
            od_set_cursor(x+4,y);
            od_printf("%s`white dark black`",number65);
            break;
        }
    case 7:
        {
            od_set_cursor(x,y);
            od_printf("`white dark black`%s",number71);
            od_set_cursor(x+1,y);
            od_printf(number72);
            od_set_cursor(x+2,y);
            od_printf(number73);
            od_set_cursor(x+3,y);
            od_printf(number74);
            od_set_cursor(x+4,y);
            od_printf("%s`white dark black`",number75);
            break;
        }
    case 8:
        {
            od_set_cursor(x,y);
            od_printf("`bright red dark black`%s",number81);
            od_set_cursor(x+1,y);
            od_printf(number82);
            od_set_cursor(x+2,y);
            od_printf(number83);
            od_set_cursor(x+3,y);
            od_printf(number84);
            od_set_cursor(x+4,y);
            od_printf("%s`white dark black`",number85);
            break;
        }
    case 9:
        {
            od_set_cursor(x,y);
            od_printf("`bright blue dark black`%s",number91);
            od_set_cursor(x+1,y);
            od_printf(number92);
            od_set_cursor(x+2,y);
            od_printf(number93);
            od_set_cursor(x+3,y);
            od_printf(number94);
            od_set_cursor(x+4,y);
            od_printf("%s`white dark black`",number95);
            break;
        }
    }
}

void slotPrint(int sum, int betW, int s1, int s2, int s3, int s4, int winPrint)
{
    od_clr_scr();
    od_set_cursor(1,1);
    od_send_file("slots");
    od_set_cursor(13,33);
    od_printf("`red`%d",s1);
    od_set_cursor(13,38);
    od_printf("%d",s2);
    od_set_cursor(13,43);
    od_printf("%d",s3);
    od_set_cursor(13,48);
    od_printf("%d`white dark black`",s4);
    displaynumbers(s1,6,31);
    displaynumbers(s2,6,37);
    displaynumbers(s3,6,43);
    displaynumbers(s4,6,49);
    od_set_cursor(15,34);
    if(winPrint < 8)
        od_printf("WIN! WIN! WIN! ");
    else
        od_printf("    Sorry!     ");
    od_set_cursor(16,34);
    switch(winPrint)
    {
        case 1:
            od_printf(" Mega Jackpot!!");
            break;
        case 2:
            od_printf("  Match Four!");
            break;
        case 3:
            od_printf("   Jackpot!!");
            break;
        case 4:
            od_printf("   Two Pair!!");
            break;
        case 5:
            od_printf("  Match Three!");
            break;
        case 6:
            od_printf("  Match Two!");
            break;
        case 7:
            od_printf(" Crazy Eight!");
            break;
        case 8:
            od_printf("  Try Again!");
            break;
        default:            //should not happen
            break;
    }
    od_set_cursor(22, 1);
    od_clr_line();
    od_set_cursor(22,27);
    switch(winPrint)
    {
    case 1:
        od_printf("  MEGA JACKPOT! You win $%d", betW);
        break;
    case 2:
        od_printf("  Match Four! You win $%d", betW);
        break;
    case 3:
        od_printf("JACKPOT! Make it rain! You win $%d", betW);
        break;
    case 4:
        od_printf("   Two Pairs! You win $%d", betW);
        break;
    case 5:
        od_printf("  Match Three! You win $%d", betW);
        break;
    case 6:
        od_printf("   Match Two! You win $%d", betW);
        break;
    case 7:
        od_printf("   Crazy 8! You win $%d", betW);
        break;
    case 8:
        od_printf("Sorry, no winning combination.");
    }
    
    return ;
}

int slotWinning(int s1, int s2, int s3, int s4, int betA, int* winSum)
{
    int winAmount;
    int temp1=0;
    int temp2=0;
    if ((s1 == 8) && (s2 == 8) && (s3 == 8) && (s4 == 8))
       {
        *winSum = 1;
        winAmount = betA * 120;
       } //Mega Jackpot (four 8s)
    else if ((s1 == s2) && (s1 == s3) && (s1 == s4))
        {
        *winSum = 2;
        winAmount = betA * 100;
        } //Match 4
    else if (((s1 == 8) && (s2 == 8) && (s3 == 8)) || ((s2 == 8) && (s3 == 8) && (s4 == 8)) || ((s1 == 8) && (s3 == 8) && (s4 == 8)) || ((s1 == 8) && (s2 == 8) && (s4 == 8)))
        {
         *winSum = 3;
         winAmount = betA * 80;
        } //Three 8s
    else if (((s1 == s2) && (s1 == s3)) || ((s2 == s3) && (s2 == s4)) || ((s1 == s3) && (s1 == s4)) || ((s1 == s2) && (s1 == s4)))
        {
         *winSum = 5;
         winAmount = betA * 25;
        } //Match 3
    else if ((s1 == s2) || (s1 == s3) || (s2 == s3) || (s1 == s4) || (s2 == s4) || (s3 == s4))
        {
            if (s1 == s2) temp1=s2;
            else if (s1 == s3) temp1=s3;
            else if (s1 == s4) temp1=s4;
            else if (s2 == s3) temp1=s3;
            else if (s2 == s4) temp1=s2;
            else if (s3 == s4) temp1=s3;
            if (s4 == s3) temp2=s4;
            else if (s4 == s2) temp2=s4;
            else if (s4 == s1) temp2=s4;
            else if (s3 == s2) temp2=s3;
            else if (s3 == s1) temp2=s3;
            else if (s2 == s1) temp2=s2;
            od_set_cursor(20,1);
            od_printf("%d %d",temp1,temp2);
            if ((temp1!=0) && (temp2!=0) && (temp1 != temp2))
            {
                *winSum = 4;
                winAmount = betA * 50;
                temp1=temp2=0;
            }
            else
            {
                *winSum = 6;
                winAmount = betA *2;
            }
        } // Match 2 or Two Pair
    else if ((s1 == 8) || (s2 == 8) || (s3 == 8) || (s4 == 8))
        {
         *winSum = 7;
         winAmount = betA * 1;
        }//Crazy Eight
    else
        {
         *winSum = 8;
         winAmount = betA * 0;
        }//Bust
    return winAmount;
}

char* goldconvert(int x)
{
    sprintf(comma,"%d",x);
    switch (findtotaldigits(x))
    {
    case 0:
    case 1:
    case 2:
    case 3:
        {
            return comma;
            break;
        }
    case 4:
        {
            insert_substring(comma,",",2);
            break;
        }
    case 5:
        {
            insert_substring(comma,",",3);
            break;
        }
    case 6:
        {
            insert_substring(comma,",",4);
            break;
        }
    case 7:
        {
            insert_substring(comma,",",2);
            insert_substring(comma,",",6);
            break;
        }
    case 8:
        {
            insert_substring(comma,",",3);
            insert_substring(comma,",",7);
            break;
        }
    case 9:
        {
            insert_substring(comma,",",4);
            insert_substring(comma,",",8);
            break;
        }
    case 10:
        {
            insert_substring(comma,",",2);
            insert_substring(comma,",",6);
            insert_substring(comma,",",10);
            break;
        }
    case 11:
        {
            insert_substring(comma,",",3);
            insert_substring(comma,",",7);
            insert_substring(comma,",",11);
            break;
        }
    case 12:
        {
            insert_substring(comma,",",4);
            insert_substring(comma,",",8);
            insert_substring(comma,",",12);
            break;
        }
    default:
        {
            return comma;
        }
    }
    return comma;
}

int findtotaldigits(unsigned long int no)
{
  if (no==0) return 0;
  return 1+findtotaldigits(no/10);
}

void insert_substring(char *a, char *b, int position)
{
  char *f, *e;
  int length;
  length=strlen(a);
  f=substring(a,1,position -1);
  e=substring(a,position,length-position+1);

  strcpy(a,"");
  strcat(a,f);
  free(f);
  strcat(a,b);
  strcat(a,e);
  free(e);
}

char *substring(char *string, int position, int length)
{
  char *pointer;
  int c;
  pointer=malloc(length+1);
  if(pointer == NULL)
    exit(EXIT_FAILURE);
  for(c=0;c<length;c++)
    *(pointer+c) = *((string+position-1)+c);
  *(pointer+c)='\0';
  return pointer;
}

void listplayers()          //Creates list to show of other players - Also creates ascii file with same info
{
  int x=1;
  int y=0;
  int total_records=get_total_idx();
  struct PlyrRec PlyrInfo;
  struct PlyrRec *Players;
  FILE *fptr;
  FILE *fptr2;
  char s[80];
  char v[80];
  fptr = fopen(PlyrFile,"rb");
  fptr2 = fopen("slotplyr.txt","w");
  if (!fptr || !fptr2) gameExit(-1);

  Players = (struct PlyrRec *)malloc(sizeof(struct PlyrRec) * total_records);

  while (fread(&PlyrInfo, sizeof(struct PlyrRec), 1, fptr) == 1)
  {
      strcpy(Players[y].Name,PlyrInfo.Name);
      Players[y].Score=PlyrInfo.Score;
      y++;
  }
  od_clr_scr();
  od_printf("`blue`");
  strcpy(s,"List of Players in Crazy Eights Slot Machine");
  centerText(s,78);
  sprintf(v,"Ver %s %s",FULLVERSION_STRING,STATUS);
  centerText(v,78);
  centerTextfile(s,78,fptr2);
  centerTextfile(v,78,fptr2);
  od_printf("\r\n -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n");
  fprintf(fptr2,"\r\n -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n");
  od_printf("  Name                                       Score\r\n");
  fprintf(fptr2,"  Name                                       Score\r\n");
  od_printf(" -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n");
  fprintf(fptr2," -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\r\n");
  bubble_sort(Players,get_total_idx());
  for (x=0;x<15 && x < total_records;x++)
  {
    od_printf("`blue`  %-42s $%-2s\r\n`white`",Players[x].Name,goldconvert(Players[x].Score));
    fprintf(fptr2,"  %-42s $%-2s\r\n",Players[x].Name,goldconvert(Players[x].Score));
  }
  fclose(fptr);
  fclose(fptr2);
  free(Players);
}

void bubble_sort(struct PlyrRec *list, int s)
{
    int i, j;
    struct PlyrRec temp;

    for (i = 0; i < s - 1; i++)
    {
        for (j = 0; j < (s - 1-i); j++)
        {
            if (list[j].Score < list[j+1].Score)
            {
                temp=list[j];
                list[j]=list[j+1];
                list[j+1]=temp;
            }
        }
    }
}

void add_player_idx()
{
  FILE *fptr;

  fptr = fopen("slotplyr.idx", "a");
  if (!fptr)
    {
      fprintf(stderr, "ERROR OPENING slotplyr.idx!\n");
      gameExit(-1);
    }
  fprintf(fptr, "%s+%s\n", od_control_get()->user_name, od_control_get()->user_handle);
  fclose(fptr);
}

int get_player_idx()
{
    FILE *fptr;
    char buffer[256];
    char savefile[256];
    int idx = 0;
    fptr = fopen("slotplyr.idx", "r");

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

int get_total_idx()
{
    FILE *fptr;
    char buffer[256];
    int idx = 0;
    fptr = fopen("slotplyr.idx","r");
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

int load_player()
{
    FILE *fptr;
    Plyr.Index = get_player_idx();
    if (Plyr.Index == -1) return 0;
    fptr = fopen(PlyrFile, "rb");
    if (!fptr)
    {
        fprintf(stderr, "rcstdta.ply missing! please reset.\n");
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

void SavePlyr()
{
    #if defined(_MSC_VER) || defined(WIN32)
    int fno = open(PlyrFile, O_WRONLY | O_CREAT | O_BINARY, 0644);
    #else
    int fno = open(PlyrFile, O_WRONLY | O_CREAT, 0644);
    #endif // defined
    if (fno < 0) gameExit(-1);
    lseek(fno, sizeof(struct PlyrRec) * Plyr.Index, SEEK_SET);
    write(fno, &Plyr, sizeof(struct PlyrRec));
    close(fno);
}

void gameExit(int errorlevel)
{
    od_get_key(TRUE);
    listplayers();
    od_get_key(TRUE);
    od_exit(errorlevel,FALSE);
}
