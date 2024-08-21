from mystic_bbs import *
import sys,os

sys.path.append(getcfg()['script']+'xqbbsdb'+os.sep)
appdir = getcfg()['script']+'xqbbsdb'+os.sep
import bbsdbvar 

import datetime
import binascii
import json
import os
import sqlite3
import csv

box12=('|04'+chr(254),'|04'+chr(223),'|15'+chr(220),'|04'+chr(221),'|04'+chr(222),'|14'+chr(254),'|04'+chr(220),'|04'+chr(254),'|16'+' ')
cfg = getcfg()

def crc32(filename):
    buf = open(filename,'rb').read()
    hash = binascii.crc32(buf) & 0xFFFFFFFF
    return "%08X" % hash
    
def clrscr():
  write('|07|16|CL')

def log(s):
  global logdir
  global user
  today = datetime.datetime.now().strftime("%Y%m%d")
  totime = datetime.datetime.now().strftime("%H:%M:%S")
  logfile = prefix+'_'+today+'.log'
  with open(logdir+logfile,'ar') as f:
    f.write(str(totime)+' :: '+s+'\n')

def issysop():
  if user['level'] >= getcfg()['sysopacs']:
    return True
  else:
    return False
    
def dirslash(d):
  if d[-1:]!=os.sep:
    d = d+os.sep
  return d

def writexy(x,y,a,s):
  gotoxy(x,y)
  textcolor(a)
  write(s)

