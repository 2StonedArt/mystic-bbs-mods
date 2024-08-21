#!/bin/ksh
#
# program    : make_gfiles.ksh
# Version    : 1.0
# Author     : Darryl Perry, aka Gryphon, Cyberia BBS, cyberia.darktech.org
# Date       : First relaease : 05/08/2014
# Description: Companion tool to the gfiles.mps program for Mystic BBS
#            : make_gfiles will allow the creation of gfiles.dat files, or
#            : the data file that holds all the textfile entries in the
#            : gfiles.mps Mystic BBS program.  Use this tool to create
#            : the gfiles.dat file outside of the Mystic BBS environment.
#            : 
#            : This program is not useful as is.  It is designed to read
#            : a list of *.art article files, grep for the title of the 
#            : article file, and the author, and then add those fields
#            : into the the gfiles.dat file.  
#            : This is a quick way to create Pascal-format data files.
#            : I use this to create the article listings in my RSS feeds.
#            : You may use it any way you wish.  It is only intended as a
#            : starting point to help with your own script.

### Change rssdir to point to your text dir.
rssdir=/home/bbs/rss/psmag
gfiles=${rssdir}/gfiles.dat


ord(){
	printf "\\$(printf '%03o' ${1})"
}
long(){
	printf "\\$(printf '%04o' ${1})"
}
short(){
	printf "\\$(printf '%02o' ${1})"
}

write_gfiles() 
{
	outfile=$1
	ord "${#outfile}" >> ${gfiles}
	printf "%-80.80s" "${outfile}" >> ${gfiles}
	ord "${#title}" >> ${gfiles}
	printf "%-80.80s" "${title}"} >> ${gfiles}
	ord "${#author}" >> ${gfiles}
	printf "%-30.30s" "${author}" >> ${gfiles}
	ord "1" >> ${gfiles}
}

cd $rssdir
## Remove the gfiles.dat file or run the risk of adding duplicate
## entries to the file.
rm -f ${gfiles}

# Generate a list of text files to read.  Mine end with *.art.
article=`ls -t *.art`

for a in $article; do
   ### The titles of the articles just happen to be on the first line
   ### of the file.  Capture that as the title.
	title=`cat $a | head -1`
	### The author of the article is found after "By" on a line by itself"
	author=`cat $a | grep "^   By " | head -1 | awk '{print $2" "$3}'`

	### Create the entry.
	write_gfiles $a
done
