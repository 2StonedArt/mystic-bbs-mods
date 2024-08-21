#
# (c) 2018 Last Sysop from Infoline
#

import cmd2 as cmd
import sqlite3
from sqlite3 import Error
from prettytable import PrettyTable

config_pretty = "N" # This toggle usage of Pretty Tables

bbs_path="/u01/bbs"
pho_fname=bbs_path + "/data/zenpho.db" # change to path imported using import.py
bbs_name="Infoline BBS" # Change to Your BBS Name
prog_version="0.1"
keyword="zenpho"

def rep(s,n):
  ''.join(list(repeat(s,n)))

def create_connection(db_file):
  try:
    conn = sqlite3.connect(db_file)
    return conn
  except Error as e:
    print(e)
  return None

def print_rows(keyword,rows):
  pageno = 0
  datlen = len(rows)
  pagesize = 19
  print("--[ ====================================================================== ]--")
  print("***  Found " + str(datlen) + " records.")
  print("--[ ====================================================================== ]--")
  if (config_pretty == "Y"):
    t = PrettyTable(["Name","Surname","E-mail","Phone"])
    for x in range(0,datlen,pagesize):
      for val in rows[(pageno*pagesize):((pageno+1)*pagesize)]:
        t.add_row(val)
      page = str(t)
      print page
      if ((pageno+1)*pagesize < datlen):
        raw_input("Press any key ...")
      pageno = pageno + 1
  else:
    for x in range(0,datlen,pagesize):
      for val in rows[(pageno*pagesize):((pageno+1)*pagesize)]:
        print (val[0]+"|"+val[1]+"|"+val[2]+"|"+val[3])
      if ((pageno+1)*pagesize < datlen):
        raw_input("-[ Press any key ... ]-")
      pageno = pageno + 1
  print("--[ ====================================================================== ]--")
   

def query_phone(keyword):
  base = "/u01/bbs/data/zenpho.db"
  conn = create_connection(base)
  cur = conn.cursor()
  cur.execute(
  """
    SELECT given_name, family_name, email_1_value, phone_1_value 
     FROM contacts
      where phone_1_value like ?
  """, ('%'+keyword+'%',))
  rows = cur.fetchall()
  print_rows(keyword,rows)

def query_email(keyword):
  base = "/u01/bbs/data/zenpho.db"
  conn = create_connection(base)
  cur = conn.cursor()
  cur.execute(
  """
    SELECT given_name, family_name, email_1_value, phone_1_value 
     FROM contacts
      where email_1_value like ?
  """, ('%'+keyword+'%',))
  rows = cur.fetchall()
  print_rows(keyword,rows)

def query_first_name(keyword):
  base = "/u01/bbs/data/zenpho.db"
  conn = create_connection(base)
  cur = conn.cursor()
  cur.execute(
  """
    SELECT given_name, family_name, email_1_value, phone_1_value 
     FROM contacts
      where first_name like ?
  """, ('%'+keyword+'%',))
  rows = cur.fetchall()
  print_rows(keyword,rows)

def query_last_name(keyword):
  base = "/u01/bbs/data/zenpho.db"
  conn = create_connection(base)
  cur = conn.cursor()
  cur.execute(
  """
    SELECT given_name, family_name, email_1_value, phone_1_value 
     FROM contacts
      where family_name like ?
  """, ('%'+keyword+'%',))
  rows = cur.fetchall()
  print_rows(keyword,rows)

def getContact(keyword):
  txt_banner = "" \
    + "\n\n" \
    + "\033[2J" \
    + "\n"
  #  print (txt_banner)
  print (keyword)
  query_contacts(keyword)

def noway():
    print "->" # red

class cli(cmd.Cmd):

  prompt = '> '
  intro = "\nZEN PHONEBOOK\n"+bbs_name+"\nUse:\nsl <last name>\nsf <first name>\nsp <phone>\nse <e-mail>\nnq - quit\n"

  def do_shell(self, line):
    noway()

  def do_pause(self, line):
    noway()

  def do_edit(self, line):
    noway()

  def do_shortcuts(self, line):
    noway()

  def do_set(self, line):
    noway()

  def do_run(self, line):
    noway()

  def do_py(self, line):
    noway()

  def do_load(self, line):
    noway()

  def do__relative_load(self, line):
    noway()

  def do_version(self, line):
    noway()

  def do_help(self, line):
    noway()

  def do_sf(self,line):
    resp = query_first_name(line) 

  def do_sl(self,line):
    resp = query_last_name(line) 

  def do_se(self,line):
    resp = query_email(line) 

  def do_sp(self,line):
    resp = query_phone(line) 


if __name__ == '__main__':
  try:
    cli().cmdloop()
  except:
    pass
