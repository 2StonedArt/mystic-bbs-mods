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
// - modName: mrcstatus bar sample         -
// - majorVersion: 1                       -
// - minorVersion: 1                       -
// - author: StackFault                    -
// - publisher: Phenom Productions         -
// - website: https://www.phenomprod.com   -
// - email: stackfault@bottomlessabyss.net -
// - bbs: bbs.bottomlessabyss.net:2023     -
// -----------------------------------------
//
// **********************************************************************
//         Sample applet for MRC stats to use in the BBS
// This is a bit more advanced and will require some modding knowledge
// **********************************************************************
//
// Displays the status of the server to the users and some other stats.
// Requires mrc_client.py v1.2.7
// 
// To display this applet in your menu:
// 1. Add a new menu entry to your desired menu.
// 2. Set Hotkey to 'AFTER' by pressing CTRL-L on the Hotkey field
// 3. Set your menu command to 'GX' and use 'mrc_stat2' as data
//
// Your new applet should now be shown on your menu screen.

Uses Cfg

Var SvrQueuePath  : String = CfgDataPath + 'mrc'  // Align with mrc_client.py config

// Location of each items
Var BarLocAttr    : String = '|[X32|[Y02|16'      // Location of Bar text
Var StateLocAttr  : String = '|[X36|[Y02|16'      // Location of State text
Var BBSesLocAttr  : String = '|[X49|[Y02|16|15'   // Location of BBSes count
Var RoomsLocAttr  : String = '|[X58|[Y02|16|15'   // Location of Rooms count
Var UsersLocAttr  : String = '|[X67|[Y02|16|15'   // Location of Users count
Var LevelLocAttr  : String = '|[X76|[Y02|16|15'   // Location of Activity Level

// Define the Bar look and text
Var BarText : String = '|15M|11RC|08[       ] ' +
                       '|15B|11BS|03|08[   ] ' +
                       '|15R|11ms|08[   ] ' +
                       '|15U|11sr|08[   ] ' +
                       '|15A|11ct|08[   ]|07'

// Activity Level Strings
Var ActivityBar : Array[1..4] of String[6]

// Look of the state text
Var Offline : String = '|12OFFLINE|16' // Text for offline status
Var Online  : String = '|10ON-LINE|16' // Text for online status

Var State                      : String  = Offline
Var BBSes, Rooms, Users, Level : Integer = 0
Begin
    Var F1:File
    Var F:String = SvrQueuePath + PathChar + 'mrcstats.dat' 
    Var L:String = ''

    // Activity Meter display
    // Now allows to display completely different string/level
    ActivityBar[1] := '|07NUL'  // No Activity
    ActivityBar[2] := '|14LOW'  // Low
    ActivityBar[3] := '|10MED'  // Moderate
    ActivityBar[4] := '|12HI '  // High

    // Read the stats file from mrc_client.py
    // Do not read if older than 120 seconds
    FindFirst(F, 66)
    If DirTime + 120 > DateTime Then
    Begin
        FAssign(F1, F, 66)
        FReset(F1)
        FReadLn (F1, L)
        FClose(F1)
    End
    FindClose

    // Fetch the stats from the file
    If Length(L) > 0 and WordCount(L, ' ') > 3 Then
    Begin
        BBSes := Str2Int(WordGet(1, L, ' '))
        Rooms := Str2Int(WordGet(2, L, ' '))
        Users := Str2Int(WordGet(3, L, ' '))
        Level := Str2Int(WordGet(4, L, ' '))
        If BBSes > 0 Then
            State := Online
    End

    // Draw the applet
    Write(BarLocAttr+BarText)
    Write(StateLocAttr+State)
    Write(BBSesLocAttr+PadCT(Int2Str(BBSes) ,3, ' '))
    Write(RoomsLocAttr+PadCT(Int2Str(Rooms), 3, ' '))
    Write(UsersLocAttr+PadCT(Int2Str(Users), 3, ' '))
    Write(LevelLocAttr+ActivityBar[Level+1])
    Write('|[X01|[Y24')
End

