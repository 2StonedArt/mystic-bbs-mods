# coding: CP437

# Written by XQTR of Another Droid BBS
# telnet: andr01d.zapto.org:9999
# web   : andr01d.zapto.org:8080
# gopher: andr01d.zapto.org:7070

# The code is written under the GPL3 license, which is included in the package
# If you use the code, mention it in your project!!!!

from mystic_bbs import *
import struct
import os
from time import sleep

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


class ansiviewer():

  maxwidth = 160
  width = 80
  bottom = 0
  maxheight = 1000
  filename = ''
  speed = 0.1
  screenwidth=80
  screenheight=25
  top = 0
  left = 0
  
  x1 = 1
  x2 = 80
  y1 = 1
  y2 = 25
  h = 25
  w = 80
  
  attr_title = 30
  attr_bold = 31
  attr_normal = 23
  attr_fade = 24
  
  progress = True
  progress_attr = 30
  progress_posx = 75
  progress_posy = 25
  
  statusbar = True
  statusbar_attr = 31
  statusbar_posx = 1
  statusbar_posy = 25
  statusbar_width = 79
  statusbar_str = 'H:Help | %w x %h | ICE:%ice | SAUCE:%sauce | Speed:%speed'
  sb = ''  #temp var for statusbar
  
  txt_customwidth = '|15|17Enter custom width: '
  

  def __init__(self,ansifilename):
    self.sauce = list()
   
    self.matrixchar = [[' ' for x in range(self.maxwidth)] for y in range(self.maxheight)] 
    self.matrixattr = [[7 for x in range(self.maxwidth)] for y in range(self.maxheight)]
       
    self.screenwidth,self.screenheight = termsize()
    self.filename = ansifilename
    self.sauce=self.getsauce(self.filename)
    if self.sauce:
      if self.sauce['datatype']==1 and self.sauce['filetype'] in range(2):
        if self.sauce['width']<>0:
          self.width = self.sauce['width']
        if self.sauce['height']<>0:
          self.bottom = self.sauce['height']
          
    self.loadansi()
    self.speed = 0.1
    self.top = 0
    self.left = 0
    self.x1 = 1
    self.x2 = 80
    self.y1 = 1
    self.y2 = 25
    self.h = 25
    self.w = 80
    self.initstatusbar()
    
  def drawstatusbar(self):
    if not self.statusbar: return
  
    self.writexy(self.statusbar_posx,self.statusbar_posy,self.statusbar_attr, \
    self.sb.ljust(self.statusbar_width,' '))
    
  def initmatrix(self):
    del self.matrixchar[:]
    del self.matrixattr[:]
    
    self.matrixchar = [[' ' for x in range(self.maxwidth)] for y in range(self.maxheight)] 
    self.matrixattr = [[7 for x in range(self.maxwidth)] for y in range(self.maxheight)]
    
    self.initstatusbar()
    
  def initstatusbar(self):
    self.sb = self.statusbar_str
    self.sb=self.sb.replace('%w',str(self.width))
    self.sb=self.sb.replace('%h',str(self.bottom))
    self.sb=self.sb.replace('%speed',str(self.speed))
    self.sb=self.sb.replace('%scrwidth',str(self.screenwidth))
    self.sb=self.sb.replace('%scrheight',str(self.screenheight))
    if self.sauce:
      self.sb=self.sb.replace('%sauce','True')
      self.sb=self.sb.replace('%title',self.sauce['title'])
      self.sb=self.sb.replace('%group',self.sauce['group'])
      self.sb=self.sb.replace('%author',self.sauce['author'])
      self.sb=self.sb.replace('%date',self.sauce['date'])
      self.sb=self.sb.replace('%width',str(self.sauce['width']))
      self.sb=self.sb.replace('%height',str(self.sauce['height']))
      self.sb=self.sb.replace('%ice',str(self.sauce['blink']))
      self.sb=self.sb.replace('%spacing',str(self.sauce['spacing']))
      self.sb=self.sb.replace('%aspect',str(self.sauce['aspect']))
    else:
      self.sb=self.sb.replace('%sauce','False')
      self.sb=self.sb.replace('%title','None')
      self.sb=self.sb.replace('%group','None')
      self.sb=self.sb.replace('%author','None')
      self.sb=self.sb.replace('%date','--/--/--')
      self.sb=self.sb.replace('%width',str(self.width))
      self.sb=self.sb.replace('%height',str(self.bottom))
      self.sb=self.sb.replace('%ice','Unknown')
      self.sb=self.sb.replace('%spacing','Unknown')
      self.sb=self.sb.replace('%aspect','Unknown')
      
  def changestatusbartext(self,text):
    self.statusbar_str = text
    self.initstatusbar()
    
  def isbitset(self,n, k): #n: the number, k:the bit to check
    if n & (1 << (k - 1)):
        return True
    else:
        return False

  def getsauce(self,filename):
    if os.path.getsize(filename)<130: return None
    f = open(filename, 'rb')
    f.seek(-128,2)
    saucestr = "<5s2s35s20s20s8sisshhhhcc22s"
    sf = struct.calcsize(saucestr)
    saucedata = f.read(sf)
    s = struct.unpack(saucestr,saucedata)
    
    if ''.join(str(s[0]).strip("b'")) == "SAUCE":
      res = dict()
      res['title']=s[2]
      res['author']=s[3]
      res['group']=s[4]
      res['date']=s[5]
      res['size']=s[6]
      res['datatype']=ord(s[7])
      res['filetype']=ord(s[8])
      res['width']=s[9]
      res['height']=s[10]
      res['info3']=s[11]
      res['info4']=s[12]
      res['comments']=int(ord(s[13]))
      res['flags']=ord(s[14])
      res['infos']=s[15].strip(chr(0))
      
      if res['comments']<>0:
        f.seek(-128-(res['comments']*64)-5,2)
        commentid = f.read(5)
        print commentid
        if commentid == 'COMNT':
          for a in range(int(res['comments'])):
            cmnt=f.read(64)
            res['comment'+str(a)]=cmnt.strip(chr(0))
      f.close()
      
      if self.isbitset(res['flags'],1):
        res['blink']=True
      else:
        res['blink']=False
        
      if self.isbitset(res['flags'],2) and self.isbitset(res['flags'],3): res['spacing']='Invalid'
      if self.isbitset(res['flags'],2) and not self.isbitset(res['flags'],3): res['spacing']='8px'
      if self.isbitset(res['flags'],2)==False and self.isbitset(res['flags'],3): res['spacing']='9px'
      if self.isbitset(res['flags'],2)==False and self.isbitset(res['flags'],3)==False: res['spacing']='Legacy'
      
      if self.isbitset(res['flags'],4) and self.isbitset(res['flags'],5): res['aspect']='Invalid'
      if self.isbitset(res['flags'],4) and not self.isbitset(res['flags'],5): res['aspect']='Legacy'
      if self.isbitset(res['flags'],4)==False and self.isbitset(res['flags'],5): res['aspect']='Modern'
      if self.isbitset(res['flags'],4)==False and self.isbitset(res['flags'],5)==False: res['aspect']='Legacy'
      
      
      return res
    else:
      return None
    
    
  def loadansi(self):
    eof = 0
    self.top = 0
    self.sauce=self.getsauce(self.filename)
    if self.sauce:
      if self.sauce['datatype']==1 and self.sauce['filetype'] in range(2):
        if self.sauce['width']<>0:
          self.width = self.sauce['width']
        if self.sauce['height']<>0:
          self.bottom = self.sauce['height']
    
    
    if self.sauce:
      if self.sauce['comments']<>0: 
        eof = -129-(self.sauce['comments']*64)-6
      else:
        eof = -129
        
    ansifg = range(30,38)
    ansibg = range(40,48)
    colid = [0,4,2,6,1,5,3,7]
    oldxy = [0,0]
    fg = 7
    bg = 16
    fattr = 7
    esc = False
    opt = ''
    tmp = ''
    x,y = 0,0
    self.bottom = 0
    mode = 0

    if not os.path.isfile(self.filename):
      write("File doesn't exist.")
      return
      
    fn = open(self.filename,'rb')
    fn.seek(eof,2) # move the cursor to the end of the file
    eof = fn.tell()
    fn.seek(0,0)
    fpos = 0
    fbuf = 0
    while fpos<=eof and not shutdown():
      fbuf = fn.read(1)
      fpos+=1
      if esc:
        tmp = ''
        esc = False
        while fbuf not in ['A','B','C','D','E','F','G','l','N','O','P','m','s','u','J','H','f','h','t']: 
          fbuf = fn.read(1)
          fpos+=1
          tmp += fbuf
        
        if 't' in tmp:
          pass
        elif 'A' in tmp: #up
          tmp = tmp[:-1]
          if tmp:
            y -= int(tmp)
          else:
            y -= 1
        elif 'B' in tmp: #down
          tmp = tmp[:-1]
          if tmp:
            y += int(tmp)
          else:
            y += 1
          if self.bottom<y: self.bottom=y
        elif 'C' in tmp: #right
          tmp = tmp[:-1]
          if tmp:
            offset = int(tmp)
          else:
            offset = 1
            
          if x+offset > self.width-1:
            x = (x + offset) - self.width-1
            y+=1
            if y>self.maxheight: y=self.maxheight
          else:
            x+=offset
                     
        elif 'D' in tmp: #left
          tmp = tmp[:-1]
          if tmp:
            x -= int(tmp)
          else:
            x -= 1
        elif 's' in tmp: # save cursor position
          oldxy = [x,y]
        elif 'u' in tmp: # restore cursor position
          [x,y]=oldxy
        elif 'J' in tmp:  #clear screen?
          x = 0
          y = 0
        elif 'l' in tmp:
          pass
        elif 'K' in tmp: #clear EOL
          for i in range(x,self.width):
            self.matrixchar[y][i]=' '
            self.matrixattr[y][i]=fattr
          #x = 0   # does it need to move the cursor?
          #y += 1
        elif 'H' in tmp or 'f' in tmp: #gotoxy
          tmp = tmp[:-1]
          if len(tmp)==0:
            x,y = [0,0]
          else:
            k=tmp.split(';')
            x=int(k[0])-1
            y=int(k[1])-1
        elif 'm' in tmp: # colors and mode
          tmp = tmp[:-1]
          
          codes=tmp.split(';')
          for code in codes:
            num = int(code)
            if num == 0:
              mode = 0 # reset
              fg = 7
              bg = 0
              fattr = 7
            elif num == 1: #hilight
              mode = 1
              fattr = fattr | 0x8
              fg = fattr % 16
              bg = fattr // 16
            elif num == 5: # blink?
              mode = 5
              fattr = fattr | 0x80
              fg = fattr % 16
              bg = fattr // 16
            elif num == 7:
              mode = 7  #reverse
              tmpcl = fg
              fg = bg
              bg = tmpcl
              if bg > 7: bg -=8
              fattr = fg+bg*16
            elif num == 8: #reset?
              fg = 7
              bg = 0
              fattr = 7
            elif num in ansifg:
              fg = colid[ansifg.index(num)]
              if mode==1: fg+=8
              fattr = fg+bg*16
            elif num in ansibg:
              bg = colid[ansibg.index(num)]
              fattr = fg+bg*16

        tmp = ''
      else:
        if fbuf == chr(27):  #esc
          esc = True
        elif fbuf == chr(9):
          x+=4
          if x>self.width-1: x=self.width-1
        elif fbuf == chr(13):
          x = 0
        elif fbuf == chr(10): #new line //LF
          x = 0
          y +=1
          if self.bottom<y: self.bottom=y
          if y>self.maxheight-1: y=self.maxheight-1
        else:  #we have a char to display!!!
          try:
            if fbuf<>chr(0):
              self.matrixchar[y][x]=fbuf
            else:
              self.matrixchar[y][x]=' '
            self.matrixattr[y][x]=fg+(bg*16)
            x+=1
            if x>self.width-1 or x>self.maxwidth-1:
              x=0
              y+=1
              if y>self.bottom: self.bottom=y
              if y>self.maxheight-1: y=self.maxheight-1
              
          except:
            #it shouldn't raise anything, but just in case
            self.writexy(1,1,12,'Exception on pos: '+str(x)+' x '+str(y)+'|PA')
            break
    
    fn.close()
    
  def scroll(self):  #the space bar scroller, like mystics default one
    write('|07|16|CL')
    y = 0
    xw=80
    if self.width>self.screenwidth:xw=self.screenwidth
    
    while y<self.bottom:
      for x in range(xw):
        self.writexy(x,y,self.matrixattr[y][x],self.matrixchar[y][x])
        if keypressed(): return
      sleep(self.speed)
      write('|CR')
      y+=1
    write('|PA')
  
  def writexy(self,x,y,a,s):
    gotoxy(x,y)
    textcolor(a)
    write(s)
    
  def drawansi(self): # draw the visible area to the screen
    for y in range(self.y2-self.y1+2):
      for x in range(self.x2-self.x1+1):
        self.writexy(self.x1+x,self.y1+y,self.matrixattr[y+self.top][x+self.left],self.matrixchar[y+self.top][x+self.left])

  def moverightside(self): # move the visible window area
    self.left = self.width-self.w
    
  def moveleftside(self):
    self.left = 0
    
  def movehome(self):
    self.top = 0
    
  def moveend(self):
    self.top = self.bottom-self.h+1
    if self.top<0: self.top = 0
    
  def movepgup(self):
    self.top-=self.h
    if self.top<0: self.top = 0
    
  def movepgdn(self):
    self.top+=self.h
    if self.top+self.h>self.bottom: self.top = self.bottom-self.h+1
    
  def movedown(self):
    self.top+=1
    if self.bottom<self.h:
      self.top =0
    elif self.top+self.h>self.bottom:
      self.top = self.bottom-self.h+1
    
  def moveup(self):
    self.top -=1
    if self.top<0: self.top=0
  
  def moveleft(self):
    self.left-=1
    if self.left<0: self.left=0
    
  def moveright(self):
    self.left+=1
    if self.left+self.w>self.width:
      self.left = self.width-self.w
            
  def cleararea(self,x1,y1,x2,y2,bg):
    for i in range(y2-y1+1):
      gotoxy(x1,y1+i)
      write(bg*(x2-x1+1))

  def displayansi(self,wx1,wy1,wx2,wy2):
    if wx1>self.screenwidth or wx2>self.screenwidth or wy1>self.screenheight or wy2>self.screenheight:
      write('|13Display window, dimensions are bigger than the screen res.|CR|PA')
      return
      
    self.speed = 0.1
    self.top = 0
    self.left = 0
    
    self.x1 = wx1
    self.x2 = wx2
    self.y1 = wy1
    self.y2 = wy2
    
    self.w = wx2-wx1+1
    self.h = wy2-wy1+1
    
    def showhelp(self): # i don't like this help screen... but it'll do for now
      textcolor(self.attr_normal)
      self.cleararea(wx1,wy1,wx2,wy2,' ')
      d=0
      self.writexy(wx1,wy1+d,self.attr_title,  ' -- Keyboard Shortcuts --')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' X: |07Download Image')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' W: |07Set Custom Width')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' 6: |07Force Width to 160c')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' 8: |07Force Width to 80c')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' 3: |07Force Width to 132c')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' P: |07Show/Hide Progress Per.')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' I: |07Show/Hide SAUCE Info')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' S: |07Show/Hide Status Bar')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_title,  ' -- Navigation --')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' [: |07Start of line')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' ]: |07End of line')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' SPACE: |07Scroll Image')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' +/-: |07Increase/Decrease Scrolling Speed')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  ' Home/End/PGUP/PGDN as normal')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_fade,'Press key to continue...|PN')
      
    
    def showsauce(self):
      if not self.sauce: return
      textcolor(23)
      self.cleararea(wx1,wy1,wx2,wy2,' ')
      d=0
      self.writexy(wx1,wy1,self.attr_title,  ' -- SAUCE Info --')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,  'Title : |07'+self.sauce['title'])
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,'Author: |07'+self.sauce['author'])
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,'Group : |07'+self.sauce['group'])
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,'Date  : |07'+self.sauce['date'])
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,'Size  : |07'+str(self.sauce['width'])+'|08x|07'+str(self.sauce['height']))
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,'Font  : |07'+self.sauce['infos'])
      d+=1
      self.writexy(wx1,wy1+d,self.attr_title,' -- Flags --')
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,'Blink    : |07'+str(self.sauce['blink']))
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,'Spacing  : |07'+self.sauce['spacing'])
      d+=1
      self.writexy(wx1,wy1+d,self.attr_normal,'Aspect   : |07'+self.sauce['aspect'])
      d+=1
      try:
        if self.sauce['comments']<>0:
          self.writexy(wx1,wy1+d,self.attr_title,'-- Comments --')
          for a in range(self.sauce['comments']):
            d+=1
            self.writexy(wx1,wy1+d,self.attr_normal,self.sauce['comment'+str(a)])
        d+=1  
      except:
        self.writexy(wx1,wy1+d,self.attr_fade,'Error in getting comment(s)')
        d+=1
      self.writexy(wx1,wy1+d,self.attr_fade,'Press key to continue...|PN')
    
    
    while True:
      self.drawansi()
      self.drawstatusbar()
      
      if self.progress:
        per = (self.top+self.h)*100//self.bottom
        if per>100: per = 100
        self.writexy(self.progress_posx,self.progress_posy,self.progress_attr,str(per).rjust(3,' ')+'%')
      
      key,ext = getkey()
      if ext:
        if key == KEY_LEFT:
          self.moveleft()
        elif key == KEY_RIGHT:
          self.moveright()
        elif key == KEY_UP:
          self.moveup()
        elif key == KEY_DOWN:
          self.movedown()
        elif key == KEY_PGUP:
          self.movepgup()
        elif key == KEY_PGDN:
          self.movepgdn()
        elif key == KEY_HOME:
          self.movehome()
        elif key == KEY_END:
          self.moveend()
      else:
        key = key.upper()
        if key == KEY_ESCAPE:
          break
        elif key == 'W':
          gotoxy(wx1,wy2)
          write(self.txt_customwidth)
          customwidth = getstr(20,3,3,str(self.width))
          if customwidth:
            self.top,self.left = 0,0
            self.width = int(customwidth)
            self.initmatrix()
            self.loadansi()
        elif key == 'X':
          menucmd('F3',self.filename)
        elif key == 'S':
          self.statusbar = not self.statusbar
        elif key == 'P':
          self.progress = not self.progress
        elif key == 'H':
          showhelp(self)
        elif key == 'I':
          showsauce(self)
        elif key == ' ':
          self.scroll()
        elif key == '+':
          self.speed += 0.05
          self.initstatusbar()
        elif key == '-':
          self.speed -= 0.025
          if self.speed<0:self.speed = 0
          self.initstatusbar()
        elif key == ']':
          self.moverightside()
        elif key == '[':
          self.moveleftside()
        elif key == '6':
          self.top,self.left = 0,0
          self.width = 160
          self.initmatrix()
          self.loadansi()
        elif key == '8':
          self.top,self.left = 0,0
          self.width = 80
          self.initmatrix()
          self.loadansi()
        elif key == '3':
          self.top,self.left = 0,0
          self.width = 132
          self.initmatrix()
          self.loadansi()
        
'''
#The easiest way to use:
av = ansiviewer('/home/mystic/themes/default/text/logoff.ans')
av.changestatusbartext('this was made by %author')
av.displayansi(1,1,80,24)
'''
# Read the sysop.txt file for more information
