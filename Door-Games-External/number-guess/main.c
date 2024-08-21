#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "OpenDoor.h"

#ifdef ODPLAT_WIN32
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
   LPSTR lpszCmdLine, int nCmdShow)
#else
int main(int argc, char *argv[])
#endif
{
#ifdef ODPLAT_WIN32
   od_control.od_cmd_show = nCmdShow;
#endif
#ifdef ODPLAT_WIN32
   od_parse_cmd_line(lpszCmdLine);
#else
   od_parse_cmd_line(argc, argv);
#endif
    od_printf("This is a very simple number guessing game. Each time you will be given a number\r\n");
    od_printf("of the range 0-10\r\n");
    od_printf("The objective of the game is to guess whether the next number is going to be\r\n");
    od_printf("higher or lower. It's as simple as that.\r\n");
    od_printf("You have the ability to make no more than 3 mistakes before you lose, so guess\r\n");
    od_printf("wisely\r\n\n");
    od_printf("You are starting with the number 5. Is the next number higher(H) or lower(L)?\r\n\n");

    int mistakes=0;
    int correctGuesses=0;
    int prevNum=5, nextNum;
    char choice;

    do
    {
        srand (time(NULL));
        do
            nextNum=rand() % 11;
        while (nextNum == prevNum);

        choice=od_get_answer("HL");

        if (choice == 'H')
        {
            if (prevNum < nextNum)
            {
                od_printf("Correct! The new number is %d\r\n",nextNum);
                correctGuesses++;
            }
            else if (prevNum > nextNum)
            {
                od_printf("Wrong, you made a mistake! The new number is %d\r\n",nextNum);
                mistakes++;
            }
        }

        if (choice == 'L')
        {
            if (prevNum > nextNum)
            {
                od_printf("Correct! The new number is %d\r\n",nextNum);
                correctGuesses++;
            }
            else if (prevNum < nextNum)
            {
                od_printf("Wrong, you made a mistake! The new number is %d\r\n",nextNum);
                mistakes++;
            }
        }
        prevNum=nextNum;

    }
    while (mistakes<3);

    od_printf("\r\nYou've made 3 mistakes! The game is now over!\r\n");
    od_printf("You had %d correct guesses before the game was over\r\n",correctGuesses);

    return 0;
}
