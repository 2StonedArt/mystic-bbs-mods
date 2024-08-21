#!/usr/bin/python3
import struct
from datetime import datetime
import os

jam_local =        int('00000001',16)
jam_intransit =    int('00000002',16)
jam_priv =         int('00000004',16)
jam_rcvd =         int('00000008',16)
jam_sent =         int('00000010',16)
jam_killsent =     int('00000020',16)
jam_achvsent =     int('00000040',16)
jam_hold =         int('00000080',16)
jam_crash =        int('00000100',16)
jam_imm =          int('00000200',16)
jam_direct =       int('00000400',16)
jam_gate =         int('00000800',16)
jam_freq =         int('00001000',16)
jam_fattch =       int('00002000',16)
jam_truncfile =    int('00004000',16)
jam_killfile =     int('00008000',16)
jam_rcptreq =      int('00010000',16)
jam_confmreq =     int('00020000',16)
jam_orphan =       int('00040000',16)
jam_encrypt =      int('00080000',16)
jam_compress =     int('00100000',16)
jam_escaped =      int('00200000',16)
jam_fpu =          int('00400000',16)
jam_typelocal =    int('00800000',16)
jam_typeecho =     int('01000000',16)
jam_typenet =      int('02000000',16)
jam_nodisp =       int('20000000',16)
jam_locked =       int('40000000',16)
jam_deleted =      int('80000000',16)
base_filename = ''
mbase_header=dict()
msg_header=dict()
# mbase_header["signature"] 
# mbase_header["created"]
# mbase_header["modcounter"] 
# mbase_header["activemsgs"] 
# mbase_header["passwordcrc"]
# mbase_header["basemsgnum"] 
#functions for msg attributes
def isdeleted():  
  global msg_header
  if (jam_deleted & msg_header["attr1"] ) !=  0:
    return True
  else:
    return False
    
def islocal(): 
  global msg_header 
  if (jam_local & msg_header["attr1"] ) != 0:
    return True
  else:
    return False    
    
def isreceived(): 
  global msg_header 
  if (jam_rcvd & msg_header["attr1"] ) != 0:
    return True
  else:
    return False    
# read the header file and get info
# returns 0 if is succesful, -1 if file doesn't exist and -2 if file
# is not valid jam base
def get_msg_base_hdr(filename):
  global mbase_header
  global base_filename
  base_filename = filename
  filename = filename + '.jhr'
  if os.path.exists(filename) == False:
    return -1
  jamf = "ssssIIIII"
  with open(filename, mode='rb') as file:
    fileMsgHdr = file.read(struct.calcsize(jamf))
  jam_hdr = struct.unpack(jamf, fileMsgHdr[0:24])
  mbase_header["signature"] = jam_hdr[:4]
  mbase_header["created"] = \
  datetime.fromtimestamp(jam_hdr[4]).strftime('%Y-%m-%d %H:%M:%S')
  mbase_header["modcounter"] = jam_hdr[5]
  mbase_header["activemsgs"] = jam_hdr[6]
  mbase_header["passwordcrc"] = jam_hdr[7]
  mbase_header["basemsgnum"] = jam_hdr[8]
  if mbase_header["signature"] == (b'J', b'A', b'M', b'\x00'):
    return 0
  else:
    return -2
    
