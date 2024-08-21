/*****************************************************************************
*                          ANSI Viewer for Linux
*                               Ben Fowler
*                              December  1995
*     Derived largely in part from /usr/src/linux/driver/char/console.c
*
*
****************************************************************************/

#include <stdio.h>
#include <string.h>
#include <curses.h>

#define BLANK 0x0020


/**************************************************************************/
/*              ah the joys of global variable definitions                */


unsigned long video_num_columns = 80;	/* Number of text columns       */
unsigned long video_num_lines = 25;	/* Number of text lines         */
unsigned long video_size_row = 50;
unsigned long video_screen_size = 4000;
int rows = 25;
int cols = 80;
int can_do_color = 1;
int video_mode_512ch = 0;	/* 512-character mode */

int x = 0;
int y = 0;
int pos = 0;
int par[8];
int splos = 0;

unsigned int editbuffer[80000];	/* Max 1000 lines = 80000 */
     /* yes we can do 1000 line ansi's :) */


int need_wrap = 0;
int def_color = 0x07;		/* white */
int ulcolor = 0x0f;		/* bold white */
int halfcolor = 0x08;		/* grey */
int top = 0;
int bottom = 25;
int ques = 0;
int npar = 0;
int attr = 7;
int foreground = 7;
int background = 0;
int tab_stop[5];


int video_erase_char = ' ';
int maxread = 0;

int intensity = 1;
int underline = 0;
int reverse = 0;
int blink = 0;
int color = 0x07;		/* gray on black */
int saved_x = 0;
int saved_y = 0;
int s_intensity = 0;
int s_underline = 0;
int s_blink = 0;
int s_reverse = 0;
int s_color = 0;
int reverse_video_char = ' ';
int ishome = 0;

int lattr;
int lastline;


unsigned char color_table[] = { 0, 4, 2, 6, 1, 5, 3, 7,
  8, 12, 10, 14, 9, 13, 11, 15
};



enum
{ ESnormal, ESesc, ESsquare, ESgetpars, ESgotpars, ESfunckey,
  EShash, ESsetG0, ESsetG1, ESpercent, ESignore, ESnonstd,
  ESpalette
};


int vc_state = ESnormal;


void
clearbuf (int currcons)
{
  int i;

  for (i = 0; i < 80000; i++)
    {
      editbuffer[i] = 0x0720;	/* default color ' ' */
    }
}


void
gotoxy (int currcons, int new_x, int new_y)
{
  if (new_x < 0)
    x = 0;
  else if (new_x >= 80)
    x = 79;
  else
    x = new_x;


  if (new_y < 0)
    y = 0;
  else if (new_y >= 1000)
    y = 999;
  else
    y = new_y;
  pos = (y * 80) + x;
  need_wrap = 0;
}



void
lf (int currcons)
{
  if (y < 999)
    {
      y++;
      pos += 80;
    }
  need_wrap = 0;
}


void
ri (int currcons)
{
  /* don't scroll if below top of scrolling region, or
   * if above scrolling region
 *//*
   if (y == top)
   scrdown(currcons,top,bottom);
   else if (y > 0) {
   y--;
   pos -= video_size_row;
   } */
  /* need_wrap = 0; */
}



void
cr (int currcons)
{
  pos -= x;
  need_wrap = 0;
  x = 0;
}

void
bs (int currcons)
{
  if (x)
    {
      pos--;
      x--;
      need_wrap = 0;
    }
}



void
update_attr (int currcons)
{
  attr = color;

  if (blink)
    attr ^= 0x80;

  if (intensity == 2)
    attr ^= 0x08;

  /* video_erase_char = (color << 8) | ' '; */
}


void
default_attr (int currcons)
{
  intensity = 1;
  underline = 0;
  reverse = 0;
  blink = 0;
  color = 0x07;			/* def_color; */
  foreground = 0x07;
  background = 0;
}



