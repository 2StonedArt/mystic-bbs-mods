Program JamBase_List;

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
  SaveFile   : String = '';
  i          : Integer;
  Ch         : Char;

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
  MBase     : RecMessageBase;
  MsgBase   : PMsgBaseABS;
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
  
  If SaveToFile THen 
    WriteLn(OutF,Format('%3d %-20s %5s %48s',[MBase.Index,MBase.Name, Jos(MBase.BaseType),MBase.Path + MBase.FileName]))
  Else
    WriteLn(Format('%3d %-20s %5s %48s',[MBase.Index,MBase.Name, Jos(MBase.BaseType),MBase.Path + MBase.FileName]));
  //writeln(StrI2S(MsgBase^.GetHighMsgNum));
  
  If SaveToFile Then Begin
    Assign(OutF,SaveFile);
    Rewrite(OutF);
  End;
  
  MsgBase^.SeekFirst(1);
  While MsgBase^.GetMsgNum < MsgBase^.GetHighMsgNum Do Begin
      If Not MsgBase^.IsDeleted Then Begin
        MsgBase^.MsgStartUp;
        MsgBase^.MsgTxtStartUp;
        If SaveToFile THen Begin
          Writeln(OutF,'Msg No. '+StrI2S(MsgBase^.GetMsgNum)+' Subject: ' + MsgBase^.GetSubj);
          WriteLn(OutF,'From: '+ MsgBase^.GetFrom + ' To: '+ MsgBase^.GetTo + ' Date: '+ MsgBase^.GetDate+ ' Time: '+ MsgBase^.GetTime);
          WriteLn(OutF,StrRep('-',79));
        End Else Begin
          Writeln('Msg No. '+StrI2S(MsgBase^.GetMsgNum)+' Subject: ' + MsgBase^.GetSubj);
          WriteLn('From: '+ MsgBase^.GetFrom + ' To: '+ MsgBase^.GetTo + ' Date: '+ MsgBase^.GetDate+ ' Time: '+ MsgBase^.GetTime);
          WriteLn(StrRep('-',79));
        End;
      End;
    MsgBase^.SeekNext;
  End;
  
  If SaveToFile Then Close(OutF);
  MsgBase^.CloseMsgBase;
  Dispose(MsgBase, Done);
  WriteLn;
End;

Procedure ExportMsg(BID,MID:Integer; FEName:String);
Var
  FE        : File of Byte;
  BF        : File of Byte;
  MBase     : RecMessageBase;
  MsgBase   : PMsgBaseABS;
  Buffer    : Byte;
  i         : Integer = 0;
Begin
  
  
  If Not GetMBaseByIndex(BID,MBase) Then Begin
    Writeln('Message Base, Not Found!!!');
    Exit;
  End;

  Case MBase.BaseType of
    0 : MsgBase := New(PMsgBaseJAM, Init);
    1 : MsgBase := New(PMsgBaseSquish, Init);
  End;
  
  MsgBase^.SetMsgPath (MBase.Path + MBase.FileName);
  
  //writeln(MBase.Path + MBase.FileName);
  
  If Not MsgBase^.OpenMsgBase Then Begin
    Dispose (MsgBase, Done);
    //Continue;
  End;
  
  MsgBase^.SeekFirst(MID);
    
    
  If MsgBase^.SeekFound Then Begin
    MsgBase^.MsgStartUp;
    MsgBase^.MsgTxtStartUp;
    
    If ShowHeader Then Begin
      WriteLn('From: '+ MsgBase^.GetFrom + ' To: '+ MsgBase^.GetTo);
      Writeln('Subject: ' + MsgBase^.GetSubj);
      WriteLn(StrRep('-',79));
    End;
    //WriteLn(StrI2S(MsgBase^.GetTxtPos));
    //WriteLn(StrI2S(MsgBase^.GetTextLen));
    
    Assign(BF,MBase.Path + MBase.FileName+'.jdt');
    //Assign(FE, FEName);
    //ReWrite(FE,1);
    Reset(BF,1);
    Seek(BF,MsgBase^.GetTxtPos);
    
    While i <= MsgBase^.GetTextLen Do Begin
      BlockRead(BF,buffer,1);
      //BlockWrite(FE,buffer,1);
      If Buffer=13 Then WriteLn Else Write(Chr(buffer));
      i := i + 1;
    End;
    //Close(FE);
    Close(BF);
   

  End Else WritelN('Message Not Found');
  MsgBase^.CloseMsgBase;

  Dispose(MsgBase, Done);
 
  WriteLn;
