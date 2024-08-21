#!/usr/bin/python3

# ------------------------------------------------------------------------
# this file is part of the pycrt project // github.com/xqtr/pycrt 
# ------------------------------------------------------------------------

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  

import time
import os, re
import sys
import struct
import tty,termios
#from future import division

pathchar = os.sep
pathsep  = os.sep
utf = False

# to change color you can use it like this:  print(colors[7])
# 0 - 15  : foreground colors
# 16 - 23 : background colors

colors = {
 'r':"\033[0m",
  0:"\033[0;30m",
  1:"\033[0;34m",
  2:"\033[0;32m",
  3:"\033[0;36m",
  4:"\033[0;31m",
  5:"\033[0;35m",
  6:"\033[0;33m",
  7:"\033[0;37m",
  8:"\033[1;30m",
  9:"\033[1;34m",
  10:"\033[1;322m",
  11:"\033[1;366m",
  12:"\033[1;31m",
  13:"\033[1;35m",       
  14:"\033[1;33m",
  15:"\033[1;37m",
  16:"\033[40m",
  17:"\033[44m",
  18:"\033[42m",
  19:"\033[46m",
  20:"\033[41m",
  21:"\033[45m",
  22:"\033[43m",      
  23:"\033[47m"
}

# key codes used for the readkey() function below

# common
LF = '\x0d'
CR = '\x0a'
ENTER = '\x0d'
BACKSPACE = '\x7f'
SUPR = ''
SPACE = '\x20'
ESC = '\x1b'

# CTRL
CTRL_A = '\x01'
CTRL_B = '\x02'
CTRL_C = '\x03'
CTRL_D = '\x04'
CTRL_E = '\x05'
CTRL_F = '\x06'
CTRL_G = '\x07'
CTRL_H = '\x08'
CTRL_I = '\x09'
CTRL_J = '\x0a'
CTRL_K = '\x0b'
CTRL_L = '\x0c'

CTRL_N = '\x0e'
CTRL_O = '\x0f'
CTRL_P = '\x10'
"""
q
r
s
t
u
v
w
x
y
"""
CTRL_Y = '\x19'
CTRL_Z = '\x1a'

# ALT
ALT_A = '\x1b\x61'

# CTRL + ALT
CTRL_ALT_A = '\x1b\x01'

# cursors
UP = '\x1b\x5b\x41'
DOWN = '\x1b\x5b\x42'
LEFT = '\x1b\x5b\x44'
RIGHT = '\x1b\x5b\x43'

CTRL_ALT_SUPR = '\x1b\x5b\x33\x5e'

# other
F1 = '\x1b\x4f\x50'
F2 = '\x1b\x4f\x51'
F3 = '\x1b\x4f\x52'
F4 = '\x1b\x4f\x53'
F5 = '\x1b\x4f\x31\x35\x7e'
F6 = '\x1b\x4f\x31\x37\x7e'
F7 = '\x1b\x4f\x31\x38\x7e'
F8 = '\x1b\x4f\x31\x39\x7e'
F9 = '\x1b\x4f\x32\x30\x7e'
F10 = '\x1b\x4f\x32\x31\x7e'
F11 = '\x1b\x4f\x32\x33\x7e'
F12 = '\x1b\x4f\x32\x34\x7e'

PAGE_UP = '\x1b\x5b\x35\x7e'
PAGE_DOWN = '\x1b\x5b\x36\x7e'
HOME = '\x1b\x5b\x48'
END = '\x1b\x5b\x46'

INSERT = '\x1b\x5b\x32\x7e'
SUPR = '\x1b\x5b\x33\x7e'

NextLine = '\033[{n}E'
PrevLine = '\033[{n}F'
curfg = colors[7]
curbg = colors[16]
textattr_str = curfg+curbg
textattr = 7

# screen size variables
rows, columns = os.popen('stty size', 'r').read().split()
screenheight = int(rows)
screenwidth = int(columns)