void
csi_m (int currcons)
{
  int i;

  for (i = 0; i <= npar; i++)
    switch (par[i])
      {
      case 0:			/* all attributes off */
	default_attr (currcons);
	break;
      case 1:
	intensity = 2;
	break;
      case 2:
	intensity = 0;
	break;
      case 4:
	underline = 1;
	break;
      case 5:
	blink = 1;
	break;
      case 7:
	reverse = 1;
	break;
      case 10:			/* ANSI X3.64-1979 (SCO-ish?)
				 * Select primary font, don't display
				 * control chars if defined, don't set
				 * bit 8 on output.
				 */
	/* translate = set_translate(charset == 0
	   ? G0_charset
	   : G1_charset);
	   disp_ctrl = 0;
	   toggle_meta = 0;
	 */
	break;
      case 11:			/* ANSI X3.64-1979 (SCO-ish?)
				 * Select first alternate font, let's
				 * chars < 32 be displayed as ROM chars.
				 */
	/*
	   translate = set_translate(IBMPC_MAP);
	   disp_ctrl = 1;
	   toggle_meta = 0;
	 */

	break;
      case 12:			/* ANSI X3.64-1979 (SCO-ish?)
				 * Select second alternate font, toggle
				 * high bit before displaying as ROM char.
				 */
	/*
	   translate = set_translate(IBMPC_MAP);
	   disp_ctrl = 1;
	   toggle_meta = 1;
	 */

	break;
      case 21:
      case 22:
	intensity = 1;
	break;
      case 24:
	underline = 0;
	break;
      case 25:
	blink = 0;
	break;
      case 27:
	reverse = 0;
	break;
      case 38:			/* ANSI X3.64-1979 (SCO-ish?)
				 * Enables underscore, white foreground
				 * with white underscore (Linux - use
				 * default foreground).
				 */
	color = (def_color & 0x0f) | background;
	underline = 1;
	break;
      case 39:			/* ANSI X3.64-1979 (SCO-ish?)
				 * Disable underline option.
				 * Reset colour to default? It did this
				 * before...
				 */
	color = (def_color & 0x0f) | background;
	underline = 0;
	break;
      case 49:
	color = (def_color & 0xf0) | foreground;
	break;
      default:
	if (par[i] >= 30 && par[i] <= 37)
	  /*      color = color_table[par[i]-30]
	     | background; */
	  {
	    foreground = (par[i] - 30) & 0x07;

	    color = (background << 4) | foreground;
	  }
	else if (par[i] >= 40 && par[i] <= 47)
	  /* color = (color_table[par[i]-40]<<4) */
	  /*      | foreground; */
	  {
	    background = (par[i] - 40) & 0x07;

	    color = (background << 4) | foreground;
	  }
	break;
      }
  update_attr (currcons);
}



void
save_cur (int currcons)
{
  saved_x = x;
  saved_y = y;
  s_intensity = intensity;
  s_underline = underline;
  s_blink = blink;
  s_reverse = reverse;
  s_color = color;
}

void
restore_cur (int currcons)
{
  gotoxy (currcons, saved_x, saved_y);
  intensity = s_intensity;
  underline = s_underline;
  blink = s_blink;
  reverse = s_reverse;
  color = s_color;
  update_attr (currcons);
  need_wrap = 0;
}



void
printattr ()
{
  int fg;
  int bg;
  int bold;
  int flash;
  flash = 25;
  fg = (attr & 0x07);
  bg = (attr >> 4) & 0x07;
  fg = fg + 30;
  bg = bg + 40;
  bold = 0;
  if (attr & 0x08)
    bold = 1;
  if (attr & 0x80)
    flash = 5;
  printf ("\e[0;%d;%d;%d;%dm", bold, flash, fg, bg);

}

void
dumpline ()			/* print one line to screen */
{
  int co;
  for (co = 0; co < 80; co++)
    {
      attr = (editbuffer[pos + co] >> 8);
      if (lattr != attr)
	{
	  printattr ();
	  lattr = attr;
	}
      putc (editbuffer[pos + co] & 0xFF, stdout);
    }
}

