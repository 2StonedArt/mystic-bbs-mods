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

import datetime

def datestr(t):
    if t == 1:
        return datetime.date.today().strftime('%d/%m/%Y')
    elif t == 2:
        return datetime.date.today().strftime('%m/%d/%Y')
    elif t == 3:
        return datetime.date.today().strftime('%Y/%m/%d')
    elif t == 4:
        return datetime.date.today().strftime('%j')
    elif t == 5:
        return datetime.date.today().strftime('%s')
        
def unpackdt(t): #unpacks a DOS time longint
    year = 1980 + (t >> 25)
    month = (t & 0b00000001111000000000000000000000) >> 21
    day = (t & 0b00000000000111110000000000000000) >> 16
    hour = (t & 0b00000000000000001111100000000000) >> 11
    minute = (t & 0b00000000000000000000011111100000) >> 5
    second = (t & 0b00000000000000000000000000011111) * 2
    return datetime(year, month, day, hour, minute, second)
        
def datetimeunix():
    dt = datetime.datetime.now()
    return dt.strftime("%s")
    
def now():
    return datetime.datetime.now()
    
def date():
    return datetime.datetime.today()

def timestr(t):
    if t == 1:
        return datetime.datetime.now().strftime('%H:%M:%S')
    elif t == 2:
        return datetime.datetime.now().strftime('%I:%M:%S %p')
    elif t == 3:
        return datetime.datetime.now().strftime('%H:%M')
    elif t == 4:
        return datetime.datetime.now().strftime('%I:%M %p')
    elif t == 5:
        return datetime.date.today().strftime('%s')
        
def datevalid(date_text):
    res = False
    try:
        datetime.datetime.strptime(date_text, '%d/%m/%Y')
    except ValueError:
        res = False
    if res == True:
        return True
    try:
        datetime.datetime.strptime(date_text, '%m/%d/%Y')
    except ValueError:
        res = False
    if res == True:
        return True  
    try:
        datetime.datetime.strptime(date_text, '%s')
    except ValueError:
        res = False
    if res == True:
        return True 
    try:
        datetime.datetime.strptime(date_text, '%Y/%m/%d')
    except ValueError:
        res = False
    return res        
    
def dayofweek():
    return datetime.date.today().weekday()

def ismdy(date_text):
    res = True
    try:
        datetime.datetime.strptime(date_text, '%m/%d/%Y')
    except ValueError:
        res = False
    return res
    
def isdmy(date_text):
    res = True
    try:
        datetime.datetime.strptime(date_text, '%d/%m/%Y')
    except ValueError:
        res = False
    return res

def isymd(date_text):
    res = True
    try:
        datetime.datetime.strptime(date_text, '%Y/%m/%d')
    except ValueError:
        res = False
    return res  

    
def daysago(date_text):
    if isymd(date_text):
        b = datetime.datetime.strptime(date_text, '%Y/%m/%d')
        
    if isdmy(date_text):
        b = datetime.datetime.strptime(date_text, '%d/%m/%Y')
        
    if ismdy(date_text):
        b = datetime.datetime.strptime(date_text, '%m/%d/%Y')
       
    a = datetime.datetime.today()
    c = abs(a - b)
    return c.days
    
def timer():
    now = datetime.datetime.now()
    midnight = now.replace(hour=0, minute=0, second=0, microsecond=0)
    seconds = (now - midnight).seconds
    return seconds
    
def formatdatetime(form):
    return datetime.datetime.now().strftime(form)