# internally used function for wherex/y
def getpos():
    buf = ""
    stdin = sys.stdin.fileno()
    tattr = termios.tcgetattr(stdin)

    try:
        tty.setcbreak(stdin, termios.TCSANOW)
        sys.stdout.write("\x1b[6n")
        sys.stdout.flush()

        while True:
            buf += sys.stdin.read(1)
            if buf[-1] == "R":
                break

    finally:
        termios.tcsetattr(stdin, termios.TCSANOW, tattr)

    # reading the actual values, but what if a keystroke appears while reading
    # from stdin? As dirty work around, getpos() returns if this fails: None
    try:
        matches = re.match(r"^\x1b\[(\d*);(\d*)R", buf)
        groups = matches.groups()
    except AttributeError:
        return None

    return (int(groups[0]), int(groups[1]))
    
def savescreen():
    os.system('tput smcup') #save previous state

def restorescreen():
    os.system('tput rmcup')

# where c can be 0 - 15, changes foreground color
def textcolor(c):
    global textattr
    global textattr_str
    global curfg
    global curbg
    textattr = textattr // 16
    textattr = textattr + c
    curfg = colors[c]
    textattr_str = curfg + curbg
    sys.stdout.write(curfg)
    sys.stdout.flush()
    
# where c can be 0 - 7, changes background color        
def textbackground(c):
    global textattr
    global textattr_str
    global curfg
    global curbg
    textattr = textattr % 16
    textattr = textattr + (c * 16)
    curbg = colors[16+c]
    textattr_str = curfg + curbg
    sys.stdout.write(curbg)
    sys.stdout.flush()
  

# takes a color byte value 0-255 and returns it as an ansi string
# example: textattr2str(31), will give the string for white text in
# blue color    
def textattr2str(a):
    c = a % 16
    d = a // 16
    fg = ''
    bg = ''
    fg = colors[c]
    bg = colors[d+16]
    return fg+bg

# internally used function to spit cp437 chars.    
def swrite(s):    
    #sys.stdout.write(str(s))
    #s="".join(s).encode("CP437")
    os.write(1,bytes(s,"CP437"))
    #sys.stdout.write(str(s))
# internally used function to spit cp437 chars.    
def swritexy(x,y,at,s):    
    #sys.stdout.write(str(s))
    #s="".join(s).encode("CP437")
    gotoxy(x,y)
    sys.stdout.write(textattr2str(at))
    sys.stdout.flush()
    os.write(1,bytes(s,"CP437"))
    #sys.stdout.write(str(s))    

# writes text, with no new lines, in the current color        
def write(s):
    if utf:
        sys.stdout.write(textattr_str)
        sys.stdout.write(str(s))
        sys.stdout.flush()
    else:
        swrite(s)

# same as above but with newline added    
def writeln(st):
    write(st+'\n')


def cursorup(n):
    sys.stdout.write('\033['+str(n)+'A')
    sys.stdout.flush()
    
def cursordown(n):
    sys.stdout.write('\033['+str(n)+'B')
    sys.stdout.flush() 
    
def cursorleft(n):
    sys.stdout.write('\033['+str(n)+'D')
    sys.stdout.flush() 
    
def cursorright(n):
    sys.stdout.write('\033['+str(n)+'C')
    sys.stdout.flush() 
    
def cursorblock():
    sys.stdout.write('\033[?112c\007')
    sys.stdout.flush() 

def cursorhalfblock():
    sys.stdout.write('\033[?2c\007');
    sys.stdout.flush()

def clrscr():
    sys.stdout.write('\033[2J')
#   n=0 clears from cursor until end of screen,
#   n=1 clears from cursor to beginning of screen
#   n=2 clears entire screen
    sys.stdout.flush()
    gotoxy(1,1)
   
def clreol():
    sys.stdout.write('\033[2K')
#   n=0 clears from cursor to end of line
#   n=1 clears from cursor to start of line
#   n=2 clears entire line
    sys.stdout.flush()

def ansi_on():
    sys.stdout.write('\033(U\033[0m')
    sys.stdout.flush()

# moves cursor to position i, horizontally
def gotox(i):
    sys.stdout.write('\033['+str(i)+'G')
    sys.stdout.flush()

