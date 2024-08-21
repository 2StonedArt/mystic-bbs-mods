#
# LOADING THE JAM MESSAGE BASE FOR FUN
# Version 0x02
#
import struct
import datetime
import os

mbbs_msgs_dir="/u01/bbs/msgs"
mbbs_msgs_base="fsx_gen"
mbase_meta=dict()

def get_msg_base_hdr():
  fileNameHdr = mbbs_msgs_dir + "/" + mbbs_msgs_base + ".jhr"
  with open(fileNameHdr, mode='rb') as file:
    fileMsgHdr = file.read()

  # JAM MESSAGE BASE HEADER
  jam_hdr = struct.unpack("ssssIIIII", fileMsgHdr[0:24])
  mbase_meta["Signature"] = jam_hdr[:4]
  mbase_meta["datecreated"] = datetime.datetime.fromtimestamp(jam_hdr[4]).strftime('%Y-%m-%d %H:%M:%S')
  mbase_meta["modcounter"] = jam_hdr[5]
  mbase_meta["activemsgs"] = jam_hdr[6]
  mbase_meta["passwordcrc"] = jam_hdr[7]
  mbase_meta["basemsgnum"] = jam_hdr[8]

def get_msg_next(msg_start):
  fileNameHdr = mbbs_msgs_dir + "/" + mbbs_msgs_base + ".jhr"
  with open(fileNameHdr, mode='rb') as file:
    fileMsgHdr = file.read()
 
  msg_file_hdr_sz = os.path.getsize(mbbs_msgs_dir + "/" + mbbs_msgs_base + ".jhr")
  if (msg_start>msg_file_hdr_sz):
    return (-2)
  msg_begin = msg_start
  msg_hdr_len = 76

  # JAM FIRST MESSAGE HEADER
  jam_msgs = struct.unpack("ssssHHIIIIIIIIIIIIIIIII", fileMsgHdr[msg_begin:msg_begin+msg_hdr_len])
  Signature = jam_msgs[0:3]
  Revision = jam_msgs[4]
  ReservedWord = jam_msgs[5]
  SubfieldLen = jam_msgs[6]
  TimesRead = jam_msgs[7]
  MSGIDcrc = jam_msgs[8]
  REPLYcrc = jam_msgs[9]
  ReplyTo = jam_msgs[10]
  Reply1st = jam_msgs[11]
  Replynext = jam_msgs[12]
  DateWritten = jam_msgs[13]
  MsgDateWritten = datetime.datetime.fromtimestamp(DateWritten).strftime('%Y-%m-%d %H:%M:%S')
  DateReceived = jam_msgs[14]
  MsgDateReceived = datetime.datetime.fromtimestamp(DateReceived).strftime('%Y-%m-%d %H:%M:%S')
  DateProcessed = jam_msgs[15]
  MsgDateProcessed = datetime.datetime.fromtimestamp(DateProcessed).strftime('%Y-%m-%d %H:%M:%S')
  MessageNumber = jam_msgs[16]
  Attribute = jam_msgs[17]
  Attribute2 = jam_msgs[18]
  Offset = jam_msgs[19]
  TxtLen = jam_msgs[20]
  PasswordCRC = jam_msgs[21]
  Cost = jam_msgs[22]
    
  # JAM FIRST MESSAGE SUBFIELDS
  msgs_subflds = []

  # CONSTANTS
  message_subfield_header_length = 8

  # CALCULATE BEGIN OF FIRST SUBFIELD
  message_subfields_start = msg_begin+msg_hdr_len
  #sf_hdr_end = sf_begin+first_message_subfield_length


  def get_sf_hdr(start):
    # GET HEADER OF FIRST SUBFIELD
    sf_hdr_begin = start
    test_for_end = ''.join(struct.unpack("ssss", fileMsgHdr[sf_hdr_begin:sf_hdr_begin+4]))
    if (test_for_end == 'JAM\x00'):
      return (-1)
    sf_hdr_end = sf_hdr_begin + message_subfield_header_length
    tmp_jam_msgs_subfld = struct.unpack("HHI", fileMsgHdr[sf_hdr_begin:sf_hdr_end])
    # CALCULATE FIRST SUBFIELD TEXT END
    sf_hdr_dat_len = tmp_jam_msgs_subfld[2]
    if (sf_hdr_dat_len < 1024):
      sf_hdr_dat_mask = (sf_hdr_dat_len)*"s"
      sf_hdr_dat_end = sf_hdr_begin + + message_subfield_header_length + sf_hdr_dat_len
      sf_hdr_dat_type = tmp_jam_msgs_subfld[0]
      sf_hdr_dat = struct.unpack(sf_hdr_dat_mask, fileMsgHdr[sf_hdr_end:sf_hdr_dat_end])
      str(tmp_jam_msgs_subfld[0]) + " " + ''.join(sf_hdr_dat)
      msgs_subflds.append({
        "sf_hdr_begin":sf_hdr_begin,
        "sf_hdr_end":sf_hdr_end,
        "sf_hdr_len":sf_hdr_dat_len,
        "sf_hdr_dat":''.join(sf_hdr_dat),
        "sf_hdr_dat_type":sf_hdr_dat_type
        }
      )
      return (sf_hdr_dat_end)
    else:
      return 0

  sf = message_subfields_start

  while (sf > 0):
    sf = get_sf_hdr(sf)
    if (sf > 0):
      msg_sf_end = sf

  fileNameDat = mbbs_msgs_dir + "/" + mbbs_msgs_base + ".jdt"

  with open(fileNameDat, mode='rb') as file: # b is important -> binary
      msgDataContent = file.read()

  msg = repr(msgDataContent[Offset:Offset+TxtLen])  
  #print "--- MESSAGE NUMBER: " + str(MessageNumber)  
  #print "--- HEADER SUBFIELDS ENDS: " + str(msg_sf_end)  
  #print "--- MESSAGE SUBFIELDS: " + str(msgs_subflds)
  #print "--- MESSAGE TEXT BEGIN: " + str(Offset) + " " + "END: " + str(Offset+TxtLen)
  #print "--- MESSAGE TEXT BODY: "  
  #print msg  
  return (msg_sf_end,msg)

