#!/usr/bin/python3

import os
import struct
import sys

# gets basic sauce info from file
def getsauce(filename):
    f = open(filename, 'rb')
    f.seek(-128,2)
    saucestr = "<5s2s35s20s20s8si32x"
    sf = struct.calcsize(saucestr)
    sauce = f.read(sf)
    #sid, version, title, author, group, date, size = struct.unpack(saucestr,sauce)
    s = struct.unpack(saucestr,sauce)
    f.close()
    if ''.join(str(s[0]).strip("b'")) == "SAUCE":
        return s
    else:
        return -1