void
ansiscrollup ()
{
  if ((pos - (25 * 80)) >= 0)
    {
      splos = pos;
      pos = pos - (25 * 80);
      printf ("\e[0;0H\e[L\e[0;0H");	/* insert a line */
      dumpline ();
      pos = splos - 80;
      ishome = 0;
    }
  else
    ishome = 1;
}

void
ansiscrolldown ()
{
  if ((pos + 80) >= maxread)
    return;
  if (lastline < 25)
    return;

  {
    printf ("\e[25;0H\r\n");
    pos += 80;
    dumpline ();
    ishome = 0;
  }
}

void
home ()
{
  int i, zz;
  if (ishome == 1)		/* if already at top skippit */
    return;
  zz = 25;
  if (lastline < 25)
    zz = lastline;
  printf ("\e[2J\e[0;0H");
  for (i = 0; i < zz; i++)
    {
      pos = i * 80;
      dumpline ();
    }
  ishome = 1;
}

void
end ()
{

  int i, zz;
  if (lastline < 25)
    return;
  if ((pos + 80) >= maxread)	/* if already at end skippit */
    return;

  zz = lastline - 25;
  if (zz < 0)
    zz = 0;
  zz = zz * 80;
  printf ("\e[2J\e[0;0H");
  for (i = 0; i < 25; i++)
    {
      pos = zz + (i * 80);
      dumpline ();
    }
  ishome = 0;
}


void
pagedown ()
{
  int i;
  i = pos / 80;
  if ((lastline - i) <= 25)
    {
      end ();
    }
  else
    {
      printf ("\e[2J\e[0;0H");
      for (i = 0; i < 25; i++)
	{
	  pos = pos + 80;
	  dumpline ();
	}
      ishome = 0;
    }
}


void
pageup ()
{
  int i;
  if ((pos - 4000) >= 0)
    {
      printf ("\e[2J\e[0;0H");
      pos = pos - 4000;
      for (i = 0; i < 25; i++)
	{
	  pos = pos + 80;
	  dumpline ();		/* leave it pointing at last line */
	}
    }
  else
    home ();
}

