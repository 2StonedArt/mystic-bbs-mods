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


# BEWARE!!! IF THE FONT FILE CONTAINS A ; CHARACTER, YOU'RE GONNA GET EN ERROR
# WHEN YOU TRY TO USE IT, WITH THE SPRITE ENGINE, CAUSE IT USES THE SEMICOLON
# TO SEPARATE FIELDS.

import struct
import os,sys
import codecs

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
  del fonts[:]
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
      continue
    else:
      s += chr(i+33)
  return s
  
def attr2mci(atr):
  ifg = atr % 16
  ibg = atr // 16
  ibg += 16
  return [ifg,ibg]
  
def convert(tdf,ofl):
  global chars
  f = open(tdf,'rb')
  fs = open(ofl,'w')
  fs.write('#conversion from TheDraw font file.\n')
  fs.write('#original filename: '+tdf+'\n')
  fs.write('#converted with tdf2mci\n')
  fs.write('#available characters: '+availablechars()+'\n')
  name = fonts[selected]['name']
  name = name.replace(chr(0),'')
  fs.write('#Font name: '+name+'\n')
  fs.write('#Another Droid BBS // andr01d.zapto.org:9999 // XQTR :: 2020 \n')
  if fonts[selected]['type'] == 'color':
    print('Found BLOCK type font. Converting...')
  else:
    print('Found COLOR type font. Converting...')
  print('Converting char.: ', end =" ")
  for c in chars:
    print(c, end ="")
    f.seek(fonts[selected]['position']+fonts[selected]['chars'][ord(c)-33])
    width = int.from_bytes(f.read(1),byteorder='little')
    height = int.from_bytes(f.read(1),byteorder='little')
    fs.write('@'+c+';'+str(width)+';'+str(height)+'\n')
    l = ''
    d = 32
    cl = 32
    b = 0
    ofg = 7
    obg = 16
    fg = 7
    bg = 16
    while d!=0:
      if fonts[selected]['type'] == 'color':
        b=int.from_bytes(f.read(1),byteorder='little')
        #d=byte2int(b)
        if b == 0x0D:
          fs.write(l+'\n')
          l=''
        elif b == 0x00:
          fs.write(l+'\n')
          l=''
          break
        else:
          #cl = byte2int(f.read(1))
          cl = int.from_bytes(f.read(1),byteorder='little')
          if cl>0:
            #print(ord(cl))
            fg,bg = attr2mci(cl)
            #print(fg,bg)
            if fg!=ofg:
              l+= '|'+str(fg).zfill(2)
              ofg = fg
            if bg!=obg:
              l+= '|'+str(bg).zfill(2)
              obg = bg
            if b>0:
              l+=chr(b)
            else:
              fs.write(l+'\n')
              break
          else:
            #fs.write('\n')
            break
      else:
        b=int.from_bytes(f.read(1),byteorder='little')
        #d = byte2int(b)
        if b == 0x0D:
          fs.write(l+'\n')
          l=''
        elif b== 0x00:
          fs.write(l+'\n')
          l=''
          break
        else:
          l+=chr(b)
        
  
  f.close()
  fs.close()
  
  
def writestr(x,y,text,spacing=255):
  if selected > len(fonts):
    write('Selected text is out of range.')
    return
  text = bytes(text).encode('CP437')
  if fonts[selected]['type'] == 'block':
    writestr_block(x,y,text,spacing)
  elif fonts[selected]['type'] == 'color':
    writestr_color(x,y,text,spacing)
    
def showhelp():
  print(":"*78)
  print("")
  print("Convert TheDraw TDF files, to text files, compatible with SpriteEngine")
  print("")
  print("Usage:")
  print("  tdf2spr <tdf_file>")
  print("  tdf_file   : must be a TheDraw TDF file")
  print("")
  print("Another Droid BBS // andr01d.zapto.org:9999 // XQTR :: 2020")
  print("")
  print(":"*78)

if len(sys.argv)!=2:
  showhelp()
  exit()

if not istdf(sys.argv[1]):
  print("")
  print(" tdf2spr>")
  print(' Input file, is not in compatible TDF format.')
  print("")
  exit()

init(sys.argv[1])

for i in range(len(fonts)):
  print('Font '+str(i+1)+' of total '+str(len(fonts)))
  selected = i
  fn = fonts[i]['name'].replace(' ','_')
  fn = fn.replace(chr(0),'')
  print('Name: '+fn)
  chars = availablechars()
  convert(sys.argv[1],fn+'.spr')
  print('')
  print('')
  
print('Done!')
