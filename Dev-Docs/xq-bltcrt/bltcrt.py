#!/usr/bin/python3

import os
from bearlibterminal import terminal as blt
from configparser import ConfigParser
import time

blt_fgcolors = []
font_files = []
font_index = 0
pathchar = os.sep
pathsep  = os.sep

dos_colors = [
  255,0,0,0,
  255,0,0,170,
  255,0,170,0,
  255,0,170,170,
  255,170,0,0,
  255,170,0,170,
  255,170,85,0,
  255,170,170,170,
  255,85,85,85,
  255,85,85,255,
  255,85,255,85,
  255,85,255,255,
  255,255,85,85,
  255,255,85,255,
  255,255,255,85,
  255,255,255,255 
  ]

ubuntu_colors = [
  255,0,0,0,
  255,0,82,255,
  255,9,222,0,
  255,18,231,255,
  255,233,0,16,
  255,218,0,233,
  255,212,63,2,
  255,200,200,200,
  255,150,150,150,
  255,131,157,254,
  255,53,255,104,
  255,123,240,255,
  255,255,84,80,
  255,250,124,254,
  255,253,243,73,
  255,255,255,255
  ]
  
windows_colors = [
  255,12,12,12,
  255,0,55,218,
  255,19,161,14,
  255,58,150,221,
  255,197,15,31,
  255,136,23,152,
  255,193,156,0,
  255,204,204,204,
  255,118,118,118,
  255,59,120,255,
  255,22,198,12,
  255,97,214,214,
  255,231,72,86,
  255,180,0,158,
  255,249,241,165,
  255,242,242,242
  ]
  
  
KEY_BACKSPACE = blt.TK_BACKSPACE
KEY_CLOSE =  blt.TK_CLOSE
KEY_TAB = blt.TK_TAB
KEY_RETURN = blt.TK_RETURN
KEY_SHIFT = blt.TK_SHIFT
KEY_CONTROL = blt.TK_CONTROL
KEY_PAUSE = blt.TK_PAUSE
KEY_ESC = blt.TK_ESCAPE
KEY_PGUP = blt.TK_PAGEUP
KEY_PGDN = blt.TK_PAGEDOWN
KEY_END = blt.TK_END
KEY_HOME = blt.TK_HOME
KEY_LEFT = blt.TK_LEFT
KEY_UP = blt.TK_UP
KEY_RIGHT = blt.TK_RIGHT
KEY_DOWN = blt.TK_DOWN
KEY_INS = blt.TK_INSERT
KEY_DEL = blt.TK_DELETE
KEY_F1 = blt.TK_F1
KEY_F2 = blt.TK_F2
KEY_F3 = blt.TK_F3
KEY_F4 = blt.TK_F4
KEY_F5 = blt.TK_F5
KEY_F6 = blt.TK_F6
KEY_F7 = blt.TK_F7
KEY_F8 = blt.TK_F8
KEY_F9 = blt.TK_F9
KEY_F10 = blt.TK_F10
KEY_F11 = blt.TK_F11
KEY_F12 = blt.TK_F12
KEY_KPDIV = blt.TK_KP_DIVIDE 
KEY_KPMULT = blt.TK_KP_MULTIPLY
KEY_KPMINUS = blt.TK_KP_MINUS
KEY_KPPLUS = blt.TK_KP_PLUS
KEY_KPENTER = blt.TK_KP_ENTER
KEY_KP0 = blt.TK_KP_0
KEY_KP1 = blt.TK_KP_1
KEY_KP2 = blt.TK_KP_2
KEY_KP3 = blt.TK_KP_3
KEY_KP4 = blt.TK_KP_4
KEY_KP5 = blt.TK_KP_5
KEY_KP6 = blt.TK_KP_6
KEY_KP7 = blt.TK_KP_7
KEY_KP8 = blt.TK_KP_8
KEY_KP9 = blt.TK_KP_9
KEY_KPPERIOD = blt.TK_KP_PERIOD
KEY_GRAVE = blt.TK_GRAVE
KEY_MINUS = blt.TK_MINUS
KEY_EQUALS = blt.TK_EQUALS
KEY_TAB = blt.TK_TAB
KEY_SEMICOLON = blt.TK_SEMICOLON
KEY_APOSTROPHE = blt.TK_APOSTROPHE
KEY_BACKSLASH = blt.TK_BACKSLASH
KEY_COMMA = blt.TK_COMMA
KEY_PERIOD = blt.TK_PERIOD
KEY_SLASH = blt.TK_SLASH
KEY_SHIFT = blt.TK_SHIFT
KEY_SPACE = blt.TK_SPACE
KEY_LBRACKET = blt.TK_LBRACKET
KEY_RBRACKET = blt.TK_RBRACKET
KEY_0 = blt.TK_0
KEY_1 = blt.TK_1
KEY_2 = blt.TK_2
KEY_3 = blt.TK_3
KEY_4 = blt.TK_4
KEY_5 = blt.TK_5
KEY_6 = blt.TK_6
KEY_7 = blt.TK_7
KEY_8 = blt.TK_8
KEY_9 = blt.TK_9
KEY_A = blt.TK_A
KEY_B = blt.TK_B
KEY_C = blt.TK_C
KEY_D = blt.TK_D
KEY_E = blt.TK_E
KEY_F = blt.TK_F
KEY_G = blt.TK_G
KEY_H = blt.TK_H
KEY_I = blt.TK_I
KEY_J = blt.TK_J
KEY_K = blt.TK_K
KEY_L = blt.TK_L
KEY_M = blt.TK_M
KEY_N = blt.TK_N
KEY_O = blt.TK_O
KEY_P = blt.TK_P
KEY_Q = blt.TK_Q
KEY_R = blt.TK_R
KEY_S = blt.TK_S
KEY_T = blt.TK_T
KEY_U = blt.TK_U
KEY_V = blt.TK_V
KEY_W = blt.TK_W
KEY_X = blt.TK_X
KEY_Y = blt.TK_Y
KEY_Z = blt.TK_Z

  
color_pal = dos_colors
colorpallete = 0
wherex = 1
wherey = 1
textattr = 7

