// ::::: __________________________________________________________________ :::::
// : ____\ ._ ____ _____ __. ____ ___ _______ .__ ______ .__ _____ .__ _. /____ :
// __\ .___! _\__/__    / _|__   / _/_____  __|  \ gRK __|_ \  __  |_ \ !___. /__
// \   ! ___/  |/  /___/  |   \__\ ._/  __\/  \   \___/  |/  \/  \_./  \___ !   /
// /__  (___   /\____\____|\   ____|   /  /___|\   ______.    ____\|\   ___)  __\
//   /____  \_/ ___________ \_/ __ |__/ _______ \_/ ____ |___/ _____ \_/  ____\
// :     /________________________________________________________________\     :
// :::::       +  p  H  E  N  O  M  p  R  O  D  U  C  T  I  O  N  S  +      :::::
// ==============================================================================
//
// -----------------------------------------
// - modName: MRC Mystic Client            -
// - majorVersion: 1.3                     -
// - minorVersion: 6                       -
// - author: Stackfault                    -
// - publisher: Phenom Productions         -
// - website: https://www.phenomprod.com   -
// - email: stackfault@bottomlessabyss.net -
// - bbs: bbs.bottomlessabyss.net:2023     -
// -----------------------------------------
//
// Release history
//
// Version 1.1    - Gryphon // Cyberia BBS
// Version 1.1.4  - Stackfault [sf] <phENom> // The Bottomless Abyss
// Version 1.2.5  - Stackfault [sf] <phENom> // The Bottomless Abyss
// Version 1.2.7  - Stackfault [sf] <phENom> // The Bottomless Abyss
// Version 1.2.9  - Stackfault [sf] <phENom> // The Bottomless Abyss
// Version 1.2.9a - Stackfault [sf] <phENom> // The Bottomless Abyss
// Version 1.2.9a - Stackfault [sf] <phENom> // The Bottomless Abyss
// Version 1.3.3  - Stackfault [sf] <phENom> // The Bottomless Abyss
// Version 1.3.4  - Stackfault [sf] <phENom> // The Bottomless Abyss
// Version 1.3.5  - Stackfault [sf] <phENom> // The Bottomless Abyss
// Version 1.3.6  - Stackfault [sf] <phENom> // The Bottomless Abyss
//
// List of changes/fixes:
//
// v1.1.4
// - Input buffer is now unblocking, you can see received chats while typing
// - Input buffer length is maxed, with color coded character counter
// - Input buffer history still available with UP/DOWN arrow keys
// - Fixed a race condition when line cannot be word wrapped
// - Added CPU release in each loops
// - Visible heartbeat animation when server refresh is active
// - Improved responsiveness and buffer refresh rate
// - Enlarged view port, now using the full 24 lines screen height
// - Now shows connected chatters when logging in
// - Welcome text at connection
// - New /changes command
// - 100% compatible with current MRC server implementation
// - Various small fixes
// - Implemented command whitelisting around pipe codes
// - Implemented colors live switching with PgUp/PgDn
// - Implemented timestamp highlighting on nick mention
// - Various validation of string input and length checking
// - Show direct message when sent
// - Changed mention indicator to better support present/absent clock
// - Change wrapping on multiline chats to better use available screen space
// - Added information scroller
//
// v1.2.5
// - Added message queuing serialization
// - Added multi-line packet handling
// - Updated scrolling ticker behavior
// - Added new server commands support
// - Stale queue indicator (heartbeat change color)
// - User now marked as unavailable for node message when in MRC
// - Increased topic to 55 chars
// - Added file-locking check via exclusive open
// - Tilde character handling
// - Nick autocomplete
// - Fixed and optimized clear screen
// - Many other smaller changes
// - Small issues fixed and code cleanup
//
// v1.2.7 (Hotfix release)
// - Server banner support
// - Several fixes
// - Client/Server latency display
// - Changes scroller/banner behavior
//
// v1.2.9 (Hotfix release)
// - Topic can now contain colon
// - Addressed some bleeding in banners
// - Added server hello/iamhere dialog support
// - Fixed screen update for some calls
// - Fixed issue with userlist server refresh
// - Fixed issue with server-side banners
// - Added server stats in scrolling banner
// - Reply to last received direct message using /r
// - Word-wrapping routine redone to support long strings
// - Updated skin to be more intuitive re latency, buffer, etc
// - Redone the formatting of the /SET features display
// - Added missing /SET command to code
// - Converted all loop timing events to prime numbers to avoid collisions
// - Addressed the cause for random crash
//
// v1.2.9a (Hotfix release)
// - Fixed scroller issues with some OS/Architecture combinations
// - Added support for scroller background color in customization block
// - Added an easter surprise
//
// v1.3.1
// - /quote no longer required for server commands
// - PrivMSG now called DirectMSG for clarity
// - User configurable Twit filter
// - User configurable Broadcast shield
// - User configurable Scrolling banner toggle
// - Dynamic screen size support
// - Theming support via multiple ANSI and matching INI files
// - Dynamic placement of vertical elements by using sections of single ANSI file
// - Scrollback buffer no longer use ANSI viewer and is now non-blocking
// - Scrollback buffer no longer limited to 1000 lines
// - Distinct buffer for mentions with history review using /mentions
// - CTCP support
// - Hotkey support from scrollbacks
//
// v1.3.2
// - DirectMSG now shows in Mentions
// - Implemented TERMINATE
// - Implemented USERNICK
// - Implemented USERIP
// - Password masking for sensitive prompts
// - Minor edits, bug fixes and screen optimization
//
// v1.3.3
// - Switchable theme support
//
// v1.3.4
// - Fixed "ghost" scroller in some themes
// - Fixed text wrap issue on wide themes
//
// v1.3.5
// - Removed /rainbow (Now server-side using !rainbow)
// - Added new terminal resolutions (132x52 and 132x60)
// - Added 132x51 and 132x59 themes
//
// v1.3.6
// - Added new terminal resolutions (160x45 and 160x60)
// - Added 160x44 and 160x59 themes
//
//  *************************************************************************
//  *  Starting with v1.2.9 release, only the current and previous version  *
//  *  of the client will be able to connect to the server, make sure       *
//  *  to keep your installation updated.                                   *
//  *************************************************************************
//
//                       Installation instructions
//
//         MRC Central server is located at the address below.
//   ====================================================================
//               mrc.bottomlessabyss.net on port 5000 (plain)
//               mrc.bottomlessabyss.net on port 5001 (SSL)
//   ====================================================================
//
// - This release is distributed as a complete installation, including
//   both the mrc_client.py (for both Python2 or Python3) and mrc_client.mps.
//
// - Make sure you read the upgrade instructions if you are upgrading.
//
// - Make sure to run the user conversion script to carry over your users
//   settings
//

Uses Cfg
Uses User

Const MRCVersion = 'Multi Relay Chat MPL v1.3.6 2024-07-23 |15[sf]'
Const InputSize  = 255
Const MaxBuffer  = 140    // Max input buffer limit [sf]
Const ThemeDebug = False  // Allows to print some debug details when adjusting theme

// MRC message packet
Type MRCRec  = Record
    FromUser : String[30]
    FromSite : String[30]
    FromRoom : String[30]
    ToUser   : String[30]
    MsgExt   : String[30]
    ToRoom   : String[30]
    Message  : String[InputSize]
End

// MRC user settings
Type UserRec        = Record
    RecIdx          : Integer
    PermIdx         : Integer
    EnterChatMe     : String[80]
    EnterChatRoom   : String[80]
    EnterRoomMe     : String[80]
    EnterRoomRoom   : String[80]
    LeaveChatMe     : String[80]
    LeaveChatRoom   : String[80]
    LeaveRoomMe     : String[80]
    LeaveRoomRoom   : String[80]
    Name            : String[80]
    DefaultRoom     : String[80]
    NameColor       : String[16]
    LtBracket       : String[16]
    RtBracket       : String[16]
    ThemeName       : String[16]
    TwitList        : String[255]
    PromptColor     : Byte
    UsageCount      : Integer
    BroadcastShield : Boolean
    ShowScroller    : Boolean
    TwitFilter      : Boolean
    ShowWelcome     : Boolean
    HideCTCPReq     : Boolean
    UseClock        : Boolean
    ClockFormat     : Boolean
End

Var Plyr            : UserRec
Var WinTL, WinTT    : Byte = 0
Var WinBL, WinBB    : Byte = 0

Var ServFile        : MRCRec
Var CLBuffer        : Integer = 25
Var WinSize         : Integer = 0
Var MyChatRoom      : Integer = 1
Var Loop            : Integer = 1
Var UserIP          : String[32] = ''
Var SecLevel        : String[32] = ''
Var Sysop           : String[32] = ''

Var TermX           : Byte = 80   // Terminal Size (default)
Var TermY           : Byte = 24   // Use auto-detected value later

// Moved to theme INI
Var WinAttr         : Byte = 0
Var PromptX         : Byte = 0
Var PromptY         : Byte = 0
Var PromptL         : Byte = 0
Var PromptAttr      : Byte = 0
Var RoomX, RoomY    : Byte = 0
Var RoomL           : Byte = 0
Var RoomAttr        : Byte = 0
Var TopicX, TopicY  : Byte = 0
Var TopicL          : Byte = 0
Var TopicAttr       : Byte = 0

Var MyNamePrompt    : String = ''
Var SiteTag         : String = ''
Var UserTag         : String = ''
Var MyRoom          : String = ''
Var MyTopic         : String = ''
Var BBSTempStub     : String = ''
Var ChatLog         : String = ''
Var MentionLog      : String = ''
Var PInUse          : String = ''
Var Scroller        : String = ''
Var ChatSeed        : Integer = 0
Var NodeMsgFlag     : Boolean = False
Var BufferHist      : Array [1..10] of String [255]  // Buffer history [sf]
Var BannerList      : Array [1..20] of String [255]  // Header banners [sf]
Var ChatLines       : Array [1..60] of String [255]  // ChatLines buffer
Var RoomUsers       : String = '' // Comma delimited user list [sf]
Var LastUSearch     : String = '' // Last user search string [sf]
Var LastDirectMsg   : String = '' // Last direct message received [sf]
Var MRCStats        : String = '' // MRC Stats string [sf]
Var BannerOff       : Byte = 0    // Banner scrolling offset [sf]
Var BanIdx          : Byte = 1    // Banner index [sf]
Var ScrollWait      : Byte = 0    // Banner scrolling wait [sf]
Var HBClr           : Byte = 11   // Color of Heartbeat [sf]
Var UserIdx         : Byte = 1    // Index of UserList search [sf]
Var Anim            : Byte = 1    // Animation step [sf]
Var IMaxBuffer      : Byte = MaxBuffer
Var MentionCount    : Integer = 0 // Number of mentions since last /mentions
Var TwitCount       : Integer = 0 // Number of messages blocked by twit filter
Var ShieldCount     : Integer = 0 // Number of messages blocked by broadcast shield
Var LatencyData     : Integer = 0 // Network latency in ms [sf]
Var RefreshChat     : Boolean = False
Var Terminate       : Boolean = False
Var ReplyTarget     : String =''

// Read version specific user settings file (see upgrade doc)
// Moved to Mystic data dir instead of script directory
Var UserFile        : String = CfgDataPath+'mrcusers_1_3.dat'

// Handle variable terminal/template size
Var ThemeList       : String = 'mrctheme.list'
Type ThemeIniData = Record
    TX : Byte  // X Coord
    TY : Byte  // Y Coord
    TL : Byte  // Length
    TF : Byte  // Fore color
    TB : Byte  // Back color
End

// Theme record
Type MrcThemeRec = Record
    IniFile     : String[30]   // INI config file
    AnsiFile    : String[30]   // ANSI file
    Width       : Byte         // Terminal width to use with theme
    Height      : Byte         // Terminal height to use with theme
    TopANSI     : String[20]   // Top of screen ANSI
    BotANSI     : String[20]   // Bottom of screen ANSI
    HelpANSI1   : String[20]   // Help screen ANSI page 1
    HelpANSI2   : String[20]   // Help screen ANSI page 2
    WelcomeANSI : String[20]   // Welcome ANSI
    MarkGood    : String[20]
    MarkWarn    : String[20]
    MarkCrit    : String[20]
    Room        : String[20]   // Contains 5 elements
    Topic       : String[20]   // X, Y, Length, ForeClr, BackClr
    Scroll      : String[20]
    InputBar    : String[20]
    Latency     : String[20]
    Chatters    : String[20]
    Buffer      : String[20]
    Heartbeat   : String[20]
    Mentions    : String[20]
    ChatTL      : String[20]
    ChatBL      : String[20]
End

// Array of available screen sizes
Var ScreenSizes      : Array [1..34] of String [6]
Var TsX, TsY         : Byte     // Terminal size
Var MrcTheme         : MrcThemeRec

// Align this path with the Python client config [sf]
// Default: mystic/data/mrc
Var SvrQueuePath     : String = CfgDataPath + 'mrc'

// CTCP room
Var CTCPROOM         : String = 'ctcp_echo_channel'

//
// Beginning of customization variables block [CUST]
//

// Heartbeat animation sequence [sf]
Var Heartbeat        : String = Chr(176) + Chr(177) + Chr(178) + Chr(219) + Chr(178) + Chr(177)

// Default configuration
// Most parameters are now configured by theme INI
Var HeartbeatX       : Byte = 0                // X position of HeartBeat [sf]
Var HeartbeatY       : Byte = 0                // Y position of HeartBeat [sf]
Var HeartbeatAttr    : Byte = 0                // Color of heartbeat text [sf]

Var HeartbeatGood    : Byte = 10               // Color of HeartBeat when local queue is flowing [sf]
Var HeartbeatBad     : Byte = 12               // Color of HeartBeat when local queue is stalled [sf]

Var LatX             : Byte = 0                // X position of Latency [sf]
Var LatY             : Byte = 0                // Y position of Latency [sf]
Var LatCol           : Byte = 0                // Color of Latency text [sf]

Var UsrX             : Byte = 0                // X position of Chatters [sf]
Var UsrY             : Byte = 0                // Y position of Chatters [sf]
Var UsrCol           : Byte = 0                // Color of Chatters text [sf]

