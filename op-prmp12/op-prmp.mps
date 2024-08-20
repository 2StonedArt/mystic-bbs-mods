// ==========================================================================
// File: OP-PRMP.MPS
// Desc: Animated Prompt v1.2 for Mystic BBS v1.12a46+
// Author: Opicron
// ==========================================================================
//
// WHY? WHEN THERE ARE SO MANY PROMPT SCRIPTS?!
//
// The scripts floating around did not have the functionality of the plugin
// which I coded in 1996 for my own board. Nor did they work with my customs
// prompts. Thus OP-PRMP was born :).
//
// INSTALLATION:
//
//   1)  Copy OP-PRMP.MPS into a directory in the BBS scripts directory and
//       compile it using MPLC or MIDE.
//   1a) Copy and the included prompt files files to /OP-PRMP folder in the
//       scripts directory
//   2)  Set your system pause prompt #022 to: !op-prmp
//
//   3)  Check if your prompts are showing (they show on |PA MCI string)
//
//   3a) IMPORTANT: on windows the below configuration has to be adjusted
//
//        PromptFilePath    = 'op-prmp\';    (for windows)
//          or
//        PromptFilePath    = 'op-prmp/';    (for linux)


// PROMPT FILE NAMES:
//
//   PRMP scans the /op-prmp folder for .ANS files. One prompt will be
//   selected at random. The maximum number of prompts is limited at 100
//   which should be enough for now.
//
// MAKING YOUR OWN PROMPTS:
//
//   Each .ANS file is either an ANSI or TEXT file. The first line is split
//   into two arguments which can be set (or not). The script will assume
//   values when it is missing data.
//
//   First argument: the delay time in milliseconds between transitions.
//   Dont put the delay to high as the animation will feel off.
//
//   Second argument: rotate direction after reaching end of animation.
//   Set to Y will make the counter loop back to zero making it more easy
//   to create looping prompts. Set to N will make the loop jump back to
//   the first position after reaching the end.
//
//   The following lines are each one frame of animation. Which should not
//   be touched if you dont know MSI codes or ANSI codes ;).
//
// HISTORY:
//
//   - 12/2022
//      + added center prompt
//      + clear eol of current step, and return to xpos
//
//   - 10/2020
//      + added a lot of additional ANSI prompts
//      + fixed TimerStart to Timer
//      + fixed to check if no timeout set for board (else immediate hangup)
//      + added subfolder to PromptFilePath to avoid mixing files in scripts
//      + updated docs (above) with install sub folder
//      + updated docs (above) with |! for script instead of |DX
//      + replaced shutdown with CheckTimeOut
//      + removed SaveBuf / BufNoFlush
//      + added StuffKey to actually send an enter after pausing
//        this fixes issues when adding the script on the replacement |PA prompt
//      + changed file selection method (no more random file exists querys)
//      + added directional rotation option
//      + avoided garbage ouput on some ANSI prompts
//      + avoided SAUCE entries in ANSI files to mess up prompt
//           - thanks Pablodraw ;)
//      * todo: add shutdown check
//
//   - g00r00's t-prompt script as base and inspiration
//
//
// ==========================================================================

Uses
  CFG;

Const
  //### IMPORTANT ###

  PromptFilePath    = 'op-prmp/';         // PROMPT SUB FOLDER

  //### END CONFIG ###

  Version          = 1.1;                 // VERSION INFO
  PromptAsciiPause = '[Press any key]';   // ASCII REPLACEMENT
  MaxFrames        = 100;                 // MAX FRAMES
  MaxFiles         = 100;


Var
  Files     : Array[1..MaxFiles] of String[50];
  Count     : Byte;
  MaxLen    : Byte;
  FileNum   : Byte;
  Ch        : Char;
  Rotate    : Boolean;
  Increment : Boolean;
  Done      : Boolean;
  FileName  : String;
  SavedX    : Byte;
  TimeStart : LongInt
  DelayTime : Integer
  TmpData   : String;
  Data      : Array[1..MaxFrames] of String;
  DataSize  : Byte;
  InFile    : File;

procedure Trim(var AText: string): string;
var
  FirstPos, LastPos: integer;
