Program Jambase_info;

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
  Code       : Integer;
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

Procedure BaseNfo(id:integer);
Var
  MBase     : RecMessageBase;
  MsgBase   : PMsgBaseABS;
  S         : String = '';
  OutF      : Text;
Begin

  If Not GetMBaseByIndex(ID,MBase) Then Begin
    Writeln('Message Base, Not Found!!!');
    Exit;
  End;
  
  If SaveToFile Then Begin
    Assign(OutF,SaveFile);
    Rewrite(OutF);
  End;

  Case MBase.BaseType of
    0 : MsgBase := New(PMsgBaseJAM, Init);
    1 : MsgBase := New(PMsgBaseSquish, Init);
  End;
  
  MsgBase^.SetMsgPath (MBase.Path + MBase.FileName);
  
  If Not MsgBase^.OpenMsgBase Then Begin
    Dispose (MsgBase, Done);
  End;
  
     MsgBase^.MsgStartUp;
    MsgBase^.MsgTxtStartUp;
    
    S:= S + StrI2S(MBase.Index)+';';
    S:= S + MBase.Name+';';
    S:= S + MBase.Filename+';';
    S:= S + MBase.Path+';';
    S:= S + StrI2S(MsgBase^.GetHighMsgNum)+';';
    S:= S + StrI2S(MsgBase^.NumberOfMsgs)+';';
 
  
  If SaveToFile Then WriteLn(Outf,S) Else WriteLn(s);
  
  
  If SaveToFile Then Close(Outf);
    
  MsgBase^.CloseMsgBase;

  Dispose(MsgBase, Done);
End;

Procedure BaseNfoName(Name:String);
Var
  MBase     : RecMessageBase;
  MsgBase   : PMsgBaseABS;
  S         : String = '';
  OutF      : Text;
Begin

  If Not GetMBaseByName(name,MBase) Then Begin
    Writeln('Message Base, Not Found!!!');
    Exit;
  End;
  
  If SaveToFile Then Begin
    Assign(OutF,SaveFile);
    Rewrite(OutF);
  End;

  Case MBase.BaseType of
    0 : MsgBase := New(PMsgBaseJAM, Init);
    1 : MsgBase := New(PMsgBaseSquish, Init);
  End;
  
  MsgBase^.SetMsgPath (MBase.Path + MBase.FileName);
  
  If Not MsgBase^.OpenMsgBase Then Begin
    Dispose (MsgBase, Done);
  End;
  
     MsgBase^.MsgStartUp;
    MsgBase^.MsgTxtStartUp;
    
    S:= S + StrI2S(MBase.Index)+';';
    S:= S + MBase.Name+';';
     S:= S + MBase.EchoTag+';';
    S:= S + MBase.Filename+';';
    S:= S + MBase.Path+';';
    S:= S + StrI2S(MsgBase^.GetHighMsgNum)+';';
    S:= S + StrI2S(MsgBase^.NumberOfMsgs)+';';
 
  
  If SaveToFile Then WriteLn(Outf,S) Else WriteLn(s);
  
  
  If SaveToFile Then Close(Outf);
    
  MsgBase^.CloseMsgBase;

  Dispose(MsgBase, Done);
End;

Procedure Show_Help;
Begin
  WriteLn ('Usage: Jambase_info <Base> [-o <filename>]');
  WriteLn;
  WriteLn ('<Base>            Mystic Base ID Number Or Exact Name');
  WriteLn ('-o <Output_File>  Save output to file');
  Writeln;
  WriteLn ('The output has the following format:');
  Writeln ('Index;Name;EchoTag;Filename;Path;HighMsgNum;NumberOfMsgs');
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
    WriteLn ('Error reading MYSTIC.DAT.  Run Jambase_info from the main BBS directory.');
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
    Exit;
  End;  
  
  Val(Paramstr(1),i,code);
  If Code<>0 Then 
    BaseNfoName(Paramstr(1))
  Else
    BaseNfo(StrS2I(Paramstr(1)));
  
 
End.
