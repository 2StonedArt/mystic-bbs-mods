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

import os
import textwrap

def byte2str(v):
    s=''.join(str(v))
    return s[2:-1]

def lower(s):
    return s.lower()
  
def upper(s):
    return s.upper()
  
def title(s):
    return s.title()
    
def str2kb(s):
    ret = ""
    size = int(s)
    if size < 1000:
        ret = str(size)+"b"
    elif size >= 1000 and size <1000000:
        ret = size / 1000
        ret = "{:.2f}".format(ret)+"kb"
    elif size >= 1000000 and size <= 1000000000:
        ret = size / 1000000
        ret = "{:.2f}".format(ret)+"mb"
    return ret    

def addslash(path):
    return os.path.join(path, '')
    
def center(txt,width,char):
    return txt.center(width, char)

def noslash(path):
    path = str(path)
    if path.endswith(os.sep):
        path = path[:-1]
    return path
    
def padleft(txt,width,char):
    return txt.ljust(width, char)
    
def padright(txt,width,char):
    return txt.rjust(width, char)
    
def padcenter(txt,width,char):
    return txt.center(width, char)
    
def stripb(txt,char):
    return txt.strip(char)
    
def stripl(txt,char):
    return txt.lstrip(char)    

def stripr(txt,char):
    return txt.rstrip(char)
    
def repeat(width,char):
    return char*width
    
def replace(txt,old,new):
    return txt.replace(old,new)
    
def pos(substr,string):
    found = string.find(substr)
    if found == -1:
        return 0
    else:
        return found+1
        
def insert(Sub,Str,Ind):
    return Str[:Ind-1]+Sub+Str[Ind-1:]
    
def length(Str):
    return len(Str)
    
def copy(txt,x1,length):
    if x1 == 0:
        x1 = 1
    return txt[x1-1:x1+length-1]
    
def strwrap(Str,width):
    dedented_text = textwrap.dedent(Str).strip()
    return textwrap.fill(dedented_text, width=width)
  
def delete(txt,x1,length):
    return txt[:x1-1]+txt[x1-1+length:]
    
def mcilen(s):
  res = s
  while True:
    a = res.find('|')
    if a >= 0:  #and a <=len(res)-2:
      if res[a+1].isdigit() and res[a+2].isdigit():
        res = res[:a]+res[a+3:]
      else:
        res=res.replace('|','x',1)
    else: break
  return len(res)
    
def initials(fullname):
  xs = (fullname)
  name_list = xs.split()
  initials = ""
  for name in name_list:  # go through each name
    initials += name[0].upper()  # append the initial

  return initials

def wordget(Num,Str,Ch):
    a = Str.split(Ch)
    return a[Num-1]
    
def wordpos(Num,Str,Ch):
    a = Str.split(Ch)
    b = Str.find(a[Num-1])
    if b == -1:
        return 0
    else:
        return b+1

def wordcount(Str,Ch):
    a = Str.split(Ch)
    return len(a)
    
def strcomma(value):
    return "{:,}".format(value)
    
def striplow(Str):
    return ''.join([c for c in Str if ord(c) > 31 or ord(c) == 9])
    
def int2hex(integer):
    h = hex(integer)[2:]
    if len(h) % 2 == 1:
        h = '0'+h
    return h
    
def int2str(integer):
    return str(integer)
    
def real2str(f,d):
    a = '{0:,.'+str(d)+'f}'
    return str(a).format(f)
    
def str2int(txt):
    try:
        return int(txt)
    except ValueError:
        return 'Conversion Error'
        
def getsha1(filename):
    import hashlib
    BLOCKSIZE = 65536
    hasher = hashlib.sha1()
    with open(filename, 'rb') as afile:
        buf = afile.read(BLOCKSIZE)
        while len(buf) > 0:
            hasher.update(buf)
            buf = afile.read(BLOCKSIZE)
    return hasher.hexdigest()