Var CounterX1        : Byte = 0                // X position of characters counter [sf]
Var CounterY1        : Byte = 0                // X position of characters counter [sf]

Var CounterX2        : Byte = 0                // X position of max characters count [sf]
Var CounterY2        : Byte = 0                // X position of max characters count [sf]

Var MentionsX        : Byte = 0
Var MentionsY        : Byte = 0
Var MentionsL        : Byte = 0
Var MentionsCol      : Byte = 0

Var InputBg          : String = Chr(250)       // Input background character [sf]
Var InputClr         : String = '|16|17|07'    // Input field color [sf]

Var RInputClr        : String = '|16|17|07'    // Room Input field color [sf]
Var DInputClr        : String = '|16|20|15'    // Direct Message Input field color [sf]
Var DirectClr        : String = ''

Var Cursor           : String = Chr(178)       // Virtual Cursor Character
Var CursorBg         : String = '|25'          // Cursor Background color
Var RCursorBg        : String = '|25'          // Room Cursor Background color
Var DCursorBg        : String = '|28'          // Direct Message Cursor Background color
Var CIdx,TIdx        : Byte   = 7              // Chat text color index [sf]

Var ChatWidth        : Byte   = 80             // Default width of chat box

Var MClr             : String = '|24|10'       // Mention indicator colors (background+foreground)
Var MChr             : String = Chr(175)       // Mention indicator character
Var TClr             : Byte = 8                // Timestamp color
Var BBg              : Byte = 16               // Scroller background (16-23) [sf]
Var BClr             : Byte = 11               // Scroller color [sf]
Var BFad1            : Byte = 3                // Scroller fader color 1 [sf]
Var BFad2            : Byte = 8                // Scroller fader color 2 [sf]
Var BannerX          : Byte = 43               // XPosition of banner [sf]
Var BannerY          : Byte = 2                // YPosition of banner [sf]
Var BannerLen        : Byte = 36               // Length of banner [sf]
Var ScrollDly        : Byte = 0                // Banner scrolling start delay
Var ScrollSpeed      : Byte = 15               // Scroll speed factor (Lower = Faster)
Var ScrollDisable    : Boolean = False         // Disable scrolling banner
Var HeartbeatDisable : Boolean = False         // Disable heartbeat display

// Define banner to scroll, loaded at each banner change (for dynamic content for example)
Procedure LoadBanners
Begin
    BannerList[1] := MRCVersion + MRCStats
    BannerList[2] := 'Messages blocked by Twit filter: ' + Int2Str(TwitCount)
    BannerList[3] := 'Broadcasts blocked by Shield: ' + Int2Str(ShieldCount)
    BannerList[4] := 'Find more about the connected BBSes using the /INFO command'
    BannerList[5] := 'Give a try to the new nick auto-completion feature using the TAB key'
    BannerList[6] := 'Reply to your last received direct message using the /R shortcut'
    BannerList[7] := 'Look at the expanded client help with /?'
    // SysOp can add their own banners
End

//
// End of customization variables block [CUST]
//

// Return the elements from the Theme string
Function GetParams(I:String) : ThemeIniData
Var TT : ThemeIniData
Begin
    TT.TX := Str2Int(WordGet(1,I,','))
    TT.TY := Str2Int(WordGet(2,I,','))
    TT.TL := Str2Int(WordGet(3,I,','))
    TT.TF := Str2Int(WordGet(4,I,','))
    TT.TB := Str2Int(WordGet(5,I,','))
    GetParams := TT
End

// Define Screen
Procedure SetScreen
Var F1       : File
Var M,X,Y    : Byte
Var AnsiFile : String[128] = ''
Var IniFile  : String[128] = ''
Var P,V      : String[30] = ''
Var S        : String = ''
Var Ver1,Ver2: String = ''
Begin

    // Find which Mystic version
    Ver1 := WordGet(1, MCI2Str('VR'),' ')
    Ver2 := WordGet(2, MCI2Str('VR'),' ')

    // If using older version (only 80x24)
    TermX := 80
    TermY := 24

    // Version 1.12 A47+ support TermSize and wide screen
    If Ver1 = '1.12' and Pos('A', Ver2) = 1 and Str2Int(Replace(Ver2, 'A', '')) > 46 Then Begin
        TermX := TermSizeX
        TermY := TermSizeY
    End

    // Any terminal sizes (actual and with status bar) can be defined
    // _Must_ have a matching mrctheme-{theme}.{size}.ini in your theme SCRIPT folder
    // _Must_ have a matching ANSI in your theme TEXT folder (defined in INI)
    ScreenSizes[1]  := '80x24'
    ScreenSizes[2]  := '80x25'
    ScreenSizes[3]  := '80x27'
    ScreenSizes[4]  := '80x28'
    ScreenSizes[5]  := '80x29'
    ScreenSizes[6]  := '80x30'
    ScreenSizes[7]  := '80x42'
    ScreenSizes[8]  := '80x43'
    ScreenSizes[9]  := '80x49'
    ScreenSizes[10] := '80x50'
    ScreenSizes[11] := '80x59'
    ScreenSizes[12] := '80x60'
    ScreenSizes[13] := '132x24'
    ScreenSizes[14] := '132x25'
    ScreenSizes[15] := '132x27'
    ScreenSizes[16] := '132x28'
    ScreenSizes[17] := '132x29'
    ScreenSizes[18] := '132x30'
    ScreenSizes[19] := '132x33'
    ScreenSizes[20] := '132x34'
    ScreenSizes[21] := '132x36'
    ScreenSizes[22] := '132x37'
    ScreenSizes[23] := '132x42' // Syncterm
    ScreenSizes[24] := '132x43'
    ScreenSizes[25] := '132x49'
    ScreenSizes[26] := '132x50'
    ScreenSizes[27] := '132x51'
    ScreenSizes[28] := '132x52'
    ScreenSizes[29] := '132x59'
    ScreenSizes[30] := '132x60'
    ScreenSizes[31] := '160x44' // Netrunner
    ScreenSizes[32] := '160x45'
    ScreenSizes[33] := '160x59'
    ScreenSizes[34] := '160x60'

    // Some default values
    // These are hardcoded defaults using the original theme
    MrcTheme.IniFile     := 'mrctheme-original.default.ini'
    MrcTheme.Width       := 80
    MrcTheme.Height      := 24
    MrcTheme.TopANSI     := '1,4,1,1,1'
    MrcTheme.BotANSI     := '6,1,1,23,1'
    MrcTheme.HelpANSI1   := '8,21,4,2,1'
    MrcTheme.HelpANSI2   := '30,21,4,2,1'
    MrcTheme.WelcomeANSI := '52,21,4,2,1'
    MrcTheme.MarkGood    := '0,0,0,15,18'
    MrcTheme.MarkWarn    := '0,0,0,15,22'
    MrcTheme.MarkCrit    := '0,0,0,15,20'
    MrcTheme.Room        := '13,2,30,10,16'
    MrcTheme.Topic       := '13,3,30,15,16'
    MrcTheme.Scroll      := '43,2,35,7,16'
    MrcTheme.InputBar    := '1,24,78,7,16'
    MrcTheme.Latency     := '12,23,3,7,16'
    MrcTheme.Chatters    := '30,23,3,7,16'
    MrcTheme.Buffer      := '59,23,3,7,16'
    MrcTheme.Heartbeat   := '76,23,1,7,16'
    MrcTheme.Mentions    := '46,23,2,7,16'
    MrcTheme.ChatTL      := '1,5,79,7,16'
    MrcTheme.ChatBL      := '1,22,79,7,16'

    // Align the Theme from user record
    IniFile          := 'mrctheme-' + Plyr.ThemeName + '.default.ini'
    MrcTheme.IniFile := IniFile

    // Find best template based on terminal size
    Write('|CL|07')
    For M:=1 To 34 Do Begin
        X := Str2Int(WordGet(1,ScreenSizes[M],'x'))
        Y := Str2Int(WordGet(2,ScreenSizes[M],'x'))
        If ThemeDebug Then WriteLn('Checking: ' + ScreenSizes[M])

        // Select the best template based on terminal size
        // Must use ANSI auto-detect in Mystic
        If TermX >= X Then TsX := X
        If TermY >= Y Then TsY := Y

        // Make the filename based on terminal size to check
        IniFile  := 'mrctheme-' + Plyr.ThemeName + '.' + Int2Str(TsX) + 'x' + Int2Str(TsY) + '.ini'

        // If file is present, let's use it until we find better
        // We also use these as screen size
        if FileExist(CfgMpePath + IniFile) Then Begin
            // Make the filename based on terminal size to check
            If ThemeDebug Then WriteLn('Matching file: ' + IniFile)
            MrcTheme.Width    := TsX
            MrcTheme.Height   := TsY
            MrcTheme.IniFile  := IniFile
            CLBuffer          := TsY
        End
    End

    // Read the INI file
    If FileExist(CfgMpePath + MrcTheme.IniFile) Then Begin
        If ThemeDebug Then WriteLn('Reading file: ' + MrcTheme.IniFile)
        fAssign(F1, CfgMpePath + MrcTheme.IniFile, 66)
        fReset(F1)
        While Not fEof(F1) Do Begin
            fReadLn(F1,S)

            // Ignore comments in INI file
            If Pos('//', S) < 1 and WordCount(S,'=') = 2 Then Begin
                // Split the INI line on '=' and get Param and Value
                P := WordGet(1,S,'=')
                V := WordGet(2,S,'=')

                If ThemeDebug Then WriteLn('Reading pair: P=' + P + ', V=' + V)

                // Read the param/values to a Record
                Case P Of
                    'ANSIFILE':    MrcTheme.AnsiFile    := V
                    'TOPANSI':     MrcTheme.TopANSI     := V
                    'BOTANSI':     MrcTheme.BotANSI     := V
                    'HELPANSI1':   MrcTheme.HelpANSI1   := V
                    'HELPANSI2':   MrcTheme.HelpANSI2   := V
                    'WELCOMEANSI': MrcTheme.WelcomeANSI := V
                    'MARKGOOD':    MrcTheme.MarkGood    := V
                    'MARKWARN':    MrcTheme.MarkWarn    := V
                    'MARKCRIT':    MrcTheme.MarkCrit    := V
                    'ROOM':        MrcTheme.Room        := V
                    'TOPIC':       MrcTheme.Topic       := V
                    'SCROLL':      MrcTheme.Scroll      := V
                    'INPUT':       MrcTheme.InputBar    := V
                    'LATENCY':     MrcTheme.Latency     := V
                    'CHATTERS':    MrcTheme.Chatters    := V
                    'BUFFER':      MrcTheme.Buffer      := V
                    'HEARTBEAT':   MrcTheme.Heartbeat   := V
                    'MENTIONS':    MrcTheme.Mentions    := V
                    'CHATTL':      MrcTheme.ChatTL      := V
                    'CHATBL':      MrcTheme.ChatBL      := V
                End
            End
        End
        fClose(F1)
        If ThemeDebug Then WriteLn('Done reading')
    End
    If ThemeDebug Then Write('|PN')
End


Function ReadPlyr(I:Integer):Boolean
Var Ret  : Boolean = False
Var Fptr : File
Begin
    fAssign(Fptr,UserFile,66)
    fReset(Fptr)
    If IoResult = 0 Then Begin
        fSeek(Fptr,(I-1)*SizeOf(Plyr))
        If Not fEof(fptr) Then Begin
            fReadRec(Fptr,Plyr)
            Ret:=True
        End
        fClose(Fptr)
    End
    ReadPlyr:=Ret
End


Procedure SavePlyr(I:Integer)
Var Fptr : File
Begin
    fAssign(Fptr,Userfile,66)
    fReset(Fptr)
    If IoResult = 0 Then
        fSeek(Fptr,(I-1)*SizeOf(Plyr))
    Else Begin
        Plyr.RecIdx:=1
        fReWrite(Fptr)
    End
    fWriteRec(Fptr,Plyr)
    fClose(Fptr)
End


Function FindPlyr:Integer
Var X,Ret : Integer = 0
Var Done  : Boolean = False
Var UN    : String  = ''
Begin
    X:=1
    UN:=Upper(StripMCI(Replace(UserAlias,' ','_')))
    While ReadPlyr(X) And Not Done Do Begin
        If StripMCI(Upper(Plyr.Name)) = UN Then Begin
            Done:=True
            Ret:=X
        End
        X:=X+1
    End
    FindPlyr:=Ret
End


Procedure NewPlyr
Var I : Integer = 0
Begin
    I:=0
    While ReadPlyr(I+1) Do I:=I+1

    Plyr.RecIdx          :=I+1
    Plyr.PermIdx         :=UserIndex
    Plyr.EnterChatMe     :='|07- |15You have entered chat'
    Plyr.EnterChatRoom   :='|07- |11%1 |03has arrived!'
    Plyr.LeaveChatMe     :='|07- |12You have left chat.'
    Plyr.LeaveChatRoom   :='|07- |12%1 |04has left chat.'
    Plyr.EnterRoomMe     :='|07- |11Joining room |02%3'
    Plyr.LeaveRoomRoom   :='|07- |02%1 |10has left the room.'
    Plyr.LeaveRoomMe     :='|07- |10You have left room |02%4'
    Plyr.EnterRoomRoom   :='|07- |11%1 |03has entered the room.'
    Plyr.Defaultroom     :='lobby'
    Plyr.NameColor       :='|11'
    Plyr.LtBracket       :='|03<'
    Plyr.RtBracket       :='|03>'
    Plyr.ThemeName       :='original'
    Plyr.TwitList        :=''
    Plyr.PromptColor     :=7
    Plyr.UsageCount      :=1
    Plyr.BroadcastShield :=False
    Plyr.ShowScroller    :=True
    Plyr.TwitFilter      :=False
    Plyr.ShowWelcome     :=True
    Plyr.UseClock        :=True
    Plyr.ClockFormat     :=False

    Plyr.Name:=StripMCI(Replace(UserAlias,' ','_'))

    SavePlyr(Plyr.RecIdx)
End


