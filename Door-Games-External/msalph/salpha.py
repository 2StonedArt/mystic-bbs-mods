#
# Seeking Alpha News for Mystic BBS
#
# VERSION 0.1
#
# By: Last Sysop 
#
# MMXVII a.d.
#

import sys
import os
import feedparser
import sys
import codecs
import requests
from bs4 import BeautifulSoup
import textwrap
from termcolor import colored
from colorama import Fore, Back, Style

bbs_name = "Infoline BBS"
prog_version = "0.1"
keyword = "salpha"
rss_url = "https://seekingalpha.com/listing/most-popular-articles.xml"
bbs_path = "/u01/bbs"

#https://seekingalpha.com/listing/most-popular-articles.xml

feed = feedparser.parse( rss_url)
y = len(feed[ "items" ])

file = codecs.open(bbs_path + '/text/' + keyword.lower() + '.txt','arw+','utf-8')
file.truncate()
file.write("|16|07|CL|03---=========================================================================---\n")
file.write("    |10"+bbs_name+"|03 - |05News from " + keyword.lower() + " |09[v"+ prog_version + "]|03\n")
file.write("---=========================================================================---\n")

file.write("|03"+"=".ljust(77,"-")+"=\n")

for x in range(0,y):
  file.write("|11" + str(x) + " |10"+feed[ "items" ][x][ "title" ]+ "\n")

file.write("|03"+"=".ljust(77,"-")+"=\n")
file.close() 



def get_text(link):
  article = []
  #r = requests.get(df3["link"][0].encode("ascii","ignore"))
  r = requests.get(link)
  content = r.content
  soup = BeautifulSoup(content, "html.parser")
  for div in soup.findAll('p', attrs={'class':'p p1'}):
    article.append(div.text)
  for div in soup.findAll('p', attrs={'class':'p p2'}):
    article.append(div.text)
  for div in soup.findAll('p', attrs={'class':'p p3'}):
    article.append(div.text)
  for div in soup.findAll('p', attrs={'class':'p p4'}):
    article.append(div.text)
  for div in soup.findAll('p', attrs={'class':'p p5'}):
    article.append(div.text)
  for div in soup.findAll('p', attrs={'class':'p p6'}):
    article.append(div.text)
  for div in soup.findAll('p', attrs={'class':'p p7'}):
    article.append(div.text)
  for div in soup.findAll('p', attrs={'class':'p p8'}):
    article.append(div.text)
  for div in soup.findAll('p', attrs={'class':'p p9'}):
    article.append(div.text)
  for div in soup.findAll('p', attrs={'class':'p p10'}):
    article.append(div.text)
  for div in soup.findAll('p', attrs={'class':'p p11'}):
    article.append(div.text)
  for div in soup.findAll('p', attrs={'class':'p p12'}):
    article.append(div.text)
  return (article)

for x in range(0,y):
  file = codecs.open(bbs_path + '/text/' + keyword.lower() + str(x) + '_tmp.txt','arw+','utf-8')
  file.truncate()
  article = '\n'.join(get_text(feed["items"][x]["link"]))
  file.write("|RP23")
  file.write("|10"+feed[ "items" ][x][ "title" ]+ "\n")
  file.write("|12" + "\n")
  file.write("|10");
  file.write(article)
  file.write("" + "\n")
  file.close()
  os.system('fmt -w80 ' + bbs_path + '/text/' + keyword.lower() + str(x) + '_tmp.txt > ' + bbs_path + '/text/' + keyword.lower() + str(x) + '.txt')

