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

import os, sys, time
import tty,termios

colors = {
'r':"reset='\033[0m",
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
#box1=(chr(218),chr(196),chr(191),chr(173),chr(173),chr(192),chr(196),chr(217),' ')
box1=('┌','─','┐','│','│','└','─','┘',' ')
box2=('╔','═','╗','║','║','╚','═','╝',' ')
box3=('╓','─','╖','║','║','╙','─','╜',' ')
box4=('╒','═','╕','│','│','╘','═','╛',' ')
box5=('█','▀','█','█','█','█','▄','█',' ')
box6=('█','▀','▄','█','█','▀','▄','█',' ')
box7=(' ',' ',' ',' ',' ',' ',' ',' ',' ')
box8=('.','-','.','|','|','`','-','\'',' ')
box9=(colors[15]+'█',colors[15]+colors[23]+'▀',colors[23]+colors[8]+'▄',colors[15]+'█',colors[8]+'█',colors[15]+colors[23]+'▀',colors[8]+colors[23]+'▄',colors[8]+'█',colors[7]+colors[23]+' ')
box10=(colors[17]+' ',colors[17]+' ',colors[17]+' ',colors[15]+colors[23]+'▌',colors[8]+colors[23]+'▐',colors[8]+colors[16]+'▀',colors[8]+colors[16]+'▀',colors[8]+colors[16]+'▀',colors[7]+colors[23]+' ')
box11=(colors[11]+'■',colors[11]+'▀',colors[15]+'■',colors[11]+'▌',colors[3]+'▐',colors[15]+'■',colors[3]+'▄',colors[3]+'■',colors[16]+' ')
box12=(colors[7]+'■',colors[7]+'▀',colors[15]+'■',colors[7]+'▌',colors[8]+'▐',colors[15]+'■',colors[8]+'▄',colors[8]+'■',colors[16]+' ')

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

pathchar = os.sep
pathsep  = os.sep

fdInput = sys.stdin.fileno()
termAttr = termios.tcgetattr(0) 

def delay(t):
  time.sleep(t/ 1000.0)
  
def byte2str(v):
    s=''.join(str(v))
    return s[2:-1]

class TScreen:
  wherex = 1
  wherey = 1
  attr   = 7
  oldx   = 1
  oldy   = 1
  width  = 80
  height = 25
  buffc = []
  buffa = []
  utf8  = True
  
  def __init__(self):
    self.wherex=1
    self.wherey=1
    self.attr=7
    self.buffa.clear()
    self.buffc.clear()
    for x in range(0,(self.width*self.height)):
      self.buffa.append(7)
      self.buffc.append(' ')
  
  def cursorup(self,n):
    sys.stdout.write('\033['+str(n)+'A')
    sys.stdout.flush()
    self.wherey -= n
    if self.wherey < 1: self.wherey = 1
    
  def cursordown(self,n):
    sys.stdout.write('\033['+str(n)+'B')
    sys.stdout.flush()
    self.wherey += n
    if self.wherey > self.height: self.wherey = self.height
    
  def cursorleft(self,n):
    sys.stdout.write('\033['+str(n)+'D')
    sys.stdout.flush() 
    self.wherex -= n
    if self.wherex < 1: self.wherex = 1
    
  def cursorright(self,n):
    sys.stdout.write('\033['+str(n)+'C')
    sys.stdout.flush()
    self.wherex += n
    if self.wherex > self.wherex: self.wherex = self.width
  
  def clreol(self):
    sys.stdout.write('\033[2K')
#   n=0 clears from cursor to end of line
#   n=1 clears from cursor to start of line
#   n=2 clears entire line
    sys.stdout.flush()
    for x in range(self.wherex,self.width+1):
      bufputchar(x,self.wherey,self.attr," ")
  
  def textcolor(self,c):
    self.attr = self.attr // 16
    self.attr = self.attr + c
    sys.stdout.write(colors[c])
    sys.stdout.flush()
  
  def textbackground(self,c):
    self.attr = self.attr % 16
    self.attr = self.attr + (c * 16)
    sys.stdout.write(colors[16+c])
    sys.stdout.flush()
      
  def clearbuf(self):
    self.buffc.clear()
    self.buffa.clear()
    for x in range((self.width*self.height)+1):
      self.buffa.append(7)
      self.buffc.append(' ')

  def bufputchar(self,x,y,a,c):
    self.buffa[((y-1)*self.width)+x-1]=a
    self.buffc[((y-1)*self.width)+x-1]=c
    
  def getchar(self,x,y):
    return self.buffc[((y-1)*self.width)+x-1]
  
  def getattr(self,x,y):
    return int(self.buffa[((y-1)*self.width)+x-1])
    
  def bufwritechar(self,c):
    self.bufputchar(self.wherex,self.wherey,self.attr,c)
    self.wherex += 1
    if self.wherex > self.width:
      self.wherex = 1
      self.wherey += 1
    if self.wherey > self.height:
      self.wherey = self.height
      
  def bufwritestr(self,s):
    for x in range(len(s)):
      self.bufwritechar(s[x:x+1])
      
  def gotox(self,x):
    if x < self.width+1:
      sys.stdout.write('\033['+str(x)+'G')
      sys.stdout.flush()
      self.wherex = x
      
  def gotoxy(self,x,y):
    if x < 1:
        x = 1
    if x > self.width:
        x = self.width
    if y<1:
        y = 1
    if y>self.height:
        y=self.height
    self.wherex = x
    self.wherey = y
    sys.stdout.write('\033['+str(y)+';'+str(x)+'H')
    sys.stdout.flush()
    
  def settextattr(self,a):
    self.textcolor(a % 16)
    self.textbackground(a // 16)
    self.attr = a
  
  def textattr2str(self,a):
    c = a % 16
    d = a // 16
    fg = ''
    bg = ''
    fg = colors[c]
    bg = colors[d+16]
    return str(fg+bg)
    
  def clearscreen(self):
    sys.stdout.write('\033[2J')
    sys.stdout.flush()
    self.gotoxy(1,1)
    
  def clrscr(self):
    self.clearbuf()
    self.clearscreen()
    
  def bufflush(self):
    #for x in range(self.width*self.height):
    #  sys.stdout.write(self.textattr2str(self.buffa[x]))
    #  sys.stdout.write(self.buffc[x])
    #  sys.stdout.flush()
    if self.utf8:
      for y in range(1,self.height+1):
        for x in range(1,self.width+1):
          sys.stdout.write('\033['+str(y)+';'+str(x)+'H')
          sys.stdout.write(self.textattr2str(self.getattr(x,y)))
          sys.stdout.write(self.getchar(x,y))
          sys.stdout.flush()
    else:
      for y in range(1,self.height+1):
        for x in range(1,self.width+1):
          sys.stdout.write('\033['+str(y)+';'+str(x)+'H')
          sys.stdout.write(self.textattr2str(self.getattr(x,y)))
          sys.stdout.flush()
          #sys.stdout.write(self.getchar(x,y))
          os.write(1,bytes(self.getchar(x,y),"CP437"))
          
      
    self.wherex = 1
    self.wherey = 1
    self.attr   = 7
    
  def savecursor(self):
    sys.stdout.write('\033[s')
    self.oldx = self.wherex
    self.oldy = self.wherey
    
  def restorecursor(self):
    sys.stdout.write('\033[n')
    self.wherey = self.oldy
    self.wherex = self.oldx
    
  def savescreen(self):
    return self.buffc+self.buffa
    
  def restorescreen(self,b):
    self.buffc.clear()
    self.buffa.clear()
    self.buffc = b[0:(self.width*(self.height))]
    self.buffa = b[(self.width*(self.height)):]
    self.bufflush()
  
  def write(self,s):
    self.bufwritestr(str(s))
    sys.stdout.write(self.textattr2str(self.attr))
    if self.utf8==True:
      sys.stdout.write(str(s))
      sys.stdout.flush()
    else:
      os.write(1,bytes(s,"CP437"))
  
  def writeln(self,s):
    self.bufwritestr(str(s))
    sys.stdout.write(self.textattr2str(self.attr))
    if self.utf8:
      sys.stdout.write(str(s)+'\n')
      sys.stdout.flush()
    else:
      os.write(1,bytes(s+'\n',"CP437"))
    self.wherex = 1
    self.wherey += 1
    if self.wherey > self.height: self.wherey = self.height
    
  def writexy(self,x,y,a,s):
    self.gotoxy(x,y)
    oldattr = self.attr
    self.attr = a
    self.write(s)
    self.attr = oldattr
    
  def writepipe(self,txt):
    OldAttr = self.attr
    width=len(txt)
    Count = 0

    while Count <= len(txt)-1:
        if txt[Count] == '|':
            Code = txt[Count+1:Count+3]
            CodeNum = int(Code)
            if (Code == '00') or (CodeNum > 0):
                Count = Count +2
                if 0 <= int(CodeNum) < 16:
                    self.settextattr(int(CodeNum) + ((self.attr // 16) * 16))
                else:
                    self.settextattr((self.attr % 16) + (int(CodeNum) - 16) * 16)
            else:
                self.write(txt[Count:Count+1])
                width = width - 1
      
        else:
            self.write(txt[Count:Count+1])
            width = width - 1
        if width == 0:
            break
        Count +=1
    self.attr = OldAttr
  
  def writexypipe(self,x,y,attr,width,txt):
    OldAttr = self.attr
    self.gotoxy(x,y)
    self.settextattr(attr)
    width=len(txt)
    Count = 0

    while Count <= len(txt)-1:
        if txt[Count] == '|':
            Code = txt[Count+1:Count+3]
            CodeNum = int(Code)
            if (Code == '00') or (CodeNum > 0):
                Count = Count +2
                if 0 <= int(CodeNum) < 16:
                    self.settextattr(int(CodeNum) + ((self.attr // 16) * 16))
                else:
                    self.settextattr((self.attr % 16) + (int(CodeNum) - 16) * 16)
            else:
                self.write(txt[Count:Count+1])
                width = width - 1
      
        else:
            self.write(txt[Count:Count+1])
            width = width - 1
        if width == 0:
            break
        Count +=1
    if width > 1:
        self.write(' '*width)
    self.attr = OldAttr
    
  def cleararea(self,x1,y1,x2,y2,bg):
    for i in range(y2-y1):
        self.gotoxy(x1,y1+i)
        self.write(bg*(x2-x1))
        
  def shadowarea(self,x1,y1,x2,y2,sc):
    for y in range(y1,y2+1):
      for x in range(x1,x2+1):
        self.buffa[((y-1)*self.width)+x-1]=sc
  
  def fillarea(self,x1,y1,x2,y2,c):
    for y in range(y1,y2+1):
      for x in range(x1,x2+1):
        self.buffc[((y-1)*self.width)+x-1]=c
        
  def ansibox(self,x1,y1,x2,y2,box):
    self.gotoxy(x1,y1)
    self.write(box[0]+box[1]*(x2-x1-1)+box[2])
    self.gotoxy(x1,y2)
    self.write(box[5]+box[6]*(x2-x1-1)+box[7])
    for i in range(y2-y1-1):
      self.gotoxy(x1,y1+1+i)
      self.write(box[3]+box[8]*(x2-x1-1)+box[4])
        
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
    
    