Procedure CleanOut
Var X : Byte = 0
Begin
    For X:=1 To 20       Do BannerList[X] := ''
    For X:=1 To 10       Do BufferHist[X] := ''
    For X:=1 To CLBuffer Do ChatLines[X]  := ''

    FindFirst(CfgTempPath + '*.mrc',66)
    While DosError = 0 Do Begin
        If FileExist(CfgTempPath+DirName) Then
            FileErase(CfgTempPath+DirName)
        FindNext
    End
    FindClose
    If FileExist(PInUse) Then
        fileErase(PInUse)
    If FileExist(ChatLog) Then
        fileErase(ChatLog)
    If FileExist(MentionLog) Then
        fileErase(MentionLog)

End


// Add Banners from Server [sf]
Procedure AddBanner(Text:String)
Var BanExist : Boolean = False
Begin
    BanIdx := 1
    Repeat
        If BannerList[BanIdx] = Text Then
           BanExist := True
        BanIdx := BanIdx + 1
    Until Length(BannerList[BanIdx]) = 0 or BanIdx > 20
    If BanExist = False Then
    Begin
        If BanIdx < 21 Then
            BannerList[BanIdx] := Text
        BanIdx := 1
    End
End


// Return PIPE code based on byte
Function GetPipe(C:Byte) : String
Begin
    If C < 32 Then
        GetPipe := '|' + PadLT(Int2Str(C), 2, '0')
End

Procedure UpdateRoom
Begin
    WriteXY(RoomX,RoomY,RoomAttr,PadRt('#'+MyRoom,RoomL,' '))
End

Procedure UpdateTopic
Begin
    WriteXY(TopicX,TopicY,TopicAttr,PadRt(MyTopic,TopicL,' '))
End

Procedure UpdateLatency
Begin
    WriteXY(LatX, LatY, LatCol, PadLt(Int2Str(LatencyData), 3, ' '))
End

Procedure UpdateChatters
Begin
    WriteXY(UsrX, UsrY, UsrCol, PadLt(Int2Str(WordCount(RoomUsers,',')), 3, ' '))
End

Procedure UpdateMentions
Var T  : ThemeIniData
Var MC : String = ''
Begin
    T := GetParams(MrcTheme.MarkCrit)

    If MentionCount < 1 Then
        MC := GetPipe(MentionsCol)
    Else
        MC := GetPipe(T.TF) + GetPipe(T.TB)

    GotoXY(MentionsX, MentionsY)
    Write(MC + PadLt(Int2Str(MentionCount), 2, ' ') + GetPipe(MentionsCol))
End

Procedure ShowChat(Top:Integer)
Var C,T,L,Y,X : Integer = 0
Var CL        : Byte
Begin
    If RefreshChat Then
    Begin
        Y:=CLBuffer-WinSize-Top
	    Write('|08')
        For X:=1 To WinSize+1 Do Begin
            GoToXy(WinTL,WinTT+X-1)
            CL := Length(StripMCI(ChatLines[Y]))
            Write(ChatLines[Y] + '|16' + StrRep(' ', ChatWidth-CL))
            // Write(ChatLines[Y] + '|16' + chr(27) + '[2K')
            Y:=Y+1
        End
        RefreshChat := False
    End
End


// Parse chat into a message record
Function ParseChat(S:String) : MrcREc
Var MR    : MrcRec
Begin
    MR.FromUser := WordGet(1,S,'~')  // Source user
    MR.FromSite := WordGet(2,S,'~')  // Source BBS
    MR.FromRoom := WordGet(3,S,'~')  // Room the user is in
    MR.ToUser   := WordGet(4,S,'~')  // Target user (if direct msg)
    MR.MsgExt   := WordGet(5,S,'~')  // Message extension
    MR.ToRoom   := WordGet(6,S,'~')  // Target room
    MR.Message  := WordGet(7,S,'~')  // Message content
    ParseChat   := MR
End

Procedure CheckUserlist(U:String)
Var X : Integer = 0
Var A : Boolean = True
Begin
    For X := 1 to WordCount(RoomUsers, ',') Do
        If Upper(U) = Upper(WordGet(X, RoomUsers, ',')) Then
            A := False

    If U = 'SERVER' or U = 'CLIENT' Then
        A := False

    If A = True Then
    Begin
        If Length(RoomUsers) > 0 Then
            RoomUsers := RoomUsers + ',' + U
        Else
            RoomUsers := U
    End
End


// Read ANSI file and print relevant section
Procedure DrawAnsi(I:String)
Var F1  : File
Var T   : ThemeIniData
Var L,C : Integer = 0
Var S   : Char  = ''
Var LF  : Char  = Chr(10)
Var CR  : Char  = Chr(13)
Begin

    T:=GetParams(I)
    If T.TB <> 0 Then Begin
        fAssign(F1, CfgTextPath + MrcTheme.AnsiFile, 66)
        L:=1  // File lines
        C:=0  // Line count
        fReset(F1)
        GotoXy(T.TL, T.TF)
        While Not fEof(F1) Do Begin
            S:=''
            fRead(F1,S,1) // Read char

            // Do we have a linefeed?
            If S = LF Then
                L:=L+1

            // Do we need to print the char?
            if L >= T.TX and C <= T.TY Then
                If S <> LF Then
                    If S <> CR Then
                        Write(S)
                Else
                Begin
                    C:=C+1
                    GotoXy(T.TL, T.TF+C)
                End
        End
        fClose(F1)
    End
End


// Draw MRC screen components
Procedure DrawScreen
Begin
    Write('|CL')
    DrawAnsi(MrcTheme.TopANSI)
    DrawAnsi(MrcTheme.BotANSI)
End

Procedure RedrawScreen
Begin
    DrawScreen
    UpdateRoom
    UpdateTopic
    UpdateLatency
    UpdateChatters
    UpdateMentions
    RefreshChat:=True
    ShowChat(0)
End

// Check if user is in Twit list
Function IsTwit(UT:String) : Boolean
Var I : Integer = 0
Var W : Boolean = False
Var U : String[20] = ''
Begin
    If Plyr.TwitFilter = True Then
    Begin
        For I:=1 To WordCount(Plyr.TwitList, ' ') Do Begin
            U:=WordGet(I,Plyr.TwitList,' ')
            If Upper(U) = Upper(UT) Then
                W := True
        End
        IsTwit := W
    End
    Else
        IsTwit := False
End


// Cut string to multiple lines
Function StringCutter(S:String;L:Byte):Byte
Var P,W,O : Byte   = 0
Var S1    : String = ''
Var Done  : Boolean = False
Begin
    P := Length(S)

    If Length(StripMCI(S)) < L Then
        StringCutter := P
    Else
    Begin
        Repeat
            S1 := Copy(S,1,P)
            If Length(StripMCI(S1)) < L Then
            Begin
                O := WordCount(S1, ' ')
                W := WordPos(O, S1, ' ')

                // If word is not within 10 chars from line end or
                // the line fits
                If Length(StripMCI(S)) < L Or W < P - 10 Then
                    W := 0

                // Cut on word
                If W > 0 Then
                Begin
                    StringCutter := W - 1
                    Done := True
                End

                // Cut on size
                Else
                Begin
                    StringCutter := P
                    Done := True
                End
            End

            // Avoid cutting a PIPE code in the middle when scanning
            If Copy(S, P - 2, 1) = '|' Then
                P := P - 3
            Else
                P := P - 1

        Until Done = True
    End
End


// Add line to chat
// U: FromAnotherUser
// P: PrivateMsg
Procedure Add2Chat(U:Boolean;P:Boolean;S:String)
Var E,W,L,B,A,X    : Integer = 0
Var DS,S1,S2,S3,S4 : String = ''
Var HL,HDR,NL      : String = ''
Var M              : Boolean = False
Var T              : ThemeIniData
Begin

    // Handle nick mention [sf]
    HL  := '|16|00.'
    HDR := GetPipe(TClr)
    T   := GetParams(MrcTheme.MarkCrit)

    // Either we match the user in the line or P is true (DirectMSG)
    If Pos(Upper(UserTag), Upper(StripMCI(Copy(S, Length(WordGet(1,S,' ')), Length(S))))) > 0 Or P = True Then
    Begin
        // Bell
        GotoXy(HeartbeatX,HeartbeatY)
        Write('|16|00|BE|07')

        HL := MClr + MChr + '|16|07'

        // Mark as mention only if originate from a user (skip server and notifications)
        If U = True Then Begin
            MentionCount:=MentionCount+1
            If MentionCount > 99 Then
                MentionCount := 99
            M:=True
        End
    End

    NL:=' ' + Chr(28) + ' '
    If Plyr.UseClock Then
    Begin
        DS:=TimeStr(DateTime,Plyr.ClockFormat)

        // Apply highlight over clock on mention
        If M Then
            HDR := GetPipe(T.TF) + GetPipe(T.TB)

        If Not Plyr.ClockFormat Then Begin
            Delete(DS,6,3)
        End

        S:=HDR+DS+HL+'|16|07' + S
        S3:=StrRep(' ', Length(DS)) + NL
    End
    Else
    Begin
        S:=HL+'|16|07' + S
        S3:=NL
    End

    S1:=S
    Repeat
        Delay(5)

        W := StringCutter(S1,ChatWidth)

        If Length(S1) > W Then
        Begin
            S2 := Copy(S1, W+1, Length(S1)-W)
            S4 := Copy(S1, 1, W)
            S1 := S4

        End
        Else
            S2 := ''

        If (S1 <> '')  Then
        Begin
            For X:=2 To CLBuffer Do
                ChatLines[X-1]:=ChatLines[X]
            ChatLines[CLBuffer]:='|16'+S1+''
            AppendText(ChatLog,ChatLines[CLBuffer])
            RefreshChat := True
            S1:=S3+S2

            // Append mention lines to mention log
            If M = True Then Begin
                AppendText(MentionLog,ChatLines[CLBuffer])
            End
        End

    Until S2=''

    // Update mentions counter
    If M = True Then
        UpdateMentions

End


// Add user to twitlist
Procedure TwitAdd(Line:String)
Var UT : String[20] = ''
Begin
    UT:=WordGet(1,Line,' ')

    If Upper(UT) = 'SERVER' or Upper(UT) = 'CLIENT' or Upper(UT) = 'NOTME' Then
        Add2Chat(False, False, '* |12Cannot add this user to your Twit List')
    Else
    Begin
        If Plyr.TwitList = '' Then
            Plyr.TwitList := Upper(UT)
        Else
            Plyr.TwitList := Plyr.TwitList + ' ' + Upper(UT)

        SavePlyr(Plyr.RecIdx)
        Add2Chat(False, False, '* |11Added |15' + UT + ' |11to your Twit List')
    End
End

// Del user from twitlist
Procedure TwitDel(Line:String;S:Boolean)
Var UT, U   : String[20]  = ''
Var NewList : String[255] = ''
Var I       : Integer = 0
Var E       : Boolean = False
Begin
    UT:=WordGet(1,Line,' ')
    For I:=1 To WordCount(Plyr.TwitList, ' ') Do Begin
        U:=WordGet(I,Plyr.TwitList,' ')
        If Upper(U) <> Upper(UT) Then
        Begin
            If NewList = '' Then
                NewList := U
            Else
                NewList := NewList + ' ' + U
        End
        If Upper(U) = Upper(UT) Then
            E := True
    End

    Plyr.TwitList:=NewList
    SavePlyr(Plyr.RecIdx)

    If S = True Then   // Show result?
    Begin
    If E = True Then   // Exist?
        Add2Chat(False, False, '* |11Removed |15' + UT + ' |11from your Twit List')
    Else
        Add2Chat(False, False, '* |11Cannot find |15' + UT + ' |11in your Twit List')
    End
End

// Clear twitlist
Procedure TwitClear
Begin
    Plyr.TwitList:=''
    SavePlyr(Plyr.RecIdx)
    Add2Chat(False, False, '* |11Your Twit List have been cleared')
End

// Show twitlist
Procedure TwitShow
Var I  : Integer = 0
Var TF : String = 'ENABLED'
Begin
    If Plyr.TwitFilter = False Then
        TF := 'DISABLED'

    I := WordCount(Plyr.TwitList,' ')
    if I < 1 Then
        Add2Chat(False, False, '* |11Your Twit List is |15empty')
    Else
    Begin
        Add2Chat(False, False, '* |11Your Twit List (|15' + Int2Str(I) + '|11): |15' + Plyr.TwitList)
        Add2Chat(False, False, '* |11Your Twit Filter is |15' + TF + '|11. See |15/SET TWITFILTER')
    End
End

// Handle Twit management
Procedure ManageTwit(S:String)
Var C,U : String[20] = ''
Begin
    C := Upper(WordGet(1,S,' '))
    If WordCount(S, ' ') > 1 Then
        U := WordGet(2,S,' ')
    Case C Of
        'ADD'   : Begin
            TwitDel(U,False)      // Avoid duplicate by deleting first
            TwitAdd(U)
        End
        'DEL'   : TwitDel(U,True)
        'LIST'  : TwitShow
        'CLEAR' : TwitClear
    Else
        Add2Chat(False, False, '* |12Invalid TWIT command')
        Add2Chat(False, False, '* |11Usage: |10/TWIT |15|08[|15ADD|08/|15DEL|08] |14twituser')
        Add2Chat(False, False, '* |11       |10/TWIT |15|08[|15LIST|08/|15CLEAR|08]')
        Add2Chat(False, False, '* |11Also see |15/SET TWITFILTER |11to |15ENABLE|11/|15DISABLE')
    End
    ShowChat(0)

End

// Check if stale outbound messages are stuck in queue
Procedure CheckStale
Begin
    HBClr := HeartbeatGood
    FindFirst(SvrQueuePath + PathChar + '*.mrc', 63)
    While DOSError = 0 Do
    Begin
        If DateTime > DirTime Then
            HBClr := HeartbeatBad
        FindNext
    End
    FindClose
End

// Display error message to chat window [sf]
Procedure ShowError(S:String)
Begin
    Add2Chat(False, False, '|15!|12 ' + S)
    ShowChat(0)
End

Procedure MakeChatEntry(S:String)
Var Fil : String = SvrQueuePath + PathChar +
    Int2Str(NodeNum) + Int2Str(ChatSeed) +
    Int2Str(Random(9))+Int2Str(Random(9)) + '.mrc'
