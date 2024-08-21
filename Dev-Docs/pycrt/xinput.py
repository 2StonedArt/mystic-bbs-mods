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

from pycrt import *
from datetime import datetime

scrollbar = {"enable":True,"hichar":"▓","lochar":"░","hiatt":7,"loatt":8}
exit_keys = []
exit_code = ""


cs_numbers = " 1234567890"
cs_phone = " 1234567890#+-/"
cs_upper = " QWERTYUIOPASDFGHJKLZXCVBNM"
cs_lower = " qwertyuiopasdfghjklzxcvbnm"
cs_symbols = " ~-=!@#$%^&*()_+[]}{;:'\"\|,<.>/?"
cs_printable = cs_lower+cs_upper+cs_symbols+cs_numbers
cs_email = cs_numbers+cs_lower+cs_upper+"@."
cs_email = cs_email.replace(" ", "")
cs_www = cs_numbers+cs_upper+cs_lower+"/-.:"

def datevalid(date_text):
    try:
        if date_text != datetime.strptime(date_text, "%Y%m%d").strftime('%Y%m%d'):
            raise ValueError
        return True
    except ValueError:
        return False

def inputdate(x,y,att,fillatt,default):
    """
    Function to input a valid date string
    att: foreground color
    fillatt : background color, displays default value
    """
    global exit_keys
    global exit_code
    key = ""
    dt = datetime.fromtimestamp(default)
    dtstr = dt.strftime('%Y/%m/%d')
    year = ""
    month = ""
    day = ""
    val = ""
    pos = 0
    changed = False
    valid = False

    while True:
        if (key == "#enter") and (datevalid(year+month+day)==True):
            break
        
        writexy(x,y,fillatt,dtstr)
        writexy(x,y,att,year)
        writexy(x+5,y,att,month)
        writexy(x+8,y,att,day)
        key = readkey()
        changed = True
        if key in cs_numbers:
            if len(val)<4:
                year = year + key
            elif len(val)<6:
                if len(val)==4 and key in "01":
                    month = month + key
                if len(val)==5:
                    if val[4]=="1" and key in "012":
                        month = month + key
                    elif val[4]=="0":
                        month = month + key
            elif len(val)<8:
                if len(val)==6 and key in "0123":
                    day = day + key
                if len(val)==7:
                    if val[6]=="3" and key in "01":
                        day = day + key
                    elif val[6] in "012":
                        day = day + key
        elif key == "#back":
            if len(val)>6 and len(val)<9:
                day = day[:-1]
            if len(val)>4 and len(val)<7:
                month = month[:-1]
            if len(val)>0 and len(val)<5:
                year = year[:-1]
        elif key in exit_keys:
            exit_code = key
            break
        val = year+month+day
        
    if changed and len(val)==8:
        date_time_obj = datetime.strptime(val, '%Y%m%d')
        return str(datetime.timestamp(date_time_obj))
    else:
        return str(default)
            
def toggle(x,y,att,items,length,toggle_keys,accept_key):
    """
    Gets a list of items and toggles between them with toggle_keys, until
    the accept_key is pressed. see the pycrt.py file for key codes
    """
    global exit_code
    global exit_keys
    exit_code =""
    r = 0
    key = ""
    while key != accept_key:
        writexy(x,y,att,items[r].ljust(length,' '))
        key = readkey()
        if key in toggle_keys:
            r = r + 1
            if r > len(items)-1:
                r = 0
        elif key in exit_keys:
            exit_code = key
            break
    return items[r]

def input(x,y,att,fillatt,chars,length,maxc,fc,default):
    """
    Simple function to get an input from user
    att    : fg color
    fillatt: bg color
    chars  : string with valid characters.
    length : length for the input box
    maxc   : maximum size for the string to be entered
    fc     : fill character for the bg
    default: default value
    """
    global exit_keys
    global exit_code
    exit_code =""
    pos = 0
    res = default
    key = ""
    while key != "#enter":
        swritexy(x,y,fillatt,fc*length)
        #writexy(x,y,fillatt,fc*length)
        writexy(x,y,att,res[pos:length+pos])
        gotoxy(x+len(res[pos:length+pos]),y)
        key = readkey()
        if key in chars:
            res = res + key
            if len(res)>length:
                if len(res)<maxc:
                    pos += 1
        elif key == "#space":
            res = res + " "
            if len(res)>length:
                if len(res)<maxc:
                    pos += 1
        elif key == "#back":
            res = res[:-1]
            pos = pos - 1
            if pos < 0:
                pos = 0
        elif key == "#ctrly":
            res = ""
        elif key == "#enter":
            exit_code = "#enter"
        elif key in exit_keys:
            exit_code = key
            swritexy(x,y,fillatt,fc*length)
            writexy(x,y,fillatt,res[:length])
            return res
            break
    swritexy(x,y,fillatt,fc*length)
    writexy(x,y,fillatt,res[:length])
    return res

