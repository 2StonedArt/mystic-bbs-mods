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
// - minorVersion: 3                       -
// - author: Stackfault                    -
// - publisher: Phenom Productions         -
// - website: https://www.phenomprod.com   -
// - email: stackfault@bottomlessabyss.net -
// - bbs: bbs.bottomlessabyss.net:2023     -
// -----------------------------------------
//
// This tool convert an existing MRC user file from 1.2 to 1.3
//
// After compiling, execute the following from your BBS main directory:
// ./mystic -u{user} -p{password} -l -xconvert_users

Uses Cfg

// Define old user record structure (1.2)
Type OldUserRec   = Record
    RecIdx        : Integer
    PermIdx       : Integer
    EnterChatMe   : String[80]
    EnterChatRoom : String[80]
    EnterRoomMe   : String[80]
    EnterRoomRoom : String[80]
    LeaveChatMe   : String[80]
    LeaveChatRoom : String[80]
    LeaveRoomMe   : String[80]
    LeaveRoomRoom : String[80]
    Name          : String[80]
    DefaultRoom   : String[80]
    Temp1         : String[80]
    Temp5         : String[80]
    Temp6         : String[80]
    Temp7         : String[80]
    NameColor     : String[16]
    LtBracket     : String[16]
    RtBracket     : String[16]
    UseClock      : Boolean
    ClockFormat   : Boolean
End

// Define new user record structure (1.3)
Type NewUserRec     = Record
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
    ThemeName       : String[16]  // New
    TwitList        : String[255] // New
    PromptColor     : Byte        // New
    UsageCount      : Integer     // New
    BroadcastShield : Boolean     // New
    ShowScroller    : Boolean     // New
    TwitFilter      : Boolean     // New
    ShowWelcome     : Boolean     // New
    HideCTCPReq     : Boolean     // New
    UseClock        : Boolean
    ClockFormat     : Boolean
End

// Assign record structure, file pointer and file name
Var OldPlyr       : OldUserRec
Var OldFptr       : File
Var OldUserFile   : String = JustPath(Progname)+'mrcusers.dat'

Var NewPlyr       : NewUserRec
Var NewFptr       : File
Var NewUserFile   : String = CfgDataPath+'mrcusers_1_3.dat'

// Convert user file records
Procedure Convert
Var Done : Boolean = False
Var I    : Integer = 0
Begin
    fAssign(OldFptr,OldUserFile,66)
    fAssign(NewFptr,NewUserFile,66)

    fReset(OldFptr)
    fReset(NewFptr)

    WriteLn('Reading from: ' + OldUserFile)
    WriteLn('Writing to:   ' + NewUserFile)

    While Not Done Do
    Begin
        I:=I+1

        // Recreate a new file if record is 1
        // Leave the first record empty
        If I = 1 Then Begin
            fReWrite(NewFptr)
            fSeek(NewFptr,SizeOf(NewPlyr))
            I:=I+1
        End

        If Not fEof(Oldfptr) Then
        Begin

            fReadRec(OldFptr,OldPlyr)

            WriteLn('Writing user: ' + Int2Str(I) + ' ' + OldPlyr.Name)

            NewPlyr.RecIdx          := I
            NewPlyr.PermIdx         := OldPlyr.PermIdx
            NewPlyr.EnterChatMe     := OldPlyr.EnterChatMe
            NewPlyr.EnterChatRoom   := OldPlyr.EnterChatRoom
            NewPlyr.LeaveChatMe     := OldPlyr.LeaveChatMe
            NewPlyr.LeaveChatRoom   := OldPlyr.LeaveChatRoom
            NewPlyr.EnterRoomMe     := OldPlyr.EnterRoomMe
            NewPlyr.LeaveRoomRoom   := OldPlyr.LeaveRoomRoom
            NewPlyr.LeaveRoomMe     := OldPlyr.LeaveRoomMe
            NewPlyr.Name            := OldPlyr.Name
            NewPlyr.EnterRoomRoom   := OldPlyr.EnterRoomRoom
            NewPlyr.Defaultroom     := OldPlyr.Defaultroom
            NewPlyr.NameColor       := OldPlyr.NameColor
            NewPlyr.LtBracket       := OldPlyr.LtBracket
            NewPlyr.RtBracket       := OldPlyr.RtBracket
            NewPlyr.ThemeName       := 'original'
            NewPlyr.TwitList        := ''
            NewPlyr.PromptColor     := 7
            NewPlyr.UsageCount      := 0
            NewPlyr.BroadcastShield := False
            NewPlyr.ShowScroller    := True
            NewPlyr.TwitFilter      := True
            NewPlyr.ShowWelcome     := True
            NewPlyr.HideCTCPReq     := False
            NewPlyr.UseClock        := OldPlyr.UseClock
            NewPlyr.ClockFormat     := OldPlyr.ClockFormat

            fWriteRec(NewFptr,NewPlyr)
        End
        Else
            Done := True

    End
    fClose(NewFptr)
    fClose(OldFptr)
End

// Main block
Begin
    WriteLn('|CLStarting convert')
    Convert
    WriteLn('Conversion completed')
    WriteLn('|PA')
    Halt
End