# read the message header  
def read_msg_header(filename,num):
  global msg_header
  global base_filename
  base_filename = filename
  jdx_name = filename + '.jdx'  # get header offset from index file
  if os.path.exists(jdx_name) == False:
    return -1
  jdx = open(jdx_name,"rb")
  jdx_size = os.path.getsize(jdx_name)
  offset = (num - mbase_header["basemsgnum"])*8
  if offset>jdx_size:
    jdx.close()
    return -2
  jdx.seek((num - mbase_header["basemsgnum"])*8)
  jdxf = "<II"
  jdxvalue = jdx.read(8)
  jdxuser,jdxoffset = struct.unpack(jdxf,jdxvalue)
  jdx.close()
  
  jhr_name = filename + '.jhr'
  jhr = open(jhr_name,"rb")  # open header file
  jhr.seek(jdxoffset)         # seek header of specific msg
  
  #debug string
  #print('header offset: '+str(jdxoffset))
  
  msgheaderf = "<4sHHIIIIIIIIIIIiIIIII"
  msgheader = jhr.read(struct.calcsize (msgheaderf))  # read header
  msg = struct.unpack(msgheaderf,msgheader)
  
  #debug string
  #print("header size: "+str(struct.calcsize (msgheaderf)))
    
  msg_header["signature"] = msg[0]
  msg_header["rev"] = msg[1]   
  msg_header["resvd"] = msg[2]
  msg_header["subfieldlen"] = msg[3]
  msg_header["timesread"] = msg[4]
  msg_header["msgidcrc"] = msg[5]
  msg_header["replycrc"] = msg[6]
  msg_header["replyto"] = msg[7]
  msg_header["replyfirst"] = msg[8]
  msg_header["replynext"] = msg[9]
  msg_header["datewritten"] = msg[10]
  msg_header["datercvd"] = msg[11]
  msg_header["datearrived"] = msg[12]
  msg_header["msgnum"] = msg[13]
  msg_header["attr1"] = msg[14]
  msg_header["attr2"] = msg[15]
  msg_header["textofs"] = msg[16]
  msg_header["textlen"] = msg[17]
  msg_header["pwdcrc"] = msg[18]
  msg_header["cost"] = msg[19]
  
  msg_header["origin"] = ''
  msg_header["destination"] = ''
  msg_header["sender"] = ''
  msg_header["receiver"] = ''
  msg_header["msgid"] = ''
  msg_header["replyid"] = ''
  msg_header["subject"] = ''
  msg_header["pid"] = ''
  msg_header["trace"] = ''
  msg_header["kludge"] = ''
  msg_header["seenby"] = ''
  msg_header["path2d"] = ''
  msg_header["flags"] = ''
  msg_header["tzutc"] = ''
  if msg_header["subfieldlen"] != 0:
    #print(jdxoffset + struct.calcsize (msgheaderf) + msg_header["subfieldlen"])    
    while jhr.tell() <= jdxoffset + struct.calcsize (msgheaderf) + \
    msg_header["subfieldlen"]:
      loid = jhr.read(2)
      loid = struct.unpack('<H',loid)
      loid = loid[0]
      hiid = jhr.read(2)
      hiid = struct.unpack('<H',hiid)
      hiid = hiid[0]
      sflen = struct.unpack('<I',jhr.read(4))
      buf = jhr.read(sflen[0])
      #debug string
      #print("tell: "+str(jhr.tell()))
      
      
      if loid == 0:
        msg_header["origin"] = ''.join(str(buf)).strip("b'")
      elif loid == 1:
        msg_header["destination"] = ''.join(str(buf)).strip("b'")
      elif loid == 2:
        msg_header["sender"] = ''.join(str(buf)).strip("b'")
      elif loid == 3:
        msg_header["receiver"] = ''.join(str(buf)).strip("b'")
      elif loid == 4:
        msg_header["msgid"] = ''.join(str(buf)).strip("b'")
      elif loid == 5:
        msg_header["replyid"] = ''.join(str(buf)).strip("b'")
      elif loid == 6:
        msg_header["subject"] = ''.join(str(buf)).strip("b'")
      elif loid == 7:
        msg_header["pid"] = ''.join(str(buf)).strip("b'")
      elif loid == 8:
        msg_header["trace"] = ''.join(str(buf)).strip("b'")
      elif loid == 2000:
        msg_header["kludge"] = ''.join(str(buf)).strip("b'")
      elif loid == 2001:
        msg_header["seenby"] = ''.join(str(buf)).strip("b'")
      elif loid == 2002:
        msg_header["path2d"] = ''.join(str(buf)).strip("b'")
      elif loid == 2003:
        msg_header["flags"] = buf
      elif loid == 2004:
        msg_header["tzutc"] = ''.join(str(buf)).strip("b'")
  jhr.close()
  return 0
  
# get the text of a message if msg is not deleted    
def msg_read_text():
  global base_filename
  global msg_header
  if not os.path.exists(base_filename+'.jdt'):
    return -2
  if isdeleted():
    return -3
  jdt = open(base_filename+'.jdt','rb')
  #print(msg_header["textofs"])
  #print(msg_header["textlen"])
  jdt.seek(msg_header["textofs"])
  res = jdt.read(msg_header["textlen"])
  jdt.close()
  res = ''.join(str(res,"cp437"))
  res = "\n".join(res.splitlines())
  return res
    
# convert unix time to string
def unix2str(dt):
  return datetime.fromtimestamp(dt).strftime('%Y-%m-%d %H:%M:%S')
