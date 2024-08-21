
from mystic_bbs import *

def writexy(x,y,a,s):
  gotoxy(x,y)
  textcolor(a)
  write(s)

class mform:
  items = list()
  cl_normal = 7
  cl_high = 14+16
  cl_edit_normal = 7
  cl_edit_high = 15
  cl_editing = 14+1*16
  cl_key_norm = 15
  cl_key_high = 11+16
  results = dict()
  index = 0
  changed = False
  ch_pass = '$'
  
  '''
  type of input string
  --------------------
  1	Standard input.	All characters allowed.
  2	Upper case input.	Allows all characters, but will convert any lower case letters into upper case.
  3	Proper input.	Allows all characters, but will convert the first letter in each word to an upper case letter.
  4	Phone input.	Allows only numbers and will pre-format them using the USA-style phone numbers. IE: XXX-XXX-XXXX. Note that the length of this input should always be 12, as that is the length of the USA phone number format.
  5	Date input.	Allows only numbers and will pre-format them using the date format (ie XX/XX/XX) that is currently selected by the user. NOTE: The date input will always return the date in the MM/DD/YY format, regardless of what format the user has selected. For example, if the user has selected the DD/MM/YY format, Input will expect the user to enter the date in that format, but will then convert it to MM/DD/YY when it returns the date back to the MPE program.
  6	Password input.	Allows all characters, but will convert any lower case letters into upper case. The character that is typed is NOT echoed to the screen. Instead, it is replaced by the * character so that what they have entered will not be shown on the screen.
  7	Lower case input.	Allows all characters, but will convert any lower case letters into upper case.
  8	User Defined.	User name format from sys config
  9	Standard Input w/o CRLF	Will not append CRLF to input
  10	Numeric Input.
  
  11 : List value picker. You have to set the fields variable. This option will
       display the values from the list and every time the user presses enter
       the value changes.
  
  '''
  
  
  def __init__(self):
    pass
    
  def additem(self, typeof,tx,ty,tw,title,vx,vy,vw,vmax,value,key,code,fields=[]):
    item = dict()
    item['titlex']=tx
    item['titley']=ty
    item['title_width']=tw
    item['title']=title
    item['valuex']=vx
    item['valuey']=vy
    item['value_width']=vw
    item['value_max']=vmax
    item['value']=value
    item['key']=key
    item['code']=code
    item['type']=typeof
    item['fields']=fields
    item['findex']=0
    self.items.append(item)
    if typeof==11:
      self.results[code] = fields[0]
    else:
      self.results[code] = value

  def stripmci (self,strn):
    pos = strn.find("|")
    while pos != -1:
      strn = strn[:pos] + strn[pos+3:]
      pos = strn.find("|")
    return strn        
  
  def mcilen(self,text):
    return len(self.stripmci(text))
  
  def lpad(self,s,w,char):
    d = w + len(s) - self.mcilen(s)
    return str(s)[:d].ljust(d,char)
    
  def drawitem_norm(self,item):
    writexy(item['titlex'],item['titley'],self.cl_normal,self.lpad(item['title'],item['title_width'],' '))
    if item['type']==6:
      writexy(item['valuex'],item['valuey'],self.cl_edit_normal,self.lpad('',item['value_width'],self.ch_pass))
    else:
      writexy(item['valuex'],item['valuey'],self.cl_edit_normal,self.lpad(self.results[item['code']],item['value_width'],' '))
    i = item['title'].find(item['key'])
    writexy(item['titlex']+i,item['titley'],self.cl_key_norm,item['key'])
    
  def drawitem_high(self,item):
    writexy(item['titlex'],item['titley'],self.cl_high,self.lpad(item['title'],item['title_width'],' '))
    if item['type']==6:
      writexy(item['valuex'],item['valuey'],self.cl_edit_high,self.lpad('',item['value_width'],self.ch_pass))
    else:
      writexy(item['valuex'],item['valuey'],self.cl_edit_high,self.lpad(self.results[item['code']],item['value_width'],' '))
    i = item['title'].find(item['key'])
    writexy(item['titlex']+i,item['titley'],self.cl_key_high,item['key'])
  
  def drawall(self):
    for item in self.items:
      self.drawitem_norm(item)
      
  def getinput(self,index):
    textcolor(self.cl_editing)
    writexy(self.items[index]['valuex'],self.items[index]['valuey'],self.cl_editing,' '*self.items[index]['value_width'])
    if self.items[index]['type']==11:
      self.items[index]['findex']+=1
      if self.items[index]['findex'] > len(self.items[index]['fields'])-1:
        self.items[index]['findex']=0
      r = self.items[index]['fields'][self.items[index]['findex']]
    else:
      gotoxy(self.items[index]['valuex'],self.items[index]['valuey'])
      r = getstr(self.items[index]['type'],self.items[index]['value_width'],self.items[index]['value_max'],self.results[self.items[self.index]['code']])
      if not r: r = ''
      if r<>self.results[self.items[self.index]['code']]: self.changed = True
    self.results[self.items[index]['code']] = r
              
  def show(self):
    done = False
    while not done and not shutdown():
      self.drawitem_high(self.items[self.index])
      key,ext = getkey()
      
      if ext:
        self.drawitem_norm(self.items[self.index])
        if key == chr(72) or key == chr(75): #up or left
          self.index -= 1
          if self.index<0:
            self.index = len(self.items)-1
        elif key == chr(80) or key == chr(77): #down or right
          self.index += 1
          if self.index == len(self.items):
            self.index = 0
        elif key == chr(79): #end
          self.index = len(self.items)-1
        elif key == chr(71): #home
          self.index = 0
        self.drawitem_high(self.items[self.index])
      else:
        if self.items[self.index]['type']==11:
          if key == chr(32): #Space
            self.getinput(self.index)
            self.drawitem_high(self.items[self.index])
          elif key == chr(13): #enter
            done = True
        else:
          if key == chr(27): #esc
            done = True
          elif key == chr(13): #enter
            self.getinput(self.index)
            self.drawitem_high(self.items[self.index])
          else:
            for i in range(len(self.items)):
              if key.upper() == self.items[i]['key']:
                self.drawitem_norm(self.items[self.index])
                self.index = i
                self.drawitem_high(self.items[self.index])
                break

'''
#EXAMPLE
  
write('|07|16|CL')
tform = mform()
tform.additem(6,5,5,10,'Name:',5,6,30,30,'|UN','N','code')
tform.additem(10,5,7,10,'SurName',20,7,8,8,'MySurName','S','surcode')
tform.additem(11,5,10,10,'Gender',20,10,8,8,'Male','G','gender',['Male','Female','Android'])
tform.drawall()
tform.show()
gotoxy(1,24)

'''