def passinput(x,y,att,fillatt,chars,length,maxc,fc,pc,default):
    """
    Same as above but for password input
    att    : fg color
    fillatt: bg color
    chars  : string with valid characters.
    length : length for the input box
    maxc   : maximum size for the string to be entered
    fc     : fill character for the bg
    pc     : character to show, for the password, instead of actual char.
    default: default value
    """
    global exit_keys
    global exit_code
    exit_code =""
    pos = 0
    res = default
    pas = pc*len(res)
    key = ""
    while key != "#enter":
        gotoxy(x,y)
        swrite(fc*length)
        #writexy(x,y,fillatt,fc*length)
        writexy(x,y,att,pas[pos:length+pos])
        gotoxy(x+len(pas[pos:length+pos]),y)
        key = readkey()
        if key in chars:
            res = res + key
            pas = pas + pc
            if len(res)>length:
                if len(res)<maxc:
                    pos += 1
        elif key == "#space":
            res = res + " "
            pas = pas + pc
            if len(res)>length:
                if len(res)<maxc:
                    pos += 1
        elif key == "#back":
            res = res[:-1]
            pas = pas[:-1]
            pos = pos - 1
            if pos < 0:
                pos = 0
        elif key == "#ctrly":
            res = ""
            pas = ""
        elif key == "#enter":
            exit_code = "#enter"
        elif key in exit_keys:
            exit_code = key
            break
    return res    
    

def onekey(chars,echo):
    """
    Expects a string with valid chars to accept for a keypress.
    If echo is on, it will also show the key pressed.
    This function is case sensitive
    """
    while 1:
        key = readkey()
        if key in chars:
            break
    if echo:
            writeln(key)
            
def onekeyci(chars,echo):
    """
    Expects a string with valid chars to accept for a keypress.
    If echo is on, it will also show the key pressed.
    This function is NOT case sensitive
    """
    while 1:
        key = readkey().upper()
        
        if key in chars.upper():
            break
    if echo:
            writeln(key)            

def getyesno(x,y,trueat,falseat,offat,default):
    """
    Function to get a Yes/No answer
    trueat  : color in byte value for the No button
    falseat : color in byte value for the Yes button
    default : True/False to begin with 
    """
    global exit_code
    exit_code = ""
    key = ""
    val = {0:'No ',1:'Yes'}
    res = default
    while key != "#enter":
        writexy(x,y,offat,val[True]+val[False])
        if res == True:
            writexy(x,y,trueat,val[res])
        else:
            writexy(x+3,y,falseat,val[res])
        gotoxy(1,25)
        key = readkey()
        if key == "#left" or key == "#right" or key == "#space":
            res = not res
        elif key in exit_keys:
            exit_code = key
            return None
            break
    return val[res].lower().strip(" ")


def getyesnocancel(x,y,trueat,offat,default):
    """
    Function to get a Yes/No/Cancel answer
    trueat  : color in byte value for the No button
    falseat : color in byte value for the Yes button
    default : True/False to begin with 
    """
    global exit_code
    exit_code = ""
    key = ""
    val = {1:' No ',0:' Yes ',2:' Cancel '}
    res = default
    while key != "#enter":
        writexy(x,y,offat,val[0]+val[1]+val[2])
        if res == 1:
            writexy(x+5,y,trueat,val[res])
        elif res == 0:
            writexy(x,y,trueat,val[res])
        elif res == 2:
            writexy(x+9,y,trueat,val[res])
        gotoxy(1,25)
        key = readkey()
        if key == "#left": 
            res -= 1
        elif key == "#right" or key == "#space":
            res += 1
        elif res >2:
            res = 0
        elif res < 0:
            res = 2
        elif key in exit_keys:
            exit_code = key
            break
        
    if res == 0:
        return "yes"
    elif res == 1:
        return "no"
    elif res == 2:
        return "cancel"
        
def dirslash(d):
    if d[:-1]!=os.sep:
        d = d+os.sep
    return d
    
def backdir(d):
    s = d
    if s[:-1] == os.sep:
        s = s[:-1]
    s = s.split(os.sep)
    val = os.sep
    for i in range(1,len(s)-1):
      val = val +os.sep+ s[i]
    
    return val[1:]
        
