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
         [.             ANSI Frames v1.0               `]
        -+-- -   .  -   -  - --+--- -    . -.-  .  - ---+-
         :                                              .
         ; A small utility to make transitions from one :
         . ansi screen to another with cool effects!    .
         ;                                              :
         :                                linux 64b/rpi .  
         + --   -   -  - --          -- - -+- -  -   -  +        __  _                        __ _                           _  __
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
           |                           ANSI Frames v1.0                              |
           :                                                                         :
           + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
           | ._          SoftWare         Oper.System      Type                      |
           ; |           - { } BASH       - {x} Linux      - { } ANSI                ;
           :             - { } DOOR       - {x} RPi        - { } TEXT                :
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
        
           + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
           |        _ _                                                              |
           ;      _| | |_    _____ _           _                                     ;
           :     |_     _|  |  _  | |_ ___ _ _| |_                                   :
           .     |_     _|  |     | . | . | | |  _|   _ _ _                          .
           ;       |_|_|    |__|__|___|___|___|_|    |_|_|_|                         ;
           |                                                                         |
           + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
           
           With this utility you make cool transition effects with ansi screens. 
           You can load two ansi images and go from one to another with effects 
           like "curtain", matrix style or even wait for a keypress. You can use 
           it between menu screens in your BBS or at login to animate things like 
           logos/banners.
         
           + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
           |        _ _                                                              |
           ;      _| | |_    _____         _       _ _                               ;
           :     |_     _|  |     |___ ___| |_ ___| | |                              :
           .     |_     _|  |-   -|   |_ -|  _| .'| | |   _ _ _                      .
           ;       |_|_|    |_____|_|_|___|_| |__,|_|_|  |_|_|_|                     ;
           |                                                                         |
           + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
        
           ::/ No installation. Just execute the binary...
        
            
        
           + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
           |        _ _                                                              |
           ;      _| | |_    _____                                                   ;
           :     |_     _|  |  |  |___ ___                                           :
           .     |_     _|  |  |  |_ -| -_|                                          .
           ;       |_|_|    |_____|___|___|                                          ;
           |                                                                         |
           + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
           
           Usage:
             ansiframes <file1> [command1] [command2] ...
        
           Commands:
                  DE: delay 200ms       LD: delay 500ms   RExxx: slow by xxx ms
               PAUSE: wait for key   FIRST: show 1st img   LAST: show 2nd img
        
           Clear effects:
             cls clsquarters clshorlines clsvertlines dotsclear
        
           Effects:
             dotspaint overright overleft overup overdown slideup slidedown
             slideleft curtainclose curtainopen baropen barclose vlines matrix
        
           You can use many parameters in the command line. Each command has a 
           different use. All commands are case insensitive.
           
                      The first command/parameter has to be an ansi file!
                              All images must be 80x25 or less!
           
           DE     : It will stop the execution for 200ms
           LD     : It will stop the execution for 0.5sec
           PAUSE  : It will wait for a keypress
           
           FIRST  : It will display the first image passed as a parameter
           LAST   : It will display the second image (if any).
           RE     : For each effect there is a delay variable. In some effects 
                    has to be smaller and in some higher. It depends on your 
                    system and how quick you want to make the effect. With this 
                    option you can manipulate this delay. You can use it like: 
                          RE1, this means a delay of 1ms
                          RE20, this is a delay of 20ms
                          RE300, this is a delay of 300ms
                    Don't give too high values cause in some effects you will wait 
                    for a very very very long time to finish... Make tests before 
                    you add a command to your BBS.
                    
           Lets see some examples:
             
             // it will clear the screen and display the ansi image
             ./ansiframes image.ans cls first
             
             // show the file and wait for a keypress
             ./ansiframes image.ans first pause
           
             // show first image and transition to second with the dotspaint 
               effect
             ./ansiframes image1.ans first image2.ans re1 dotspaint
             
             // switch between two images back and forth
             ./ansiframes image1.ans first image2.ans ld last ld first ld 
              last ld first
              
             // make something like a sliding door effect. it first "closes" to 
                one image and then re-opens to the first one 
              ./ansiframes image1.ans first image2.ans barclose
              ./ansiframes image2.ans image1.ans baropen
              
            // show the image and clear it with the clsquarters effect, with a 
               delay of 100ms
            ./ansiframes image1.ans first ld re100 clsquarters
              
           
           To use it in a BBS, you can add a menu command like above to a menu 
           entry or save multiple commands in a bash script and execute that 
           instead. This way you can make very complicated animations / 
           transitions.
        
           + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
           |        _ _                                                              |
           ;      _| | |_    _____ _     _                                           ;
           :     |_     _|  |  |  |_|___| |_ ___ ___ _ _                             :
           .     |_     _|  |     | |_ -|  _| . |  _| | |   _ _ _                    .
           ;       |_|_|    |__|__|_|___|_| |___|_| |_  |  |_|_|_|                   ;
           |                                        |___|                            |
           + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
           
            .:. May 2019
             `  + First Release
                
                  
           
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
         /: TuTors      /: bOOkS/PdFs    /: SuRVaViLiSM   /: ArakNet    8 8 88888888888
                                                                      888 8888][][][888
           TeLNeT : andr01d.zapto.org:9999 / ssh: 8888                  8 888888##88888
           SySoP  : xqtr                   eMAiL: xqtr@gmx.com          8 8888.####.888
           DoNaTe : https://paypal.me/xqtr                              8 8888##88##888
