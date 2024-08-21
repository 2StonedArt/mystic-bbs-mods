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

exit_keys = []
exit_code = ""

scrollbar = {"enable":True,"hichar":"▓","lochar":"░","hiatt":7,"loatt":8}

def menulist(items,x1,y1,x2,y2,hc=15,nc=7,sel=0,sb=scrollbar):
    """
    Displays a menu with lightbar, to select from
    items   : list of items to display
    x1,x2,
    y1,y2   : box area to display the menu
    hc      : Highlight/On color
    nc      : Normal text/off color
    sel     : default value to begin with.
    sb      : a dictionary, with values to display a scrollbar in the 
              right side of the menu
    """
    global exit_keys
    global exit_code
    
    def updatebar():
        if sb["enable"] == False: Return
        for i in range(0,y2-y1+1):
            swritexy(x2,y1+i,sb["loatt"],sb["lochar"])
        if len(items) < 2:
            y = 0
        else:
            y = (selbar * (y2-y1)) // (len(items)-1)
        swritexy(x2,y1+y,sb["hiatt"],sb["hichar"])
    
    if len(items)<1:
      return -1
    exit_code = ""
    key = ""
    value = -1
    done = False
    if sel <= len(items):
        top = sel-(y2-y1)
        if top < 1: top = 0
    else:
        top = 0
    if sel <= len(items):
        selbar = sel
    else:
        selbar = 0
    
    while done == False:
        #writexy(1,1,7,str(top)+"/"+str(selbar)+"/"+str(len(items)))
        gotoxy(x1,y1)
        y = top
        while y1+y-top<=y2:
            if y<len(items):
                writexy(x1,y1+y-top,nc,items[y].ljust(x2-x1, " ")[:x2-x1])
            else:
                writexy(x1,y1+y-top,nc," ".ljust(x2-x1, " ")[:x2-x1])
            y += 1
        writexy(x1,y1+selbar-top,hc,items[selbar].ljust(x2-x1, " ")[:x2-x1])
        #writexy(3,23,7,items[selbar].ljust(75," "))
        updatebar()
        gotoxy(1,25)
        
        key = readkey()
        
        if key == "#up":
            selbar=selbar-1
            if selbar < 1:
                selbar = 0
            if selbar < top:
                top = selbar
        elif key == "#pgup":
            selbar = selbar - (y2-y1)
            if selbar < 0:
                selbar = 0
                top = 0
            else:
                top = top - (y2-y1)
                if top < 0:
                    top = 0
        elif key == "#pgdn":
            selbar = selbar+(y2-y1)
            if selbar > len(items)-1:
                selbar = len(items)-1
            top = top+(y2-y1)
            if top > len(items)-1-(y2-y1):
                top = len(items)-1-(y2-y1)
                if top < 0:
                    top = 0
        elif key == "#end":
            selbar=len(items)-1
            if len(items)-(y2-y1)-1 > 0:
                top = len(items)-(y2-y1)-1
            else:
                top = 0
        elif key == "#home":
            selbar=0
            top = 0
        elif key == "#down": 
            selbar=selbar+1
            if selbar > len(items)-1:
                selbar = len(items)-1
            if selbar > top+y2-y1:
                top += 1
        elif key == "#enter":
            value = selbar
            exit_code = "#enter"
            done = True
        elif key in exit_keys:
            exit_code = key
            value = selbar
            done = True
        
            
    return value