Uses Cfg
Uses User

Const
  MaxLevels = 5;
  Sysop = 'xqtr';

Type
  TUser = Record
    Name    : String[30];
    Credits : LongInt;
    Table   : Array[1..30] Of Byte; // For future use
  End;
Type  
  TLevel = Record
    Credits : LongInt;
    Desc    : String;
  End;
  
Var
  URec      : TUser;
  TmpDir    : String;
  ScrDir    : String;
  V         : LongInt;
  FP        : File;
  S         : String;
  Levels    : Array[1..MaxLevels] Of TLevel;
  
Procedure Help;
Begin
  ClrScr;
  WriteLn('|15Reward System for Mystic BBS');
  WriteLn('');
  WriteLn('|14Usage|07:');
  WriteLn('  xq-reward <function> [option]');
  WriteLn('');
  WriteLn('|14Functions|07:');
  WriteLn('  add <no>       : Adds <no> credits to User');
  WriteLn('  sub <no>       : Substracts <no> credits from User');
  WriteLn('  timer put      : Start Timing user');
  WriteLn('  timer read     : Finishes timing and adds credits');
  WriteLn('  check          : Checks if user reached a certain level');
  WriteLn('');
  Pause;
End;
  
Procedure InitUser(Var UR:TUser);
Begin
  FillChar(UR,SizeOf(UR),#0);
  UR.Name := UserAlias;
  UR.Credits := 0;
End;

Procedure ReadUser(Var UR:TUser):Boolean;
Var
  fpt : File;
Begin
  If FileExist(ScrDir+UR.Name+'.dat') Then Begin
    fAssign(fpt,ScrDir+UR.Name+'.dat',66);
    fReset(fpt);
    fReadRec(fpt,UR);
    fClose(fpt);
    ReadUser:=True;
  End Else ReadUser:=False;
End;

Procedure WriteUser(UR:TUser);
Var
  fpt : File;
  TUR : TUser;
Begin
  If FileExist(ScrDir+UR.Name+'.dat') Then FileErase(ScrDir+UR.Name+'.dat');
  fAssign(fpt,ScrDir+UR.Name+'.dat',66);
  fRewrite(fpt);
  fWriteRec(fpt,UR);
  fClose(fpt);
End;  

Procedure TopTen;
Var
  UAR : Array[1..10] Of TUser;
  i   : Byte;
  fpt : File;
  TUR : TUSer;
  
  Procedure Sort;
  Var
    d, j:integer;
    temp1 : Integer;
    tmpname : String;
  Begin
    for j:=1 to 10 do
    For d := 2 to 10 do begin
      if UAR[d-1].Credits > UAR[d].Credits then begin
        TUR := UAR[d-1];
        UAR[d-1] := UAR[d];
        UAR[d] := TUR;
      end;
    end;
  End;
  
Begin
  ClrScr;
  For i := 1 To 10 Do Begin
    FillChar(UAR[i],SizeOf(TUR),#0);
    UAR[i].Name := 'Unknown';
    UAR[i].Credits := 0;
  End;
  FindFirst (ScrDir + '*.dat', 63); 
  While DosError = 0 Do Begin           // Did we find one? 
    fAssign(fpt,ScrDir+DirName,66);
    fReset(fpt);
    fReadRec(fpt,TUR);
    fClose(fpt);
    For i := 1 To 10 Do Begin
      if UAR[i].Credits<TUR.Credits Then Begin  
        UAR[i] := TUR;
        Sort;
        Break;
      End;
    End;
    
    FindNext;
  End;
  FindClose;
  ClrScr;
  DispFile(ScrDir+'reward.ans');
  
  For i := 1 To 10 Do Begin
    WriteXY(21,8+i,7,PadRT(UAR[i].Name,29,' ') + ' ' + PadLT(strComma(UAR[i].Credits),10,' '));
  End;
  GotoXY(1,25);
  Pause;
End;

Procedure ShowLevels;
Begin
  ClrScr;
  DispFile(ScrDir+'levels.ans');
  GotoXY(1,25);
  Pause;
End;

Procedure InitLevels;
Begin
  Levels[5].Credits := 3;
  Levels[5].Desc    := 'User Reached level 1';
  Levels[4].Credits := 2000;
  Levels[4].Desc    := 'User Reached level 2';
  Levels[3].Credits := 3000;
  Levels[3].Desc    := 'User Reached level 3';
  Levels[2].Credits := 4000;
  Levels[2].Desc    := 'User Reached level 4';
  Levels[1].Credits := 5000;
  Levels[1].Desc    := 'User Reached level 5';
End;

Procedure CheckLevels;
Var
  d : byte;
  fps : file;
Begin
  For d := 1 To MaxLevels Do 
    if URec.Credits >= Levels[d].Credits Then Begin
      If URec.Table[1]<> d Then Begin
        fAssign(fps,TmpDir+'temp.txt',66);
        fRewrite(fps);
        fWriteLn(fps,UserAlias+' : '+Levels[d].Desc);
        fClose(fps);
        MenuCmd('MX',TmpDir+'temp.txt'+';1;Reward_Sys;'+Sysop+';User '+UserAlias+' Level Upgrade');
        FileErase(TmpDir+'temp.txt');
        URec.Table[1]:=d;
        WriteUser(URec);
        Break;
      End;
    End;
End;
  
// Main Block

Begin
  GetThisUser;
	TmpDir:=CfgSysPath  + 'temp' + Int2Str(NodeNum) + PathChar;
  ScrDir:=CfgMPEPath + 'xq-reward' + PathChar;
  
  InitUser(URec);
  ReadUser(URec);
  InitLevels;
  
  If Upper(ParamStr(1)) = 'TOP' Then Begin
    TopTen;
  End;
  
  If Upper(ParamStr(1)) = 'CHECK' Then Begin
    CheckLevels;
  End;
  
  If Upper(ParamStr(1)) = 'LEVELS' Then Begin
    ShowLevels;
  End;
  
  If Upper(ParamStr(1)) = 'ADD' Then Begin
    V := Str2Int(Paramstr(2));
    URec.Credits := URec.Credits + V;
    WriteUser(URec);
  End;
  
  If Upper(ParamStr(1)) = 'SUB' Then Begin
    V := Str2Int(Paramstr(2));
    URec.Credits := URec.Credits - V;
    If URec.Credits < 0 Then URec.Credits := 0;
    WriteUser(URec);
  End;
  
  If Upper(ParamStr(1)) = 'TIMER' Then Begin
    If Upper(ParamStr(2)) = 'PUT' Then
      fAssign(fp,TmpDir+UserAlias+'.tmp',66);
      fRewrite(fp);
      fWriteLn(fp,Int2Str(TimerMin));
      fClose(fp);
        
      If Upper(ParamStr(2)) = 'READ' Then Begin
      If FileExist(TmpDir+UserAlias+'.tmp') Then Begin
        fAssign(fp,TmpDir+UserAlias+'.tmp',66);
        fReset(fp);
        fReadLn(fp,S);
        fClose(fp);
        V := Str2Int(S);
        If V < TimerMin Then Begin
          V := TimerMin - V;
          If (V <= 120) Then URec.Credits := URec.Credits + V
            Else URec.Credits := URec.Credits + 120;
        End;
        FileErase(TmpDir+UserAlias+'.tmp');
        WriteUser(Urec);
      End Else Begin
      
      End;
    End;
  End;
End;