# place cursor at position x,y    
def gotoxy(x,y):
    if x < 1:
        x = 1
    if x > 80:
        x = 80
    if y<1:
        y = 1
    if y>25:
        y=25
    sys.stdout.write('\033['+str(y)+';'+str(x)+'H')
    sys.stdout.flush()

# a is a byte color value 0-255    
def settextattr(a):
    global textattr_str
    global textattr
    textattr = a
    textcolor(a % 16)
    textbackground(a // 16)

# writes text at position x,y with color a    
def writexy(x,y,a,s):
    gotoxy(x,y)
    write(s)
    #sys.stdout.write(textattr2str(a))
    #sys.stdout.write(s)
    #sys.stdout.flush()

    
def writepipe(txt):
    OldAttr = textattr
    
    width=len(txt)
    Count = 0

    while Count <= len(txt)-1:
        #swrite(str(Count)+' '+str(len(txt))+' '+str(width)
        if txt[Count] == '|':
            Code = txt[Count+1:Count+3]
            CodeNum = int(Code)

            if (Code == '00') or (CodeNum > 0):
                Count = Count +2
                if 0 <= int(CodeNum) < 16:
                    settextattr(int(CodeNum) + ((textattr // 16) * 16))
                else:
                    settextattr((textattr % 16) + (int(CodeNum) - 16) * 16)
            else:
                write(txt[Count:Count+1])
                width = width - 1
      
        else:
            write(txt[Count:Count+1])
            width = width - 1
    

        if width == 0:
            break

        Count +=1
    
    if width > 1:
        write(' '*width)

    
def writexypipe(x,y,attr,width,txt):
    OldAttr = textattr
    OldX    = wherex()
    OldY    = wherey()

    gotoxy(x,y)
    settextattr(attr)

    Count = 0

    while Count <= len(txt)-1:
        #swrite(str(Count)+' '+str(len(txt))+' '+str(width)
        if txt[Count] == '|':
            Code = txt[Count+1:Count+3]
            CodeNum = int(Code)

            if (Code == '00') or (CodeNum > 0):
                Count = Count +2
                if 0 <= int(CodeNum) < 16:
                    settextattr(int(CodeNum) + ((textattr // 16) * 16))
                else:
                    settextattr((textattr % 16) + (int(CodeNum) - 16) * 16)
            else:
                write(txt[Count:Count+1])
                width = width - 1
      
        else:
            write(txt[Count:Count+1])
            width = width - 1
    

        if width == 0:
            break

        Count +=1
    
    if width > 1:
        write(' '*width)

    settextattr(OldAttr)
    gotoxy(OldX, OldY)
    
    
def setwindow(y1,y2):
    sys.stdout.write('\033[' + str(y1) + ';' + str(y2) + 'r');
    sys.stdout.flush()
    
def resetwindow():
    setwindow(1,25)
    
def cls():
    os.system('cls' if os.name == 'nt' else 'clear')
  
def delay(t):
    time.sleep(t/ 1000.0)
    
def savecursor():
    sys.stdout.write('\033[s')

def restorecursor():
    sys.stdout.write('\033[n')
    
def wherex():
    return getpos()[1]
    
def wherey():
    return getpos()[0]
    
def ANSIRender(data):
    """
    Return the .ans file data unpacked & in the correct 437 codepage
    """
    #Check terminal width, a width different to 80 normally causes problems
    #rows, cols = os.popen('stty size', 'r').read().split()
    #if cols != "80":
    #    raw_input("\n[!] The width of the terminal is %s rather than 80, this can often cause bad rendering of the .ANS file. Please adjust terminal width to be 80 and press any key to continue....\n"%(cols))

    ans_out = ""
    for a in data:
        ans_out += chr(struct.unpack("B", a)[0]).decode('cp437')

    return ans_out

def dispfile2(filename,wait):
    write(colors[7]+colors[16])
    clrscr()
    with open(filename,encoding="CP437") as fp:  
            lines = fp.readlines()
            cnt = 0
            #write(mci)
            while cnt<=len(lines)-1:
                a=lines[cnt]
                os.write(1,bytes(a,"CP437"))
                delay(wait)
                cnt+=1    

def dispfile(filename):
    data = open(filename, "rb").read()
    swrite(ANSIRender(data).encode('cp437'))
   
# def readkey():
    # ch1=''
    # ch2=''
    # fd = sys.stdin.fileno()
    # old_settings = termios.tcgetattr(fd)
    # try:
        # tty.setraw(sys.stdin.fileno())
        # ch = sys.stdin.read(1)
    # finally:
        # termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    # return ch
    
fdInput = sys.stdin.fileno()
termAttr = termios.tcgetattr(0)    

# waits user to press a key and returns the value.    
def readkey():
    tty.setraw(fdInput)
    ch = sys.stdin.buffer.raw.read(4).decode(sys.stdin.encoding)
    if len(ch) == 1:
        if ch == ENTER:
            ch = "#enter"
        elif ch == BACKSPACE:
            ch = "#back"
        elif ch == SPACE:
            ch = "#space"
        elif ch == ESC:
            ch = "#esc"
        elif ch == CTRL_A:
            ch = "#ctrla"
        elif ch == CTRL_B:
            ch = "#ctrlb"
        elif ch == CTRL_C:
            ch = "#ctrlc"
        elif ch == CTRL_D:
            ch = "#ctrld"
        elif ch == CTRL_E:
            ch = "#ctrle"
        elif ch == CTRL_F:
            ch = "#ctrlf"
        elif ch == CTRL_G:
            ch = "#ctrlg"
        elif ch == CTRL_H:
            ch = "#ctrlh"
        elif ch == CTRL_I:
            ch = "#ctrli"
        elif ch == CTRL_J:
            ch = "#ctrlj"
        elif ch == CTRL_K:
            ch = "#ctrlk"
        elif ch == CTRL_L:
            ch = "#ctrll"
        elif ch == CTRL_N:
            ch = "#ctrln"
        elif ch == CTRL_O:
            ch = "#ctrlo"
        elif ch == CTRL_P:
            ch = "#ctrlp"
        elif ch == CTRL_Z:
            ch = "#ctrlz"
        elif ch == CTRL_Y:
            ch = "#ctrly"
        elif ord(ch) < 32 or ord(ch) > 126:
            ch = ord(ch)

    elif ch == INSERT:
        ch = "#ins"
    elif ch == PAGE_DOWN:
        ch = "#pgdn"
    elif ch == PAGE_UP:
        ch = "#pgup"
    elif ch == HOME:
        ch = "#home"
    elif ch == END:
        ch = "#end"
    elif ch == F1:
        ch = "#f1"
    elif ch == F2:
        ch = "#f2"
    elif ch == F3:
        ch = "#f3"
    elif ch == F4:
        ch = "#f4"
    elif ch == F5:
        ch = "#f5"
    elif ch == F6:
        ch = "#f6"
    elif ch == F7:
        ch = "#f7"
    elif ch == F8:
        ch = "#f8"
    elif ch == F9:
        ch = "#f9"
    elif ch == F10:
        ch = "#f10"
    elif ch == F11:
        ch = "#f11"
    elif ch == F12:
        ch = "#f12"
    elif ord(ch[0]) == 27:
        if ch[1] == "[":
            if ch[2] == "A":
                ch = "#up"
            elif ch[2] == "B":
                ch = "#down"
            elif ch[2] == "C":
                ch = "#right"
            elif ch[2] == "D":
                ch = "#left"
            elif ch[2] == "K" or ch[2]=="F":
                ch = "#end"
            elif ch[2] == "V":
                ch = "#pgup"
            elif ch[2] == "U":
                ch = "#pgdn"
    
    termios.tcsetattr(fdInput, termios.TCSADRAIN, termAttr)
    return ch

def cleararea(x1,y1,x2,y2,bg):
    for i in range(y2-y1):
        gotoxy(x1,y1+i)
        swrite(bg*(x2-x1))
        
def byte2str(v):
    s=''.join(str(v))
    return s[2:-1]