Begin
    AppendText(Fil,S)
    ChatSeed:=ChatSeed+1
End

Procedure SendOut(FU,FS,FR,TU,TS,TR,S:String)
Var TX : String = ''
Begin
    TX:=FU+'~'+FS+'~'+FR+'~'+TU+'~'+TS+'~'+TR+'~'+S+'~'
    MakeChatEntry(TX)
End

Procedure SendToMe(S:String)
Begin
    Add2Chat(False, False, S)
    ShowChat(0)
End

Procedure SendToCTCP(U:String;P:String;S:String)
Begin
    SendOut(UserTag, SiteTag, CTCPROOM, U, '', CTCPROOM, P + ' ' + UserTag + ' ' + S)
End

Procedure SendToAllNotMe(S:String)
Begin
    SendOut(UserTag,SiteTag,MyRoom,'NOTME','','',S)
End

Procedure SendToRoomNotMe(S:String)
Begin
    SendOut(UserTag,SiteTag,MyRoom,'NOTME','',MyRoom,S)
End

Procedure SendToAll(S:String)
Begin
    SendOut(UserTag,SiteTag,MyRoom,'','','',S)
End

Procedure SendToRoom(S:String)
Begin
    SendOut(UserTag,SiteTag,MyRoom,'','',MyRoom,S)
End

Procedure SendToUser(U,S:String)
Begin
    SendOut(UserTag,SiteTag,MyRoom,U,'','',S)
End

Procedure SendToUserEncrypted(U,S:String)
Begin
    SendOut(UserTag,SiteTag,MyRoom,U,'ENCRYPTED','',S)
End

Procedure SendToClient(S:String)
Begin
    SendOut(UserTag,SiteTag,MyRoom,'CLIENT',SiteTag,MyRoom,S)
End

Procedure SendToServer(S:String)
Begin
    SendOut(UserTag,SiteTag,MyRoom,'SERVER',SiteTag,MyRoom,S)
End

Function UpdateStrings(S,M,U,NR,OR:String):String
Begin
    S:=Replace(S,'%1',M)
    S:=Replace(S,'%2',U)
    S:=Replace(S,'%3','#'+NR)
    S:=Replace(S,'%4','#'+OR)
    UpdateStrings:=S
End

Procedure JoinRoom(S:String;B:Boolean)
Var NewRoom,OldRoom : String = ''
Begin
    If Length(S) > 20 Then
        ShowError('Room name is limited to 20 chars max')
    Else Begin
        If Length(S) > 0 Then Begin
            if Pos('|', S) < 1 Then Begin
                OldRoom:=MyRoom
                NewRoom:=lower(S)
                StripB(S,'#')
                SendToServer('NEWROOM:'+MyRoom+':'+S)
                If B Then Begin
                    SendToMe(UpdateStrings(Plyr.LeaveRoomMe,Plyr.Name,'',NewRoom,OldRoom))
                    SendToRoomNotMe(UpdateStrings(Plyr.LeaveRoomRoom,Plyr.Name,'',NewRoom,OldRoom))
                    MyRoom:=NewRoom
                    SendToMe(UpdateStrings(Plyr.EnterRoomMe,Plyr.Name,'',NewRoom,OldRoom))
                    SendToRoomNotMe(UpdateStrings(Plyr.EnterRoomRoom,Plyr.Name,'',NewRoom,OldRoom))
                End
                MyRoom:=S
                SetPromptInfo(4,'#'+S)
                UpdateRoom
            End
            Else
                ShowError('Room name cannot contain the PIPE symbol')
        End
    End
End

Procedure InboundCTCP(F:String;U:String;M:String)
Var TYP,USR,TGT,CMD : String = ''
Var PRM : Byte = 0
Begin

    // Do not handle our own requests
    If Upper(F) <> Upper(UserTag) Then Begin

        // Handle inbound CTCP if for the user of broadcast
        // If U = '' or Upper(U) = Upper(UserTag) Then Begin // Will need to think if we leave it broadcast

            // Check CTCP packet type
            TYP:=WordGet(1,M,' ')
            Case Upper(TYP) Of

                // Handle request
                '[CTCP]' : Begin
                    USR := WordGet(2,M,' ')
                    TGT := WordGet(3,M,' ')
                    CMD := WordGet(4,M,' ')

                    If Plyr.HideCTCPReq = False Then
                        Add2Chat(False, False, '* |14[CTCP-REQUEST] |15' + Upper(CMD) + ' |07on |15' + TGT + ' |07from |10' + F)

                    If TGT = '*' or Upper(TGT) = Upper(UserTag) or Upper(TGT) = '#' + Upper(MyRoom) Then Begin
                        Case Upper(CMD) Of
                            'VERSION'    : SendToCTCP(USR, '[CTCP-REPLY]', 'VERSION ' + stripMCI(MRCVersion))
                            'TIME'       : SendToCTCP(USR, '[CTCP-REPLY]', 'TIME ' + DateStr(DateTime,1) + ' ' + TimeStr(DateTime,False))
                            'PING'       : Begin
                                PRM:=Length(TYP)+Length(USR)+Length(TGT)+Length(CMD)+4
                                Delete(M,1,PRM)
                                SendToCTCP(USR,'[CTCP-REPLY]', 'PING ' + M)
                            End
                            'CLIENTINFO' : SendToCTCP(USR,'[CTCP-REPLY]', 'CLIENTINFO VERSION TIME PING CLIENTINFO')
                        End
                    End
                End

                // Display reply
                '[CTCP-REPLY]' : Begin
                    // Only we it's a message to us
                    If Upper(U) = Upper(UserTag) Then Begin
                        Delete(M,1,Length(TYP)+1)
                        TGT := WordGet(1,M,' ')
                        Delete(M,1,Length(TGT))
                        Add2Chat(False, False, '* |14[CTCP-REPLY] |10' + TGT + '|15' + M)
                    End
                End
            End
        // End
    End
End

Procedure ProcessChat(MR:MRCRec)
Var Ok2Send                      : Boolean = True
Var Command,Opt1,Opt2,Stats,Room : String  = ''
Var ST,SL                        : Byte    = 0
Begin

    // Handle topic set from server
    If Mr.FromUser = 'SERVER' and
        Pos('ROOMTOPIC',Mr.Message) > 0 Then
    Begin
        Ok2Send := False
        Command:=WordGet(1,Mr.Message,':')
        Opt1:=WordGet(2,Mr.Message,':')
        Opt2:=Copy(Mr.Message,
             WordPos(3,Mr.Message,':'),
             Length(Mr.Message)-WordPos(3,Mr.Message,':')+1)
        If Opt1 = MyRoom Then Begin
            MyTopic:=Opt2
            UpdateTopic
        End
    End

    // Handle room set from server
    If Mr.FromUser = 'SERVER' and
        Pos('USERROOM',Mr.Message) > 0 Then
    Begin
        Ok2Send := False
        Command := WordGet(1,Mr.Message,':')
        Room    := WordGet(2,Mr.Message,':')
        JoinRoom(Room,False)
    End

    // Handle userlist from server
    If Mr.FromUser = 'SERVER' and
        Pos('USERLIST',Mr.Message) > 0 Then
    Begin
        Ok2Send   := False
        Command   := WordGet(1,Mr.Message,':')
        Opt1      := WordGet(2,Mr.Message,':')
        RoomUsers := Opt1
        WriteXY(UsrX, UsrY, UsrCol, PadLt(Int2Str(WordCount(RoomUsers,',')), 3, ' '))
    End

    // Handle client hello request
    If Mr.FromUser = 'SERVER' and
        Mr.Message = 'HELLO' Then
    Begin
        Ok2Send := False

        SendToServer('IAMHERE')
    End

    // Handle Latency from client
    If Mr.FromUser = 'SERVER' and
        Pos('LATENCY',Mr.Message) > 0 Then
    Begin
        Ok2Send := False
        LatencyData := Str2Int(WordGet(2,Mr.Message,':'))
        If LatencyData > 999 Then
            LatencyData := 999
        WriteXY(LatX, LatY, LatCol, PadLt(Int2Str(LatencyData), 3, ' '))
    End

    // Handle stats from client
    If Mr.FromUser = 'SERVER' and
        Pos('STATS',Mr.Message) > 0 Then
    Begin
        Ok2Send := False
        Stats := WordGet(2,Mr.Message,':')
        If Length(Stats) > 0 Then
        Begin
            MRCStats := ' :: Server Stats >> BBSes:' + WordGet(1, Stats, ' ') +
                ' Rooms:' + WordGet(2, Stats, ' ') +
                ' Users:' + WordGet(3, Stats, ' ')
            LoadBanners
        End
    End

    // Handle Banners from server
    If Mr.FromUser = 'SERVER' and
        Pos('BANNER',Mr.Message) > 0 Then
    Begin
        Ok2Send := False
        ST := Pos(':', Mr.Message)              // Match the first colon
        SL := Length(Mr.Message) - ST           // String length
        AddBanner(Copy(Mr.Message, ST + 1, SL)) // Add the banner
    End

    // Handle CTCP message
    If Lower(Mr.ToRoom) = CTCPROOM Then Begin
        Ok2Send   := False
        InboundCTCP(Mr.FromUser,Mr.ToUser, Mr.Message)
    End

    // Handle TERMINATE from server
    If Mr.FromUser = 'SERVER' and
        Pos('TERMINATE',Mr.Message) > 0 Then
    Begin
        Ok2Send   := False
        Command   := WordGet(1,Mr.Message,':')
        Opt1      := WordGet(2,Mr.Message,':')
        Add2Chat(True, False, Opt1)
        ShowChat(0)
    End

    // Handle USERNICK from server
    If Mr.FromUser = 'SERVER' and
        Pos('USERNICK',Mr.Message) > 0 Then
    Begin
        Ok2Send   := False
        Command   := WordGet(1,Mr.Message,':')
        Opt1      := WordGet(2,Mr.Message,':')
        UserTag   := Opt1
        Add2Chat(True, False, '|10Server changed your nick to: |15' + Opt1)
        ShowChat(0)
    End

    // Message for another room
    If MR.ToRoom <> '' Then
        if Upper(MR.ToRoom) <> Upper(MyRoom) Then
            Ok2Send:=False

    // Message not empty and not for me
    If MR.ToUser <> '' Then
        If Mr.ToUser <> 'NOTME' Then
            If Pos(Upper(MR.ToUser),Upper(UserTag))=0
                 Then Ok2Send:=False
    Else
        If Mr.ToUser <> 'NOTME' Then
            If Upper(Mr.FromUser) = Upper(UserTag) Then
                Ok2Send:=False

    // Message FromMe with NOTME as ToUser
    If Upper(Mr.FromUser) = Upper(UserTag) and
        Mr.ToUser = 'NOTME' Then
            Ok2Send:=False

    // Message from a user
    If Mr.FromUser <> 'SERVER' and Mr.FromUser <> 'CLIENT' Then
        If Upper(Mr.ToUser) = Upper(UserTag) Then
            LastDirectMsg := Mr.FromUser

    // Check for broadcast
    If Mr.ToUser = '' and Mr.ToRoom = '' and Ok2Send Then
        If Plyr.BroadcastShield = True Then
            ShieldCount:=ShieldCount+1

    If Ok2Send Then
    Begin
        // Validate against twit list
        If IsTwit(MR.FromUser) Then
            TwitCount:=TwitCount+1
        Else If Mr.FromUser = 'SERVER' or Mr.FromUser = 'CLIENT' Then
            Add2Chat(False, False, MR.Message)
        Else If Upper(Mr.ToUser) = Upper(UserTag) Then
            // This is a direct message
            Add2Chat(True, True, MR.Message)
        Else If Upper(Mr.FromUser) = Upper(UserTag) Then
            // This is from me
            Add2Chat(False, False, MR.Message)
        Else
            Add2Chat(True, False, MR.Message)
        CheckUserlist(MR.FromUser)
    End
End

Procedure ReadChatFiles(D:Boolean)
Var F1      : File
Var S       : String  = ''
Var Ret     : Boolean = False
Var TLines  : Array [1..100] of String [255]
Var TSorted : Array [1..100] of String [255]
Var TStamp  : LongInt = 0
Var LCount  : Byte = 0
Var Largest : LongInt = 0
Var LIndex  : Byte = 0
Var A,B,F,L : Byte = 0
Begin
    FindFirst(CfgTempPath+'*.mrc',66)
    While DOSError = 0 Do Begin
        Ret:=True
        fAssign(F1,CfgTempPath+DirName,66)
        fReset(F1)
        L:=0
        While Not fEof(F1) Do Begin
            fReadLn(F1,S)
            LCount:=LCount+1
            TStamp := Str2Int(Copy(DirName, 1, 8)) + L
            TLines[LCount] :=  Int2Str(TStamp) + ' ' + S
            L:=L+1
        End
        fClose(F1)
        fileErase(CfgTempPath+DirName)
        FindNext
    End
    FindClose

    // Little home-made sorting routine
    // Sort loop 1 - Populate array from largest to lowest
    For A:=LCount DownTo 1 Do
    Begin
        // Sort loop 2 - Read original array from
        Largest := 0

        For B:=1 to LCount Do
        Begin
            If Str2Int(WordGet(1, TLines[B], ' ')) > Largest Then
            Begin
                Largest := Str2Int(WordGet(1, TLines[B], ' '))
                LIndex  := B
            End
        End
        TSorted[A] := Copy(TLines[LIndex],
                      WordPos(2, TLines[LIndex], ' '),
                      Length(TLines[LIndex]) - WordPos(2, TLines[LIndex], ' ') + 1)
        TLines[LIndex] := '0'
    End

    // Process messages from the sorted array
    For F:=1 to LCount Do
    Begin
        If WordCount(TSorted[F], '~') > 6 Then
        Begin
            ServFile:=ParseChat(TSorted[F])
            ProcessChat(ServFile)
        End
    End

    If Ret and D Then ShowChat(0)
End

Procedure ChangeNick(LRNC,N:String;Announce:Boolean)
Var ON : String = ''
Begin

    Case LRNC Of

