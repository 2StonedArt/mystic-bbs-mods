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

import os
class door:
    cfg = {}
    def readdoor32sys(self,fname):
        f = open(fname,"r")
        self.cfg["commtype"] = f.readline()
        self.cfg["portorhandle"] = f.readline()
        self.cfg["baud"] = f.readline()
        self.cfg["bbsid"] = f.readline()
        self.cfg["userrecpos"] = f.readline()
        self.cfg["username"] = f.readline()
        self.cfg["useralias"] = f.readline()
        self.cfg["usersec"] = f.readline()
        self.cfg["usertimeleft"] = f.readline()
        self.cfg["emulation"] = f.readline()
        self.cfg["node"] = f.readline()
        f.close()
        
    def readdoorsys(self,fname):
        f = open(fname,"r")
        self.cfg["commtype"] = f.readline()             
        self.cfg["baud"] = f.readline()
        self.cfg["parity"] = f.readline()
        self.cfg["node"] = f.readline()
        self.cfg["BPS"] = f.readline()
        self.cfg["screen"] = f.readline()
        self.cfg["printer"] = f.readline()
        self.cfg["bell"] = f.readline()
        self.cfg["caller_alarm"] = f.readline()
        self.cfg["fullname"] = f.readline()
        self.cfg["from"] = f.readline()
        self.cfg["homephone"] = f.readline()
        self.cfg["dataphone"] = f.readline()
        self.cfg["password"] = f.readline()
        self.cfg["usersec"] = f.readline()
        self.cfg["totaltimeson"] = f.readline()
        self.cfg["lastcall"] = f.readline()
        self.cfg["secremaincall"] = f.readline()
        self.cfg["minremaincall"] = f.readline()
        self.cfg["graphics"] = f.readline()
        self.cfg["pagelength"] = f.readline()
        self.cfg["usermode"] = f.readline()
        self.cfg["regforums"] = f.readline()
        self.cfg["exitforum"] = f.readline()
        self.cfg["userexpdate"] = f.readline()
        self.cfg["userrecno"] = f.readline()
        self.cfg["protocol"] = f.readline()
        self.cfg["uploads"] = f.readline()
        self.cfg["downloads"] = f.readline()
        self.cfg["dailydwtotal"] = f.readline()
        self.cfg["dailydwmax"] = f.readline()     
        f.close()
        
    def readdoor(self,directory):
        res = False
        PATH=directory+os.sep+'door32.sys'
        if os.path.isfile(PATH) and os.access(PATH, os.R_OK):
            self.readdoor32sys(PATH)
            return str('door32')           
        else:    
          PATH=directory+os.sep+'DOOR.SYS'
          if os.path.isfile(PATH) and os.access(PATH, os.R_OK):
              self.readdoorsys(PATH)
              return str('door')
        
        return res
        
#Usage Example, using the PyCRT Unit
# dr=door()
# writeln(dr.readdoor('/home/x/mystic/temp1'))
# writeln(dr.cfg)        
# 
# Now the dr.cfg contains all the info from DOOR/32.SYS file

#DOOR.SYS Format
#COM1:             <-- Comm Port - COM0: = LOCAL MODE
#2400              <-- Baud Rate - 300 to 38400
#8                 <-- Parity - 7 or 8
#1                 <-- Node Number - 1 to 99                    (Default to 1)
#19200             <-- DTE Rate. Actual BPS rate to use.
#Y                 <-- Screen Display - Y=On  N=Off             (Default to Y)
#Y                 <-- Printer Toggle - Y=On  N=Off             (Default to Y)
#Y                 <-- Page Bell      - Y=On  N=Off             (Default to Y)
#Y                 <-- Caller Alarm   - Y=On  N=Off             (Default to Y)
#Rick Greer        <-- User Full Name
#Lewisville, Tx.   <-- Calling From
#214 221-7814      <-- Home Phone
#214 221-7814      <-- Work/Data Phone
#PASSWORD          <-- Password
#110               <-- Security Level
#1456              <-- Total Times On
#03/14/88          <-- Last Date Called
#7560              <-- Seconds Remaining THIS call (for those that particular)
#126               <-- Minutes Remaining THIS call
#GR                <-- Graphics Mode - GR=Graph, NG=Non-Graph, 7E=7,E Caller
#23                <-- Page Length
#Y                 <-- User Mode - Y = Expert, N = Novice
#1,2,3,4,5,6,7     <-- Conferences/Forums Registered In  (ABCDEFG)
#7                 <-- Conference Exited To DOOR From    (G)
#01/01/99          <-- User Expiration Date
#1                 <-- User File's Record Number
#Y                 <-- Default Protocol - X, C, Y, G, I, N, Etc.
#0                 <-- Total Uploads
#0                 <-- Total Downloads
#0                 <-- Daily Download "K" Total
#999999            <-- Daily Download Max. "K" Limit
