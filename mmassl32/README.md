      
                              __           
              ___  __________/  |________  
              \  \/  / ____/\   __\_  __ \ 
               >    < <_|  | |  |  |  | \/ 
              /__/\_ \__   | |__|  |__|    
                    \/  |__|               
      ------------------------------------------------
                   Mystic BBS Mass Mailer              
      ------------------------------------------------
        If you own a bbs and want to send the same
      message to multiple echo areas then this
      utility is for you. Upload a text file to any
      message base of Mystic BBS, with an easy and
      graphical way.                 Linux 32bit ver.
      ------------------------------------------------
                                  .oO0( xqtr )0Oo.
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
         | Mystic BBS Mass Mailer                                                  |
         :                                                                         :
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         | ._          SoftWare         Oper.System      Type                      |
         ; |           - { } BASH       - {x} Linux      - { } ANSI                ;
         :             - { } DOOR       - { } RPi        - { } TEXT                :
         .             - { } MPL        - { } Windows    - { } ASCII               .
         :             - { } Python     - { } Mac        - {x} BINARY              :
         ;             - { } Source     - { } OS/2                                 ;
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
         |        _ _                                                              |
         ;      _| | |_    _____ _           _                                     ;
         :     |_     _|  |  _  | |_ ___ _ _| |_                                   :
         .     |_     _|  |     | . | . | | |  _|   _ _ _                          .
         ;       |_|_|    |__|__|___|___|___|_|    |_|_|_|                         ;
         |                                                                         |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         | This is an utility to upload text files/messages to multimple bases in  |
         ; Mystic BBS. It uses a GUI to guide you and select the bases and the     ;
         : file you want to upload.                                                :
         .                                                                         .
         ;                                                                         ;
         |                                                                         |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         |        _ _                                                              |
         ;      _| | |_    _____         _       _ _                               ;
         :     |_     _|  |     |___ ___| |_ ___| | |                              :
         .     |_     _|  |-   -|   |_ -|  _| .'| | |   _ _ _                      .
         ;       |_|_|    |_____|_|_|___|_| |__,|_|_|  |_|_|_|                     ;
         |                                                                         |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         | 1. Unpack the archive to your desired directory.                        |
         ; 2. Edit the mysmass.ini file and configure it.                          ;
         : 3. Execute the file... ;)                                               :
         .                                                                         .
      
         .                                                                         .
         :                                                                         :
         ;                                                                         ;
         |                                                                         |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         |        _ _                                                              |
         ;      _| | |_    _____         ___ _                                     ;
         :     |_     _|  |     |___ ___|  _|_|___                                 :
         .     |_     _|  |   --| . |   |  _| | . |   _ _ _                        .
         ;       |_|_|    |_____|___|_|_|_| |_|_  |  |_|_|_|                       ;
         |                                    |___|                                |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         | Edit the .ini file. You will see some fields that you have to fill.     |
         ;                                                                         ;
         
            [main]
            editor=/usr/bin/nano      // The path & filename to your prefered text
                                      // editor
            temp_folder=/tmp          // Path to a temp directory
            delay=100                 // How many milliseconds to wait, after
                                      // each upload to a base. 1sec=1000ms
      
            [mystic]
            mbases=/mystic/mbases.dat // Path & filename of the mbases.dat file
            mutil=/mystic/mutil       // Path & filename of the mutil utility
            dir=/mystic/              // Path of your mystic bbs
      
            [message]
            from=userid               // Enter your User id to auto fill the form
            to=All                    // Auto fill receipient
            subject=                  // Same... you could also leave it blank.
         
         
            The app, will not use the file mbases.dat inside the mystic/data 
            directory, but the one you will provide in the mbases field above. This
            is to avoid any risk of corrupting the main file. You can have a backup
            mbases.dat file and use that for the app to look for the bases info.
          
         ;                                                                         ;
         |                                                                         |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         |        _ _                                                              |
         ;      _| | |_    _____                                                   ;
         :     |_     _|  |  |  |___ ___                                           :
         .     |_     _|  |  |  |_ -| -_|   _ _ _                                  .
         ;       |_|_|    |_____|___|___|  |_|_|_|                                 ;
         |                                                                         |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         | You can execute the program with a parameter or not. If you provied a   |
         ; filename as a parameter the app, will check it if it exists and ask you ;
         : if you want to edit it. If the file doesn't exist, it will provide a    :
         . file browser dialog to choose one yourself.                             .
      
         . The rest are easy, just follow the instructions.                        .
         :                                                                         :
         ; Warning!!! Because of the file browser dialog, don't give access to     ;
         | other users except you, or else you risk of compropising your system.   |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         |        _ _                                                              |
         ;      _| | |_    _____ _ _                                               ;
         :     |_     _|  |   __|_| |___ ___                                       :
         .     |_     _|  |   __| | | -_|_ -|   _ _ _                              .
         ;       |_|_|    |__|  |_|_|___|___|  |_|_|_|                             ;
         |                                                                         |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         | mysmass                                                                 |
         ; mysmass.ini                                                             ;
         : file_id.diz                                                             :
         . sysop.txt                                                               .
      
         .                                                                         .
         :                                                                         :
         ;                                                                         ;
         |                                                                         |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         |        _ _                                                              |
         ;      _| | |_    _____ _     _                                           ;
         :     |_     _|  |  |  |_|___| |_ ___ ___ _ _                             :
         .     |_     _|  |     | |_ -|  _| . |  _| | |   _ _ _                    .
         ;       |_|_|    |__|__|_|___|_| |___|_| |_  |  |_|_|_|                   ;
         |                                        |___|                            |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         | 23/09/2018 - first release                                              |
         ;                                                                         ;
         :                                                                         :
         .                                                                         .
      
         .                                                                         .
         :                                                                         :
         ;                                                                         ;
         |                                                                         |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         |        _ _                                                              |
         ;      _| | |_    _____         _           _                             ;
         :     |_     _|  |     |___ ___| |_ ___ ___| |_                           :
         .     |_     _|  |   --| . |   |  _| .'|  _|  _|   _ _ _                  .
         ;       |_|_|    |_____|___|_|_|_| |__,|___|_|    |_|_|_|                 ;
         |                                                                         |
         + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         | ._                                                                   _, |
         ; |        _____         _   _              ____          _   _         | ;
         :         |  _  |___ ___| |_| |_ ___ ___   |    \ ___ ___|_|_| |          :
         .         |     |   | . |  _|   | -_|  _|  |  |  |  _| . | | . |          .
         '         |__|__|_|_|___|_| |_|_|___|_|    |____/|_| |___|_|___|          '
                           DoNt Be aNoTHeR DrOiD fOR tHe SySteM                     
                                                                                   '
         `  /: HaM RaDiO     /: ANSi ARt!       /: MySTiC MoDS     /: DooRS         
            /: NeWS          /: WeATheR         /: FiLEs           /: SPooKNet     `
         '  /: GaMeS         /: TeXtFiLeS       /: PrEPardNeSS     /: FsxNet       '
            /: TuTors        /: bOOkS/PdFs      /: SuRVaViLiSM     /: ArakNet       
         .                                                                         .
         ;          TeLNeT : andr01d.zapto.org:9999 [UTC 11:00 - 20:00]            ;
         :          SySoP  : xqtr                   eMAiL: xqtr@gmx.com            :
         |          DoNaTe : https://paypal.me/xqtr                                |
         `:_______________________________________________________________________;´
           \________________\  No CoPyRiGHT ReSeRVeD - 2018xx    /________________/
              \___\    \______________________________________________/   /___/
                              \________________________________/
      