// FIXME: May be used with IDENTIFY
//        'N':    Plyr.Name:=StripMCI(N)

        // Limit left bracket to 1 visible character [sf]
        'L':    Begin
            If Length(StripMCI(N)) > 1 Then
                ShowError('Left bracket max length is 1 char')
            Else If StripMCI(N) = ' ' Then
                ShowError('Right bracket cannot be a space')
            Else
                Plyr.LtBracket:=N
            End

        // Limit right bracket to 8 visible character [sf]
        // Record length stays at 16 for compatibility
        'R':    Begin
            If Length(StripMCI(N)) > 8 or Length(N) > 16 Then
                ShowError('Right brackets max length is 8 chars (16 including Pipe codes)')
            Else If WordCount(N, ' ') > 1 Then
                ShowError('Right bracket cannot contain a space')
            Else
                Plyr.RtBracket:=N
            End

        // Make sure Nick color is a color PIPE code [sf]
        'C':    Begin
            If Length(StripMCI(N)) > 0 or Length(N) <> 3 Then
                ShowError('Only color pipe codes allowed for nick color')
            Else
                Plyr.NameColor:=N
            End
    End

    SavePlyr(Plyr.RecIdx)
    MyNamePrompt:=Plyr.LtBracket+Plyr.NameColor+StripMCI(Plyr.Name)+Plyr.RtBracket+'|16|07 '
End

// Theme lister
Procedure ListThemes
Var F1       : File
Var N,D,S,Pad:String = ''
Begin

    If FileExist(CfgMpePath + ThemeList) Then Begin
        Add2Chat(False, False, '|15* |15List of available themes|07')
        fAssign(F1, CfgMpePath + ThemeList, 66)
        fReset(F1)
        While Not fEof(F1) Do Begin
            fReadLn(F1,S)

            // Ignore comments in file
            If Pos('//', S) < 1 and WordCount(S,'=') = 2 Then Begin
                N := WordGet(1,S,'=')  // Name
                D := WordGet(2,S,'=')  // Description

                If ThemeDebug Then WriteLn('Reading pair: N=' + N + ', D=' + D)

                Pad := StrRep(' ', 12-Length(N))
                Add2Chat(False, False, '|15* |10' + N + '|07:|11' + Pad + D + '|07')
            End
        End
        fClose(F1)
    End
    Else
    Begin
        Add2Chat(False, False, '|15* |11No additional themes available|07')
    End
    ShowChat(0)

End



Procedure Init
Var X,Y : Integer = 0
Var K,S : String = ''
Var T   : ThemeIniData
Begin
    S:=Int2Str(NodeNum)
    For X:=1 To 3 Do
        S:=S+Int2Str(Random(9))
    ChatSeed:=Str2Int(S)
    ChatLog:=CfgTempPath+'mrcchat.log'
    MentionLog:=CfgTempPath+'mrcmention.log'
    PInUse:=CfgTempPath+'tchat.inuse'

    If Upper(UserAlias) = 'SERVER' or
        Upper(UserAlias) = 'CLIENT' or
        Upper(UserAlias) = 'NOTME' Then
    Begin
        WriteLn('|16|12|CL|CRUnfortunately, your User Alias is a reserved word and therefore cannot be used.')
        WriteLn('|12Please ask your SysOp to change your User Alias to use MRC.')
        WriteLn('|CR|PA|07|CL')
        Halt
    End

    BBSTempStub:=CfgTempPath
    Y:=Pos(Int2Str(NodeNum),BBSTempStub)
    If Y > 0 Then
        Delete(BBSTempStub,Y,Length(Int2Str(NodeNum))+1)

    Y:=FindPlyr
    If Y = 0 Then NewPlyr
    Else ReadPlyr(Y)

    // Make sure to remove spaces in RtBracket if exist
    If WordCount(Plyr.RtBracket, ' ') > 1 Then Begin
        Plyr.RtBracket:=StripMCI(Replace(Plyr.RtBracket,' ',''))
        SavePlyr(Plyr.RecIdx)
    End

    // Load saved configs
    TIdx := Plyr.PromptColor

    SiteTag:=StripMCI(Replace(MCI2Str('BN'),' ','_'))
    UserTag:=StripMCI(Replace(UserAlias,' ','_'))
    ChangeNick('N',UserTag,False)
    Write('|CL|[X01|[Y01')

    // Detect and set theme settings
    SetScreen

    // Chat Window Top line
    // GetScreenInfo(1,WinTL,WinTT,WinAttr)
    T := GetParams(MrcTheme.ChatTL)
    WinTL:=T.TX
    WinTT:=T.TY
    WinAttr:=T.TF
    ChatWidth:=T.TL

    // Chat Windows Bottom line
    // GetScreenInfo(2,WinBL,WinBB,WinAttr)
    T := GetParams(MrcTheme.ChatBL)
    WinBL:=T.TX
    WinBB:=T.TY
    WinAttr:=T.TF

    // Chat Input line
    // GetScreenInfo(3,PromptX,PromptY,PromptAttr)
    T := GetParams(MrcTheme.InputBar)
    PromptX:=T.TX
    PromptY:=T.TY
    PromptL:=T.TL
    PromptAttr:=T.TF

    // Room name
    // GetScreenInfo(4,RoomX,RoomY,RoomAttr)
    T := GetParams(MrcTheme.Room)
    RoomX:=T.TX
    RoomY:=T.TY
    RoomL:=T.TL
    RoomAttr:=T.TF

    // Room topic
    // GetScreenInfo(5,TopicX,TopicY,TopicAttr)
    T := GetParams(MrcTheme.Topic)
    TopicX:=T.TX
    TopicY:=T.TY
    TopicL:=T.TL
    TopicAttr:=T.TF

    // Scrolling banner
    T := GetParams(MrcTheme.Scroll)
    BannerX:=T.TX
    BannerY:=T.TY
    BannerLen:=T.TL
    If BannerLen = 0 or Plyr.ShowScroller = False Then
        ScrollDisable := True

    // Latency
    T := GetParams(MrcTheme.Latency)
    LatX:=T.TX
    LatY:=T.TY
    LatCol:=T.TF

    // Chatters
    T := GetParams(MrcTheme.Chatters)
    UsrX:=T.TX
    UsrY:=T.TY
    UsrCol:=T.TF

    // Buffer counter
    T := GetParams(MrcTheme.Buffer)
    CounterX1:=T.TX
    CounterY1:=T.TY
    CounterX2:=T.TX + 4
    CounterY2:=T.TY

    // Heartbeat
    T := GetParams(MrcTheme.Heartbeat)
    HeartbeatX:=T.TX
    HeartbeatY:=T.TY

    // Mentions
    T := GetParams(MrcTheme.Mentions)
    MentionsX:=T.TX
    MentionsY:=T.TY
    MentionsL:=T.TL
    MentionsCol:=T.TF

    WinSize:=WinBB-WinTT

    If ThemeDebug Then Begin
        WriteLn('Ansi file: ' + MrcTheme.AnsiFile)

        WriteLn('Top line: ' + MrcTheme.ChatTL)
        WriteLn('Top line: ' + Int2Str(WinTL) + ':' + Int2Str(WinTT))

        WriteLn('Bottom line: ' + MrcTheme.ChatBL)
        WriteLn('Bottom line: ' + Int2Str(WinBL) + ':' + Int2Str(WinBB))
        WriteLn('|PN')
    End

    AppendText(PInUse,'0')
    MenuCmd('NA','Multi Relay Chatting')
End

// Theme switcher
Procedure ChangeTheme(Line:String)
Var Tag,Theme,S,N,D:String = ''
Var Reload:Boolean = False
Var F1:File
Begin
    Tag:=WordGet(1,Line,' ')

    Case Upper(Tag) Of
        'LIST': ListThemes()

        'SET':  Begin
            If WordCount(Line, ' ') > 1 Then Begin
                Theme:=WordGet(2,Line,' ')
                If FileExist(CfgMpePath + ThemeList) Then Begin
                    fAssign(F1, CfgMpePath + ThemeList, 66)
                    fReset(F1)
                    While Not fEof(F1) Do Begin
                        fReadLn(F1,S)

                        // Ignore comments in file
                        If Pos('//', S) < 1 and WordCount(S,'=') = 2 Then Begin
                            N := WordGet(1,S,'=')
                            D := WordGet(2,S,'=')

                            If ThemeDebug Then WriteLn('Reading pair: N=' + N + ', D=' + D)
                            If Upper(Theme) = Upper(N) Then Begin
                                Add2Chat(False, False, '|15* |11Setting theme to: |15' + Theme + '|07')
                                Plyr.ThemeName := Theme
                                SavePlyr(Plyr.RecIdx)
                                Reload := True
                            End
                        End
                    End
                    fClose(F1)

                    If Reload = False Then Begin
                        Add2Chat(False, False, '|15* |12This theme is not found|07')
                    End
                End
                Else
                Begin
                    Add2Chat(False, False, '|15* |12This theme is not found|07')
                End
            End
        End
    Else
    Begin
    Add2Chat(False, False, '* |11Current: |15' + Plyr.ThemeName)
    Add2Chat(False, False, '* |11Usage:   |10/THEME LIST        |07- |11List available themes')
    Add2Chat(False, False, '* |11         |10/THEME SET <theme> |07- |11Set the selected theme')
    End

    If Reload = True Then Begin
        Init
        RedrawScreen
    End
    Else ShowChat(0)

End

Procedure DoHelp
Begin
    DrawAnsi(MrcTheme.HelpANSI1)
    Write('|PN')
    DrawAnsi(MrcTheme.HelpANSI2)
    Write('|PN')
    RedrawScreen
End

Procedure DoWelcome
Var Ch : Char = ''
Begin
    Write('|01')
    DrawAnsi(MrcTheme.WelcomeANSI)
    GotoXY(1,1)
    While Upper(Ch) <> 'E' Do
        Ch := ReadKey
End

Procedure DoWho
Begin
    Write('|16|11')
    MenuCmd('NW','')
    RedrawScreen
End

Procedure ChangeTopic(S:String)
Var R : String = ''
Begin
    if Length(S) > 55 Then
        ShowError('Topic is limited to 55 chars max')
    Else Begin
        SendToServer('NEWTOPIC:'+MyRoom+':'+S)
        UpdateTopic
    End
End

Procedure DoDirectMsg(S:String)
Var M,U : String = ''
Var L   : Integer = 0
Begin
    U:=Upper(WordGet(2,S,' '))
    L:=Pos(U,Upper(S))
    L:=L+Length(U)+1
    M:='|15* |08(|15'+Plyr.Name+'|08/|14DirectMsg|08) |07'+Copy(S,L,Length(S)-L+1)
    SendToUser(U,M)
    Add2Chat(False, False, '|15* |08(|14DirectMsg|08->|15' + U + '|08) '+ GetPipe(CIdx) + Copy(S,L,Length(S)-L+1))
    ShowChat(0)

    ReplyTarget := U
End

Procedure DoBroadcast(S:String)
Var M : String = ''
Begin
    If Plyr.BroadcastShield = True Then
        Add2Chat(False, False, 'Cannot broadcast with broadcast shield enabled')
    Else
    Begin
        M:='|15* |08(|15'+Plyr.Name+'|08/|14Broadcast|08) |07'+Copy(S,4,Length(S)-3)
        SendToAll(M)
    End
End

Procedure DoMeAction(S:String)
Var R : String = ''
Begin
    R:=Copy(S,5,Length(S)-4)
    SendToRoom('|15* |13'+Plyr.Name+' ' + R)
End

// Buffer history handling [sf]
Procedure AddToBufferHistory(B:String)
Var I : Byte = 0
Begin
    For I := 10 DownTo 2 Do
    Begin
        If Length(BufferHist[I-1]) > 0 Then
            BufferHist[I] := BufferHist[I-1]
    End
    BufferHist[2] := B
End

// Select next banner from the defined list [sf]
Procedure NextBanner
Begin
    Repeat
        BanIdx := BanIdx + 1
        If BanIdx > 20 Then BanIdx := 1
    Until Length(BannerList[BanIdx]) > 0
    ScrollWait := 0
    BannerOff := 0
End

// Display and scroll banners [sf]
Function ScrollBanner
Var BS: String = StripMCI(BannerList[BanIdx])
Begin
    // This is a scrolling banner

    // Add white padding for nice scroll entry/exit
    BS:=StrRep(' ', BannerLen) + BS + StrRep(' ', BannerLen)

    // Initial display before we start scrolling
    If ScrollWait = 0 Then
    Begin
        BS:=GetPipe(BBg)+GetPipe(BClr) + Copy(BS, 1, BannerLen-2) +
            GetPipe(BFad1) + Copy(BS, BannerLen-1, 1) +
            GetPipe(BFad2) + Copy(BS, BannerLen, 1) + '|16'
        BannerOff := BannerOff + 1
        GoToXy(BannerX, BannerY)
        Write(BS)
        GoToXy(HeartBeatX, HeartBeatY)
    End

    // We have made it to the end
    If BannerOff > Length(BS) - BannerLen Then
    Begin
        BS:=GetPipe(BBg)+GetPipe(BFad2) + Copy(BS, BannerOff, 1) +
            GetPipe(BFad1) + Copy(BS, BannerOff+1, 1) +
            GetPipe(BClr) + Copy(BS, BannerOff+2, BannerLen-2) + '|16'
        GoToXy(BannerX, BannerY)
        Write(BS)
        GoToXy(HeartBeatX, HeartBeatY)
        ScrollWait := 0
        NextBanner
    End

    // Let's start the scrolling shall we
    If ScrollWait > ScrollDly Then
    Begin
        BS:=GetPipe(BBg)+GetPipe(BFad2) + Copy(BS, BannerOff, 1) +
            GetPipe(BFad1) + Copy(BS, BannerOff+1, 1) +
            GetPipe(BClr)  + Copy(BS, BannerOff+2, BannerLen-4) +
            GetPipe(BFad1) + Copy(BS, BannerOff+BannerLen-2, 1) +
            GetPipe(BFad2) + Copy(BS, BannerOff+BannerLen-1, 1) + '|16'
        BannerOff := BannerOff + 1
        GoToXy(BannerX, BannerY)
        Write(BS)
        GoToXy(HeartBeatX, HeartBeatY)
    End

    // Not yet
    Else
    Begin
        ScrollWait := ScrollWait + 1
        GoToXy(HeartBeatX, HeartBeatY)
    End
