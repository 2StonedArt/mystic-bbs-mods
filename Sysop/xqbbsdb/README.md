# xqbbsdb
BBS Database MOD for Mystic BBS

> // What is it?
 
 > It's a BBS Database, that self populates its data from two sources. 
 The first source is the Message Bases of the Echonets your BBS is 
 connected to! The second one, is special data packets that the MOD 
 sends, to selected echo areas, with information about your BBS. Even 
 if you don't want to send these special packets, the MOD can gather 
 BBS information from the echo nets. No need for you to fill anything.
 
 > But it's advisable to send the special packets, called "Pings" from 
 now on. A Ping contains information, you provide, about your BBS, like 
 location, web page, how many calls it has and more. This way, a 
 visitor that checks your BBS info, through the mod, can see that you 
 have a BBS with many calls (for example) and also connect to it, or 
 because he saw that you have many interesting File Areas, worth 
 checking.
 
 > The mod, sends info/data, that only you provided and in no 
 circumstance, sends other info. There is a Configuration script, that 
 you can easily use to fill the information you want to provide.
 
 
 // How it works?
 
 > The mod uses a SQLite database to store all the data. This way, when 
 you use the main mod script, you can use any SQL query to share the 
 information to your users/visitors. As an example you can see the 
 default configuration, but you can also write anything you like or 
 think that would be useful to your visitors.
 
 > The mod is actually a sum of one big/main script and some other 
 smaller. In detail:
 
   - BBSDB    : Main script.
   - BBSDBLOG : The script that sends the Ping messages.
   - BBSDBCFG : Configuration script.
   - BBSDBSQL : The scrape tool to gather BBS information from the echo 
                areas.
   - BBSDBCOM : Common functions used by the other scripts.
   - BBSDBVAR : Variables stored, that are needed by the mod.
 
 > You use the BBSDBLOG script to send automatic Ping messages, for 
 other BBSes to catch/read and fill their databases. So, if many BBSes 
 use this mod, the database will be more complete and accurate.
 
 > You don't have to send too many Ping messages. One per one or two 
 days is enough, or you could send them, while a user logs into your 
 BBS.
 
 > With the BBSDBSQL script, we can fill the database by scraping as 
 many echoareas you like, for telnet addresses. This script uses a 
 telnet Regex and any match, is added into the database. It's not an 
 accurate way, for gathering BBS information, but still it helps a lot 
 to have an informed BBS database. 
 
 > The regex for searching BBS address, needs the BBS port to be passed 
 in the telnet address (ex. mybbs.com:23), otherwise it discards it. 
 It's just a regex, not an AI :) So it would be a good practice to fill 
 your complete telnet address (address:port), in the origin line of 
 your BBS messages, as this scrape tool, searches for telnet addresses 
 in the Origin line of each post.