End;

Procedure ListMBases;
Var
  F        : File;
  TempBase : RecMessageBase;
  OutF     : Text;
  i        : Integer;
  S        : String;
Begin

  If SaveToFile Then Begin
    Assign(OutF,SaveFile);
    Rewrite(OutF);
  End;
  Assign (F, bbsCfg.DataPath + 'mbases.dat');

  If Not ioReset(F, SizeOf(RecMessageBase), fmRWDN) Then Exit;
  
  While Not Eof(F) Do Begin
    ioRead (F, TempBase);
    S := '';
    //WriteLn(StrI2S(TempBase.Index)+' '+TempBase.Name+' '+Jos(TempBase.BaseType)+' '+TempBase.Path + TempBase.FileName);
    
     For i := 1 To ParamCount Do Begin
        If StrUpper(ParamStr(i)) = 'NAME' Then S := S + ';' + TempBase.NAME;    
        If StrUpper(ParamStr(i)) = 'QWKNAME' Then S := S + ';' + TempBase.QWKNAME;
        If StrUpper(ParamStr(i)) = 'NEWSNAME' Then S := S + ';' + TempBase.NEWSNAME;
        If StrUpper(ParamStr(i)) = 'FILENAME' Then S := S + ';' + TempBase.FILENAME;
        If StrUpper(ParamStr(i)) = 'PATH' Then S := S + ';' + TempBase.PATH;
        If StrUpper(ParamStr(i)) = 'BASETYPE' Then S := S + ';' + StrI2S(TempBase.BASETYPE);
        If StrUpper(ParamStr(i)) = 'NETTYPE' Then S := S + ';' + StrI2S(TempBase.NETTYPE);
        If StrUpper(ParamStr(i)) = 'READTYPE' Then S := S + ';' + StrI2S(TempBase.READTYPE);
        If StrUpper(ParamStr(i)) = 'LISTTYPE' Then S := S + ';' + StrI2S(TempBase.LISTTYPE);
        If StrUpper(ParamStr(i)) = 'LISTACS' Then S := S + ';' + TempBase.LISTACS; 
        If StrUpper(ParamStr(i)) = 'READACS' Then S := S + ';' + TempBase.READACS; 
        If StrUpper(ParamStr(i)) = 'POSTACS' Then S := S + ';' + TempBase.POSTACS; 
        If StrUpper(ParamStr(i)) = 'NEWSACS' Then S := S + ';' + TempBase.NEWSACS;
        If StrUpper(ParamStr(i)) = 'SYSOPACS' Then S := S + ';' + TempBase.SYSOPACS;
        If StrUpper(ParamStr(i)) = 'SPONSOR' Then S := S + ';' + TempBase.SPONSOR;
        If StrUpper(ParamStr(i)) = 'COLQUOTE' Then S := S + ';' + StrI2S(TempBase.COLQUOTE);
        If StrUpper(ParamStr(i)) = 'COLTEXT' Then S := S + ';' + StrI2S(TempBase.COLTEXT); 
        If StrUpper(ParamStr(i)) = 'COLTEAR' Then S := S + ';' + StrI2S(TempBase.COLTEAR);
        If StrUpper(ParamStr(i)) = 'COLORIGIN' Then S := S + ';' + StrI2S(TempBase.COLORIGIN);
        If StrUpper(ParamStr(i)) = 'COLKLUDGE' Then S := S + ';' + StrI2S(TempBase.COLKLUDGE);
        If StrUpper(ParamStr(i)) = 'NETADDR' Then S := S + ';' + StrI2S(TempBase.NETADDR);
        If StrUpper(ParamStr(i)) = 'ORIGIN' Then S := S + ';' + TempBase.ORIGIN;
        If StrUpper(ParamStr(i)) = 'DEFNSCAN' Then S := S + ';' + StrI2S(TempBase.DEFNSCAN);
        If StrUpper(ParamStr(i)) = 'DEFQSCAN' Then S := S + ';' + StrI2S(TempBase.DEFQSCAN);
        If StrUpper(ParamStr(i)) = 'MAXMSGS' Then S := S + ';' + StrI2S(TempBase.MAXMSGS);
        If StrUpper(ParamStr(i)) = 'MAXAGE' Then S := S + ';' + StrI2S(TempBase.MAXAGE);  
        If StrUpper(ParamStr(i)) = 'HEADER' Then S := S + ';' + TempBase.HEADER;
        If StrUpper(ParamStr(i)) = 'RTEMPLATE' Then S := S + ';' + TempBase.RTEMPLATE;
        If StrUpper(ParamStr(i)) = 'ITEMPLATE' Then S := S + ';' + TempBase.ITEMPLATE;
        If StrUpper(ParamStr(i)) = 'INDEX' Then S := S + ';' + StrI2S(TempBase.INDEX);   
        If StrUpper(ParamStr(i)) = 'FLAGS' Then S := S + ';' + StrI2S(TempBase.FLAGS);
        If StrUpper(ParamStr(i)) = 'CREATED' Then S := S + ';' + StrI2S(TempBase.CREATED); 
        If StrUpper(ParamStr(i)) = 'ECHOTAG' Then S := S + ';' + TempBase.ECHOTAG;
        If StrUpper(ParamStr(i)) = 'QWKNETID' Then S := S + ';' + StrI2S(TempBase.QWKNETID);
        If StrUpper(ParamStr(i)) = 'QWKCONFID' Then S := S + ';' + StrI2S(TempBase.QWKCONFID);
      End;
      Delete(S,1,1);
    
    
    If Not SaveToFile Then
      WriteLn(S)
    Else 
      WriteLn(OutF,S)
     
  End;

  Close (F);
  If SaveToFile Then Begin
    Close(OutF);
  End;
