#!/usr/bin/python3

import bltcrt as crt


crt.init()

crt.writexy(5,5,14,'This is a very small example!')
crt.writexy(15,15,3,'Press a key to continue...')
crt.readkey()

crt.shutdown()