End

// Buffer history seeker [sf]
Function GetBufferIndex(Idx:Byte;Dir:Integer) : Byte
Var NIdx: Byte = 0
Begin
    NIdx := Idx + Dir
    GetBufferIndex := Idx

    If NIdx > 1 and NIdx < 10 and Length(BufferHist[NIdx]) > 0 Then
        GetBufferIndex := NIdx

    If NIdx = 1 Then
        GetBufferIndex := NIdx
End

// Color Index seeker [sf]
Function GetColorIndex(Idx:Byte;Dir:Integer) : Byte
Var MIdx: Byte = 0
Begin
    MIdx := Idx + Dir

    // Span from Blue...
    If MIdx < 1 Then
        MIdx := 1

    // ... to Bright White
    If MIdx > 15 Then
        MIdx := 15

    GetColorIndex := MIdx
End

Procedure DoScrollBack(F:String;V:String)
Var F1          : File
Var L,T,SB,I    : Integer = 0
Var P,Y,X,CL,R  : Byte
Var S           : String  = ''
Var Done        : Boolean = False
Var SBackLines  : Array [1..60] of String[255]
Var Ch          : Char
Var SBM,SBT     : String = ''
Begin
    If Not FileExist(F) Then Begin
        Add2Chat(False, False, '* |14No content in this buffer yet')
        ShowChat(0)
    End
    Else
    Begin
        fAssign(F1,F,66)
        fReset(F1)
        L:=0
        // Count the total number of lines
        While Not fEof(F1) Do Begin
            fReadLn(F1,S)
            L:=L+1
        End
        T:=L
        L:=0

        // Load the scrollback 1 screen height back
        If T > WinSize + 1 Then
            SB := T - WinSize - (WinSize - 1)   // How much lines to skip

        If SB < 1 Then
            SB := 1

        // Create the tool bar
        If TsX > 130 Then
            SBM := '|16|08[|15Up|08] |07Move Up   |08[|15Dn|08] |07Move Down   |08[|15PgUp|08] |07Page Up   |08[|15PgDn|08] |07Page Down   |08[|15Esc|08/|15Q|08] |07Exit|07'
        Else
            SBM := '|16|08[|15Up|08] [|15Dn|08] [|15PgUp|08] [|15PgDn|08] [|15Esc|08/|15Q|08]|07'

        SBT := '|18|15 ' + V + ' |16|07'

        GotoXy(PromptX,PromptY)
        Write('|16' + StrRep(' ', PromptL+1) + '|11')

        GotoXy(PromptX + (PromptL-Length(StripMCI(SBM)))/2, PromptY)
        Write(SBM)

        GotoXy(PromptX + 1, PromptY)
        Write(SBT)

        GotoXy(PromptX + PromptL - Length(StripMCI(SBT)), PromptY)
        Write(SBT)


        // Loop will go here
        Repeat

            // Load the lines into buffer
            fReset(F1)
            L:=0
            R:=0
            For X:=1 To CLBuffer Do SBackLines[X] := ''
            While Not fEof(F1) Do Begin
                fReadLn(F1,S)
                L:=L+1
                if L >= SB and R <= WinSize Then Begin
                    For X:=2 To CLBuffer Do
                        SBackLines[X-1]:=SBackLines[X]
                    SBackLines[CLBuffer]:='|16'+S
                    R:=R+1
                End
            End

            // Print the buffer to screen
            Y:=CLBuffer-WinSize
            Write('|08')
            For X:=1 To WinSize+1 Do Begin
                CL := Length(StripMCI(SBackLines[Y]))
                GoToXy(WinTL,WinTT+X-1)
                Write(SBackLines[Y] + '|16' + StrRep(' ', ChatWidth-CL-1))
                Write('|16')
                Y:=Y+1
            End

            // Print the scrollbar
            If L-Winsize+1 > 0 Then
                P := (Winsize+1) * SB / (L-Winsize+1)

            If P < 0 Then P := 0

            For X:=1 To WinSize+1 Do Begin
                GoToXy(WinTL+ChatWidth-1,WinTT+X-1)
                if P = X-1 Then
                    WriteXY(WinTL+ChatWidth-1, WinTT+X-1, 7, Chr(178))
                Else
                    WriteXY(WinTL+ChatWidth-1, WinTT+X-1, 8, Chr(176))

            End

            // Idle timeout reset in scrollback
            I:=0

            // Non-blocking loop for core functions
            While Not Keypressed and I < 30000 Do
            Begin

                Delay(10)

                // 5 minutes idle timeout on scrollback
                I:=I+1
                If Not I < 30000 Then Begin
                    StuffKey('Q')
                    Done := True
                End

                If Loop % 7 = 0 Then
                    ReadChatFiles(False)

                If Loop % 11987 = 0 Then Begin
                    SendToServer('IAMHERE')
                End

                // Read chatroom userlist [sf]
                If Loop % 1999 = 0 Then
                    SendToServer('USERLIST')

                // Also re-read banners from server and add new ones
                If Loop > 47948 Then Begin
                    SendToServer('BANNERS')
                    Loop:=1
                End

                If Loop % ScrollSpeed = 0 and ScrollDisable = False Then
                    ScrollBanner

                If Loop % 499 = 0 Then
                    CheckStale

                If Loop % 997 = 0 Then
                Begin
                    If HBClr = HeartbeatGood Then
                        SendToClient('LATENCY')
                End

                // Animate the heartbeat animation every 199 cycles [sf]
                If Loop % 199 = 0 and HeartbeatDisable = False Then
                Begin
                    Anim := Anim + 1
                    If Anim > Length(HeartBeat) Then
                        Anim := 1
                    WriteXY(HeartBeatX, HeartBeatY, HBClr, Copy(HeartBeat, Anim, 1))
                    GoToXy(HeartBeatX, HeartBeatY)
                End

                If Loop > 47948 Then
                    Loop:=1

                Loop:=Loop+1
            End

            // Check for page keys
            AllowArrow := True
            Ch := ReadKey

            // Scrollback handling [sf]
            If IsArrow Then
            Begin
                Case Ch Of
                    Chr(72) : SB := SB - 1            // Up
                    Chr(80) : SB := SB + 1            // Dn
                    Chr(73) : SB := SB - Winsize + 1  // PgUp
                    Chr(81) : SB := SB + Winsize - 1  // PgDn
                    Chr(71) : SB := 1                 // Home
                    Chr(79) : SB := L - WinSize       // End
                End
                Ch := Chr(0)
            End

            // Exit
            if Ch = Chr(27) or Upper(Ch) = 'Q' Then
                Done := True

            // Upper Boundary
            If SB < 1 Then
                SB := 1

            // Lower Boundary
            If SB > L - WinSize Then
                SB := L - WinSize

        Until Done
        fClose(F1)

        RefreshChat := True
        ReadChatFiles(True)
        ShowChat(0)
    End
End

// Inputbar function
Function InputLine:String
Var IX,UL : Integer = 0
Var Ch    : Char    = #13
Var IBuf  : String  = ''    // Input buffer [sf]
Var DBuf  : String  = ''    // Displayed buffer [sf]
Var MBuf  : String  = ''
Var RBuf  : Boolean = False // Refresh buffer flag [sf]
Var Done  : Boolean = False // Done getting input (Enter) [sf]
Var BIdx  : Byte    = 1     // Buffer Current Idx [sf]
Var NIdx  : Byte    = 1     // Buffer Target Idx [sf]
Var CClr  : Byte    = 7     // Char counter color [sf]
Var InpL  : Byte            // Input bar length
Var FarX  : Byte
Var Mask  : Byte
Var WW    : Byte
Var I     : Integer
Var Words : String  = ''
Var LastW : String  = ''
Var PrefixLen : Byte = 0
Begin
    UL:=Length(StripMCI(MyNamePrompt))
    IX:=PromptX+Length(StripMCI(MyNamePrompt))

    // Derive the maximum allowed buffer based on packet fields
    PrefixLen := Length(UserTag) + Length(SiteTag) + Length(MyRoom)*2 + Length(MyNamePrompt) + 20

    // Init the characters counter [sf]
    WriteXY(CounterX1, CounterY1, 7, PadLt(Int2Str(Length(IBuf)), 3, '0'))
    WriteXY(CounterX2, CounterY2, 7, PadLt(Int2Str(IMaxBuffer), 3, '0'))

    // Init the buffer input bar [sf]
    GoToXy(PromptX,PromptY)

    CIdx := Plyr.PromptColor

    If ReplyTarget <> '' Then
    Begin
        IBuf := '/t ' + ReplyTarget
        StuffKey(' ')
    End

    InpL := PromptL - Length(StripMCI(MyNamePrompt))
    FarX := PromptX + PromptL + 1

    Write('|16' + MyNamePrompt + InputClr + GetPipe(CIdx) + DBuf + CursorBg + Cursor + InputClr +
        StrRep(InputBg,InpL))

    If HeartbeatDisable = False Then Begin
        WriteXY(HeartBeatX, HeartBeatY, HBClr, Copy(HeartBeat, Anim, 1))
        GoToXy(HeartBeatX, HeartBeatY)
    End

    Repeat
        While (Not Keypressed and ReplyTarget = '') Do
        Begin
            // Improved polling time to keyboard [sf]
            Delay(10)

            // Read chat files every 7 cycles [sf]
            // Slightly improve file access rate
            If Loop % 29 = 0 Then
                ReadChatFiles(True)

            // Read chatroom userlist [sf]
            If Loop % 1999 = 0 Then
                SendToServer('USERLIST')

            // Heartbeat to server every 12000 cycles
            // Maintain server heartbeat rate
            If Loop % 11987 = 0 Then Begin
                SendToServer('IAMHERE')
            End

            // Also re-read banners from server and add new ones
            If Loop > 47948 Then Begin
                SendToServer('BANNERS')
                Loop:=1
            End

            If Loop % ScrollSpeed = 0 and ScrollDisable = False Then
                ScrollBanner

            If Loop % 499 = 0 Then
                CheckStale

            If Loop % 997 = 0 Then
            Begin
                If HBClr = HeartbeatGood Then
                    SendToClient('LATENCY')
            End

            // Animate the heartbeat animation every 199 cycles [sf]
            If Loop % 199 = 0 and HeartbeatDisable = False Then
            Begin
                Anim := Anim + 1
                If Anim > Length(HeartBeat) Then
                    Anim := 1
                WriteXY(HeartBeatX, HeartBeatY, HBClr, Copy(HeartBeat, Anim, 1))
                GoToXy(HeartBeatX, HeartBeatY)
            End

            Loop:=Loop+1
        End

        // Handle arrow keys [sf]
        AllowArrow := True
        Ch := ReadKey

        // Buffer history handling [sf]
        If IsArrow Then
        Begin
            Case Ch Of
                Chr(72) : NIdx := GetBufferIndex(BIdx, 1)   // Scroll back input (Up)
                Chr(80) : NIdx := GetBufferIndex(BIdx, -1)  // Scroll forward input (Dn)
                Chr(75) : TIdx := GetColorIndex(CIdx, -1)   // Decrease color index (Left)
                Chr(77) : TIdx := GetColorIndex(CIdx, 1)    // Increase color index (Right)

                Chr(73) : Begin // PgUp
                    DoScrollBack(ChatLog, 'Chat History')  // Enter scrollback mode on PgUp
                    RBuf := True
                End

                Chr(83) : Begin // Del key
                    DoScrollBack(MentionLog, 'Chat Mentions')
                    MentionCount:=0
                    RBuf := True
                    UpdateRoom
                    UpdateTopic
                    UpdateLatency
                    UpdateChatters
                    UpdateMentions
                End

            Else
                NIdx := BIdx
                TIdx := CIdx
            End

            Ch := Chr(0)

            If BIdx <> NIdx Then
            Begin
                IBuf := BufferHist[NIdx]
                BIdx := NIdx
                RBuf := True
            End
            Else

            If CIdx <> TIdx Then
            Begin
                CIdx := TIdx
                RBuf := True
                Plyr.PromptColor := CIdx
            End
        End

        // PIPE codes whitelist [sf]
        If Copy(IBuf, Length(IBuf), 1) = '|' Then
        Begin
            Case Ch Of
                '0',
                '1',
                '2',
                '3',
                '|',
                Chr(32),
                Chr(8),
                Chr(27)    : Ch := Ch
            Else
                Ch := Chr(0)
            End
        End

        If Ch = Chr(32) and Length(IBuf) < 1 Then
            Ch := Chr(0)

        // Nick auto-completion [sf]
        If Ch = Chr(9) Then
        Begin
            Var WC : Byte   = WordCount(IBuf, ' ')    // Count of words in buffer
            Var LW : String = WordGet(WC, IBuf, ' ')  // Last word in buffer
            Var WL : Byte   = Length(LW)              // Length of the last word in buffer

            // Define display if at the beginning or mid-sentence
            Var Tail : String = ''
            If WC < 2 Then
                Tail := ': '
            Else
                Tail := ' '

            If LastUSearch = ''  Then
                LastUSearch := LW

            If WL > 0 and Length(RoomUsers) > 0 Then
            Begin
                Var PF :String = Copy(IBuf, 1, WordPos(WC, IBuf, ' ')-1)  // Buffer prefix
                Var UMatch : Boolean = False
                Var SLoop  : Byte = 0

                While Not UMatch Do
                Begin
                    If UserIdx > WordCount(RoomUsers, ',') Then UserIdx := 1
                    Var UHandle : String = WordGet(UserIdx, RoomUsers, ',')
                    If Length(UHandle) > 0 and
                         Upper(LastUSearch) = Upper(Copy(UHandle, 1, Length(LastUSearch))) Then
                    Begin
                        UMatch := True
                        IBuf := PF + UHandle + Tail
                    End
                    UserIdx:=UserIdx+1
                    SLoop:=SLoop+1
                    If SLoop > WordCount(RoomUsers, ',') Then UMatch := True
                End
            End
        End
        Else
        Begin
            LastUSearch := ''
            UserIdx     := 1
        End

        IMaxBuffer := 255 - PrefixLen
        If IMaxBuffer > MaxBuffer Then IMaxBuffer := MaxBuffer

        // Send to server and add to buffer history [sf]
        If Ch = Chr(13) Then
        Begin
            InputLine := IBuf

            AddToBufferHistory(IBuf)
            IBuf := ''
            BIdx := 1
            IMaxBuffer := MaxBuffer
            WriteXY(CounterX1, CounterY1, 7, PadLt(Int2Str(Length(IBuf)), 3, '0'))
            WriteXY(CounterX2, CounterY2, 7, PadLt(Int2Str(IMaxBuffer), 3, '0'))

            Done := True
        End
        Else

        // Clear input buffer with ESC [sf]
        If Ch = Chr(27) Then
        Begin
            IBuf := ''
            BIdx := 1
            ReplyTarget := ''
            RBuf := True
        End
        Else
        Begin
            // Handle backspace [sf]
            If Ch = Chr(8) Then
            Begin
                Delete (IBuf, Length(IBuf), 1)
                RBuf := True
            End
            Else

            // Allow characters between #32 and #126 only [sf]
            Begin
                If Ord(Ch) > 31 and Ord(Ch) < 127 Then
                Begin
                    // Limit input buffer length [sf]
                    If Length(IBuf) < IMaxBuffer Then
                    Begin
                        IBuf := IBuf + Ch
                        RBuf := True
                    End
                End

                // Ignore any other character [sf]
                Else
                    Ch := ''
            End
        End

        if Upper(Copy(IBuf,1,3)) = '/R ' and LastDirectMsg <> '' Then
            IBuf := '/t ' + LastDirectMsg + ' '

        // Adjust message bar for direct messages [sf]
        if Upper(Copy(IBuf,1,3)) = '/T ' or Upper(Copy(IBuf,1,6)) = '/TELL ' or Upper(Copy(IBuf,1,5)) = '/MSG ' Then
        Begin
            DirectClr := '|16|20|15'
            InputClr  := DInputClr
            CursorBg  := DCursorBg
        End
        Else
        Begin
            DirectClr := ''
            InputClr  := RInputClr
            CursorBg  := RCursorBg
        End

        // Refresh buffer only if changed [sf]
        If RBuf Then
        Begin
            // Update input bar [sf]
            GoToXy(PromptX,PromptY)

            DBuf := IBuf

            // Password masking
            Mask := 0
            If WordCount(DBuf, ' ') > 1 Then
            Begin
                Case WordGet(1,Lower(DBuf),' ') Of
                    '/identify': Mask := 2
                    '/register': Mask := 2
                    '/roompass': Mask := 2
                    '/update':
                        If WordGet(2,Lower(DBuf),' ') = 'password' Then Mask := 3
                    '/roomconfig':
                        If WordGet(2,Lower(DBuf),' ') = 'password' Then Mask := 3
                End
            End

            If Mask > 0 Then
            Begin
                MBuf:=''
                For WW:=1 To WordCount(DBuf, ' ') Do
                Begin
                    If WW = Mask Then
                        MBuf := MBuf + ' ' + StrRep('*', Length(WordGet(WW,DBuf,' ')))
                    Else
                        MBuf := MBuf + ' ' + WordGet(WW,DBuf,' ')
                End
                If Copy(DBuf, Length(DBuf),1) = ' ' Then
                    MBuf := MBuf + ' '
                DBuf := StripL(MBuf, ' ')
            End

            // DirectMSG uppercase
            Mask := 0
            If WordCount(DBuf, ' ') > 1 Then
            Begin
                Case WordGet(1,Upper(DBuf),' ') Of
                    '/T','/TELL','/M','/MSG',
                    '/PM': Mask := 2
                End
            End

            If Mask > 0 Then
            Begin
                MBuf:=''
                For WW:=1 To WordCount(DBuf, ' ') Do
                Begin
                    If WW = Mask Then
                        MBuf := MBuf + ' ' + Upper(WordGet(WW,DBuf,' '))
                    Else
                        MBuf := MBuf + ' ' + WordGet(WW,DBuf,' ')
                End
                If Copy(DBuf, Length(DBuf),1) = ' ' Then
                    MBuf := MBuf + ' '
                DBuf := StripL(MBuf, ' ')
            End

            // Scroll input buffer [sf]
            If Length(StripMCI(IBuf)) > InpL Then
            Begin
                I:=Length(IBuf)-Length(StripMCI(IBuf))
                DBuf := Copy(DBuf, Length(IBuf) - InpL + 1, InpL + 1)
            End

            // Update input bar [sf]
            GoToXy(PromptX,PromptY)

            Write('|16' + MyNamePrompt + InputClr + GetPipe(CIdx) + DirectClr +
                DBuf + CursorBg + Cursor + InputClr)
            I := FarX - WhereX
            If I > 0 Then
                Write(StrRep(InputBg,I))
            Write('|16')

            // Handle counter color coding [sf]
            CClr := 7
            If Length(IBuf) > IMaxBuffer -20 Then
                CClr := 14
            If Length(IBuf) > IMaxBuffer -10 Then
                CClr := 12

            // Update characters counter [sf]
            WriteXY(CounterX1, CounterY1, CClr, PadLt(Int2Str(Length(IBuf)), 3, '0'))
            WriteXY(CounterX2, CounterY2, CClr, PadLt(Int2Str(IMaxBuffer), 3, '0'))
        End
        If ReplyTarget <> '' Then ReplyTarget:=''

        GoToXy(PromptX,PromptY)
    Until Done