void
scrollit (void)
{
  int c, ok;
  int ex = 0;
  int scrollstate = ESnormal;
  initscr ();			/* initialize ncurses */
  noecho ();			/* shuttoff tty echoing */
  nonl ();			/* don't wait for carriage return */
  printf ("\e[?25l");		/* turn cursor off */
  printf ("\e[2J\e[0;0H");	/* clear screen and home cursor */
  printf ("\e(U");		/* set linux virtual console to IBM_PC graphics set */
  ishome = 0;

  lastline = pos / 80;
  c = lastline * 80;
  ok = pos - c;
  if (ok > 0)
    lastline++;
  maxread = pos;
  pos = 0;
  c = 0;
  ok = 0;
  home ();

  while (fflush (stdout) || (((ex != 1) && (c = getchar ()) != 255)))
    {



/* ok = (c >= 32 ); *//* less than ' ' ignored */
      switch (c)
	{
	case 7:
	  /* if (bell_pitch && bell_duration)
	     kd_mksound(bell_pitch, bell_duration); */
	  continue;
	case 8:
	  /* bs(currcons); */
	  continue;
	case 9:		/* tab key */
	  /* pos -= (x << 1); */
	  /* while (x < video_num_columns - 1) {
	     x++;
	     if (tab_stop[x >> 5] & (1 << (x & 31)))
	     break;
	     } */
	  /* pos += (x << 1); */
	  continue;
	case 11:
	case 12:
	  /* lf(currcons); */
	  continue;
	case 10:
	case 13:
	  ansiscrolldown ();
	  continue;
	case 14:
	  continue;
	case 15:
	  continue;
	case 24:
	case 26:
	  scrollstate = ESnormal;
	  continue;
	case 27:
	  scrollstate = ESesc;
	  continue;
	case 4:
	case 'Q':
	case 'q':
	case 'X':
	case 'x':
	  ex = 1;
	  continue;

	case ' ':
	  pagedown ();
	  continue;

	case 127:
	  continue;
	case 128 + 27:
	  scrollstate = ESsquare;
	  continue;
	}

      switch (scrollstate)
	{
	case ESesc:
	  scrollstate = ESnormal;
	  switch (c)
	    {
	    case '[':
	      scrollstate = ESsquare;
	      continue;
	    case ']':
	      scrollstate = ESnonstd;
	      continue;
	    case '%':
	      scrollstate = ESpercent;
	      continue;
	    case 'E':
	      /* cr(currcons);
	         lf(currcons); */
	      continue;
	    case 'M':
	      /* ri(currcons); */
	      continue;
	    case 'D':
	      /* lf(currcons); */
	      continue;
	    case 'H':
	      continue;
	    case 'Z':
	      continue;
	    case '7':
	      /* save_cur(currcons); */
	      continue;
	    case '8':
	      /* restore_cur(currcons); */
	      continue;
	    case '(':
	      scrollstate = ESsetG0;
	      continue;
	    case ')':
	      scrollstate = ESsetG1;
	      continue;
	    case '#':
	      scrollstate = EShash;
	      continue;
	    case 'c':
	      continue;
	    case '>':		/* Numeric keypad */
	      continue;
	    case '=':		/* Appl. keypad */
	      continue;
	    }
	  continue;
	case ESnonstd:
	  if (c == 'P')
	    {			/* palette escape sequence */
	      for (npar = 0; npar < 7; npar++)
		par[npar] = 0;
	      npar = 0;
	      scrollstate = ESpalette;
	      continue;
	    }
	  else if (c == 'R')
	    {			/* reset palette */
	      scrollstate = ESnormal;
	    }
	  else
	    scrollstate = ESnormal;
	  continue;
	case ESpalette:
	  if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'F')
	      || (c >= 'a' && c <= 'f'))
	    {
	      par[npar++] = (c > '9' ? (c & 0xDF) - 'A' + 10 : c - '0');
	    }
	  else
	    scrollstate = ESnormal;
	  continue;
	case ESsquare:
	  for (npar = 0; npar < 7; npar++)
	    par[npar] = 0;
	  npar = 0;
	  scrollstate = ESgetpars;
	  if (c == '[')
	    {			/* Function key */
	      scrollstate = ESfunckey;
	      continue;
	    }
	  ques = (c == '?');
	  if (ques)
	    continue;
	case ESgetpars:
	  if (c == ';' && npar < 6)
	    {
	      npar++;
	      continue;
	    }
	  else if (c >= '0' && c <= '9')
	    {
	      par[npar] *= 10;
	      par[npar] += c - '0';
	      continue;
	    }
	  else
	    scrollstate = ESgotpars;
	case ESgotpars:
	  scrollstate = ESnormal;
	  switch (c)
	    {
	    case 'h':
	      continue;
	    case 'l':
	      continue;
	    case 'n':
	      continue;
	    }
	  if (ques)
	    {
	      ques = 0;
	      continue;
	    }
	  switch (c)
	    {
	    case 'G':
	    case '`':
	      /* if (par[0]) par[0]--;
	         gotoxy(currcons,par[0],y); */
	      continue;
	    case 'A':
	      ansiscrollup ();

	      /* if (!par[0]) par[0]++;
	         gotoxy(currcons,x,y-par[0]); */
	      continue;
	    case 'B':
	    case 'e':
	      ansiscrolldown ();

	      /* if (!par[0]) par[0]++;
	         gotoxy(currcons,x,y+par[0]); */
	      continue;
	    case 'C':
	    case 'a':

	      /* if (!par[0]) par[0]++;
	         gotoxy(currcons,x+par[0],y); */
	      continue;
	    case 'D':
	      /* if (!par[0]) par[0]++;
	         gotoxy(currcons,x-par[0],y); */
	      continue;
	    case 'E':
	      /* if (!par[0]) par[0]++;
	         gotoxy(currcons,0,y+par[0]); */
	      continue;
	    case 'F':
	      /* if (!par[0]) par[0]++;
	         gotoxy(currcons,0,y-par[0]); */
	      continue;
	    case 'd':
	      /* if (par[0]) par[0]--;
	         gotoxy(currcons,x,par[0]); */
	      continue;
	    case 'H':
	    case 'f':
	      /* if (par[0]) par[0]--;
	         if (par[1]) par[1]--;
	         gotoxy(currcons,par[1],par[0]); */
	      continue;
	    case 'J':
	      /* csi_J(currcons,par[0]); */
	      continue;
	    case 'K':
	      /* csi_K(currcons,par[0]); */
	      continue;
	    case 'L':
	      /* csi_L(currcons,par[0]); */
	      continue;
	    case 'M':
	      /* csi_M(currcons,par[0]); */
	      continue;
	    case 'P':
	      /* csi_P(currcons,par[0]); */
	      continue;
	    case 'c':
	      continue;
	    case 'g':
	      /* if (!par[0])
	         tab_stop[x >> 5] &= ~(1 << (x & 31));
	         else if (par[0] == 3) {
	         tab_stop[0] =
	         tab_stop[1] =
	         tab_stop[2] =
	         tab_stop[3] =
	         tab_stop[4] = 0;
	         } */
	      continue;
	    case 'm':
	      /* csi_m(currcons); */
	      continue;
	    case 'q':		/* DECLL - but only 3 leds */
	      continue;
	    case 'r':
	      continue;
	    case 's':
	      /* save_cur(currcons); */
	      continue;
	    case 'u':
	      /* restore_cur(currcons); */
	      continue;
	    case 'X':
	      /* csi_X(currcons, par[0]); */
	      continue;
	    case '@':
	      /* csi_at(currcons,par[0]); */
	      continue;
	    case ']':		/* setterm functions */
	      continue;

	    case '~':		/* home keys */
	      if (par[0] == 1)
		home ();
	      if (par[0] == 4)
		end ();
	      if (par[0] == 5)
		pageup ();
	      if (par[0] == 6)
		pagedown ();
	      continue;
	    }
	  continue;
	case ESpercent:
	  scrollstate = ESnormal;
	  continue;
	case ESfunckey:
	  scrollstate = ESnormal;
	  continue;
	case EShash:
	  scrollstate = ESnormal;
	  continue;
	case ESsetG0:
	  scrollstate = ESnormal;
	  continue;
	case ESsetG1:
	  scrollstate = ESnormal;
	  continue;
	default:
	  scrollstate = ESnormal;
	}
    }				/* end switch(scrollstate) */


  printf ("\e(B");		/* set unix character set */
  echo ();			/* turn echoing on */
  nl ();			/* turn newline mode on */
  printf ("\e[2J\e[0;0H\n");
