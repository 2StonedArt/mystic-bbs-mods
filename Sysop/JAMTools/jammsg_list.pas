Program JamMsg_List;

// post a text file to msg base?
// auto mass upload
// export AREAS.BBS?
// import FIDONET.NA
// .TIC stuff?

{$I M_OPS.PAS}

Uses
  CRT,
  DOS,
  Sysutils,
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
  SaveToFile : Boolean = False;
  ShowBody   : Boolean = False;
  SaveFile   : String = '';
  i          : Integer;
  Ch         : Char;
  Code       : Integer;

Type
  JamLastType = Record
    NameCrc  : LongInt;
    UserNum  : LongInt;
    LastRead : LongInt;
    HighRead : LongInt;
  End;

  SquLastType = LongInt;
  
Function JoS(n:byte):String;
Begin
  If n = 0 Then Result := 'Jam' Else Result := 'Squish';
End;

Function strAddr2Str (Addr : RecEchoMailAddr) : String;
Var
  Temp : String[20];
Begin
  Temp := strI2S(Addr.Zone) + ':' + strI2S(Addr.Net) + '/' +
          strI2S(Addr.Node);

  If Addr.Point <> 0 Then Temp := Temp + '.' + strI2S(Addr.Point);

  Result := Temp;
End;

Procedure ListMsgs(BID:Integer);
Var
  FE        : File of Byte;
  BF        : File of Byte;
  MBase     : RecMessageBase;
  MsgBase   : PMsgBaseABS;
  Buffer    : Byte;
  i         : Integer = 0;
  OutF      : Text;
Begin
 
  If Not GetMBaseByIndex(BID,MBase) Then Begin
    Writeln('Message Base, Not Found!!!');
    Readkey;
    Exit;
  End;

  Case MBase.BaseType of
    0 : MsgBase := New(PMsgBaseJAM, Init);
    1 : MsgBase := New(PMsgBaseSquish, Init);
  End;
  
  MsgBase^.SetMsgPath (MBase.Path + MBase.FileName);
  
  If Not MsgBase^.OpenMsgBase Then Begin
    Dispose (MsgBase, Done);
    //Continue;
  End;
  
  If SaveToFile Then Begin
    Assign(OutF,SaveFile);
    Rewrite(OutF);
  End;
  
  MsgBase^.SeekFirst(1);
  While MsgBase^.GetMsgNum < MsgBase^.GetHighMsgNum Do Begin
      If Not MsgBase^.IsDeleted Then Begin
        MsgBase^.MsgStartUp;
        MsgBase^.MsgTxtStartUp;
        
        If ShowBody Then Begin
          If SaveToFile Then Begin
            Write(OutF,StrRep('#',76));
            WriteLn(OutF,'SOM');
          End Else Begin
            Write(StrRep('#',76));
            WriteLn('SOM');
          End;
        End;
        
        If ShowHeader Then Begin
          If SaveToFile THen Begin
            Writeln(OutF,StrI2S(MsgBase^.GetMsgNum)+';' + MsgBase^.GetSubj+';'+ MsgBase^.GetFrom + ';'+ MsgBase^.GetTo + ';'+ MsgBase^.GetDate+ ';'+ MsgBase^.GetTime);
          End Else Begin
            Writeln(StrI2S(MsgBase^.GetMsgNum)+';' + MsgBase^.GetSubj+';'+ MsgBase^.GetFrom + ';'+ MsgBase^.GetTo + ';'+ MsgBase^.GetDate+ ';'+ MsgBase^.GetTime);
          End;
        End Else Begin
          If SaveToFile THen Begin
            //Writeln(OutF,'Msg No. '+StrI2S(MsgBase^.GetMsgNum));
            WriteLn(OutF,Format('From    : %-30s  Msg # %-7d',[MsgBase^.GetFrom,MsgBase^.GetMsgNum]));
            WriteLn(OutF,Format('To      : %-30s  Date: %8s %5s',[MsgBase^.GetTo,MsgBase^.GetDate,MsgBase^.GetTime]));
            WriteLn(OutF,'Subject : ' + MsgBase^.GetSubj);
            WriteLn(OutF,StrRep('-',79));
          End Else Begin
            WriteLn(Format('From    : %-30s  Msg # %-7d',[MsgBase^.GetFrom,MsgBase^.GetMsgNum]));
            WriteLn(Format('To      : %-30s  Date: %8s %5s',[MsgBase^.GetTo,MsgBase^.GetDate,MsgBase^.GetTime]));
            WriteLn('Subject : ' + MsgBase^.GetSubj);
            WriteLn(StrRep('-',79));
          End;
        End;
        
      If ShowBody Then Begin  
        Assign(BF,MBase.Path + MBase.FileName+'.jdt');
        Reset(BF,1);
        Seek(BF,MsgBase^.GetTxtPos);
        i := 0;
        While i <= MsgBase^.GetTextLen Do Begin
          BlockRead(BF,buffer,1);
          If SaveToFile Then Begin
            If Buffer=13 Then WriteLn(OutF,'') Else Write(OutF,Chr(buffer));
          End Else Begin
            If Buffer=13 Then WriteLn Else Write(Chr(buffer));
          End;
          i := i + 1;
        End;
        
        If SaveToFile Then WriteLn(Outf,'') Else Writeln;
        Close(BF);
        End;
        
        If ShowBody Then 
          If SaveToFile Then Begin
            WriteLn(OutF,StrRep('#',76),'EOM');
          End Else Begin
            WriteLn(StrRep('#',76),'EOM');
          End;
      End;
    MsgBase^.SeekNext;
  End;
  
  If SaveToFile Then Close(OutF);
  
  MsgBase^.CloseMsgBase;
  Dispose(MsgBase, Done);
End;

Procedure Show_Help;
Begin
  WriteLn ('Usage: Jammsg_list <Base> [-o <filename>] [-h1] [-h2]');
  WriteLn;
  WriteLn ('<Base>             Mystic Base ID Number Or Exact Name');
  WriteLn ('-o <Output_File>   Save Output to File');
  WriteLn ('-m1                Display Msg Headers in Mystic Format');
  WriteLn ('-m2                Display Msg Headers in CSV Format');
  WriteLn ('-b                 Display Msg Body');
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
    WriteLn ('Error reading MYSTIC.DAT.  Run JamMsg_List from the main BBS directory.');
    Halt(1);
  End;

  Read  (ConfigFile, Config);
  Close (ConfigFile);

  {If Config.DataChanged <> mysDataChanged Then Begin
    WriteLn('ERROR: Data files are not current and must be upgraded.');
    //Halt(1);
  End;}

  For i := 1 To ParamCount Do Begin
    If (StrUpper (Paramstr(i)) = '-H') Or (StrUpper (Paramstr(i)) = '-?') Or (StrUpper (Paramstr(i)) = '--HELP')Then Begin
      Show_Help;
      Halt(0);
    End;
    If StrUpper(ParamStr(i)) = '-M2' Then ShowHeader:=True;
    If StrUpper(ParamStr(i)) = '-B' Then ShowBody:=True;
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
  
  If ParamCount < 1 Then Begin
    Show_Help;
    Exit;
  End;  
  
  Val(Paramstr(1),i,code);
  If Code<>0 Then 
    //ExportMsgName((paramstr(1));
  Else
    ListMsgs(StrS2I(paramstr(1)));
  
End.
