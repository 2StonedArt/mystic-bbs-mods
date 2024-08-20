#!/usr/bin/python3

import feedparser
import sys
import textwrap
import re
import json

def savelist2json(lista,filename):
  try:
    with open(filename, 'w+') as outfile:
      json.dump(lista, outfile,indent=2)
    return 0
  except:
    return -1

def cleanhtml(raw_html):
  cleanr = re.compile('<.*?>')
  cleantext = re.sub(cleanr, '', raw_html)
  return cleantext
  
def byte2str(v):
    s=''.join(str(v))
    return s[2:-1]

if len(sys.argv)<3: quit()

url= sys.argv[1]
fout = sys.argv[2]
feed = feedparser.parse(url)

feeds = list()

def deutf(s):
  line = s.encode('ascii','ignore')
  line = line.decode('ascii')
  return line

if len(feed.entries)>0:
  for entry in feed.entries:
    item = dict()
    item['date'] = "%d/%02d/%02d" % (entry.published_parsed.tm_year,\
    entry.published_parsed.tm_mon, \
    entry.published_parsed.tm_mday)
    item['title'] = cleanhtml(deutf(entry.title))
    item['link'] = cleanhtml(deutf(entry.link))
    
    l = cleanhtml(deutf(entry.summary))
    l = l.replace('\n','\r')
    l=re.sub(r'\&\#\d{1,4}\;', '', l)
    item['summary'] = l
    
    feeds.append(item)

  savelist2json(feeds,fout)
  