End

// Clear screen
Procedure DoCls
Var X : Integer = 0
Begin
    For X:=1 To CLBuffer Do
        ChatLines[X]:=''
    RedrawScreen
End

Procedure ShowWelcome
Var BS  : String[3] = 'OFF'
Var TL  : String[3] = 'NO'
Var TF  : String[3] = 'ON'
Var HBC : String[1] = ''
Begin
    // Welcome info text [sf]
    HBC:= Copy(Heartbeat,1,1)

    Add2Chat(False, False, '* |10Welcome to ' + MRCVersion)
    Add2Chat(False, False, '* |15ESC|10 to clear input bar, |15UP|10/|15DN|10 for buffer history, |15/Q |10to quit')
    Add2Chat(False, False, '* |15LEFT|10/|15RIGHT|10 to change chat text color and |15TAB|10 for nick completion')
    Add2Chat(False, False, '* |10The bottom right heartbeat (|15' + HBC + '|10) shows your status with BBS and server')
    Add2Chat(False, False, '* |10Make sure to check |15/CHANGES |10for a list of new features and changes')
    Add2Chat(False, False, '* |10Your maximum message length is |15' + Int2Str(IMaxBuffer)+ '|10 chars and terminal size is |15' + Int2Str(TsX) + '|10x|15' + Int2Str(TsY))

    // Check if we have anything in the twit list
    If WordCount(Plyr.TwitList,' ') > 0 Then
        TL := Int2Str(WordCount(Plyr.TwitList,' '))

    // Check the status of broadcast shield
    If Plyr.BroadcastShield = True Then
        BS:='ON'

    // Check the status of twit filter
    If Plyr.TwitFilter = True Then
        TF:='ON'

    // Report status on connect
    Add2Chat(False, False, '* |14Broadcast Shield is |15' + BS + '|14, Twit Filter is |15' + TF + '|14 and contains |15' + TL + ' |14user(s)')
    ShowChat(0)
End

Procedure ShowChanges
Begin
    // Changes info text [sf]
    Add2Chat(False, False, '* |15List of changes since MRC Client v1.2.9a')
    Add2Chat(False, False, '* |10- Direct message shows input bar in |20|15 RED |16 |10when writing')
    Add2Chat(False, False, '* |10- Larger terminal size support via ANSI auto-detect')
    Add2Chat(False, False, '* |10- Non-blocking chat and mentions log scrollback buffer')
    Add2Chat(False, False, '* |10- |15/QUOTE |10command no longer required for server commands (|15/HELP|10)')
    Add2Chat(False, False, '* |10- User configurable Broadcast Shield (|15/SET SHIELD|10)')
    Add2Chat(False, False, '* |10- User configurable Twit Filter (|15/TWIT |10and |15/SET TWITFILTER|10)')
    Add2Chat(False, False, '* |10- User configurable Scrolling Banner toggle (|15/SET SCROLLER|10)')
    Add2Chat(False, False, '* |10- Change in HotKeys (Colors, Scrollback, Mentions, etc) (|15/?|10)')
    Add2Chat(False, False, '* |10- Stay in DirectMSG mode when replying (|15/R|10) until you hit |10ESC')
    Add2Chat(False, False, '* |10- CTCP initial support (|15/CTCP|10 to send raw requests)')
    Add2Chat(False, False, '* |10- User selectable themes available (|15/THEME|10)')
    ShowChat(0)
End

Procedure ShowHelpCTCP
Var B : Boolean
Begin
    B:=Plyr.UseClock
    Plyr.UseClock:=False
    Add2Chat(False, False, ' |14CTCP commands overview')
    Add2Chat(False, False, '')
    Add2Chat(False, False, ' |15/CTCP |10[target] |11[command]|07')
    Add2Chat(False, False, '')
    Add2Chat(False, False, ' |10[target] |07can be:')
    Add2Chat(False, False, '   |15*          |07Everything')
    Add2Chat(False, False, '   |15user       |07A specific user name')
    Add2Chat(False, False, '   |15#room      |07A specific room')
    Add2Chat(False, False, '')
    Add2Chat(False, False, ' |11[command] |07can be:')
    Add2Chat(False, False, '   |15VERSION    |07Client version')
    Add2Chat(False, False, '   |15TIME       |07Client time (most likely the BBS)')
    Add2Chat(False, False, '   |15PING       |07Ping request')
    Add2Chat(False, False, '   |15CLIENTINFO |07Client supported commands')
    ShowChat(0)
    Plyr.UseClock:=B
End

Procedure EnterChat
Begin
    ShowWelcome   // Show welcome text [sf]

    Add2Chat(False, False, UpdateStrings(Plyr.EnterChatMe,Plyr.Name,'',MyRoom,MyRoom))
    SendToAllNotMe(UpdateStrings(Plyr.EnterChatRoom,Plyr.Name,'',MyRoom,MyRoom))

    Delay(20)
    SendToServer('IAMHERE')

    Delay(20)
    SendToServer('TERMSIZE:' + Int2Str(TermX) + 'x' + Int2Str(TermY))

    Delay(20)
    SendToServer('BBSMETA: SecLevel(' + SecLevel + ') SysOp(' + SysOp + ')')

    If UserIp <> '' Then Begin
        Delay(20)
        SendToServer('USERIP:' + UserIP)
    End

    Delay(20)
    SendToServer('BANNERS')

    ShowChat(0)
End

Procedure LeaveChat
Var Str1    : String = ''
Begin
    SavePlyr(Plyr.RecIdx) // Save the User record
    Add2Chat(False, False, UpdateStrings(Plyr.LeaveChatMe,Plyr.Name,'',MyRoom,MyRoom))
    SendToAllNotMe(UpdateStrings(Plyr.LeaveChatRoom,Plyr.Name,'',MyRoom,MyRoom))
    ShowChat(0)
    Delay(500)
    SendToServer('LOGOFF');
    ShowChat(0)
End

Procedure DoSetList
Var R,S,BS,SC,TF,CQ : String = ''
Var B               : Boolean = False
Begin
    S:='False'
    If Plyr.UseClock Then
        S:='True'

    BS:='False'
    If Plyr.BroadcastShield = True Then
        BS:='True'

    SC:='False'
    If Plyr.ShowScroller = True Then
        SC:='True'

    TF:='False'
    If Plyr.TwitFilter = True Then
        TF:='True'

    CQ:='False'
    If Plyr.HideCTCPReq = True Then
        CQ:='True'

    R:='12Hour (HH:MMa or HHMMp)'
    If Not Plyr.ClockFormat Then
        R:='24Hour (HH:MM)'

    B:=Plyr.UseClock
    Plyr.UseClock:=False
    Add2Chat(False, False, ' |11List of current |15/SET |11values from your account')
    Add2Chat(False, False, ' |15ENTERCHATME    |08:|11 '+Plyr.EnterChatMe)
    Add2Chat(False, False, ' |15ENTERCHATROOM  |08:|11 '+Plyr.EnterChatRoom)
    Add2Chat(False, False, ' |15ENTERROOMME    |08:|11 '+Plyr.EnterRoomMe)
    Add2Chat(False, False, ' |15ENTERROOMROOM  |08:|11 '+Plyr.EnterRoomRoom)
    Add2Chat(False, False, ' |15LEAVECHATME    |08:|11 '+Plyr.LeaveChatMe)
    Add2Chat(False, False, ' |15LEAVECHATROOM  |08:|11 '+Plyr.LeaveChatRoom)
    Add2Chat(False, False, ' |15LEAVEROOMME    |08:|11 '+Plyr.LeaveRoomMe)
    Add2Chat(False, False, ' |15LEAVEROOMROOM  |08:|11 '+Plyr.LeaveRoomRoom)
    Add2Chat(False, False, ' |15DEFAULTROOM    |08:|11 '+Plyr.DefaultRoom)
    Add2Chat(False, False, ' |15NICKCOLOR      |08:|11 '+Plyr.NameColor+Plyr.Name)
    Add2Chat(False, False, ' |15LTBRACKET      |08:|11 '+Plyr.LtBracket)
    Add2Chat(False, False, ' |15RTBRACKET      |08:|11 '+Plyr.RtBracket)
    Add2Chat(False, False, ' |15SHIELD         |08:|11 '+BS)
    Add2Chat(False, False, ' |15SCROLLER       |08:|11 '+SC)
    Add2Chat(False, False, ' |15TWITFILTER     |08:|11 '+TF)
    Add2Chat(False, False, ' |15HIDECTCPREQ    |08:|11 '+CQ)
    Add2Chat(False, False, ' |15USECLOCK       |08:|11 '+S)
    Add2Chat(False, False, ' |15CLOCKFORMAT    |08:|11 '+R)
    ShowChat(0)
    Plyr.UseClock:=B
End