font_name = "./fonts/dos437.ttf"
font_hintings = ["normal", "autohint", "none"]
font_hinting = 0
font_size = 16
cell_width = 8
cell_height = 16

def savesettings():
  global colorpallete
  cfg = ConfigParser()
  cfg.add_section('window')
  cfg.set('window','font_size',str(font_size))
  cfg.set('window','font_name',font_name)
  cfg.set('window','cell_width',str(cell_width))
  cfg.set('window','cell_height',str(cell_height))
  
  cfg.add_section('pallete')
  cfg.set('pallete','colors',str(colorpallete))
  
  cfgfile = open("settings.ini",'w')
  cfg.write(cfgfile)
  cfgfile.close()
  
def loadsettings():
  if not os.path.isfile('settings.ini'):
    return
  global font_size, font_name, cell_width, cell_height
  global colorpallete, color_pal
  config = ConfigParser()
  config.read('settings.ini')
  font_size=config.getint('window','font_size')
  font_name=config.get('window','font_name')
  cell_width=config.getint('window','cell_width')
  cell_height=config.getint('window','cell_height')
  
  colorpallete=config.getint('pallete','colors')
  if colorpallete == 0:
    color_pal = dos_colors
  elif colorpallete ==1:
    color_pal = windows_colors
  elif colorpallete ==2:
    color_pal = ubuntu_colors

def setup_font(): blt.set("font: %s, size=%d, hinting=%s, codepage=437" % (font_name, font_size, font_hintings[font_hinting]))
def setup_cellsize(): blt.set("window: cellsize=%dx%d" % (cell_width, cell_height))

def resetcolors():
  global blt_fgcolors
  blt_fgcolors.clear()
  for d in range(16):
    writexy(1,1+d,d,' ')
    blt.color(blt.color_from_argb(color_pal[d*4],color_pal[d*4+1],color_pal[d*4+2],color_pal[d*4+3]))
    blt.put(1,1+d,' ')
    blt_fgcolors.append(blt.pick_color(1,1+d, 0))
  
def init():
  global blt_fgcolors
  global font_files
  blt.open()
  title = ""
  blt.set("window: size=80x25, resizeable=false, cellsize=auto, title='"+title+"'; font: "+font_name+", size="+str(font_size)+", codepage=437;")
  blt.set("input.filter={keyboard}")
  for d in range(16):
    writexy(1,1+d,d,' ')
    blt.color(blt.color_from_argb(color_pal[d*4],color_pal[d*4+1],color_pal[d*4+2],color_pal[d*4+3]))
    blt.put(1,1+d,' ')
    blt_fgcolors.append(blt.pick_color(1,1+d, 0))
  settextattr(7)
  clrscr()
  font_files = None
  font_files = os.listdir('./fonts/')

