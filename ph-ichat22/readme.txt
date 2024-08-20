     Ü                            Ü
    Û      ßÜ  ßÜ  ÞÝ  Üß  Üß      Û    Ú------------------------------------¿
    ßÜ      ßÛÜ ßß ßß ßß ÜÛß      Üß    :     filename: PN-ICHAT22.ZIP       :
   ßÜ ßÜ     ÛÜÜÛÛÛÛÛÛÛÛÜÜÛ  sM Üß Üß           author: opicron
   ° Û \Û   ÛÜÜÜÜ ßÛÛß ÜÜÜÜÛ   Û/ Û °     release date: 12/04/2022
  °Üß  Üß ÜÛ²ßÜÜßßÜÜÜÜßßÜÜß²ÛÜ ßÜ  ßÜ°         version: 2.21
  ±/ Üß   ßÜÜßßßßß ÛÛ ßßßßßÜÜß   ßÜ \±  : bbs software: Mystic               :
  ²/ÛÛ    Û     X  ÛÛ  X     Û    ÛÛ\²  Ã------------------------------------´
  Û/ÛÛ   ÞÛÛÜÜÜ    ÛÛ    ÜÜÜÛÛÝ   ÛÛ\Û  : This and ALL PHENOM PRODUCTIONS    :
  ßÜßÛÜ Û ÛÛÛÛÛÛÛÛ²ßß²ÛÛÛÛÛÛÛÛ Û ÜÛßÜß    releases can be found on ALL
    \ ßßÛ ²Û  ßÜÛÛÛÛÛÛÛÛÜß  Û² Ûßß /      ArakNet Bulletin Board Systems
       ßÛ   ÛÛßÛÛßÛÛ   Ûß         and Distribution Sites.
                   
                                          You can also find all PHENOM
       ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿        PRODUCTION at:
  /\/\/:    PHENOM PRODUCTIONS   :\/\/\ : https://www.phenomprod.com         :
  :    ÀÄÄÄÄÄÄú( EST. 2018 )úÄÄÄÄÙ    : ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


   release name: iChat v2.21

  >> -----------------------------------------------------------------------

  keys:
  -----

 #Chat
 ------------------------------------------------------------------------------- ----------------------
 ESC               Exit
 ENTER             Send message
 CTRL-S            Show irc raw data in background of chat (kludge style)
 CTRL-N            Show or hide name tab
 CTRL-Z            Show help
 Up / Down         Look up chatbuffer
 PageUp / PageDown Browse through IRC buffer
 Home / End        Start / End of text buffer


  >> -----------------------------------------------------------------------

  IRC commands:
  ------------


  /NAMES
     ..................................................................
     Toggle name tab

  /JOIN [channel] [password] (alternative: /CHANNEL /J)
     ..................................................................
     Join channel

  /PART (alternative: /P)
     ..................................................................
     Leave current channel

  /MSG [username] (alternative: /TELL /T)
     ..................................................................
     Send private message to [username] in chat

  /REPLY [text] (alternative: /R)
     ..................................................................
     Respond to last private message

  /KICK [username]
     ..................................................................
     Kick [username] from channel (if you are operator or half operator). Reques  operator status for
     channels on my board or through netmail.

  /TOPIC [the new topic text]
     ..................................................................
     Change the channel topic

  /ME [action text]
     ..................................................................
     Display action in chat. Example "/ME dances" will output: "Username dances" in the action color.

  /AWAY [reason]
     ..................................................................
     Set AFK status. Reason is optional.

  /BACK
     ..................................................................
     Return from AFK/Away

  /QUIT (alternative: /Q /EXIT)
     ..................................................................
     Exit iChat

  /HELP (alternative: /H)
     ..................................................................
     Show help

  **more to be included (any requests?)



  >> -----------------------------------------------------------------------

  Script Arguments (optional):
  ----------------------------


  /SERVER
     ..................................................................
     iCHAT will by connect to the default configured server. By default this
     is the InterBBS #Trivia channel. If you wish to force iCHAT to use another
     server and/or channel use the /SERVER argument and set the ID (number) of
     the predefined irc server, channel and optional password in the
     configuration file.

 For example:
  /SERVER 0
  /SERVER 1
  /SERVER 12


  /PAGER
     ..................................................................
     ** BEFORE USING PAGER FUNCTIONALITY BE SURE TO REQUEST AN PRIVATE
        CHANNEL, OR SET UP AN PRIVATE CHANNEL ON YOUR OWN IRC SERVER.
        WITHOUT AN PASSWORD PROTECTED PRIVATE CHANNEL YOU COULD BE
        IMPERSONATED. DO NOT USE PUBLIC CHANNELS!

     By default iCHAT will to connect to the default channel without showing
     a pager. To open the sysop pager before entering the private channel
     use the /PAGER argument.

     When the sysop (you) responds in the irc channel the iCHAT pager will
     notice the response and open the  channel for the user to chat. This
     is matched on sysop name, so again be sure to ONLY do this in a private
     channel!

     If iCHAT detects that the sysop (you) leaves the channel or sets an
     away status the chat will close for the user. Closing the chat on sysop
     leaving will only happen when in /PAGER mode of course.

     To request a unlogged(!) private channel contact me at:

 TheForze BBS:
     bbs.opicron.eu:23
     bbs.opicron.eu:22

 Netmail [opicron]:
     fsxnet 21:3/126
     araknet 10:104/4