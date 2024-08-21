Uses Cfg;
Uses User;

Const
  Win_x           = 7;
  Win_y           = 8;
  Win_w           = 67;
  Win_h           = 14;
  Win_norm_cl     = 7
  Win_high_cl     = 13
  AnsiFile        = 'xq-aboard.ans';
  Sysop           = 's255';
  NewsFile        = 'news.txt';
  Max_Lines       = 100;
  NewsWidth       = 72;
  
  
Type
  TUserRec = Record
    UserID : LongInt;
    Name   : String[30];
    Seen   : byte;
    LastOn : LongInt;
  End;

Var 
  UserRec   : Tuserrec;
  Ok        : Boolean = True;
  DataPath  : String;
  UserNumber: LongInt = -1;
  FileDate  : Longint = -1;
  News      : Array[1..Max_Lines] Of String;
  NewsItems : byte;

Procedure ClearArea;
Var o:byte;
Begin
  For o:=0 to Win_h Do Begin
    GotoXY(Win_x,Win_y+o);
    Write(strrep(' ',Win_w));
  End;
End;

Procedure AddLog(Str: String);
Var
  Stamp : String;
Begin
  Stamp := '[ '+DateStr(DateTime,1)+' / ';
  Stamp := Stamp + TimeStr(DateTime,False)+' ] ';
  AppendText(cfgsyspath+AddSlash('logs')+'fsxnet.log',Stamp+Str);
End;

Procedure SaveUser;
Var
  F : File;
Begin
  fAssign (F, DataPath + 'xq-aboard.dat', 66);
  fReset  (F);
  If UserNumber <> -1 Then
    fSeek (F, SizeOf(Userrec) * (UserNumber - 1));
  Else
    fSeek (F, fSize(F));

  fWriteRec (F, Userrec);
  fClose    (F);
  AddLog('Saved User: '+UserAlias);
End;

Procedure LoadUser;
Var
  F : File;
  T : TUserRec;
Begin
  GetThisUser;
  UserNumber := -1;
  UserRec.UserID := UserIndex;
  fAssign (F, DataPath + 'xq-aboard.dat', 66);
  fReset  (F);
  If IoResult <> 0 Then fReWrite(F);
  While Not fEof(F) Do
    Begin
      fReadRec (F, T);

      If T.UserID = UserIndex Then
        Begin
          UserRec       := T;
          UserNumber := fPos(F) / SizeOf(UserRec);
          Break;
        End;
    End;
  fClose (F);
  //UserRec.LastOn := DateTime;
  UserRec.Name   := UserAlias;
  AddLog('Loaded User: '+UserAlias);
End;



Procedure XWindow(H1:String;T,X1,Y1,X2,Y2:Integer);
Var T1,A1,A2,B1,B2  : String;
Begin
  A1 := Int2Str(X1);
        A2:=Int2Str(X2);
        B1:=Int2Str(Y1);
        B2:=Int2Str(Y2);
        T1:=Int2Str(T);
        Write('|#X#'+T1+'#'+H1+'#'+A1+'#'+B1+'#'+A2+'#'+B2+'#');
End;

Function GetFileDate(P:String): LongInt;
Var Ret : Longint = 128;
Begin
  FindFirst(P,16);
  If DOSError = 0 Then
    Begin
      Ret := DirTime;
    End
    FindClose;
  GetFileDate := Ret;
End;

Procedure Center(s:String; line:byte);
Begin
  GotoXY(40-(length(stripmci(s)) / 2),line);
  Write(s);
End;

Procedure LoadNews;
Var
  fptr2: file;
  l: integer;
Begin
  If FileExist(DataPath+NewsFile) Then Begin
    fAssign(fptr2,DataPath+NewsFile,66);
    fReset(fptr2);
    l := 0;
    While (Not feof(fptr2)) Do
      Begin
        l := l+1;
        fReadLn(fptr2,News[l]);
        //News[l] := Copy(News[l],1,NewsWidth);
        If l>=max_Lines Then break;
      End;
    fClose(fptr2);
    NewsItems := l;
  End;
End;

Function EditFile(FX,Subject:String):Boolean;
Var
  Lines    : Integer = 10;
  WrapPos  : Integer = 80;
  MaxLines : Integer = 100;
  Forced   : Boolean = False;
  Template : String  = 'msg_editor';
  Count	   : Integer;
  i        : Integer;
  S        : String;
  fptr    : file;
Begin
	If Not FileExist(FX) Then Begin
		For  i := 0 To MaxLines Do MsgEditSet(i,'');
	End Else Begin
    fAssign(fptr,DataPath+NewsFile,66);
    fReset(fptr);
    i := 1;
    While (Not feof(fptr)) Do
      Begin
        fReadLn(fptr,s);
        MsgEditSet(i,s);
        i := i + 1;
        If i>=max_Lines Then break;
      End;
    fClose(fptr);
  End;
  EditFile := True;
	MaxLines:=Lines+200;
  SetPromptInfo(1, '');
  
  

	If MsgEditor(0,MaxLines,WrapPos,MaxLines,Forced,Template, Subject) Then Begin
		fAssign(fptr,FX,66);
		fReWrite(fptr);
		For Count := 1 to MaxLines Do Begin
			fWriteLn(fptr,MsgEditGet(Count));
		End;
    fClose(fptr);
	End Else EditFile := False;
  forced := not (pos('asd','asdasd') = 0);
End;

Procedure DisplayNews;
Var
  Ch : Char;
  Ch2: Char;
  baronc : string = '|23|00';
  baroffc : string = '|16|07';
  TopPage   :byte
  BarPos    :byte
  More      :byte
  LastMore  :byte
  Temp      :byte
  Temp2     :byte  
  Done      : Boolean;
  TotalAreas:Byte;
  morecol : String = '|08|16'
  