get_msg_base_hdr()

# DEBUG
#print "=== MSG BASE: " + mbbs_msgs_base.upper()
#print "=== MSG BASE DATE CREATED: " + mbase_meta["datecreated"]
#print "=== MSG BASE MESSAGES: " + str(mbase_meta["activemsgs"])
  

first_message_pos = 1024
last_pos = first_message_pos
onetoten = range(1,mbase_meta["activemsgs"])

msgs = []
msg = ""
for i in onetoten:
  if (last_pos>0):
    (last_pos,msg) = get_msg_next(last_pos)
    msgs.append(msg)


# MYSTIC BBS A38 SQLITE DATABASE STRUCTURES PREPARATION
import sqlite3

mbbs_msgs_dir="/u01/bbs/msgs"
mbbs_msgs_repo=mbbs_logs_dir+"/" + "mbbs_msgs.db"

conn=sqlite3.connect(mbbs_msgs_repo)
sql_create_mutil_table = """ CREATE TABLE IF NOT EXISTS messages (
                                        id integer PRIMARY KEY AUTOINCREMENT,
                                        message text NOT NULL
                                    ); """
 
c = conn.cursor()
c.execute(sql_create_mutil_table)
c.close()

#  MYSTIC BBS A38 SQLITE MESSAGE BASE LOADER
import sqlite3

mbbs_msgs_dir="/u01/bbs/msgs"
mbbs_msgs_repo=mbbs_logs_dir+"/" + "mbbs_msgs.db"

sql_insert_row = """ INSERT INTO messages (message) VALUES (
                                        ?
                                    ); """

try:
  conn=sqlite3.connect(mbbs_msgs_repo)
except Error as e:
  print(e)
with conn:
  c = conn.cursor()
  for i,m in enumerate(msgs):
    c.execute(sql_insert_row,[msgs[i]])
conn.close()