begin
    FirstPos := 1;
  while (FirstPos <= Length(AText)) and (AText[FirstPos] = #32) do
    FirstPos := FirstPos + 1;
  LastPos := Length(AText)
  while (LastPos >= 1) and (AText[LastPos] = Chr(32)) do
    LastPos := LastPos - 1;
  Trim := Copy(AText, FirstPos, LastPos - FirstPos + 1);
end;

procedure StripEscCode(var s: string): string
const
  //StartChar = chr(27);
  EndChar = 'm';
var
  StartChar: char;
  i, cnt: integer;
  InEsc: Boolean;
  tmpstr: string;
begin
  StartChar := Chr(27);
  Cnt := 0;
  InEsc := False;
  for i := 1 to Length(s) do
    if InEsc then begin
      InEsc := s[i] <> EndChar
      //if InEsc then
      //  InEsc := s[i] <> Chr(27)
      // added for compatibilty with pablodraw
      if InEsc then
        InEsc := s[i] <> 't'
      cnt := cnt + 1
    end
    else begin
      InEsc := s[i] = StartChar;
      if InEsc then
        cnt := cnt + 1
      else
        tmpstr := tmpstr + s[i];
    end;

  StripEscCode := tmpstr;
  //setLength(s, Length(s) - cnt);
end;

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

// MAIN

Begin
  TimeStart := Timer;

  If Graphics = 0 Then Begin
    Write (PromptAsciiPause);
    Repeat
      CheckTimeOut;
      Delay(100);
    Until KeyPressed or CheckTimeOut;
    StuffKey(ReadKey);
    Halt;
  End;

  //find all files

  Count := 1
  FindFirst ( JustPath(ProgName) + PromptFilePath + '*.ans', 63);
  While DosError = 0 Do Begin
    Files[Count] := DirName;
    Count := Count + 1
    FindNext;
  End;
  FindClose;

  // assign random file

  FileNum  := Random(Count-1)
  FileName := JustPath(ProgName) + PromptFilePath + Files[FileNum+1]

  SavedX     := WhereX;

  // start read prompt

  fAssign (InFile, FileName, 2);
  fReset  (InFile);
  fReadLn (InFile, Data[1]);

  // determine delay
  Data[1] := StripEscCode(Data[1])
  
  If (Pos(' ', Data[1]) = 0) and (Str2Int(Data[1]) = 0) Then Begin
    //DelayTime := Str2Int(Data[1])
    //Write(' 1 '+Int2Str(DelayTime))
    //Input (30, 30, 1, '')
    DelayTime := 100;
    Rotate := False
  End
  If (Pos(' ', Data[1]) = 0) and (Str2Int(Data[1]) > 0) Then Begin
    DelayTime := Str2Int(Data[1])
    Rotate := False
  End
  If (Pos(' ', Data[1]) > 0) Then Begin
    DelayTime := Str2Int(Copy(Data[1], 0, Pos(' ', Data[1])))
    
    If Upper(Copy(Data[1],Pos(' ', Data[1])+1, Pos(' ', Data[1]) +2 )) = 'Y' Then
      Rotate := True
    Else
      Rotate := False
  End

  // read prompt lines

  Count := 1;
  MaxLen := 0;
  Done := False;
  
  While Not Done and Not fEof(InFile) And Count < MaxFrames Do Begin
    fReadLn (InFile, TmpData);
    If Pos('SAUCE',TmpData) = 0 Then Begin
       Data[Count] := TmpData

       //find length of MCI or ANSI prompts
       TmpData := StripEscCode(Data[Count])
       TmpData := StripMCI(TmpData)
       TmpData := Trim(TmpData)
       If MaxLen < Length(TmpData) Then
         MaxLen := Length(TmpData)

       Count := Count + 1;
    End
    Else
       Done := True
  End;
  fClose (InFile);

  DataSize  := Count - 1;
  Count     := 1;
  Increment := True;

  // reset background and purge inputs

  Write('|00')
  PurgeInput;

  // turn off cursor
  write(chr(27)+'[?25l');

  // MAIN LOOP

  Repeat
    CheckTimeOut;

    // middle of screen

    GotoXY (40 - (MaxLen / 2), WhereY);
    Write  (Data[Count]);
    write(chr(27)+'[?25l');

    // clear line and return to X

    SavedX := WhereX;
    write(chr(27)+'[K');
    GotoXY (SavedX, WhereY);

    // make sure buffer is send to users

    BufFlush;

    // rotate logic

    If Rotate = True Then Begin
      If Increment = True Then Begin
        Count := Count + 1;
        If Count = DataSize Then
          Increment := False
        End
      Else
      If Increment = False Then
        Count := Count - 1;
        if Count = 1 Then
          Increment := True

    End

    If Rotate = False Then Begin
      Count := Count + 1;
      If Count = DataSize + 1 Then
        Count := 1
    End

    Delay (DelayTime);

  Until KeyPressed or CheckTimeOut;

  StuffKey(ReadKey);
  write(chr(27)+'[?25h');

End.