def windowtitle(title):
  blt.set("window.title='%s'" % (title))
  
def helpscreen():
  ss = savescreen()
  clrscr()
  writexy(1,1,15,'Keyboard Shortcuts...')
  writexy(1,3,7,'CTRL + SHIFT + F  : Cycle font')
  
  #key = None
  #while key not in (blt.TK_RETURN,blt.TK_KP_ENTER): key = blt.read()
  readkey()
  
  restorescreen(ss)  
  
def indexofcolor(clv):
  tmp = 0
  for i in range(16):
    if blt_fgcolors[i] == clv:
      return i
  return 0
  
def indexofbgcolor(clv):
  tmp = 0
  for i in range(16):
    if blt.color_from_argb(color_pal[i*4],color_pal[i*4+1],color_pal[i*4+2],color_pal[i*4+3]) == clv:
      return i
  return 0
  
def delay(t):
  time.sleep(t/ 1000.0)

def colorof(i):
  return blt.color_from_argb(color_pal[i*4],color_pal[i*4+1],color_pal[i*4+2],color_pal[i*4+3])
  
def colorof2(i):
  return blt.color_from_name(str(color_pal[i*4])+','+str(color_pal[i*4+1])+','+str(color_pal[i*4+2])+','+str(color_pal[i*4+3]))
  
def shutdown():
  blt.close()
  
def clrscr():
  blt.clear()
  blt.refresh()
  
def clreol():
  global wherex,wherey
  write(' '*(80-wherex+1))
  wherex = 1
  wherey += 1
  if wherey > 25:
    wherey = 1
  