def dirselect(current,x1,y1,x2,y2,hc=15,nc=7,sel=0,sb=scrollbar):
    folder = current
  
    """
    Displays a menu with lightbar, to select from
    items   : list of items to display
    x1,x2,
    y1,y2   : box area to display the menu
    hc      : Highlight/On color
    nc      : Normal text/off color
    sel     : default value to begin with.
    sb      : a dictionary, with values to display a scrollbar in the 
              right side of the menu
    """
    global exit_keys
    global exit_code
    
    def updatebar():
        if sb["enable"] == False: Return
        for i in range(0,y2-y1+1):
            swritexy(x2,y1+i,sb["loatt"],sb["lochar"])
        if len(items) < 2:
            y = 0
        else:
            y = (selbar * (y2-y1)) // (len(items)-1)
        swritexy(x2,y1+y,sb["hiatt"],sb["hichar"])
    
    items = []
    items = [f.name for f in os.scandir(folder) if f.is_dir() ]
    items.append("..")
    items.sort()
    if len(items)<1:
      return -1
    exit_code = ""
    key = ""
    value = ""
    done = False
    if sel <= len(items):
        top = sel-(y2-y1)
        if top < 1: top = 0
    else:
        top = 0
    if sel <= len(items):
        selbar = sel
    else:
        selbar = 0
    
    while done == False:
        #writexy(1,1,7,str(top)+"/"+str(selbar)+"/"+str(len(items)))
        
        y = top
        if len(folder) > x2-x1:
          writexy(x1,y1,hc,folder[x2-x1:])
        else:
          writexy(x1,y1,hc,folder.ljust(x2-x1," ")[:x2-x1])
        gotoxy(x1,y1+1)
        while y1+1+y-top<=y2:
            if y<len(items):
                writexy(x1,y1+1+y-top,nc,items[y].ljust(x2-x1, " ")[:x2-x1])
            else:
                writexy(x1,y1+1+y-top,nc," ".ljust(x2-x1, " ")[:x2-x1])
            y += 1
        writexy(x1,y1+1+selbar-top,hc,items[selbar].ljust(x2-x1, " ")[:x2-x1])
        #writexy(3,23,7,items[selbar].ljust(75," "))
        updatebar()
        gotoxy(1,25)
        
        key = readkey()
        
        if key == "#up":
            selbar=selbar-1
            if selbar < 1:
                selbar = 0
            if selbar < top:
                top = selbar
        elif key == "#pgup":
            selbar = selbar - (y2-y1-1)
            if selbar < 0:
                selbar = 0
                top = 0
            else:
                top = top - (y2-y1-1)
                if top < 0:
                    top = 0
        elif key == "#pgdn":
            selbar = selbar+(y2-y1-1)
            if selbar > len(items)-1:
                selbar = len(items)-1
            top = top+(y2-y1)
            if top > len(items)-1-(y2-y1-1):
                top = len(items)-1-(y2-y1-1)
                if top < 0:
                    top = 0
        elif key == "#end":
            selbar=len(items)-1
            if len(items)-(y2-y1)-1 > 0:
                top = len(items)-(y2-y1-1)-1
            else:
                top = 0
        elif key == "#home":
            selbar=0
            top = 0
        elif key == "#down": 
            selbar=selbar+1
            if selbar > len(items)-1:
                selbar = len(items)-1
            if selbar > top+y2-y1-1:
                top += 1
        elif key == "#enter":
            if items[selbar] == "..":
                folder = backdir(folder)
            else:
                folder = dirslash(folder)+items[selbar]
            items.clear()
            selbar = 0
            top = 0
            items = [f.name for f in os.scandir(folder) if f.is_dir() ]
            items.append("..")
            items.sort()
        elif key == "#ins" or key == "#ctrld" or key == "#f10":
            value = dirslash(folder)
            exit_code = "#ins"
            done = True
        elif key in exit_keys:
            exit_code = key
            value = ""
            done = True
        
    return value
  

# function to make a lightbar menu, in which each item has different position
# high/low attributes, can be selected with arrow keys, but also with hotkey


# to create an item use this function  
def baradditem(x,y,low,high,lowtext,hightext,key,code):
  return {'x':x,'y':y,'low':low,'high':high,'textlow':lowtext,'texthigh':hightext, 'key':key, 'code':code}
  
# to add it, use a list like this:
# item1 = baradditem(10,10,7,14,'|01[h]|03ello','|17|15[H]ELLO','hH','hello')
# items.append(item1)
  
def lightbarmenu(items,sel=0):
  res = ""
  while True:
    for i in range(len(items)):
      writexypipe(items[i]['x'],items[i]['y'],items[i]['low'],mcilen(items[i]['textlow']),items[i]['textlow'])
    writexypipe(items[sel]['x'],items[sel]['y'],items[sel]['high'],mcilen(items[sel]['texthigh']),items[sel]['texthigh'])
    writexy(1,1,11,str(len(items)))
    ans = readkey()
    if ans == "#up" or ans == "#left":
      sel -= 1
      if sel < 0: sel = len(items) - 1
    elif ans == "#down" or ans == "#right":
      sel += 1
      if sel > len(items) - 1 : sel = 0
    elif ans == "#esc":
      res == "#esc"
      break
    elif ans == "#enter":
      res = items[sel]['code']
      break
    else:
      for i in range(len(items)):
        if ans in items[i]['key']:
          res = items[i]['code']
          return res
  return res