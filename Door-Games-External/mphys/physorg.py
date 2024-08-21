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
import urllib2
import time 

bbs_name = "Last BBS"
prog_version = "0.1"
keyword = "Physorg"
rss_url = "https://phys.org/rss-feed/"

#https://phys.org/rss-feed/

feed = feedparser.parse( rss_url)
y = len(feed[ "items" ])

file = codecs.open('/u01/bbs/text/' + keyword.lower() + '.txt','arw+','utf-8')
file.truncate()
file.write("|16|07|CL|03---=========================================================================---\n")
file.write("    |10"+bbs_name+"|03 - |05News from " + keyword + " |09[v"+ prog_version + "]|03\n")
file.write("---=========================================================================---\n")

file.write("|03"+"=".ljust(77,"-")+"=\n")

for x in range(0,y):
  file.write("|11" + str(x) + " |10"+feed[ "items" ][x][ "title" ]+ "\n")

file.write("|03"+"=".ljust(77,"-")+"=\n")
file.close() 


def get_text(link):
  article = []
  user_agent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.101 Safari/537.36'
  headers = { 'User-Agent' : user_agent }
  req = urllib2.Request(link, None, headers)
  r = urllib2.urlopen(req).read()
  content = r
  soup = BeautifulSoup(content, "html.parser")
  for div in soup.findAll('p'):
    article.append(div.text)
  return (article)


for x in range(0,y):
  file = codecs.open('/u01/bbs/text/' + keyword.lower() + str(x) + '_tmp.txt','arw+','utf-8')
  file.truncate()
  
  article = '\n'.join([str(i.encode("ascii","ignore")) for i in get_text(feed["items"][x]["link"].encode("ascii","ignore"))])
  file.write("|RP23")
  file.write("|10"+feed[ "items" ][x][ "title" ]+ "\n")
  file.write("|12" + "\n")
  file.write("|10");
  file.write(article)
  file.write("" + "\n")
  file.close()
  os.system('fmt -w80 ' + '/u01/bbs/text/' + keyword.lower() + str(x) + '_tmp.txt > /u01/bbs/text/' + keyword.lower() + str(x) + '_fmt.txt')
  os.system('cat ' + '/u01/bbs/text/' + keyword.lower() + str(x) + '_fmt.txt | grep -v "adsbygoogle" > /u01/bbs/text/' + keyword.lower() + str(x) + '.txt')
  time.sleep(3)

