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
import struct
import os

fonts = []
fontfile = ''
selected = 0

def istdf(filename):
  if os.path.exists(filename) == False:
    return False
  header = "<B18sBBBBB"
  size = struct.calcsize(header)
  f = open(filename, 'rb')
  try:
    head = f.read(size)
  except:
    return False
  f.close()
  s = struct.unpack(header,head)
  if s[0] == 0x13 and s[1].decode('CP437') == 'TheDraw FONTS file' and \
  s[2] ==0x1A and s[3] ==0x55 and s[4] ==0xAA and s[5] ==0x00 and s[6] ==0xFF:
    return True
  else:
    return False
    
def init(filename):
  global fonts
  global fontfile
  fontfile = filename
  if istdf(filename) == False:
    return -1
  fonts.clear()
  f = open(filename,'rb')
  f.seek(20)
  ftheader = "<BBBBB12sBBBBBBh94H"
  fthsize = struct.calcsize(ftheader)
  try:
    while True:
      ifont = {}
      ifont['position'] = f.tell()+fthsize
      # print(f.tell)
      # print(ifont['position'])
      fhraw = f.read(fthsize)
      fh = struct.unpack(ftheader,fhraw)
      if fh[0] == 0x55 and fh[1]==0xAA and fh[2]==0 and fh[3]==0xFF:
        
        ifont['name']=fh[5].decode('CP437')[:fh[4]]
        if fh[10] == 0:
          ifont['type']='outline'
        elif fh[10] == 1:
          ifont['type']='block'
        elif fh[10] == 2:
          ifont['type']='color'
        ifont['spacing']=fh[11]
        ifont['blocksize']=fh[12]
        ifont['chars']=fh[13:]
        #print(ifont['position'])
        fonts.append(ifont)
        f.seek(ifont['blocksize'],1)
        
  except:
    f.close()

def availablechars(fn=selected):
  s = ''
  for i in range(0,94):
    if fonts[fn]['chars'][i]==65535:
      s += '.'
    else:
      s += chr(i+33)
  return s
  
def writestr_block(x,y,text):
  y1=y
  pos = x
  x1 = 0
  f = open(fontfile,'rb')
  for i in range(len(text)):
    c = text[i:i+1]
    if fonts[selected]['chars'][ord(c)-33]==65535:
      continue
    else:
      f.seek(fonts[selected]['position']+fonts[selected]['chars'][ord(c)-33])
      width  = int.from_bytes(f.read(1), byteorder='little', signed=False)
      height = f.read(1)
      if pos+width > 79:
            break
      d = 32
      b = 0
      while d!=0:
        gotoxy(pos+x1,y1)
        b=f.read(1)
        d = int.from_bytes(b, byteorder='little', signed=False)
        
        if d == 0x0D:
          y1 += 1
          x1 = 0
          if y1 > 25:
            break
        else:
          if utf:
            write(chr(int.from_bytes(b, byteorder='little', signed=False)))
          else:
            swrite(chr(int.from_bytes(b, byteorder='little', signed=False)))
          x1 += 1
          
      y1 = y
      pos = pos + width + fonts[selected]['spacing']
      x1 = 0
  
  f.close()
  return width
  
def writestr_color(x,y,text):
  y1=y
  pos = x
  x1 = 0
  f = open(fontfile,'rb')
  for i in range(len(text)):
    c = text[i:i+1]
    if fonts[selected]['chars'][ord(c)-33]==65535:
      continue
    else:
      f.seek(fonts[selected]['position']+fonts[selected]['chars'][ord(c)-33])
      width  = int.from_bytes(f.read(1), byteorder='little', signed=False)
      height = f.read(1)
      if pos+width > 79:
            break
      d = 32
      cl = 32
      b = 0
      while d!=0:
        gotoxy(pos+x1,y1)
        b=f.read(1)
        d = int.from_bytes(b, byteorder='little', signed=False)
        
        if d == 0x0D:
          y1 += 1
          x1 = 0
          if y1 > 25:
            break
        else:
          cl = f.read(1)
          cl = int.from_bytes(cl, byteorder='little', signed=False)
          settextattr(cl)
          #write(chr(int.from_bytes(b, byteorder='little', signed=False)))
          if utf:
            write(b.decode('cp437'))
          else:
            swrite(b.decode('cp437'))
          x1 += 1
          
      y1 = y
      pos = pos + width + fonts[selected]['spacing']
      x1 = 0
  
  f.close()
  return width
  
def writestr(x,y,text):
  if selected > len(fonts):
    write('Selected text is out of range.')
    return
  if fonts[selected]['type'] == 'block':
    writestr_block(x,y,text)
  elif fonts[selected]['type'] == 'color':
    writestr_color(x,y,text)
