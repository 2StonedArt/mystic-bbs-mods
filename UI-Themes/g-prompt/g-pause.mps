// ==========================================================================
//   File: G-PAUSE.MPS
//   Desc: Animated pause engine for Mystic BBS v2.0
// Author: g00r00
// ==========================================================================
//
// INSTALLATION:
//
//   1) Copy G-PAUSE.MPS into a directory
//      or the BBS scripts directory and compile it using MPLC or MIDE.
//   1a) Copy and the included ANIPAUSE.TX? files to /g-prompt folder in
//       scripts directory (added by opicron/thunderhawk)
//   2) Set your system pause prompt to execute this program, this is done
//      by loading MCFG -> Theme Editor -> Edit Prompts and changing prompt
//      #058 to look like this:
//
//        |!g-pause|              (if g-pause is in your scripts directory)
//        |!c:\mybbs\g-pause|     (if g-pause is in its own directory)
//
// PROMPT FILE NAMES:
//
//   The engine allows for up to 26 different animated prompts, which will
//   be selected at random for each pause prompt.  If you only want to have
//   one, keep only anipause.txt.  The engine excepts file names in the
//   format of anipause.tx? where ? is any letter from a to z, and follows
//   the following routine:
//
//      1) Searches for anipause.txt, if not found it shows an error.
//      2) Searches for anipause.txa
//      3) If anipause.txa exists, the engine then searches for all
//         anipause.tx? files and randomly picks one to use
//
// MAKING YOUR OWN PROMPTS:
//
//   Each .tx? file is a text file.  The first line is the delay time, which
//   is the amount of time the engine will delay after displaying each
//   frame of animation.  It is not recommended that you go much over 200
//   on this value as it will make your prompt seem sluggish.
//
//   The following lines are each one frame of animation.  Use the included
//   prompts as a guideline if you still need help and you should be good to
//   go.  There is a maximum of 100 frames of animation, and I think that
//   will easily be enough.
//
// LICENSE:
//
//   You are not permitted to modify this program and release it.  You are
//   not permitted to take any code and use it in another program which you
//   release without permission from g00r00.  You may make modifications to
//   this program for your own personal use.  If you feel you've made the
//   program better, contact me and I may include it in a future release. As
//   long as people abide to these rules, I will continue to release mods
//   and source code.
//
// HISTORY:
//
//   - 12/20/02: Version 1 released
//
//   - 07/10/2020: modded by opicron/thunderhawk
//      + added prompts
//      + fixed TimerStart to Timer
//      + fixed to check if no timeout set for board (else immediate hangup)
//      + added subfolder to PromptFilePath to avoid mixing files in scripts
//      + updated docs (above) with install sub folder
//      + updated docs (above) with |! for script instead of |DX
//      + replaced shutdown with CheckTimeOut
//      + removed SaveBuf / BufNoFlush
//      + added StuffKey to actually send an enter after pausing
//        this fixes issues when adding the script on the replacement |PA prompt
//      * todo: add shutdown check
//
// ==========================================================================
Uses
  CFG;

Const
  Version          = 1;                   // VERSION INFO
  PromptAsciiPause = '[Press any key]';   // FOR PEOPLE WITH NO ANSI
  MaxFrames        = 100;                 // MAX FRAMES PER FILE
  PromptFilePath   = 'g-prompt/';                  // .TX? SUB DIRECTORY

Var
  Count     : Byte;
  FileName  : String;
  FileExt   : String;
  SavedX    : Byte;
  SavedBuf  : Boolean;
  TimeStart : LongInt
  DelayTime : Integer
  Data      : Array[1..MaxFrames] of String;
  DataSize  : Byte;
  InFile    : File;

Procedure CheckTimeOut:boolean;
Begin
  If CfgTimeOut > 0 Then Begin
    If Timer - TimeStart > CfgTimeOut Then Begin
      WriteLn (GetPrompt(56));
      SysopLog ('Inactivity timeout');
      HangUp;
    End;
  End;
End;

Begin
  TimeStart := Timer;

  If Graphics = 0 Then Begin
    Write (PromptAsciiPause);
    Repeat
      CheckTimeOut;
      Delay(100);
    Until KeyPressed or CheckTimeOut;
    Halt;
  End;

  FileName   := JustPath(ProgName) + PromptFilePath + 'anipause.';
  FileExt    := 'txt';
  SavedX     := WhereX;

  If Not FileExist(FileName + FileExt) Then Begin
    WriteLn ('|CR|15ERROR: |07Animated pause data not found|PN');
    Halt;
  End;

  //SavedBuf   := BufNoFlush;
  //BufNoFlush := False;

  If FileExist(FileName + 'txa') Then
    Repeat
      FileExt := 'tx' + Chr(Random(26) + 1 + 96);
    Until FileExist(FileName + FileExt);

  fAssign (InFile, FileName + FileExt, 2);
  fReset  (InFile);
  fReadLn (InFile, Data[1]);

  DelayTime := str2int(Data[1]);
  Count     := 1;

  While Not fEof(InFile) And Count < MaxFrames Do Begin
    fReadLn (InFile, Data[Count]);
    Count := Count + 1;
  End;

  fClose (InFile);

  DataSize := Count - 1;
  Count    := 1;

  Repeat
    CheckTimeOut;

    GotoXY (SavedX, WhereY);
    Write  (Data[Count]);

    If Count = DataSize Then
      Count := 1
    Else
      Count := Count + 1;

    Delay (DelayTime);
  Until KeyPressed or CheckTimeOut;

  StuffKey (chr(13))
  //BufNoFlush := SavedBuf;
End.
