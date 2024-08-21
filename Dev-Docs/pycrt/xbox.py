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

c=colors
box1=('Ú','Ä','¿','³','³','À','Ä','Ù',' ')
box2=('É','Í','»','º','º','È','Í','¼',' ')
box3=('Ö','Ä','·','º','º','Ó','Ä','½',' ')
box4=('Õ','Í','¸','³','³','Ô','Í','¾',' ')
box5=('Û','ß','Û','Û','Û','Û','Ü','Û',' ')
box6=('Û','ß','Ü','Û','Û','ß','Ü','Û',' ')
box7=(' ',' ',' ',' ',' ',' ',' ',' ',' ')
box8=('.','-','.','|','|','`','-','\'',' ')
box9=(c[15]+'Û',c[15]+c[23]+'ß',c[23]+c[8]+'Ü',c[15]+'Û',c[8]+'Û',c[15]+c[23]+'ß',c[8]+c[23]+'Ü',c[8]+'Û',c[7]+c[23]+' ')
box10=(c[17]+' ',c[17]+' ',c[17]+' ',c[15]+c[23]+'Ý',c[8]+c[23]+'Þ',c[8]+c[16]+'ß',c[8]+c[16]+'ß',c[8]+c[16]+'ß',c[7]+c[23]+' ')
box11=(c[11]+'þ',c[11]+'ß',c[15]+'þ',c[11]+'Ý',c[3]+'Þ',c[15]+'þ',c[3]+'Ü',c[3]+'þ',c[16]+' ')
box12=(c[7]+'þ',c[7]+'ß',c[15]+'þ',c[7]+'Ý',c[8]+'Þ',c[15]+'þ',c[8]+'Ü',c[8]+'þ',c[16]+' ')

def ansibox(x1,y1,x2,y2,box):
    gotoxy(x1,y1)
    #swrite(box[0]+box[1]*(x2-x1-1)+box[2])
    write(box[0]+box[1]*(x2-x1-1)+box[2])
    gotoxy(x1,y2)
    #swrite(box[5]+box[6]*(x2-x1-1)+box[7])
    write(box[5]+box[6]*(x2-x1-1)+box[7])
    for i in range(y2-y1-1):
        gotoxy(x1,y1+1+i)
        #swrite(box[3]+box[8]*(x2-x1-1)+box[4])
        write(box[3]+box[8]*(x2-x1-1)+box[4])

def preview_boxes():
    ansibox(2,2,10,7,box1)
    writexy(4,4,7,"box1")
    ansibox(12,2,20,7,box2)
    writexy(14,4,7,"box2")
    ansibox(22,2,30,7,box3)
    writexy(24,4,7,"box3")
    ansibox(32,2,40,7,box4)
    writexy(34,4,7,"box4")
    ansibox(42,2,50,7,box5)
    writexy(44,4,7,"box5")
    ansibox(52,2,60,7,box6)
    writexy(54,4,7,"box6")
    ansibox(62,2,70,7,box7)
    writexy(64,4,7,"box7")
    ansibox(2,9,10,14,box8)
    writexy(4,11,7,"box8")
    ansibox(12,9,20,14,box9)
    writexy(14,11,7,"box9")
    ansibox(22,9,30,14,box10)
    writexy(24,11,7,"box10")
    ansibox(32,9,40,14,box11)
    writexy(34,11,7,"box11")
    ansibox(42,9,50,14,box12)
    writexy(44,11,7,"box12")
    
    