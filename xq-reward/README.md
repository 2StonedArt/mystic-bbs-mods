                                __           
                ___  __________/  |________  
                \  \/  / ____/\   __\_  __ \ 
                 >    < <_|  | |  |  |  | \/ 
                /__/\_ \__   | |__|  |__|    
                      \/  |__|               
        ------------------------------------------------
            Reward/Credit System for Mystic BBS 1.12+ 
        ------------------------------------------------
        A simple credit/reward system for users in 
        Mystic BBS. Sysop has the ability to check and
        reward users actions by building a credit
        system. For example when a user posts a message,
        uploads a file, enters the chat for an amount of
        time etc. When a user reaches a certain level of
        credits, a message is sent to the sysop to
        inform him. The sysop then can decide what type
        of reward can give to the user ex: increase ACS
        level, increase file download ratio, allow 
        access to restricted areas and more.
        ------------------------------------------------
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
                                         `---`                                  11/2016
         ------------------------------------------------------------------------------
        
                                    Reward/Credits System  
                                       First Release
                                      for mystic 1.12+
                                        
        Software --------------------------------------------------------------------
               [ ] PCB PPe      [ ] OBV          [ ] VGA         [ ] OTHER___________
               [ ] Renegade     [ ] Iiniquity    [ ] ASCII       [ ] HTML/CGI/WWW    
               [x] Mystic       [ ] WWVI         [ ] Telegard    [x] MPL
               [ ] ANSI         [ ] TEXT
        OS --------------------------------------------------------------------------
            [ ] dos  [ ] os/2  [x] windows [x] Win32 [x] *nix [x] RPI Linux
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
        
          A simple credit/reward system for user in Mystic BBS. Sysop has the ability
        to check and reward users actions by building a credit system. For example when
        a user posts a message, uploads a file, enters the chat for an amount of time
        etc. When a user reaches a certain level of credits, a message is sent to the
        sysop to inform him. The sysop then can decide what type of reward can give to 
        the user. 
        
          The sysop can decide how many levels/stages for upgrades, the system can have.
        Initially there are 5, but can be added or removed as the sysop wants. 
        -------------------------------------------------------------------------------
                        ____           __        ____      __  _           
                       /  _/___  _____/ /_____ _/ / /___ _/ /_(_)___  ____ 
                       / // __ \/ ___/ __/ __ `/ / / __ `/ __/ / __ \/ __ \
                     _/ // / / (__  ) /_/ /_/ / / / /_/ / /_/ / /_/ / / / /
                    /___/_/ /_/____/\__/\__,_/_/_/\__,_/\__/_/\____/_/ /_/ 
        
        .oO Unzip the archive inside Mystics Scripts folder. Everything needed is inside
        the package.
        
        .oO Compile the scripts with mplc
            
            ./mplc xq-reward.mps
        
        -------------------------------------------------------------------------------
                   ______            _____                        __  _           
                  / ____/___  ____  / __(_)___ ___  ___________ _/ /_(_)___  ____ 
                 / /   / __ \/ __ \/ /_/ / __ `/ / / / ___/ __ `/ __/ / __ \/ __ \
                / /___/ /_/ / / / / __/ / /_/ / /_/ / /  / /_/ / /_/ / /_/ / / / /
                \____/\____/_/ /_/_/ /_/\__, /\__,_/_/   \__,_/\__/_/\____/_/ /_/ 
                                       /____/                                   
        
          Edit the script to configure the credit levels, descriptions and the Sysop
        UserID for the system.
        
        -------------------------------------------------------------------------------
                                   __  __                    
                                  / / / /________ _____ ____ 
                                 / / / / ___/ __ `/ __ `/ _ \
                                / /_/ (__  ) /_/ / /_/ /  __/
                                \____/____/\__,_/\__, /\___/ 
                                                /____/       
        
          You have to add the command to each type of user reaction you want to reward.
        You do this by editing the menus and in each command add one more that executes
        the script, preferrably first.
        
          For example edit the Messages menu. Edit the Post Message Command and at the
        command area, add a new command, before the (MP) Post Message Command. Press / 
        and I to insert the new command. Edit it and add the GX code as the command and
        to the Add field add this: add 1
        
          Done... Now, when the users goes to post a message he will get one credit ;)
        You can configure and use the reward system in many ways, as you like. Its very
        flexible.
        
        Other Commands used for the script:
        
         add <no>       : Adds <no> credits to User
         
         sub <no>       : Substracts <no> credits from User
         
         timer put      : Start Timing user
                          The script will store what time this command it executed and
                          when the "timer read" command will be executed, it will add
                          to the user credits that equals the amount ot time in minutes
                          between the execution of the "timer put" and "timer read" 
                          commands. See example below
         
         timer read     : Finishes timing and adds credits
         
         check          : Checks if user reached a certain level
                          This command will check if the credits of the user are over a
                          certain level. If yes, it will send an email to the sysop, 
                          informing him about this. It will also store the user level to
                          his data file (./xq-reward/<UserAlias>.dat). This way it will
                          not send over and over an email about the same level upgrade.
                          Only one email will be sent, when a user reaches a certain 
                          level.
          levels        : Show a sample ANSI screen with rewards a Sysop can give. You 
                          can alter it as you like.
        
        
        Example for Timer:
        
          Lets say that you want to reward users that spend time in the chat. Add the
        "timer put" command befor the chat command that you use in your BBS and in the
        exit command from the chat, put a "timer read" command.
        
          The "timer put" command will store the time its executed in a temp file. When
        the "timer read" command executes, it will read this file and compare the 
        current time. The difference in minutes between those two times, will be added
        to the user credits, with one exception...
        
        First, the current limit is 120 minutes or credits and this is done, in case the
        connection is broke down and the user doesn't log off properly. So even if his 
        connection will be as a "ghost" he will only get 120 credits and not more. You
        can increase or decrease this limit, as you want.
        
        -------------------------------------------------------------------------------
                                        _______ __         
                                       / ____(_) /__  _____
                                      / /_  / / / _ \/ ___/
                                     / __/ / / /  __(__  ) 
                                    /_/   /_/_/\___/____/  
                               
        
        file_id.diz
        sysop.txt
        xq-reward.mps
        
        -------------------------------------------------------------------------------
                    _______                   ____  ___      __                  
                   / ____(_)  _____  _____  _/_/ / / (_)____/ /_____  _______  __
                  / /_  / / |/_/ _ \/ ___/_/_// /_/ / / ___/ __/ __ \/ ___/ / / /
                 / __/ / />  </  __(__  )/_/ / __  / (__  ) /_/ /_/ / /  / /_/ / 
                /_/   /_/_/|_|\___/____/_/  /_/ /_/_/____/\__/\____/_/   \__, /  
                                                                        /____/   
        
        
        .oO First Release... 11/2016
        
        -------------------------------------------------------------------------------
                               ______            __             __ 
                              / ____/___  ____  / /_____ ______/ /_
                             / /   / __ \/ __ \/ __/ __ `/ ___/ __/
                            / /___/ /_/ / / / / /_/ /_/ / /__/ /_  
                            \____/\____/_/ /_/\__/\__,_/\___/\__/  
        
        
        If you want to send me bug report or a note telling me how much you like it,
        please feel free to do so. ;)
        
        Another Droid BBS (adbbs.no-ip.org)
        Email at xqtr.xqtr@gmail.com
        
        
