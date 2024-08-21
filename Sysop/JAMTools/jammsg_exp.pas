Program JamMsg_Exp;

{$I M_OPS.PAS}

Uses
  CRT,
  DOS,
  m_DateTime,
  m_Strings,
  m_QuickSort,
  m_FileIO,
  bbs_database,
  bbs_records,
  bbs_MsgBase_ABS,
  bbs_MsgBase_JAM,
  bbs_MsgBase_Squish;

Var
  ConfigFile : File of RecConfig;
  Config     : RecConfig;
  ShowHeader : Boolean = False;
  i          : Integer;
  Ch         : Char;
  SaveToFile : Boolean;
  SaveFile   : String;

Type
  JamLastType = Record
    NameCrc  : LongInt;
    UserNum  : LongInt;
    LastRead : LongInt;
    HighRead : LongInt;
  End;

  SquLastType = LongInt;

Function strAddr2Str (Addr : RecEchoMailAddr) : String;
Var
  Temp : String[20];
Begin
  Temp := strI2S(Addr.Zone) + ':' + strI2S(Addr.Net) + '/' +
          strI2S(Addr.Node);

  If Addr.Point <> 0 Then Temp := Temp + '.' + strI2S(Addr.Point);

  Result := Temp;
End;


Procedure ExportMsg(BID,MID:Integer);
Var
  BF        : File of Byte;
  MBase     : RecMessageBase;
  MsgBase   : PMsgBaseABS;
  Buffer    : Byte;
  i         : Integer = 0;
  OutF      : Text;
Begin

  // writeln('>>> '+stri2s(bid));
  
    
  If Not GetMBaseByIndex(BID,MBase) Then Begin
    Writeln('Message Base, Not Found!!!');
    Exit;
  End;

  Case MBase.BaseType of
    0 : MsgBase := New(PMsgBaseJAM, Init);
    1 : MsgBase := New(PMsgBaseSquish, Init);
  End;
  
  MsgBase^.SetMsgPath (MBase.Path + MBase.FileName);
  
  
  If Not MsgBase^.OpenMsgBase Then Begin
    Dispose (MsgBase, Done);
  End;
  
  MsgBase^.SeekFirst(MID);

 // Writeln('<>> '+savefile);
  If SaveToFile Then Begin
    Assign(OutF,SaveFile);
    ReWrite(OutF);
  End;
    
  If MsgBase^.SeekFound And (Not MsgBase^.IsDeleted) Then Begin
    MsgBase^.MsgStartUp;
    MsgBase^.MsgTxtStartUp;
    
    If Not SaveToFile Then Begin
      If ShowHeader Then Begin
        WriteLn('From: '+ MsgBase^.GetFrom );
        WriteLn('To: '+ MsgBase^.GetTo);
        Writeln('Subject: ' + MsgBase^.GetSubj);
        Writeln('Date: ' + MsgBase^.GetDate + ' - ' + MsgBase^.GetTime);
        WriteLn(StrRep('-',79));

      End;
    End Else Begin
      If ShowHeader Then Begin
        WriteLn(OutF,'From: '+ MsgBase^.GetFrom );
        WriteLn(OutF,'To: '+ MsgBase^.GetTo);
        Writeln(OutF,'Subject: ' + MsgBase^.GetSubj);
        Writeln(OutF,'Date: ' + MsgBase^.GetDate + ' - ' + MsgBase^.GetTime);
        WriteLn(OutF,StrRep('-',79));
      End;
    End;
    
    Assign(BF,MBase.Path + MBase.FileName+'.jdt');
    Reset(BF,1);
    Seek(BF,MsgBase^.GetTxtPos);
    
    While i <= MsgBase^.GetTextLen Do Begin
      BlockRead(BF,buffer,1);
      If Not SaveToFile Then      
        If Buffer=13 Then WriteLn Else Write(Chr(buffer))
      Else
        If Buffer=13 Then WriteLn(OutF,'') Else Write(OutF,Chr(buffer));
      i := i + 1;
    End;
    Close(BF);
   

  End Else WritelN('Message Not Found');
  MsgBase^.CloseMsgBase;
  If SaveToFile Then Close(OutF);
    
  Dispose(MsgBase, Done);
 
  WriteLn;
End;

Procedure Show_Help;
Begin
  WriteLn ('Usage: Jammsg_exp <Base_ID> <Msg_ID> [Msg_ID_Last] [-o <Output_File>] [-h]');
  WriteLn;
  WriteLn ('  <Base_ID>        Mystic Base ID Number');
  WriteLn ('  <Msg_ID>         Message ID Number');
  WriteLn ('  -o <Output_File> Save output to file');
  WriteLn ('  -m               Display Msg Header also');
  WriteLn ('  Msg_ID_Last      If added, it will display all messages from');
  WriteLn ('                   Msg_ID to Msg_ID_Last.');
  Writeln;
  Writeln ('Open Source - GPL3 - github.com/xqtr/jamtools');
  Writeln;
End;

Begin
  TextAttr := 7;
  FileMode := 66;
  Assign (ConfigFile, 'mystic.dat');
  {$I-} Reset(ConfigFile); {$I+}

  If IoResult <> 0 Then Begin
    WriteLn ('Error reading MYSTIC.DAT.  Run JamMsg_Exp from the main BBS directory.');
    Halt(1);
  End;

  Read  (ConfigFile, Config);
  Close (ConfigFile);

  If ParamCount < 2 Then Begin
    Show_Help;
    Exit;
  End;
  
  For i := 1 To ParamCount Do Begin
    If (StrUpper (Paramstr(i)) = '-H') Or (StrUpper (Paramstr(i)) = '-?') Or (StrUpper (Paramstr(i)) = '--HELP')Then Begin
      Show_Help;
      Halt(0);
    End;
    If StrUpper(ParamStr(i)) = '-M' Then ShowHeader:=True;
    If StrUpper(Paramstr(i)) = '-O' Then Begin
      If FileExist(ParamStr(i+1)) Then Begin
        WriteLn('Output file exists. If you continue, it will overwritten.');
        WriteLn('Continue? [Y/N] ');
        Ch := ReadKey;
        If StrUpper(Ch) = 'N' Then Halt(3);
      End;
      SaveToFile := True;
      SaveFile   := Paramstr(i+1);
    End;
  End;
  
  Try
    StrS2I(paramstr(1));
    Strs2i(paramstr(2));
    If Paramstr(3) <> '' Then StrS2I(Paramstr(3));
  Except
    WriteLn('Wrong parameter value...');
    Halt(2);
  End;
  
  If (ParamStr(3)<>'') And (StrS2I(ParamStr(3)) > StrS2I(Paramstr(2))) Then Begin
    For i := StrS2I(Paramstr(2)) To StrS2I(Paramstr(3)) Do ExportMsg(StrS2I(paramstr(1)),i);
  End Else
    ExportMsg(StrS2I(paramstr(1)),Strs2i(paramstr(2)));
  
End.
