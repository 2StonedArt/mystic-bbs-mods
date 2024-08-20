# coding: CP437

from mystic_bbs import *
import os
from collections import defaultdict

box1=('/','-','\\',':',':','\\','-','/',' ')
# Some keyboard code defines returned by input functions
KEY_UP      = chr(72)       
KEY_DOWN    = chr(80)
KEY_ESCAPE  = chr(27)
KEY_ENTER   = chr(13)
KEY_TAB     = chr(9)
KEY_LEFT    = chr(75)
KEY_RIGHT   = chr(77)
KEY_PGUP    = chr(73)
KEY_PGDN    = chr(81)
KEY_END     = chr(79)
KEY_HOME    = chr(71)
KEY_INS     = chr(82)
KEY_DEL     = chr(83)
KEY_BACK    = chr(8)
KEY_SPACE   = chr(32)
KEY_CTRLA   = chr(1)
KEY_CTRLB   = chr(2)
KEY_CTRLD   = chr(4)
KEY_CTRLE   = chr(5)
KEY_CTRLF   = chr(6)
KEY_CTRLG   = chr(7)
KEY_CTRLZ   = chr(26)
KEY_CTRLI   = chr(9)
KEY_CTRLJ   = chr(10)
KEY_CTRLM   = chr(13)
KEY_CTRLN   = chr(14)
KEY_CTRLO   = chr(15)
KEY_CTRLP   = chr(16)
KEY_CTRLQ   = chr(17)
KEY_CTRLR   = chr(18)
KEY_CTRLS   = chr(19)
KEY_CTRLT   = chr(20)
KEY_CTRLU   = chr(21)
KEY_CTRLX   = chr(24)

def cleararea(x1,y1,x2,y2,bg):
  for i in range(y2-y1):
    gotoxy(x1,y1+i)
    write(bg*(x2-x1+1))
    
def ansibox(x1,y1,x2,y2,box):
    gotoxy(x1,y1)
    write(box[0]+box[1]*(x2-x1-1)+box[2])
    gotoxy(x1,y2)
    write(box[5]+box[6]*(x2-x1-1)+box[7])
    for i in range(y2-y1-1):
        gotoxy(x1,y1+1+i)
        write(box[3]+' '*(x2-x1-1)+box[4])

def boxpopup(text,y,pause=True):
  d = len(text)
  d2 = d // 2
  textcolor(8)
  if d < 25:
    cleararea(26,y,54,y+3," ")
    ansibox(26,y,54,y+3,box1)
  else:
    cleararea(38-d2,y,42+d2,y+3," ")
    ansibox(38-d2,y,42+d2,y+3,box1)
  writexy(40-d2,y+1,15,text)
  if pause:
    writexy(28,y+2,7,'Press key to continue...|PN')

def shadow(x1,y1,x2,y2,attr):
  for i in range(y2-y1):
    writexy(x2+1,y1+1+i,attr,charxy(x2+1,y1+1+i)[0])
  for i in range(x2-x1):
    writexy(x1+2+i,y2+1,attr,charxy(x1+2+i,y2+1)[0])
        
def pause(visible=False):
  if not visible:
    write('|PN')
  else:
    write('|PA')

def writexy(x,y,a,s):
  gotoxy(x,y)
  textcolor(a)
  write(s)
  
def issysop():
  #if user['level'] >= getcfg()['sysopacs']:
  if access(getcfg()['sysopacs']):
    return True
  else:
    return False
     
def button(s,i=1):
  return '|00|23'+chr(221)+s[:i]+chr(222)+'|07|16'+s[i:]+' '
  
def clrscr(hide=True):
  if hide:
    write('|07|16|[0|CL')
  else:
    write('|07|16|[1|CL')
    
def dirslash(d):
  if d[-1:]!=os.sep:
    d = d+os.sep
  return d
  
def stripmci (strn):
  pos = strn.find("|")
  while pos != -1:
    strn = strn[:pos] + strn[pos+3:]
    pos = strn.find("|")
  return strn        
  
def mcilen(text):
  return len(stripmci(text))
  
def lpad(s,w,char):
  d = w + len(s) - mcilen(s)
  return str(s)[:d].ljust(d,char)
  
