# MTAFile
## Mystic BBS File Announce Program

                             Mys Tic File Announce 
                                  Ver 2.0.0.0

								 
* Black Panther(RCS)
* aka Dan Richter
* Sysop - Castle Rock BBS
* telnet://bbs.castlerockbbs.com
* http://www.castlerockbbs.com
* The sparrows are flying again...


##                             -=-= What's New =-=-


This version has a major change! The name of the config file has changed to
a more generic name. The reason for this, is the config file will be used for
multiple programs in the near future. The only change that needs to take place
at this time, is rename the mtafile.ini to rcs.ini. Simple enough, right? ;)
Please take a look at the new rcs.ini file, as there have been many additions
made to it. Not all of them are for MTAFile, but as this config file will be
used by multiple programs, it's easier to have all of it in one file.


Please take a look at the new rcs.ini file, to make sure that you have all of
the current information included. The file has been slightly re-arranged into
sections. The general section includes basic information like BBS name, Sysop
name. The MTAFile specific section includes the location of the .tic files.
The other sections can be ignored until these programs are released. If you do
run these programs, just update the rcs.ini file at that time.


##                             -=-= Description =-=-


Mys Tic File Announce is a very simple TIC file announcement generator. Other 
programs that create new file announcements require a lengthy config program
which require all file echos and BBS file areas to be set up. This program will 
take all the information from the TIC files, and generate a report that can be 
posted in message bases.

While this program was written for use with Mystic BBS, running under 
DOS/Windows or Linux, it can be used with any BBS software. Again, there is no
interaction between the BBS software and this program. It is completely 
independent of the BBS.


##                       -=-= Warranties and Guarantees =-=-


While every effort is made to make sure this program does what it is designed
to, and not harm your computer, the only warranty you have, is this program 
will take up space on your hard drive. Other than that, I assume no 
reponsibility for what happens to your computer due to the use of this 
software. 


If you do notice a bug in the program, or have a suggestion on how it could
be improved, please feel free to let me know.


##                               -=-= Files =-=-


* mtafile.exe  -  The main program
* mtafile.txt  -  The file your reading right now :)
* mtafile.rpt  -  File created by the program in Mystic directory		
* mtafile.log  -  File created by the program in logs directory
* rcs.ini      -  Configuration file read by the program
* mtafile.dat  -  File created by the program to hold overall stats
* final.txt    -  File created by the program in Mystic directory


##                            -=-= Installation =-=-


MTAFile now has a config file which allows you, the Sysop, to define a few
options, instead of including them on the command line. This file must exist
for the program to run. A sample config file is included with this archive.


The format of the config will be very familiar to you. All lines that start
with the ';', are considered comments and will be ignored. The remaining lines
include:


```Plain Text
TicPath=c:\path\to\incoming\tic\files\

BBS=Another Awesome BBS

Sysop=Exaulted Ruler

LogPath=c:\path\to\log\files\
```


Please note, the trailing slash/backslash is required in the paths. There will
be better error checking for this in future versions.


The EXE file should be placed in your \mystic directory. It will create a log
file that will be placed in the directory assigned in the config, called 
mtafile.log. This log contains, when the program was run, which files were 
announced, and from which file echo area. Right now, the log file does grow
quickly, as there is still quite a bit of debugging information being
included. 


MTAFile creates a file in the \mystic directory called mtafile.rpt. This file
can have a header and/or footer file attached to it, before being posted to 
the message echos. (Instructions will be shown below)


If the files 'header.txt' or 'footer.txt' are in the directory, MTAFile will
combine them with the 'mtafile.rpt' to create the 'final.txt'.


This program can be run with two different setups. It can be called whenever
new files are received, for those Sysops who post multiple new file 
announcements per day. *Keep in mind, the mtafile.rpt is overwritten each time 
the program in run.* The other way to set this up, is to copy the TIC files
into an announcement sub-directory. Then, when the nightly maintenance is run,
this program will process all of the TICs received, and generate one file
announcement per day. I will give examples below of how I have this set up at
Castle Rock BBS.


The following instructions show installation on a Windows system. I think it
is safe to assume if you are running the Linux/Ubuntu version, you should be
able to figure the commands out. :) If not, contact me, and I'll provide more
information on the Linux installation.


