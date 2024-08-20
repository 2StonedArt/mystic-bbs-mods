                          __
          ___  __________/  |________
          \  \/  / ____/\   __\_  __ \
           >    < <_|  | |  |  |  | \/
          /__/\_ \__   | |__|  |__|
                \/  |__|
-------------------------------------------------
    Announcements Board for Mystic BBS 1.12+     
-------------------------------------------------
With this script you can write announcements
for your BBS or use it to write new stuff added
to your board. The user when logs in, will see
the announcements only if they are newer than
the last time he logged in. After that, he
wont see them again and again when logging in.
The script has built in text editor and the
sysop can write/edit the text online.
    Compatible with Linux/Windows/Raspberry
-------------------------------------------------
                            .oO0( xqtr )0Oo.
                                          ___
                             ,----.     ,--.'|_
                            /   /  \-.  |  | :,'   __  ,-.
                 ,--,  ,--,|   :    :|  :  : ' : ,' ,'/ /|
                 |'. \/ .`||   | .\  ..;__,'  /  '  | |' |
                 '  \/  / ;.   ; |:  ||  |   |   |  |   ,'
                  \  \.' / '   .  \  |:__,'| :   '  :  /
                   \  ;  ;  \   `.   |  '  : |__ |  | '
                  / \  \  \  `--'""| |  |  | '.'|;  : |
                ./__;   ;  \   |   | |  ;  :    ;|  , ;
                |   :/\  \ ;   |   | :  |  ,   /  ---'
                `---'  `--`    `---'.|   ---`-'
                                `---`                                  06/2017

------------------------------------------------------------------------------

                              Announcement Board                               
                                 First Release                                 
                               for mystic 1.12+                                

Software --------------------------------------------------------------------
       [ ] PCB PPe      [ ] OBV          [ ] VGA         [ ] OTHER___________
       [ ] Renegade     [ ] Iiniquity    [ ] ASCII       [ ] HTML/CGI/WWW
       [x] Mystic       [ ] WWVI         [ ] Telegard    [x] MPL
       [ ] ANSI         [ ] TEXT
OS --------------------------------------------------------------------------
    [ ] dos  [ ] os/2  [ ] windows [x] Win32 [x] *nix [x] RPI Linux
Type ------------------------------------------------------------------------
                infoform [ ]   utility [ ]  misc [x]  door [ ]

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                  ____  _           __      _
                 / __ \(_)_________/ /___ _(_)___ ___  ___  _____
                / / / / / ___/ ___/ / __ `/ / __ `__ \/ _ \/ ___/
               / /_/ / (__  ) /__/ / /_/ / / / / / / /  __/ /
              /_____/_/____/\___/_/\__,_/_/_/ /_/ /_/\___/_/

   The author has taken every precaution to insure that no harm or damage
will occur on computer systems operating this util.  Never the less, the
author will NOT be held liable for whatever may happen on your computer
system or to any computer systems which connects to your own as a result of
operating this util.  The user assumes full responsibility for the correct
operation of this software package, whether harm or damage results from
software error, hardware malfunction, or operator error.  NO warranties are
offered, expressly stated or implied, including without limitation or
restriction any warranties of operation for a particular purpose and/or
merchant ability.  If you do not agree with this then do NOT use this
program.

-------------------------------------------------------------------------------
                ____                      _       __  _
               / __ \___  _______________(_)___  / /_(_)___  ____
              / / / / _ \/ ___/ ___/ ___/ / __ \/ __/ / __ \/ __ \
             / /_/ /  __(__  ) /__/ /  / / /_/ / /_/ / /_/ / / / /
            /_____/\___/____/\___/_/  /_/ .___/\__/_/\____/_/ /_/
                                       /_/

  This script is made to make announcements for new stuff added to your BBS
or whatever else you want. Add it to your login procedure and when a user
logs in, it will check if he has seen the announcement. If he has, then
nothing will appear and the script will not interfere at all. If he hasn't
then the script will show the NEWS.TXT file which is inside the script
directory.

  The Sysop can edit this file online, inside the script, on the fly... so
there is no need to invoke a shell or something else to edit it.
-------------------------------------------------------------------------------
                ____           __        ____      __  _
               /  _/___  _____/ /_____ _/ / /___ _/ /_(_)___  ____
               / // __ \/ ___/ __/ __ `/ / / __ `/ __/ / __ \/ __ \
             _/ // / / (__  ) /_/ /_/ / / / /_/ / /_/ / /_/ / / / /
            /___/_/ /_/____/\__/\__,_/_/_/\__,_/\__/_/\____/_/ /_/