def writexyw(x,y,a,w,s,char=' ',align='left'):
  gotoxy(x,y)
  textcolor(a)
  if not s: s=''
  s=s[:w]
  if align.upper() == 'LEFT':
    write(s.ljust(w,char))
  elif align.upper() == 'RIGHT':
    write(s.rjust(w,char))
  else:
    write(s.center(w,char))
    
def writelist(lst,s):
  writexyw(lst[0],lst[1],lst[2],lst[3],s,' ',lst[4])
  
#xml to dict!
def etree_to_dict(t):
    d = {t.tag: {} if t.attrib else None}
    children = list(t)
    if children:
        dd = defaultdict(list)
        for dc in map(etree_to_dict, children):
            for k, v in dc.items():
                dd[k].append(v)
        d = {t.tag: {k:v[0] if len(v) == 1 else v for k, v in dd.items()}}
    if t.attrib:
        d[t.tag].update(('@' + k, v) for k, v in t.attrib.items())
    if t.text:
        text = t.text.strip()
        if children or t.attrib:
            if text:
              d[t.tag]['#text'] = text
        else:
            d[t.tag] = text
    return d
  
# vertical menu list class 
class mlist:
  x=1
  y=1
  w=10
  h=5
  done = False
  sort = False
  reverse = False
  sort_field = 'text'
  total = 0
  items = None
  selected = None
  top = 0
  selbar = 0
  cl_normal = 7 + 16
  cl_high   = 14 + 3*16
  cl_key_norm = 15 + 16
  cl_key_high = 11 + 3*16
  exitkeys = ''
  exitcode = ''
  itemcode = ''
  scrollbar = {"enable":True,"hichar":'#',"lochar":'|',"hiatt":7,"loatt":8}
  search_show = False
  search = ''
  searchx = x
  searchy = y+1
  searchw = w
  search_at= 8
  search_fmt = '::/ %s'
  onbaron = None
  onbaroff = None
  otherkeys = None
  
  def __init__(self):
    self.exitkeys=''    
    self.items = list()
    self.search = ''
    
  def additem(self,itm):
    self.items.append(itm)
    self.total = len(self.items)
    if self.sort:
      self.items = sorted(self.items, key = lambda i: (i[self.sort_field]),reverse=self.reverse)
  
  def updatebar(self):
    if self.scrollbar["enable"] == False: return
    for i in range(self.h):
      writexy(self.x+self.w-1,self.y+i,self.scrollbar["loatt"],self.scrollbar["lochar"])
    if len(self.items) < 2:
      fz = 0
    else:
      fz = ((self.top+self.selbar)*self.h) // (len(self.items)-1)
    if fz>self.h-1: fz = self.h-1
    writexy(self.x+self.w-1,self.y+fz,self.scrollbar["hiatt"],self.scrollbar["hichar"])
    
  def draw(self):
    if len(self.items)==0: return
    yy=0
    while yy<self.h and not shutdown():
      if self.top+yy<len(self.items):
        writexy(self.x,self.y+yy,self.cl_normal,lpad(self.items[self.top+yy]['text'],self.w,' '))
      else:
        writexy(self.x,self.y+yy,self.cl_normal,' '*self.w)
      yy+=1
      
  def deleteselected(self):
    for i in range(len(self.items)):
      if self.items[i]['text'] == self.items[self.top+self.selbar]['text']:
        del self.items[i]
        self.total-=1
        self.selbar = 0
        self.top = 0
        self.draw()
        self.bar_on
        writexy(1,1,14,'deleted')
        pause()
        break
        
  def bar_on(self):
    if len(self.items)==0: return
    writexy(self.x,self.y+self.selbar,self.cl_high,lpad(self.items[self.top+self.selbar]['text'],self.w,' '))
    self.selected = self.items[self.top+self.selbar]
    if self.onbaron:
      self.onbaron(self.items[self.top+self.selbar])
      
  def bar_off(self):
    if len(self.items)==0: return
    writexy(self.x,self.y+self.selbar,self.cl_normal,lpad(self.items[self.top+self.selbar]['text'],self.w,' '))
    if self.onbaroff:
      self.onbaroff(self.items[self.top+self.selbar])
      
  def sortlist(self):
    self.items = sorted(self.items, key = lambda i: (i['order'],i[self.sort_field]),reverse=self.reverse)
  
  def clear(self):
    del self.items[:]
    self.total=0  
    self.top=0
    self.selbar=0
    
  def dosearch(self):
    if len(self.items)<=0: return
    i = 1
    while i+self.top+self.selbar<len(self.items):
      if self.search.upper() in self.items[i+self.top+self.selbar]['text'].upper():
        self.top = i+self.top+self.selbar
        self.selbar = 0
        self.draw()
        self.bar_on()
        break
      i+=1 
  
  def show(self,x,y,w,h):
    
    self.done = False
    self.x = x
    self.y = y
    self.w = w
    self.h = h   
    
    res = None 
    
    self.draw()
    self.bar_on()
    
    while not self.done and not shutdown():
      self.updatebar()
      if self.search_show:
        writexy(self.searchx,self.searchy,self.search_at,lpad(self.search_fmt % self.search,self.searchw,' '))
      key, ext = getkey()
      if ext:
        if key == KEY_HOME:
          self.top = 0
          self.selbar = 0
          self.draw()
          self.bar_on()
        elif key == KEY_LEFT: 
          self.exitcode = '#left'
          if len(self.items)>0:
            res = self.items[self.top+self.selbar]
          else:
            res = None
          self.done = True
        elif key == KEY_RIGHT: 
          self.exitcode = '#right'
          if len(self.items)>0:
            res = self.items[self.top+self.selbar]
          else:
            res = None
          self.done = True
        elif key == KEY_END:
          self.top = ((len(self.items)) // self.h)*self.h
          self.selbar = len(self.items)-self.top-1
          if self.top == len(self.items):
            self.top = len(self.items)-self.h
            self.selbar = self.h-1
          self.draw()
          self.bar_on()
        elif key == KEY_CTRLG:
          self.dosearch()
        elif key == KEY_DOWN:
          if self.selbar + self.top < len(self.items)-1:
            if self.selbar == self.h-1:
              self.top += self.h
              self.selbar = 0
              self.draw()
              self.bar_on()
            else:
              self.bar_off()
              self.selbar += 1
              self.bar_on()
        elif key == KEY_UP:
          if self.top+self.selbar>0:
            if self.selbar == 0:
              self.top -= self.h 
              self.selbar = self.h-1
              self.draw()
              self.bar_on()
            else:
              self.bar_off()
              self.selbar -= 1
              self.bar_on()
        elif key == KEY_PGDN:
          if self.selbar + self.top + h < len(self.items):
            self.top += self.h
          else:
            self.top = ((len(self.items)) // self.h)*self.h
            self.selbar = len(self.items)-self.top-1
            if self.top == len(self.items):
              self.top = len(self.items)-self.h
              self.selbar = self.h-1
          self.draw()
          self.bar_on()
        elif key == KEY_PGUP:
          if self.selbar + self.top - self.h > 0:
            self.top -= self.h
          else:
            self.top = 0
            self.selbar = 0
          self.draw()
          self.bar_on()
        elif key in self.exitkeys:
          self.exitcode = key
          if len(self.items)>0:
            res = self.items[self.top+self.selbar]
          else:
            res = None
          self.done = True
        else:
          if self.otherkeys:
            self.otherkeys(True,key)
            if len(self.items)>0:
              res = self.items[self.top+self.selbar]
            else:
              res = None
      else:
        if key == KEY_ESCAPE: 
          self.exitcode = '#esc'
          self.done = True
        elif key == KEY_CTRLG and self.search_show:
          if len(self.search)>0:
            self.dosearch()
        elif key == KEY_BACK:
          if len(self.search)>0:
            self.search = self.search[:-1]
        elif key == KEY_ENTER:
          self.exitcode = '#enter'
          if len(self.items)>0:
            res = self.items[self.top+self.selbar]
          else:
            res = None
          self.done = True
        elif key == KEY_CTRLF:
          self.search = ''
          writexy(self.searchx,self.searchy,self.search_at,lpad(self.search_fmt % self.search,self.searchw,' '))
        elif key in self.exitkeys:
          self.exitcode = key
          if len(self.items)>0:
            res = self.items[self.top+self.selbar]
          else:
            res = None
          self.done = True
        elif ord(key)>32 and ord(key)<126 and self.search_show:
          self.search += key
          self.dosearch()
        else:
          if self.otherkeys:
            self.otherkeys(False,key)
            if len(self.items)>0:
              res = self.items[self.top+self.selbar]
            else:
              res = None
    return res
