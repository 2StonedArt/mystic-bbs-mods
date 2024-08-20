# Add the name of  your BBS here.
# This will show in the /BBSES command

# Server configuration
# Default ports are 5000 for noSSL and 5001 for SSL


# Add details for your BBS here.
# This will show with the new /INFO command
# Max string is maximum 64 printed characters and 128 total
# PIPE codes are allowed



# Make sure to monitor your client and keep it updated as new
# versions are released. The server will now enforce version
# control and a version deemed too old will not be able to
# connect.

# Pid file location
# This file is used for duplicate process checking
# Use a different location if you run multiple BBSes
# on the same machine
pidfile     = "/tmp/mrc_client.pid"
# pidfile     = "c:/windows/temp/mrc_client.pid"

# BBS root folder
# Change this to your BBS root folder
# This is the path where your Mystic binaries are
# located typically
bbspath     = "/home/mystic/bbs"
# bbspath     = "c:/mystic"

# Add the name of your BBS here.
# This will show in the /BBSES command
bbsname     = "|08>|07>|15> Th|11e Bot|03tomles|11s Aby|15ss <|07<|08<"

# Server configuration
# Default ports are 5000 for noSSL and 5001 for SSL
host         = "mrc.bottomlessabyss.net"
plainport    = 5000
sslport      = 5001
usessl       = 1
nocertcheck  = 1   # Check for certificate validity

# Add details for your BBS here.
# This will show with the new /INFO command
# Max string is maximum 64 printed characters and 128 total
# PIPE codes are allowed
info_web    = "|15https|07:|08//|15bbs|08.|15bottomlessabyss|08.|15net"
info_telnet = "|15telnet|07:|08//|15bbs|08.|15bottomlessabyss|08|15net|08:|152023"
info_ssh    = "|15ssh|07:|08//|15bbs|08.|15bottomlessabyss|08|15net|08:|152222"
info_sysop  = "|11StackFault|08<|03p|11h|15EN|11o|03m|08>"
info_desc   = "|07Home of |15ThreatSentry|07 and |15MRC|07. |11ArakNet|08.|03member|08.|03board"