def center(a,y,s):
  writexy(40-len(s) // 2,y,a,s)
  
def pause(visible=False):
  if not visible:
    write('|PN')
  else:
    write('|PA')
    
def sqlconnect(filename):
  conn = None
  try:
    conn = sqlite3.connect(filename)
    return conn
  except Error as e:
    print(e)
 
  return conn
    
def savelist2json(lista,filename):
  try:
    with open(filename, 'w+') as outfile:
      json.dump(lista, outfile,indent=2)
    return 0
  except:
    return False
    
def loadjson2list(filename):
  try:
    if os.path.exists(filename):
      with open(filename) as json_file:
        jlist = json.load(json_file)
        return jlist
    else:
      return None
  except:
    return False
    
def list2csvline(ls):
  s = ''
  for l in ls:
    s += l+';'
  return s
    
def stripmci(s):
  i = 0
  val = ''
  inpipe = False
  while i < len(s):
    if len(s) - i > 2:
      if s[i] == '|' and s[i+1].isnumeric() and s[i+2].isnumeric():
        i+=2
      else:
        val += s[i]
    else:
      val += s[i]
    
    i+=1  
  return val
  
def str2date(datestr):
  try:
    return datetime.datetime.strptime(datestr, "%Y-%m-%d")
  except:
    return datetime.datetime.now()

def date2str(dt):
  return dt.strftime("%Y-%m-%d")

def rot47(data,debug=False):
  if debug:
    return data
  decode = []
  for i in range(len(data)):
    encoded = ord(data[i])
    if encoded >= 33 and encoded <= 126:
      decode.append(chr(33 + ((encoded + 14) % 94)))
    else:
      decode.append(data[i])
  return ''.join(decode)
  
  
#get all msg. groups
def getmgroups():
  res = []
  i = 0
  mg = getmgroup(i)
  while mg and not shutdown():
    if access(mg['acs']):
      res.append(mg['name'])
    i +=1
    mg = getmgroup(i)  
  return res

#get all msg. bases
def getbases():
  res = []
  i = 0
  #mb = getmbaseid(user["mbase"])
  mb = getmbase(0)
  while mb and not shutdown():
    if access(mb['listacs']):
      res.append(mb)
    i +=1
    mb = getmbase(i)  
  #return sorted(res, key = lambda i: (i['name']))[::-1]
  return res
 
def getfgroups():
  res = []
  i = 0
  mg = getfgroup(i)
  while mg and not shutdown():
    if access(mg['acs']):
      res.append(mg['name'])
    i +=1
    mg = getfgroup(i)  
  return res  

def getfbases():
  res = []
  i = 0
  fb = getfbase(1) #it should be getfbase(0) but mystic returns nothing unless
  #it's getfbase(1)... perhaps a bug?
  while fb and not shutdown():
    if access(fb['listacs']):
      res.append(fb)
    i +=1
    fb = getfbase(i)  
  #return sorted(res, key = lambda i: (i['name']))[::-1]
  return res
  
def toggleKthBit(n, k):
  return (n ^ (1 << (k-1)))
  
def testBit(int_type, offset):
   mask = 1 << offset
   return(int_type & mask)
    
def setBit(int_type, offset):
  mask = 1 << offset
  return(int_type | mask)
    
def clearBit(int_type, offset):
  mask = ~(1 << offset)
  return(int_type & mask)

def mods2str():
  r = []
  s = ''
  theme = getcfg()['deftheme']
  for mod in bbsdbvar.mods:
    if os.path.exists(getcfg()['theme']+theme+os.sep+'scripts'+os.sep+mod):
      s += '1'
    else:
      s += '0'
    
    if len(s) == 60:
      r.append(s)
      s = ''
    
  r.append(s)
  return r
  
def str2mods(s):
  index = 0
  aa = 0
  res = []
  keys = list(bbsdbvar.mods.keys())
  for line in s:
    for i,c in enumerate(line):
      if c == '1':
        res.append(bbsdbvar.mods[keys[i]])
  return res

def ansibox(x1,y1,x2,y2,box):
    gotoxy(x1,y1)
    write(box[0]+box[1]*(x2-x1-1)+box[2])
    gotoxy(x1,y2)
    write(box[5]+box[6]*(x2-x1-1)+box[7])
    for i in range(y2-y1-1):
        gotoxy(x1,y1+1+i)
        write(box[3]+' '*(x2-x1-1)+box[4])

def xwindow(title,typo,x1,y1,x2,y2):
  write('|#X#'+str(typo)+'#'+str(title)+'#'+str(x1)+'#'+str(y1)+'#'+str(x2)+'#'+str(y2)+'#')
  #ansibox(x1,y1,x2,y2,box12)
  #writexy(x1+3,y1,theme['dialog_title_at'],title)  
  
def msgdialog(title,text,p=True):
  a = len(text)
  if a<75:
    xwindow(title,1,40-(a // 2)-2,10,40+(a // 2)+2,14)
    writexy(40-(a // 2),12,theme['dialog_text_at'],text)
  if p: pause() 

def getbbsinfo(bbs):
  dbfile = cfg['data']+bbsdbvar.prefix+'.sql'
  conn = sqlconnect(dbfile)
  cursor = conn.cursor()
  cursor.execute("SELECT * FROM bbs WHERE address = '"+bbs+"'")
  data=cursor.fetchone()
  tempfile = cfg['temp']+'rec.txt'
  savelist2json(data,tempfile)
  menucmd('F3',tempfile)
  
def exportdb2csv(sql):
  dbfile = cfg['data']+bbsdbvar.prefix+'.sql'
  conn = sqlconnect(dbfile)
  cursor = conn.cursor()
  cursor.execute(sql)
  tempfile = cfg['temp']+'list.csv'
  with open(tempfile, 'w') as csv_file: 
    csv_writer = csv.writer(csv_file)
    csv_writer.writerow([i[0] for i in cursor.description]) 
    csv_writer.writerows(cursor)
  conn.close()
  menucmd('F3',tempfile)
  
def exportdb2magi(sql):
  '''
  [20 For Beers BBS]
  address = 20forbeers.com 
  port = 1338 
'''
  dbfile = cfg['data']+bbsdbvar.prefix+'.sql'
  conn = sqlconnect(dbfile)
  cursor = conn.cursor()
  cursor.execute(sql)
  tempfile = cfg['temp']+'magiterm.ini'
  with open(tempfile, 'w') as ini: 
    for row in cursor:
      addr = row[2].split(':')
      if len(addr)<2: 
        port = 23
      else:
        port=addr[1]
      ini.write('['+row[1].split(':')[0]+']\n')
      ini.write('address = '+addr[0]+'\n')
      ini.write('port = '+str(port)+'\n')
      ini.write('\n')
  conn.close()
  menucmd('F3',tempfile)
  
def exportdb2sync(sql):
  dbfile = cfg['data']+bbsdbvar.prefix+'.sql'
  conn = sqlconnect(dbfile)
  cursor = conn.cursor()
  cursor.execute(sql)
  tempfile = cfg['temp']+'syncterm.lst'
  with open(tempfile, 'w') as ini: 
    ini.write('Port           =23\n')
    ini.write('ConnectionType =Telnet\n')
    ini.write('DownloadPath   =\n')
    ini.write('UploadPath     =\n')
    ini.write('Password       =\n')
    ini.write('ScreenMode     =80x25\n')
    ini.write('NoStatus       =true\n')
    ini.write('ANSIMusic      =1\n')
    ini.write('Font           =Codepage 437 English\n')
    ini.write('\n')
    for row in cursor:
      addr = row[2].split(':')
      if len(addr)<2: 
        port = 23
      else:
        port=addr[1]
      ini.write('['+row[1].split(':')[0]+']\n')
      ini.write('  Address        ='+addr[0]+'\n')
      ini.write('  Port           ='+str(port)+'\n')
      ini.write('  ConnectionType =Telnet\n')
      ini.write('  NoStatus       =true\n')
      ini.write('\n')
  conn.close()
  menucmd('F3',tempfile)
  
  
def exportdbfull(sql):
  dbfile = cfg['data']+bbsdbvar.prefix+'.sql'
  conn = sqlconnect(dbfile)
  cursor = conn.cursor()
  cursor.execute(sql)
  tempfile = cfg['temp']+'fulllist.txt'
  with open(tempfile, 'w') as ini: 
    for row in cursor:
      addr = row[2].split(':')
      if len(addr)<2: 
        port = 23
      else:
        port=addr[1]
      ini.write('--------------------------------------------------------------------------\n')
      ini.write('    '+row[1].split(':')[0]+'\n')
      ini.write('    Last Updated: '+row[15]+'\n')
      ini.write('\n')
      ini.write('    Telnet: '+row[2]+'\n')
      ini.write('       WEB: '+row[23]+'\n')
      ini.write('     Email: '+row[21]+'\n')
      ini.write('  Location: '+row[14]+'\n')
      ini.write('   Dial-Up: '+row[22]+'\n')
      ini.write('  Software: '+row[17]+'\n')
      ini.write('     Nodes: '+str(row[16])+'\n')
      ini.write('     Login: '+row[24]+'\n')
      ini.write('\n')
  conn.close()
  menucmd('F3',tempfile)
  
def exportdbshort(sql):
  dbfile = cfg['data']+bbsdbvar.prefix+'.sql'
  conn = sqlconnect(dbfile)
  cursor = conn.cursor()
  cursor.execute(sql)
  tempfile = cfg['temp']+'short.txt'
  with open(tempfile, 'w') as ini: 
    ini.write('\n')
    for row in cursor:
      addr = row[2].split(':')
      if len(addr)<2: 
        port = 23
      else:
        port=addr[1]
      ini.write(row[1].split(':')[0].ljust(39)+row[2].ljust(40)+'\n')
    ini.write('\n')
  conn.close()
  menucmd('F3',tempfile)
 
def connect_bbs(addr):
  if addr.find(':')>0:
    ad=addr.split(':')
    menucmd('IT','/addr='+ad[0]+' /port='+ad[1])
  else:
    menucmd('IT','/addr='+addr)
  
#load config file...
cnf = {}
if os.path.isfile(cfg['data']+bbsdbvar.prefix+'.cfg'):
  cnf = loadjson2list(cfg['data']+bbsdbvar.prefix+'.cfg')
else:
  logerror('Could not load config file ['+cfg['data']+bbsdbvar.prefix+'.cfg]. Make sure it exists.')
  writeln('Could not load config file ['+cfg['data']+bbsdbvar.prefix+'.cfg]. Make sure it exists.')  
  
theme = {}
themefile=appdir+'images'+os.sep+cnf['theme']+os.sep+'theme.json'
if os.path.isfile(themefile):
  theme = loadjson2list(themefile)
  
'''  
conf = {}
conf['nodes']=5
conf['base_id']=[2,5]
conf['echonets']=['fsxnet','zeronet']
savelist2json(conf,'/home/x/mys47b/data/xqbbsdat.cfg')
'''


'''

                   /\_________/\______/\______/\_______
                  \\     /                            //
                   _\   /   /   /   /    / __/   /   /
                  /      __/   /   /____/  \      __/jp!
                //____/    \__    / ___/   /___/    \
                ==== /______\/   /==\_____// =/______\\==
                ::::::::::://____\:::::::::::::::::::::::
                =========================================
                            Inter-BBS Database
                -----------------------------------------
                            Another Droid BBS
                         andr01d.zapto.org:9999
                -----------------------------------------
'''