Procedure BarON;
Var
  d : Byte;
begin
  //GotoXY (Win_x, Win_y + BarPos - TopPage);
  //Write (baronc + PadRT(StripMCI(News[BarPos]), Win_w, ' ') + '|16');
  d := Length(News[Barpos]) - Length(StripMCI(News[BarPos]));
  WriteXYPipe(Win_x, Win_y + BarPos - TopPage,7,Win_w,PadRT(News[BarPos], Win_w + d, ' '));
end;

Procedure BarOFF;
Var
  d : Byte;
begin
  //GotoXY (Win_x, Win_y + BarPos - TopPage);
  //Write (baroffc + PadRT(News[BarPos], Win_w, ' '));
  //Write (StrREP(' ', Win_w - WhereX));
  d := Length(News[Barpos]) - Length(StripMCI(News[BarPos]));
  WriteXYPipe(Win_x, Win_y + BarPos - TopPage,7,Win_w,PadRT(News[BarPos], Win_w + d, ' '));
end;
  
Procedure DrawPage;
begin
  Temp2 := BarPos;
  For Temp := 0 to Win_h-1 do begin 
    BarPos := TopPage + Temp;
    BarOFF;
  end;
  BarPos := Temp2;
  BarON;
end   
  
Begin
  TopPage  := 1;
  BarPos   := 1;
  Done     := False;
  More     := 0;
  LastMore := 0;
  TotalAreas:=NewsItems;
  DrawPage;
  
  Repeat
    More := 0;
    Ch   := ' ';
    Ch2  := ' ';
    

    If TopPage > 1 Then begin
      More := 1;
      Ch   := Chr(244);
    End;

    If TopPage + Win_h-1 < TotalAreas Then begin
      Ch2  := Chr(245);
      More := More + 2;
    End;

    If More <> LastMore Then begin
      LastMore := More;
      GotoXY (35, 22);
      Write (morecol+' (' + Ch + Ch2 + ' more) ');
    End;    
    
    Ch := ReadKey;
    If IsArrow Then begin
	//HOME key
      if ch = chr(71) then begin

        TopPage := 1;
        BarPos  := 1;
        drawpage;
        end;
	//END Key
      if ch = chr(79) then begin

        if TotalAreas > Win_h then begin
          TopPage := TotalAreas - Win_h+1;
          BarPos  := TotalAreas;
        end else begin
          BarPos  := TotalAreas ;
        end;
        drawpage;
        end;
  
      If Ch = Chr(72) Then begin

        If BarPos > TopPage Then begin
          BarOFF;
          BarPos := BarPos - 1;
          BarON;
          end;
        Else
        If TopPage > 1 Then begin
          TopPage := TopPage - 1;
          BarPos  := BarPos  - 1;
          DrawPage;
        End;
      end;
  
      If Ch = Chr(73) Then begin

        If TopPage - Win_h > 0 Then begin
          TopPage := TopPage - Win_h;
          BarPos  := BarPos  - Win_h;
          DrawPage;
          end
        Else begin
          TopPage := 1;
          BarPos  := 1;
          DrawPage;
        End;
      end;
  
    If Ch = Chr(80) Then begin

      If BarPos < TotalAreas Then
        If BarPos < TopPage + Win_h-1 Then begin
          BarOFF;
          BarPos := BarPos + 1;
          BarON;
          end
        Else
        If BarPos < TotalAreas Then begin
          TopPage := TopPage + 1;
          BarPos  := BarPos  + 1;
          DrawPage;
        End;
      End;
  
      If Ch = Chr(81) Then begin

        If TotalAreas > Win_h Then
          If TopPage + Win_h < TotalAreas - Win_h+1 Then begin
            TopPage := TopPage + Win_h-1;
            BarPos  := BarPos  + Win_h-1;
            DrawPage;
            end
          Else
          begin
            TopPage := TotalAreas - Win_h+1;
            BarPos  := TotalAreas;
            DrawPage;
          End
        Else
        begin
          BarOFF;
          BarPos := TotalAreas;
          BarON;
        End;
    End;
  //ch:=#0
  end else
    If Ch = Chr(27) Then Done := True 
      Else
        If Ch = Chr(13) Then Done := True 
          Else
            If Upper(Ch) = 'E' And ACS(Sysop) Then Begin
              EditFile(DataPath+NewsFile,'');
              ClrScr;
              DispFile(DataPath + 'xq-aboard.ans');
              DrawPage;
              Done := False;
            End;
  Until Done;
End;

//Main Loop

Begin
  ClrScr;
  If Graphics = 0 Then
    Begin
      WriteLn('|16|15No Graphics support. Exiting... |PA');
      AddLog('No Graphics Support. Aborting. User: '+UserAlias);
      Halt;
    End;
  Datapath := AddSlash(addslash(cfgmpepath)+'xq-aboard');
  If Not FileExist(DataPath + NewsFile) Then Begin
    //WriteLn('|16|15No Graphics support. Exiting... |PA');
    AddLog('No NEWS.TXT File exist... aborting.');
    Halt;
  End;
    
  LoadUser;
  FileDate := GetFileDate(DataPath + 'news.txt');
  
  If ACS(Sysop) Then Begin
    DispFile(DataPath + 'xq-aboard.ans');
    LoadNews;
    Center('Use Arrow Keys to Navigate. ESC/ENTER to Continue',25);
    DisplayNews;
  End Else Begin
    If FileDate >= UserRec.LastOn Then Begin
      DispFile(DataPath + 'xq-aboard.ans');
      LoadNews;
      Center('Use Arrow Keys to Navigate. ESC/ENTER to Continue',25);
      DisplayNews;
    End;
  End;
  UserRec.LastOn := DateTime;
  SaveUser;
  clrscr;

End;