End;

Procedure Show_Help;
Begin
  WriteLn ('Usage: Jambase_list  [Fields] [-o <filename>]');
  WriteLn;
  WriteLn ('Fields: ');
  Writeln('  [Name] [QWKName] [NewsName] [FileName] [Path] [BaseType] [NetType] [ReadType]');
  Writeln('  [ListType] [ListACS] [ReadACS] [PostACS] [NewsACS] [SysopACS] [Sponsor]');
  Writeln('  [ColQuote] [ColText] [ColTear] [ColOrigin] [ColKludge] [NetAddr] [Origin]');
  Writeln('  [DefNScan] [DefQScan] [MaxMsgs] [MaxAge] [Header] [RTemplate] [ITemplate]');
  Writeln('  [Index] [Flags] [Created] [EchoTag] [QwkNetID] [QwkConfID] [Res]');
  WriteLn;
  WriteLn('  Seperate each field with a space.');
  WriteLn('  Example: jambase_list name filename path');
  WriteLn;
  WriteLn ('-o <Output_File>   Save output to file');
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
    WriteLn ('Error reading MYSTIC.DAT.  Run JamBase_List from the main BBS directory.');
    Halt(1);
  End;

  Read  (ConfigFile, Config);
  Close (ConfigFile);

  For i := 1 To ParamCount Do Begin
    If (StrUpper (Paramstr(i)) = '-H') Or (StrUpper (Paramstr(i)) = '-?') Or (StrUpper (Paramstr(i)) = '--HELP')Then Begin
      Show_Help;
      Halt(0);
    End;
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
    Halt(0);
  End;
  
  ListMBases;
    
End.