def textcolor(i):
  global textattr
  blt.color(blt.color_from_argb(color_pal[i*4],color_pal[i*4+1],color_pal[i*4+2],color_pal[i*4+3]))
  #blt.color(color_pal[i])
  textattr = i + ((textattr // 16) * 16)

def textbackground(i):
  global textattr
  blt.bkcolor(blt.color_from_argb(color_pal[i*4],color_pal[i*4+1],color_pal[i*4+2],color_pal[i*4+3]))
  #blt.bkcolor(color_pal[i])
  textattr = (textattr % 16) + (i * 16)
  
def settextattr(a):
  global textattr
  textattr = a
  attr2color(a)
  
def readkey():
  blt.refresh()
  blt.set("input.filter={keyboard}")
  while True:
    key = blt.read()
    if key != None:
      break
  return key
  
def state(btn):
  return blt.state(btn)
  
def systemkeys(key):
  global font_hintings
  global font_hinting
  global font_size
  global cell_width
  global cell_height
  global font_index
  global font_name
  if key == blt.TK_LEFT and blt.state(blt.TK_CONTROL) and cell_width  > 4:
    cell_width -= 1
    setup_cellsize()
  elif key == blt.TK_RIGHT and blt.state(blt.TK_CONTROL) and cell_width  < 24:
    cell_width += 1
    setup_cellsize()
  elif key == blt.TK_DOWN and blt.state(blt.TK_CONTROL) and cell_height  < 24:
    cell_height += 1
    setup_cellsize()
  elif key == blt.TK_UP and blt.state(blt.TK_CONTROL) and cell_height  > 4:
    cell_height -= 1
    setup_cellsize()
  elif key == blt.TK_EQUALS and blt.state(blt.TK_CONTROL) and font_size  < 64:
    font_size += 1
    font_name = './fonts/'+font_files[font_index]
    setup_font()
  elif key == blt.TK_MINUS and blt.state(blt.TK_CONTROL) and font_size > 4:
    font_size -= 1
    font_name = './fonts/'+font_files[font_index]
    setup_font()
  elif key == blt.TK_TAB:
    font_hinting = (font_hinting + 1) % len(font_hintings)
    font_name = './fonts/'+font_files[font_index]
    setup_font()
  elif (key == blt.TK_H) and blt.state(blt.TK_CONTROL) and blt.state(blt.TK_SHIFT): 
    helpscreen()
  elif (key == blt.TK_F) and (blt.state(blt.TK_CONTROL)) and blt.state(blt.TK_SHIFT): 
    font_index += 1
    if font_index > len(font_files)-1:
      font_index = 0
    font_name = './fonts/'+font_files[font_index]
    setup_font()  
  
def readkey2():
  global font_hintings
  global font_hinting
  global font_size
  global cell_width
  global cell_height
  global font_index
  global font_name
  blt.set("input.filter={keyboard}")
  while True:
    
    blt.refresh()
    key = blt.read()
  
    if key == blt.TK_LEFT and blt.state(blt.TK_CONTROL) and cell_width  > 4:
      cell_width -= 1
      setup_cellsize()
    elif key == blt.TK_RIGHT and blt.state(blt.TK_CONTROL) and cell_width  < 24:
      cell_width += 1
      setup_cellsize()
    elif key == blt.TK_DOWN and blt.state(blt.TK_CONTROL) and cell_height  < 24:
      cell_height += 1
      setup_cellsize()
    elif key == blt.TK_UP and blt.state(blt.TK_CONTROL) and cell_height  > 4:
      cell_height -= 1
      setup_cellsize()
    elif key == blt.TK_EQUALS and blt.state(blt.TK_CONTROL) and font_size  < 64:
      font_size += 1
      font_name = './fonts/'+font_files[font_index]
      setup_font()
    elif key == blt.TK_MINUS and blt.state(blt.TK_CONTROL) and font_size > 4:
      font_size -= 1
      font_name = './fonts/'+font_files[font_index]
      setup_font()
    elif key == blt.TK_TAB:
      font_hinting = (font_hinting + 1) % len(font_hintings)
      font_name = './fonts/'+font_files[font_index]
      setup_font()
    elif (key == blt.TK_H) and blt.state(blt.TK_CONTROL) and blt.state(blt.TK_SHIFT): 
      helpscreen()
    elif (key == blt.TK_F) and (blt.state(blt.TK_CONTROL)) and blt.state(blt.TK_SHIFT): 
      font_index += 1
      if font_index > len(font_files)-1:
        font_index = 0
      font_name = './fonts/'+font_files[font_index]
      setup_font()
    elif key == KEY_CLOSE or key == KEY_ESC:
      break
    
def refresh():
  blt.refresh()

def attr2color(a):
  textcolor(a % 16)
  textbackground(a // 16)
  
def writexy(x,y,a,s):
  attr2color(a)
  blt.puts(x-1,y-1,s)
  
def gotoxy(x,y):
  global wherex, wherey
  wherex = x
  wherey = y
  
def gotox(i):
  global wherex
  wherex = i
  
def write(s):
  global wherex, wherey,textattr
  if len(s)+wherex > 80:
    writexy(wherex,wherey,textattr,s[:81-wherex+1])
    wherey += 1
    if wherey > 25:
      wherey = 25
    writexy(1,wherey,textattr,s[80-wherex+1:])
    wherex = 80-wherex+2
  else:
    writexy(wherex,wherey,textattr,s)
    wherex += len(s)
    
def writeln(s):
  global wherex, wherey
  write(s)
  wherex = 1
  wherey += 1
  if wherey > 25:
    wherey = 1
    
def writepipe(txt):
    OldAttr = textattr
    
    width=len(txt)
    Count = 0

    while Count <= len(txt)-1:
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
    global wherex,wherey,textattr
    OldAttr = textattr
    OldX    = wherex
    OldY    = wherey

    gotoxy(x,y)
    settextattr(attr)

    Count = 0

    while Count <= len(txt)-1:
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
    
def gettextat(x,y):
  code = blt.pick(x-1, y-1, 0)
  if code == 0:
    return ' '
  else:
    return "%c" % (code)
    
def getattrat(x,y):
  color = blt.pick_color(x-1, y-1, 0)
  bkcolor = blt.pick_bkcolor(x-1, y-1, 0)
  #return color
  return indexofcolor(color)+indexofbgcolor(bkcolor)*16
  
  
def savescreen():
  screenlist = []
  for y in range(25):
    for x in range(80):
      screenlist.append(gettextat(x+1,y+1))
      screenlist.append(getattrat(x+1,y+1))
  return screenlist
  
def setattrat(x,y,a):
  ch = gettextat(x,y)
  writexy(x,y,a,ch)
  
def restorescreen(screenlist):
  for y in range(25):
    for x in range(80):
      attr2color(screenlist[1+(x*2)+(y*160)])
      blt.put(x,y,screenlist[(x*2)+(y*160)])