.oO Unzip the archive inside Mystics Scripts folder. Everything needed is
    inside the package.

.oO Compile the script with mplc
    ./mplc xq-aboard.mps

.oO Execute the script from a menu command. No parameters needed.
-------------------------------------------------------------------------------
           ______            _____                        __  _
          / ____/___  ____  / __(_)___ ___  ___________ _/ /_(_)___  ____
         / /   / __ \/ __ \/ /_/ / __ `/ / / / ___/ __ `/ __/ / __ \/ __ \
        / /___/ /_/ / / / / __/ / /_/ / /_/ / /  / /_/ / /_/ / /_/ / / / /
        \____/\____/_/ /_/_/ /_/\__, /\__,_/_/   \__,_/\__/_/\____/_/ /_/
                               /____/

  Edit the script to change some basic stuff. Just change the constants at
the top of the file.

  Inside the xq-aboard directory, you will find an ANSI file, which you can
configure and the file NEWS.TXT, which is the file being displayed. Edit this
file to add new announcements.

-------------------------------------------------------------------------------
                           __  __
                          / / / /________ _____ ____
                         / / / / ___/ __ `/ __ `/ _ \
                        / /_/ (__  ) /_/ / /_/ /  __/
                        \____/____/\__,_/\__, /\___/
                                        /____/

  As a normal user:

  The script will check the date of the NEWS.TXT file and the last time the
user logged on. If the file is newer, the script will execute and display the
data. The user can navigate with Arrow Keys / Page Up / Page Down / Home /
End. Pressing ESC or ENTER will exit the script and continue.

  As a Sysop:

  The script will always execute if the user logged in is a sysop. Use the
same keys to navigate, but you have the ability to press 'E' to edit the
NEWS.TXT file on the fly. This will invoke the internal Mystic Text Editor.
Save the file to store any new changes.

-------------------------------------------------------------------------------
            _______                   ____  ___      __
           / ____(_)  _____  _____  _/_/ / / (_)____/ /_____  _______  __
          / /_  / / |/_/ _ \/ ___/_/_// /_/ / / ___/ __/ __ \/ ___/ / / /
         / __/ / />  </  __(__  )/_/ / __  / (__  ) /_/ /_/ / /  / /_/ /
        /_/   /_/_/|_|\___/____/_/  /_/ /_/_/____/\__/\____/_/   \__, /
                                                                /____/

.oO First Release... 06/2017

-------------------------------------------------------------------------------
                       ______            __             __
                      / ____/___  ____  / /_____ ______/ /_
                     / /   / __ \/ __ \/ __/ __ `/ ___/ __/
                    / /___/ /_/ / / / / /_/ /_/ / /__/ /_
                    \____/\____/_/ /_/\__/\__,_/\___/\__/

If you want to send me bug report or a note telling me how much you like it,
please feel free to do so. ;)

Another Droid BBS (andr01d.zapto.org:9999)
Email at xqtr.xqtr@gmail.com

-------------------------------------------------------------------------------

   _            _   _              ___          _    _       
  /_\  _ _  ___| |_| |_  ___ _ _  |   \ _ _ ___(_)__| |               8888
 / _ \| ' \/ _ \  _| ' \/ -_) '_| | |) | '_/ _ \ / _` |            8 888888 8
/_/ \_\_||_\___/\__|_||_\___|_|   |___/|_| \___/_\__,_|            8888888888
                                                                   8888888888
         DoNt Be aNoTHeR DrOiD fOR tHe SySteM                      88 8888 88
                                                                   8888888888
    .o HaM RaDiO    .o ANSi ARt!       .o MySTiC MoDS              "88||||88"
    .o NeWS         .o WeATheR         .o FiLEs                     ""8888""
    .o GaMeS        .o TeXtFiLeS       .o PrEPardNeSS                  88
    .o TuTors       .o bOOkS/PdFs      .o SuRVaViLiSM          8 8 88888888888
    .o FsxNet       .o SurvNet         .o More...            888 8888][][][888
                                                               8 888888##88888
   TeLNeT : andr01d.zapto.org:9999 [UTC 11:00 - 20:00]         8 8888.####.888
   SySoP  : xqtr                   eMAiL: xqtr.xqtr@gmail.com  8 8888##88##888



