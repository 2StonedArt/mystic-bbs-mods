#!/usr/bin/python3

# coding: CP437

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
import os

exit_keys = []
exit_code = ""

scrollbar = {"enable":True,"hichar":"▓","lochar":"░","hiatt":7,"loatt":8}

def viewtextfile(filename,x1,y1,x2,y2,tc=7,sc=15,sb=scrollbar):
    """
    Displays a text file, supports Up/Down/Home/End/PGUP/PGDN keys
    """
    global exit_keys
    global exit_code
    
    if os.path.isfile(filename) == False: return
    key = ""
    value = -1
    done = False
    sel = 0
    ys = 0
    def updatebar():
        if sb["enable"] == False: Return
        for i in range(0,y2-y1+1):
            swritexy(x2,y1+i,sb["loatt"],sb["lochar"])
        y = (selbar * (y2-y1)) // (len(items)-1)
        swritexy(x2,y1+y,sb["hiatt"],sb["hichar"])
        
    def parseline(s):
        if s == "":
            s = " "*(ys+x2-x1)
        if len(s) > x2-x1:
            s = s[ys:ys+x2-x1]
        else:
            s = s.ljust(ys+x2-x1, " ")[ys:ys+x2-x1]
            #s = (s[ys:ys+x2-x1]+" "*(ys+x2-x1)).strip()
        return s
    
    def drawpage():
        gotoxy(x1,y1)
        y = top
        while y1+y-top<=y2:
            if y<len(items):
                #line = items[y].strip()+" "
                line = items[y].rstrip('\n')
                line=parseline(line)
                writexy(x1,y1+y-top,tc,line)
            else:
                writexy(x1,y1+y-top,tc," ".ljust(x2-x1, " ")[:x2-x1])
            y += 1
        baron(selbar)
    
    def baroff(i):
        writexy(x1,y1+i-top,tc,parseline(items[i].rstrip('\n')+" "))
        
    def baron(i):
        writexy(x1,y1+i-top,sc,parseline(items[i].rstrip('\n')+" "))
    
    fh = open(filename, "r")
    #items = fh.readlines()
    items = fh.read().splitlines()
    fh.close()
    
    if sel <= len(items):
        top = sel
    else:
        top = 0
    if sel <= len(items):
        selbar = sel
    else:
        selbar = 0
        
    drawpage()
    
    while done == False:
        #writexy(1,1,7,str(top)+"/"+str(selbar)+"/"+str(len(items)))
        gotoxy(x1,y1)
        y = top
        
        updatebar()
        gotoxy(1,25)
        
        key = readkey()
        
        if key == "#up":
            baroff(selbar)
            selbar=selbar-1
            if selbar < 1:
                selbar = 0
            baron(selbar)
            if selbar < top:
                top = selbar
                drawpage()
        elif key == "#left":
            ys -= 1
            if ys<0: ys = 0
            drawpage()
        elif key == "#right":
            ys += 1
            drawpage()
        elif key == "#pgup":
            selbar = selbar - (y2-y1)
            if selbar < 0:
                selbar = 0
                top = 0
            else:
                top = top - (y2-y1)
                if top < 0:
                    top = 0
            drawpage()
        elif key == "#pgdn":
            selbar = selbar+(y2-y1)
            if selbar > len(items)-1:
                selbar = len(items)-1
            top = top+(y2-y1)
            if top > len(items)-1-(y2-y1):
                top = len(items)-1-(y2-y1)
                if top < 0:
                    top = 0
            drawpage()
        elif key == "#end":
            selbar=len(items)-1
            if len(items)-(y2-y1)-1 > 0:
                top = len(items)-(y2-y1)-1
            else:
                top = 0
            drawpage()
        elif key == "#home":
            selbar=0
            top = 0
            drawpage()
        elif key == "#down": 
            baroff(selbar)
            selbar=selbar+1
            if selbar > len(items)-1:
                selbar = len(items)-1
                baron(selbar)
            else:
                baron(selbar)
            if selbar > top+y2-y1:
                top += 1
                drawpage()
        elif key == "#enter":
            value = selbar
            done = True
        elif key in exit_keys:
            exit_key = key
            done = True
        
            
    if exit_code == "":
        return value
    else:
        return -1