//  printf
//    ("\e[0;1;32;40m Linux Ansi Viewer by \e[0;1;37;40mBen Fowler\e[0m\n\n\r");
  printf ("\e[?25h");		/* turn cursor on */

}				/* end scrollit() */


void
usage ()
{

  printf ("Key Commands : ");
  printf ("\n\r\tCursor up - scroll up\n\r\tCursor Down - scroll down\n\r");
  printf ("\tPage Up - up 25 lines\n\r\tPage down - down 25 lines\n\r");
  printf ("\tHome - go to top of ansi.\n\r\tEnd - go to end of ansi.\n\r");
  printf ("\tX or x - exit viewer.\n\r\n\r");

}







int
main (int argc, char *argv[])
{
  FILE *fp;
  int c, ok;

  unsigned int currcons = 1;

  tab_stop[0] = 0x01010100;
  tab_stop[1] = 0x01010101;
  tab_stop[2] = 0x01010101;
  tab_stop[3] = 0x01010101;
  tab_stop[4] = 0x01010101;


  clearbuf (currcons);		/* fill buffer with spaces grey foreground,black backround */


  if ((fp = fopen (argv[1], "r")) != NULL)
    {

      /* read in the file,translating escape codes to color codes,
         storing it all in a large integer array */


      while (((c = getc (fp)) != -1) && (c != 26) && (pos < 80000))
	{
	  /* 26 = dos eof */
/* putc(c,stdout); *//* if debugging */

	  ok = (c >= 32);	/* less than ' ' ignored */

	  if ((vc_state == ESnormal) && ok)
	    {


	      if (need_wrap)
		{
		  cr (currcons);
		  lf (currcons);
		}



	      editbuffer[pos] = ((attr << 8) + c);
	      if (x == 79)
		need_wrap = 1;	/* decawm; */
	      else
		{
		  x++;
		  pos++;
		}
	      continue;
	    }
	  switch (c)
	    {
	    case 7:
	      /* if (bell_pitch && bell_duration)
	         kd_mksound(bell_pitch, bell_duration); */
	      continue;
	    case 8:
	      /* bs(currcons); */
	      continue;
	    case 9:
	      pos -= x;
	      while (x < 79)
		{
		  x++;
		  if (tab_stop[x >> 5] & (1 << (x & 31)))
		    break;
		}
	      pos += x;
	      continue;
	    case 10:
	    case 11:
	    case 12:
	      cr (currcons);
	      lf (currcons);
	      continue;
	    case 13:
	      /* cr(currcons); */
	      /* lf(currcons); */
	      continue;
	    case 14:
	      continue;
	    case 15:
	      continue;
	    case 24:
	    case 26:
	      vc_state = ESnormal;
	      continue;
	    case 27:
	      vc_state = ESesc;
	      continue;
	    case 127:
	      continue;
	    case 128 + 27:
	      vc_state = ESsquare;
	      continue;
	    }

	  switch (vc_state)
	    {
	    case ESesc:
	      vc_state = ESnormal;
	      switch (c)
		{
		case '[':
		  vc_state = ESsquare;
		  continue;
		case ']':
		  vc_state = ESnonstd;
		  continue;
		case '%':
		  vc_state = ESpercent;
		  continue;
		case 'E':
		  cr (currcons);
		  lf (currcons);
		  continue;
		case 'M':
		  ri (currcons);
		  continue;
		case 'D':
		  lf (currcons);
		  continue;
		case 'H':
		  continue;
		case 'Z':
		  continue;
		case '7':
		  save_cur (currcons);
		  continue;
		case '8':
		  restore_cur (currcons);
		  continue;
		case '(':
		  vc_state = ESsetG0;
		  continue;
		case ')':
		  vc_state = ESsetG1;
		  continue;
		case '#':
		  vc_state = EShash;
		  continue;
		case 'c':
		  continue;
		case '>':	/* Numeric keypad */
		  continue;
		case '=':	/* Appl. keypad */
		  continue;
		}
	      continue;
	    case ESnonstd:
	      if (c == 'P')
		{		/* palette escape sequence */
		  for (npar = 0; npar < 7; npar++)
		    par[npar] = 0;
		  npar = 0;
		  vc_state = ESpalette;
		  continue;
		}
	      else if (c == 'R')
		{		/* reset palette */
		  vc_state = ESnormal;
		}
	      else
		vc_state = ESnormal;
	      continue;
	    case ESpalette:
	      if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'F')
		  || (c >= 'a' && c <= 'f'))
		{
		  par[npar++] = (c > '9' ? (c & 0xDF) - 'A' + 10 : c - '0');
		}
	      else
		vc_state = ESnormal;
	      continue;
	    case ESsquare:
	      for (npar = 0; npar < 7; npar++)
		par[npar] = 0;
	      npar = 0;
	      vc_state = ESgetpars;
	      if (c == '[')
		{		/* Function key */
		  vc_state = ESfunckey;
		  continue;
		}
	      ques = (c == '?');
	      if (ques)
		continue;
	    case ESgetpars:
	      if (c == ';' && npar < 6)
		{
		  npar++;
		  continue;
		}
	      else if (c >= '0' && c <= '9')
		{
		  par[npar] *= 10;
		  par[npar] += c - '0';
		  continue;
		}
	      else
		vc_state = ESgotpars;
	    case ESgotpars:
	      vc_state = ESnormal;
	      switch (c)
		{
		case 'h':
		  continue;
		case 'l':
		  continue;
		case 'n':
		  continue;
		}
	      if (ques)
		{
		  ques = 0;
		  continue;
		}
	      switch (c)
		{
		case 'G':
		case '`':
		  if (par[0])
		    par[0]--;
		  gotoxy (currcons, par[0], y);
		  continue;
		case 'A':
		  if (!par[0])
		    par[0]++;
		  gotoxy (currcons, x, y - par[0]);
		  continue;
		case 'B':
		case 'e':
		  if (!par[0])
		    par[0]++;
		  gotoxy (currcons, x, y + par[0]);
		  continue;
		case 'C':
		case 'a':
		  if (!par[0])
		    par[0]++;
		  gotoxy (currcons, x + par[0], y);
		  continue;
		case 'D':
		  if (!par[0])
		    par[0]++;
		  gotoxy (currcons, x - par[0], y);
		  continue;
		case 'E':
		  if (!par[0])
		    par[0]++;
		  gotoxy (currcons, 0, y + par[0]);
		  continue;
		case 'F':
		  if (!par[0])
		    par[0]++;
		  gotoxy (currcons, 0, y - par[0]);
		  continue;
		case 'd':
		  if (par[0])
		    par[0]--;
		  gotoxy (currcons, x, par[0]);
		  continue;
		case 'H':
		case 'f':
		  if (par[0])
		    par[0]--;
		  if (par[1])
		    par[1]--;
		  gotoxy (currcons, par[1], par[0]);
		  continue;
		case 'J':
		  /* csi_J(currcons,par[0]); */
		  continue;
		case 'K':
		  /* csi_K(currcons,par[0]); */
		  continue;
		case 'L':
		  /* csi_L(currcons,par[0]); */
		  continue;
		case 'M':
		  /* csi_M(currcons,par[0]); */
		  continue;
		case 'P':
		  /* csi_P(currcons,par[0]); */
		  continue;
		case 'c':
		  continue;
		case 'g':
		  /* if (!par[0])
		     tab_stop[x >> 5] &= ~(1 << (x & 31));
		     else if (par[0] == 3) {
		     tab_stop[0] =
		     tab_stop[1] =
		     tab_stop[2] =
		     tab_stop[3] =
		     tab_stop[4] = 0;
		     } */
		  continue;
		case 'm':
		  csi_m (currcons);
		  continue;
		case 'q':	/* DECLL - but only 3 leds */
		  continue;
		case 'r':
		  continue;
		case 's':
		  save_cur (currcons);
		  continue;
		case 'u':
		  restore_cur (currcons);
		  continue;
		case 'X':
		  /* csi_X(currcons, par[0]); */
		  continue;
		case '@':
		  /* csi_at(currcons,par[0]); */
		  continue;
		case ']':	/* setterm functions */
		  continue;
		}
	      continue;
	    case ESpercent:
	      vc_state = ESnormal;
	      continue;
	    case ESfunckey:
	      vc_state = ESnormal;
	      continue;
	    case EShash:
	      vc_state = ESnormal;
	      continue;
	    case ESsetG0:
	      vc_state = ESnormal;
	      continue;
	    case ESsetG1:
	      vc_state = ESnormal;
	      continue;
	    default:
	      vc_state = ESnormal;
	    }
	}

      scrollit ();

    }
  else
    {
      printf ("\e[2J\e[0;0H\e[1;37;40mCould not open specified file.\n\r");
      printf ("Usage : ansi filename\e[0m\n\r\n\r");
      usage ();
    }

  endwin ();

  return 0;
}
