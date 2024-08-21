#!/usr/bin/python
import requests
import sys
import cmd2 as cmd
import os
import csv
import json
import tabulate
import pandas as pd
from prettytable import PrettyTable
from subprocess import Popen, PIPE
import wikipedia
import textwrap
import codecs
from termcolor import colored
from colorama import Fore, Back, Style
import re
import unicodedata

bbs_path = "/u01/bbs/text/wiki"
bbs_name = "Infoline BBS"
prog_version = "0.1"
keyword = "wiki"
section_010_begin = "--||"
section_010_end = "||--\n"
section_020_begin = "--++"
section_020_end = "++--\n"
section_010_text = Fore.YELLOW
section_020_text = Fore.CYAN
section_010_ansi_color = 'yellow'
section_010_text_color = 'yellow'
section_020_ansi_color = 'cyan'
section_020_text_color = 'cyan'

def getWikiPage(keyword):
  res = wikipedia.page(keyword.lower())
  keyword = keyword.lower().replace(" ","_")
  file = codecs.open(bbs_path + "/" + keyword + '.txt','arw+','utf-8')
  file.truncate()
  file.write("\n\n"+Style.BRIGHT + colored(keyword.lower(),'red') + "\n")
  file.write(Style.DIM + colored("---=========================================================================---\n",'green'))
  file.write(Style.BRIGHT + colored(""+bbs_name+" - Wiki [v"+ prog_version + "]") + "\n")
  file.write(Style.DIM + colored("---=========================================================================---\n",'green'))
  file.write(colored(""+"=".ljust(79,"-")+"=\n",'yellow'))
  file.write("" + "\n")
  file.write(" + ");
  p1 = re.compile('(===)(.*)(===)',re.MULTILINE)
  p2 = re.compile('(==)(.*)(==)',re.MULTILINE)
  bfsep=res.content
  bfres=bfsep
  afres = unicodedata.normalize('NFKD', bfres ).encode('ascii','ignore')
  afres = p1.sub(Style.DIM + colored(section_010_begin,section_010_ansi_color) + Style.BRIGHT + colored(r"\2",section_010_text_color) + Style.DIM + colored(section_010_end,section_010_ansi_color) + section_010_text ,bfres)
  afres = p2.sub(Style.DIM + colored(section_020_begin,section_020_ansi_color) + Style.BRIGHT + colored(r"\2",section_020_text_color) + Style.DIM + colored(section_020_end,section_020_ansi_color) + section_020_text,afres)
  #if section_010_begin in outline or section_020_begin in outline:
  for i in textwrap.wrap(afres,70,break_long_words=False,replace_whitespace=False, drop_whitespace=False):
    outline = "%s" % i
    file.write(outline)
  file.write("" + "\n")
  file.write(""+"=".ljust(77,"-")+"=")
  file.close()

def noway():
    print "->" # red

class cli(cmd.Cmd):

  prompt = '-> '
  intro = "Initializating ...\nUse: wiki <keyword>\nExit: q"

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

  def do_wiki(self,line):
    resp = getWikiPage(line) 
    line = line.lower().replace(" ","_")
    print (colored('---=== ' + line + ' ===---','green'))
    counter = 2
    sep_counter = 0
    os.system('ansi ' + bbs_path + "/" + line + '.txt')

if __name__ == '__main__':
  cli().cmdloop()