```Plain Text
Command line parameters:

-a - Announce mode

-r - Report mode

-h - Help screen

?  - Help screen
```


```Plain Text
mtafile.exe -a
```

or

```Plain Text
./mtafile -a
```


This will process any .tic files that are located in the directory given in 
the config file. It will generate the mtafile.rpt file, and combine the 
header.txt and footer.txt files, if they exist, to create the final.txt.


```Plain Text
mtafile.exe -r #
```

or 

```Plain Text
./mtafile -r #
```


This will generate a report using the information in the mtafile.dat file, for
the last # number of runs. For example, if you run MTAFile once per day, as I 
think most of us do, and you run ./mtafile -r 7, the report generated will 
show the incoming file stats for the last 7 days. If you would like this to
show only one day, just run ./mtafile -r 1, etc.


Here is a sample of my mailin.bat file that runs whenever incoming mail/files
are received:


-=>snip<=-


```Bash
c:

cd \bbs\mystic\


:start

if exist c:\bbs\mystic\echomail\in\*.tic goto file

goto in


:file

cd \bbs\mystic\echomail\in\

copy *.tic \bbs\mystic\echomail\in\announce\ /y

cd \bbs\mystic\

mutil fileimport

goto in


:in

cd \bbs\mystic\

mutil mailin.ini

goto end


:end

cd \bbs\mystic\
```


-=>snip<=-


(In case your wondering, this is only a portion of the complete batch file 
used at Castle Rock BBS. The actual file is about five times as long, but 
this should give you the idea)


Then, in your nightly maintenance, you would include something like the 
following:


-=>snip<=-


```Bash
c:

cd \bbs\mystic\


del mtafile.rpt

del final.txt

mtafile -a


cd \bbs\mystic\

mutil fileannounce.ini
```


-=>snip<=-


The 'del mtafile.rpt' and 'del final.txt' lines will ensure that old postings 

do not get posted again. These files will be generated on the 'mtafile' line 

which follows. The program should now delete old copies of mtafile.rpt, but I

would still leave this in, just to be safe. :)


The program will take the output file of MTAFILE.RPT, and combine it with 

HEADER.TXT and FOOTER.TXT files, if they exist. These files would need to be

located in the \mystic directory. The final output file name is FINAL.TXT. 


The last line is telling MUTIL to post the text file to different message

areas on the BBS.


The FILEANNOUNCE.INI file that I am using looks like this:


-=>snip<=-

```Plain Text
[General]


	PostTextFiles      = true


	logfile=mutil.log


	loglevel=3


; ==========================================================================
; ==========================================================================
; ==========================================================================


[PostTextFiles]


	totalfiles = 8


	file1_name    = c:\mystic\final.txt

        file1_baseidx = 2
	
	file1_from    = CRBBS File Bot
	
	file1_to      = All
	
	file1_subj    = New Files at Castle Rock BBS
	
	file1_addr    = 1:317/3
	
	file1_delfile = false
```	

-=>snip<=-


This .INI file is very well documented, so there shouldn't be any problems
with figuring out how to set it up.


                              -=-= Credits =-=-


I would like to give sincere thanks to the following people

(in no particular order):


g00r00    -  for making, and maintaning an awesome BBS package

Avon      -  for having an great network which provides great support

             and for testing this program during pre-release

GaryCrunk -  for answering some rookie pascal questions

Apam      -  for showing us all that BBS programming is still alive

fsxNet    -  for putting up with my stupid questions and test posts

Cmech     -  for making great looking programs look easy to do :)

Gryphon   -  for porting some awesome games into MPL which got me 

             interested in learning Pascal again
	     
xqtr      -  for making some great MPLs - even if most of them won't work 

             on Windows :) (I ran Windows at the time)
	     
fabian    -  for helping me figure out better functions to use

tiny      -  for giving me his string compare functions to use			 


I know I'm forgetting people here. It is not intentional. :)


                             -=-= Known bugs: =-=-


- None at this time - If you find something, please let me know


                              -=-= ToDo List: =-=-


- Experiment with adding ANSI capability to output file

- Would like to be able to add something to announce hatched files