Procedure DoSetHelp
Var B    : Boolean = False
Begin
    B:=Plyr.UseClock
    Plyr.UseClock:=False
    Add2Chat(False, False, ' |15/SET |08<|03tag|08> <|03text|08>')
    Add2Chat(False, False, ' |11Use |15SET |11to set various fields to your account')
    Add2Chat(False, False, ' |15ENTERCHATME     |03Displayed to |11me |03when I enter chat.')
    Add2Chat(False, False, ' |15ENTERCHATROOM   |03Displayed to |11room |03when I enter chat.')
    Add2Chat(False, False, ' |15ENTERROOMME     |03Displayed to |11me |03when I enter room.' )
    Add2Chat(False, False, ' |15ENTERROOMROOM   |03Displayed to |11room |03when I enter room.' )
    Add2Chat(False, False, ' |15LEAVECHATME     |03Displayed to |11me |03when I leave chat.' )
    Add2Chat(False, False, ' |15LEAVECHATROOM   |03Displayed to |11room |03when I leave chat.' )
    Add2Chat(False, False, ' |15LEAVEROOMME     |03Displayed to |11me |03when I leave room.')
    Add2Chat(False, False, ' |15LEAVEROOMROOM   |03Displayed to |11room |03when I leave room.')
    Add2Chat(False, False, ' |15DEFAULTROOM     |03Join this room when you join chat.')
    Add2Chat(False, False, ' |15NICKCOLOR       |03Change my nickname color |11(MCI Pipe codes).' )
    Add2Chat(False, False, ' |15LTBRACKET       |03Change my left bracket / color |11(MCI Pipe codes).' )
    Add2Chat(False, False, ' |15RTBRACKET       |03Change my right bracket / color |11(MCI Pipe codes).' )
    Add2Chat(False, False, ' |15SHIELD          |03(|15Y|03/|15N|03) Shield you from |11Broadcast Messages |14*')
    Add2Chat(False, False, ' |15SCROLLER        |03(|15Y|03/|15N|03) Display the |11Scrolling Banner |14*')
    Add2Chat(False, False, ' |15TWITFILTER      |03(|15Y|03/|15N|03) Enable your |11Twit Filter |14*')
    Add2Chat(False, False, ' |15HIDECTCPREQ     |03(|15Y|03/|15N|03) Hide received |11CTCP requests |14*')
    Add2Chat(False, False, ' |15USECLOCK        |03(|15Y|03/|15N|03) Use timestamp in chat')
    Add2Chat(False, False, ' |15CLOCKFORMAT     |1112 |03or |1124 |03hour clock format')
    Add2Chat(False, False, ' |10LIST            |03List all fields and their status')
    Add2Chat(False, False, ' |15HELP            |03This helps message')
    ShowChat(0)
    Plyr.UseClock:=B
End

Procedure ChangeClock(T:Integer;S:String)
Begin
    S:=StripB(Upper(S),' ')
    Case T Of
        1: Begin
            If Pos('YE',S) > 0 Or Pos('TR',S) > 0 Then Begin
                Plyr.UseClock:=True
                Add2Chat(False, False, '|11CLOCKFORMAT   |08: |15True')
            End Else Begin
                If Pos('NO',S) > 0 Or Pos('FA',S) > 0 Then Begin
                    Plyr.UseClock:=False
                    Add2Chat(False, False, '* |11CLOCKFORMAT   |08: |15False')
                End Else
                    Add2Chat(False, False, '* |11Usage: |15/SET USECLOCK YES||TRUE|08 or |15/SET USECLOCK NO||FALSE')
            End
        End
        2: Begin
            If S = '12' Then Begin
                Plyr.ClockFormat:=True
                Add2Chat(False, False, '|07CLOCKFORMAT   |08: |0712 hour')
            End Else Begin
                If S = '24' Then Begin
                    Plyr.ClockFormat:=False
                    Add2Chat(False, False, '* |11CLOCKFORMAT   |08: |0724 hour')
                End Else
                    Add2Chat(False, False, '* |11Usage: |08"|03/SET CLOCKFORMAT 12|08" or "|03/SET CLOCKFORMAT 24|08"')
            End
         End
    End
    SavePlyr(Plyr.RecIdx)
    ShowChat(0)
End

// Set Broadcast shield
Procedure BroadcastShield(S:String)
Begin
    S:=StripB(Upper(S),' ')
    Case Upper(Copy(S,1,1)) Of
        'Y': Begin
            Plyr.BroadcastShield:=True
            SavePlyr(Plyr.RecIdx)
            Add2Chat(False, False, '* |10Broadcast Shield |15ENABLED|10. You will no longer receive broadcasts.')
            End

        'N': Begin
            Plyr.BroadcastShield:=False
            SavePlyr(Plyr.RecIdx)
            Add2Chat(False, False, '* |10Broadcast Shield |15DISABLED|10. You will now receive broadcasts.')
            End

        Else
            Add2Chat(False, False, '* |12Invalid parameter')
    End
    ShowChat(0)
End

// Set Scrolling banner status
Procedure ShowScroller(S:String)
Begin
    S:=StripB(Upper(S),' ')
    Case Upper(Copy(S,1,1)) Of
        'Y': Begin
            if BannerLen > 0 Then Begin
                Plyr.ShowScroller:=True
                SavePlyr(Plyr.RecIdx)
                ScrollDisable:=False
            End
            Else
                Add2Chat(False, False, '* |12Scroller disabled by theme')
        End

        'N': Begin
            Plyr.ShowScroller:=False
            SavePlyr(Plyr.RecIdx)
            ScrollDisable:=True
            GotoXy(BannerX,BannerY)
            Write(StrRep(' ', BannerLen))
        End
    Else
        Add2Chat(False, False, '* |12Invalid parameter')
    End
    ShowChat(0)
End

// Set Twit filter
Procedure TwitFilter(S:String)
Begin
    S:=StripB(Upper(S),' ')
    Case Upper(Copy(S,1,1)) Of
        'Y': Begin
            Plyr.TwitFilter:=True
            SavePlyr(Plyr.RecIdx)
            Add2Chat(False, False, '* |10Twit Filter |15ENABLED|10. Any user in your Twit List will be filtered.')
            End

        'N': Begin
            Plyr.TwitFilter:=False
            SavePlyr(Plyr.RecIdx)
            Add2Chat(False, False, '* |10Twit Filter |15DISABLED|10. You will now receive message from all users.')
            End

        Else
            Add2Chat(False, False, '* |12Invalid parameter')
    End
    SavePlyr(Plyr.RecIdx)
    ShowChat(0)
End

// Hide CTCP requests
Procedure HideCTCPReq(S:String)
Begin
    S:=StripB(Upper(S),' ')
    Case Upper(Copy(S,1,1)) Of
        'Y': Begin
            Plyr.HideCTCPReq:=True
            SavePlyr(Plyr.RecIdx)
            Add2Chat(False, False, '* |10CTCP requests are now |15HIDDEN|10. Incoming CTCP requests will not be shown.')
            End

        'N': Begin
            Plyr.HideCTCPReq:=False
            SavePlyr(Plyr.RecIdx)
            Add2Chat(False, False, '* |10CTCP requests are now |15VISIBLE|10. Incoming CTCP requests will be shown.')
            End

        Else
            Add2Chat(False, False, '* |12Invalid parameter')
    End
    ShowChat(0)
End

Procedure DoSet(Line:String)
Var Tag,Txt : String = ''
Var P       : Integer = 0
Begin
    Tag:=WordGet(1,Line,' ')
    P:=Length(Tag)+1
    Delete(Line,1,P)
    StripB(line,' ')

    Case Upper(Tag) Of
        'HELP': DoSetHelp
        'LIST': DoSetList
        'ENTERCHATME'     : Plyr.EnterChatMe:=Line
        'ENTERCHATROOM'   : Plyr.EnterChatRoom:=Line
        'ENTERROOMME'     : Plyr.EnterRoomMe:=Line
        'ENTERROOMROOM'   : Plyr.EnterRoomRoom:=Line
        'LEAVECHATME'     : Plyr.LeaveChatMe:=Line
        'LEAVECHATROOM'   : Plyr.LeaveChatRoom:=Line
        'LEAVEROOMME'     : Plyr.LeaveRoomMe:=Line
        'LEAVEROOMROOM'   : Plyr.LeaveRoomRoom:=Line
        'DEFAULTROOM'     :
            Begin
                Plyr.DefaultRoom:=Line
                Add2Chat(False, False, '|07* |10Default room set to |15'+Line)
                ShowChat(0)
            End
        'NICKCOLOR'       : ChangeNick('C',Line,False)
        'LTBRACKET'       : ChangeNick('L',Line,False)
        'RTBRACKET'       : ChangeNick('R',Line,False)
        'SHIELD'          : BroadcastShield(Line)
        'SCROLLER'        : ShowScroller(Line)
        'TWITFILTER'      : TwitFilter(Line)
        'HIDECTCPREQ'     : HideCTCPReq(Line)
        'USECLOCK'        : ChangeClock(1,Line)
        'CLOCKFORMAT'     : ChangeClock(2,Line)
        ''                : DoSetHelp
    End
    SavePlyr(Plyr.RecIdx)
End

Procedure DLChatLog
Var X,Y,TS,DS,TempChat : String = ''
Var fptr               : File
Begin
    DS:=Replace(DateStr(DateTime,1),'/','')
    TS:=Replace(TimeStr(DateTime,False),':','')
    TempChat:=CfgTempPath+'mrc_chat_'+Replace(SiteTag,' ','_')+'_'+DS+'_'+TS+'.log'
    Write('|16|11|CL')
    If InputYN('Strip MCI color codes? ') Then Begin
        fAssign(fptr,ChatLog,66)
        fReset(Fptr)
        While Not fEof(Fptr) Do Begin
            fReadLn(Fptr,X)
            Y:=StripMCI(X)
            AppendText(TempChat,Y)
        End
        fClose(Fptr)
    End Else
        FileCopy(ChatLog,TempChat)
    MenuCmd('F3',TempChat);
    FileErase(TempChat)
    RedrawScreen
End

Procedure Main
Var Done         : Boolean = False
Var RestOfLine   : String = ''
Var W1,W2,U,UIL  : String = ''
Var IL           : String = ''
Var CMD          : String = ''
Begin
    Loop:=1
    UpdateRoom
    UpdateTopic
    UpdateLatency
    UpdateChatters
    UpdateMentions
    Repeat
        Delay(10)
        IL:=InputLine

        // Support slash commands even if prefixed with a PIPE code
        If Pos('/',StripMCI(IL)) = 1 Then Begin
            W1:=Upper(WordGet(1,StripMCI(IL),' '))
            W2:=WordGet(2,IL,' ')
            RestOfLine:=IL
            Delete(RestOfLine,1,Length(W1))
            RestOfLine:=StripB(RestOfLine,' ')

            Case W1 Of
                // Server commands aliases
                // Everything else is sent as-is to the server
                '/BBSES'     : SendToServer('CONNECTED ' + RestOfLine)
                '/ROOMS'     : SendToServer('LIST')
                '/QUOTE'     : SendToServer(RestOfLine)

                // Local client commands
                '/CHANGES'   : ShowChanges  // Display changes [sf]
                '/?'         : DoHelp
                '/B'         : DoBroadcast(IL)
                '/CLS',
                '/CLEAR'     : DoCls
                '/DLCHATLOG' : DLChatLog
                '/JOIN'      : JoinRoom(W2,True)
                '/ME'        : DoMeAction(IL)
                '/SCROLL'    : DoScrollBack(ChatLog, 'Chat History')
                '/SET'       : DoSet(RestOfLine)
                '/TOPIC'     : ChangeTopic(RestOfLine)
                '/THEME'     : ChangeTheme(RestOfLine)
                '/T','/MSG','/M','/PM',
                '/TELL'      : DoDirectMsg(IL)
                '/WHO'       : DoWho
                '/TWIT'      : ManageTwit(RestOfLine)
                '/CTCP'      :
                    Begin
                        if W2 = '' Then
                            ShowHelpCTCP
                        Else Begin
                            U := W2
                            If U = '*' or Pos('#',U) = 1 Then
                                U := ''
                            SendToCTCP(U,'[CTCP]', RestOfLine)
                        End
                    End
                '/Q','/QUIT' :
                    Begin
                        LeaveChat
                        Done := True
                    End
                '/MENTIONS'  : Begin
                    DoScrollBack(MentionLog, 'Chat Mentions')
                    MentionCount:=0
                End
                '/WELCOME'   : Begin
                    DoWelcome
                    RedrawScreen
                End
                '/VERSION'   :
                    Begin
                        SendToServer('VERSION')
                        Add2Chat(False, False, '|07- |13'+MRCVersion)
                    End
            Else
            Begin
                CMD := Copy(StripMCI(IL), 2, Length(StripMCI(IL)) - 1)
                SendToServer(CMD)
            End
        End Else Begin
            If Length(IL) > 0 Then
            Begin
                IL:=Replace(IL, '~', ' ')
                SendToRoom(MyNamePrompt+GetPipe(CIdx)+IL)
            End
        End

        if Terminate = True Then
        Begin
            Delay(3000)
            SendToServer('LOGOFF');
            Delay(500)
            Done := True
        End
    Until Done
End

Begin
    CleanOut
    GetThisUser

    // Check if we toggle the NodeMsgFlag
    If ACS('OA') Then
    Begin
        NodeMsgFlag:=True
        MenuCmd('GE', '18')
    End

    // Increment Usage count
    Plyr.UsageCount := Plyr.UsageCount + 1
    SavePlyr(Plyr.RecIdx)

    Init
    UserIP := mci2str('UY')
    SecLevel := mci2str('SL')
    SysOp := mci2str('SN')

    If Plyr.ShowWelcome <> False Then Begin
        RedrawScreen
        DoWelcome
        Plyr.ShowWelcome := False
        SavePlyr(Plyr.RecIdx)
    End

    RedrawScreen
    EnterChat
    JoinRoom(Plyr.DefaultRoom,False)
    SendToClient('LATENCY')

    LoadBanners

    If ScrollDisable = False Then Begin
        NextBanner
        ScrollBanner
    End

    Main

    Write('|16|11|CL')

    // Reset the NodeMsgFlag if changed
    If NodeMsgFlag Then
        MenuCmd('GE', '18')

    CleanOut
    Halt

End
