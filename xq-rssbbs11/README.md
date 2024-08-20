 :                                              :
-+---- - -+- -  -        .    .   - --+-- - ----+-
 :`                        __                 ':]
 .         ___  __________/  |________          :
           \  \/  / ____/\   __\_  __ \         .
            >    < <_|  | |  |  |  | \/
 .         /__/\_ \__   | |__|  |__|            .
 :               \/  |__|                       .
 [:.                                           ,:
-+--- -  .  -.- .    - ---+-- -  -   -  .   - --+-
 [.            RSS Feed Reader v1.1            `]
-+-- -   .  -   -  - --+--- -    . -.-  .  - ---+-
 ;                                              :
 . add as many rss feeds you want and let users .
 : read them from inside your bbs! sysops can   .
 ; add feeds on the fly and also download them  :
 :                                    mpy/script.  
 + --   -   -  - --          -- - -+- -  -   -  +
        __  _                        __ _                           _  __
  ______\ \_\\_______________________\///__________________________//_/ /______
  \___\                                                                   /___/
   | .__                                 __                                  |
   | |                   ___  __________/  |________                         |
   |                     \  \/  / ____/\   __\_  __ \                        |
   ;                      >    < <_|  | |  |  |  | \/                        ;
   :                     /__/\_ \__   | |__|  |__|                           :
   .                           \/  |__|      Releases                        .
   .                                                                         .
   :           H/Q Another Droid BBS - andr01d.zapto.org:9999                :
   ;                                                                         ;
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   :                                                                         :
   |                           RSS Feed Reader v1.1                          |
   :                                                                         :
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   | ._          SoftWare         Oper.System      Type                      |
   ; |           - { } BASH       - {x} Linux      - { } ANSI                ;
   :             - { } DOOR       - {x} RPi        - { } TEXT                :
   .             - { } MPL        - {x} Windows    - { } ASCII               .
   :             - {x} Python     - {x} Mac        - { } BINARY              :
   ;             - {x} Source     - {x} OS/2                                 ;
   |                                                                         |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   |  _     _ _                                                              |
   ; |    _| | |_    ____  _         _     _                                 ;
   :     |_     _|  |    \|_|___ ___| |___|_|_____ ___ ___                   :
   .     |_     _|  |  |  | |_ -|  _| | .'| |     | -_|  _|   _ _ _          .
   ;       |_|_|    |____/|_|___|___|_|__,|_|_|_|_|___|_|    |_|_|_|         ;
   |                                                                         |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   ; The author has taken every precaution to insure that no harm or damage  ;
   | will occur on computer systems operating this util.  Never the less, the:
   ; author will NOT be held liable for whatever may happen on your computer .
   : system or to any computer systems which connects to your own as a result:
   . of. operating this util.  The user assumes full responsibility for the  ;
   : correct operation of this software package, whether harm or damage      |
   ; results from software error, hardware malfunction, or operator error.   :
   | NO warranties are : offered, expressly stated or implied, including     .
   | without limitation or ; restriction any warranties of operation for a   :
   ; particular purpose and/or | merchant ability.  If you do not agree with ;
   : this then do NOT use this program.                                      |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´

   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   |        _ _                                                              |
   ;      _| | |_    _____ _           _                                     ;
   :     |_     _|  |  _  | |_ ___ _ _| |_                                   :
   .     |_     _|  |     | . | . | | |  _|   _ _ _                          .
   ;       |_|_|    |__|__|___|___|___|_|    |_|_|_|                         ;
   |                                                                         |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
    
    this is a mpy script, which will aloud your visitors to read any 
    rss feed you add to the script. the feeds are updated, at the time the
    user asks to read them, so no need to do background updates and it always
    will have the latest posts from the feeds.
    
    you can add categories with feeds and even add feeds on the fly, if you 
    are the sysop.
    
    also, now, users can use the P,N or Left/Right keys to navigate easily,
    through posts in a feed and use the X key to download the feed text!
 
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   |        _ _                                                              |
   ;      _| | |_    _____         _       _ _                               ;
   :     |_     _|  |     |___ ___| |_ ___| | |                              :
   .     |_     _|  |-   -|   |_ -|  _| .'| | |   _ _ _                      .
   ;       |_|_|    |_____|_|_|___|_| |__,|_|_|  |_|_|_|                     ;
   |                                                                         |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´

   the mod needs python3 and python2 to work. make sure you have them both
   and also for python3 have installed the "feedparser" library. if not
   you can install it with pip, like:
   
   pip install feedparser
   
   any other python library, the mod uses, is installed by default. now you 
   are ready to launch the script.
   
   ::/ place the files in the script folder
   ::/ add a menu command to execute the main script, "xq-rssbbs"
   
   
    

   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   |        _ _                                                              |
   ;      _| | |_    _____         ___ _                                     ;
   :     |_     _|  |     |___ ___|  _|_|___                                 :
   .     |_     _|  |   --| . |   |  _| | . |   _ _ _                        .
   ;       |_|_|    |_____|___|_|_|_| |_|_  |  |_|_|_|                       ;
   |                                    |___|                                |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   
   edit the main script and alter the variables after line 25. there are
   comments to help you.
   
   also change the ansi images, as you like... but plz, leave my name somewhere
   in the help file!

   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   |        _ _                                                              |
   ;      _| | |_    _____ _     _                                           ;
   :     |_     _|  |  |  |_|___| |_ ___ ___ _ _                             :
   .     |_     _|  |     | |_ -|  _| . |  _| | |   _ _ _                    .
   ;       |_|_|    |__|__|_|___|_| |___|_| |_  |  |_|_|_|                   ;
   |                                        |___|                            |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   
    .:. August 2019
     `  + First Release
    .:. June 2021
     `  + Second Release version 1.1
        - Complete re-write to make it an MPY script instead of a DOOR
        + Sysop can Add/Edit/Delete feeds on the fly
        + User can use Left/Right keys to navigate through posts
        + User can download the feed text in plain text
        
          
   
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         _____         _   _              ____          _   _ 
        |  _  |___ ___| |_| |_ ___ ___   |    \ ___ ___|_|_| |        8888
        |     |   | . |  _|   | -_|  _|  |  |  |  _| . | | . |     8 888888 8
        |__|__|_|_|___|_| |_|_|___|_|    |____/|_| |___|_|___|     8888888888
                                                                   8888888888
                DoNt Be aNoTHeR DrOiD fOR tHe SySteM               88 8888 88
                                                                   8888888888
 /: HaM RaDiO   /: ANSi ARt!     /: MySTiC MoDS   /: DooRS         '88||||88'
 /: NeWS        /: WeATheR       /: FiLEs         /: SPooKNet       ''8888"'
 /: GaMeS       /: TeXtFiLeS     /: PrEPardNeSS   /: FsxNet            88
 /: TuTors      /: bOOkS/PdFs    /: SuRVaViLiSM   /:            8 8 88888888888
                                                              888 8888][][][888
   TeLNeT : andr01d.zapto.org:9999 / ssh: 8888                  8 888888##88888
   SySoP  : xqtr                   eMAiL: xqtr@gmx.com          8 8888.####.888
   DoNaTe : https://paypal.me/xqtr                              8 8888##88##888
