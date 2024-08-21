program rcsmcc;

{$mode objfpc}{$H+}
{$R *.res}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils, strutils, vinfo, versiontypes, crt;

const
  prog   = 'RCS Mystic Country Count';
  author = 'DRPanther(RCS)';

type
  countrec = record
    country  : string;
    attempts : integer;
  end;

var
  ver        : string;
  sysos      : string;
  path       : string;
  fmislog    : textfile;
  mccrpt     : textfile;
  acountry   : array [1..5000] of countrec;
  lastrec    : integer;
  x          : integer;
  i          : integer;
  dateto     : string;
  datefrom   : string;
  booldate   : boolean;
  systemname : string;
  logdate    : String;
  YYYY,MM,DD : Word;
  blockedcon : Integer;

Procedure ProgramHalt;
begin
  halt(1);
end;

function OSVersion: String;
var
  SizeofPointe: string;
begin
  {$IFDEF LCLcarbon}
  OSVersion := 'Mac OS X 10.';
  {$ELSE}
  {$IFDEF Linux}
  OSVersion := 'Linux';
  {$ELSE}
  {$IFDEF UNIX}
  OSVersion := 'Unix';
  {$ELSE}
  {$IFDEF WINDOWS}
  OSVersion:= 'Windows';
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ifdef CPU32}
    SizeofPointe:='/32';   // 32-bit = 32
  {$endif}
  {$ifdef CPU64}
    SizeofPointe:='/64';   // 64-bit = 64
  {$endif}
  sysos:=OSVersion+SizeofPointe;
end;

function ProductVersionToString(PV: TFileProductVersion): String;
   begin
     Result := Format('%d.%d.%d.%d', [PV[0],PV[1],PV[2],PV[3]])
   end;

procedure ProgVersion;
var
   Info: TVersionInfo;
begin
   Info := TVersionInfo.Create;
   Info.Load(HINSTANCE);
   ver:=(ProductVersionToString(Info.FixedInfo.FileVersion));
   Info.Free;
end;

Procedure ProgramInit;
begin
  OSVersion;
  ProgVersion;
  path:=GetCurrentDir;
  DeCodeDate(Date,YYYY,MM,DD);
  logdate:=format('%d%d%d',[YYYY,MM,DD]);
  //writeln(logdate);
  //readkey;
  try
  AssignFile(fmislog,'logs'+PathDelim+'mis.'+logdate+'.log');
  reset(fmislog);
  except
    on E: EInOutError do begin
      writeln('File handling error occurred. Details: ',E.Message);
      ProgramHalt;
    end;
  end;
  acountry[1].country:='';
  acountry[1].attempts:=0;
  i:=1;
  booldate:=false;
  systemname:='';
  blockedcon:=0;
end;

Procedure DupeCheck;
var
  a:integer;
  b:integer;
begin
  a:=1;
  b:=1;
  for a:=1 to lastrec do begin
    for b:=a+1 to lastrec do begin
      if (upcase(acountry[a].country))=(upcase(acountry[b].country)) then begin
        acountry[a].attempts:=acountry[a].attempts+1;
        acountry[b].country:='';
      end;
    end;
  end;
end;

Procedure ReadMIS;
var
  s : string;
  x : integer;
begin
  if not (booldate) then
  begin
    readln(fmislog,s);
    Repeat
      if (AnsiStartsStr('+',s))then
      Begin
        Delete(s,1,2);
        dateto:=Copy(s,1,10);
        if (dateto<>'') then booldate:=true
      end
      Else readln(fmislog,s);
    Until (AnsiStartsStr('+',s)) and (booldate);
    reset(fmislog);
    booldate:=true;
  end;
  while not eof(fmislog) do
  begin
    readln(fmislog,s);
    if (AnsiStartsStr('+',s))then
    begin
      Delete(s,1,2);
      datefrom:=Copy(s,1,10);
      if (AnsiContainsStr(s,'-S: NUL SYS ')) then
      begin
        x:=pos('NUL SYS ',s);
        Delete(s,1,x+7);
        systemname:=s;
      end;
      if (AnsiContainsStr(s,'-Country ')) then
      begin
        x:=pos('Country  ',s);
        Delete(s,1,x+8);
        x:=pos(' (',s);
        acountry[i].country:=(Copy(s,1,x));
        acountry[i].attempts:=1;
        inc(i);
      end;
      if (AnsiContainsStr(s,'-Blocked connection')) then Inc(blockedcon);
    end;
  end;
  //Delete(s,1,2);
  //datefrom:=Copy(s,1,10);
  lastrec:=i;
  CloseFile(fmislog);
end;

Procedure DataSort;
var
  a:integer;
  b:integer;
  i:integer;
  temp:integer;
begin
  a:=1;
  b:=1;
  i:=lastrec-1;
  temp:=lastrec;
  for a:=1 to i do begin
    for b:=a+1 to i do begin
      if (upcase(acountry[a].country)<>'')and(upcase(acountry[b].country)<>'') then begin
        if (upcase(acountry[a].country[1])>(upcase(acountry[b].country[1]))) then begin
          acountry[temp]:=acountry[a];
          acountry[a]:=acountry[b];
          acountry[b]:=acountry[temp];
        end;
      end;
      if (upcase(acountry[a].country)<>'')and(upcase(acountry[b].country)<>'') then begin
        if (upcase(acountry[a].country[1])=(upcase(acountry[b].country[1]))) then begin
          if (upcase(acountry[a].country[2])>(upcase(acountry[b].country[2]))) then begin
            acountry[temp]:=acountry[a];
            acountry[a]:=acountry[b];
            acountry[b]:=acountry[temp];
          end;
        end;
      end;
      if (upcase(acountry[a].country)<>'')and(upcase(acountry[b].country)<>'') then begin
        if (upcase(acountry[a].country[1])=(upcase(acountry[b].country[1])))and(upcase(acountry[a].country[2])=(upcase(acountry[b].country[2]))) then begin
          if (upcase(acountry[a].country[3])>(upcase(acountry[b].country[3]))) then begin
            acountry[temp]:=acountry[a];
            acountry[a]:=acountry[b];
            acountry[b]:=acountry[temp];
          end;
        end;
      end;
      if (upcase(acountry[a].country)<>'')and(upcase(acountry[b].country)<>'') then begin
        if (upcase(acountry[a].country[1])=(upcase(acountry[b].country[1])))and(upcase(acountry[a].country[2])=(upcase(acountry[b].country[2])))and(upcase(acountry[a].country[3])=(upcase(acountry[b].country[3]))) then begin
          if (upcase(acountry[a].country[4])>(upcase(acountry[b].country[4]))) then begin
            acountry[temp]:=acountry[a];
            acountry[a]:=acountry[b];
            acountry[b]:=acountry[temp];
          end;
        end;
      end;
      if (upcase(acountry[a].country)<>'')and(upcase(acountry[b].country)<>'') then begin
        if (upcase(acountry[a].country[1])=(upcase(acountry[b].country[1])))and(upcase(acountry[a].country[2])=(upcase(acountry[b].country[2])))and(upcase(acountry[a].country[3])=(upcase(acountry[b].country[3])))and(upcase(acountry[a].country[4])=(upcase(acountry[b].country[4]))) then begin
          if (upcase(acountry[a].country[5])>(upcase(acountry[b].country[5]))) then begin
            acountry[temp]:=acountry[a];
            acountry[a]:=acountry[b];
            acountry[b]:=acountry[temp];
          end;
        end;
      end;
      if (upcase(acountry[a].country)<>'')and(upcase(acountry[b].country)<>'') then begin
        if (upcase(acountry[a].country[1])=(upcase(acountry[b].country[1])))and(upcase(acountry[a].country[2])=(upcase(acountry[b].country[2])))and(upcase(acountry[a].country[3])=(upcase(acountry[b].country[3])))and(upcase(acountry[a].country[4])=(upcase(acountry[b].country[4])))and(upcase(acountry[a].country[5])=(upcase(acountry[b].country[5]))) then begin
          if (upcase(acountry[a].country[6])>(upcase(acountry[b].country[6]))) then begin
            acountry[temp]:=acountry[a];
            acountry[a]:=acountry[b];
            acountry[b]:=acountry[temp];
          end;
        end;
      end;
      if (upcase(acountry[a].country)<>'')and(upcase(acountry[b].country)<>'') then begin
        if (upcase(acountry[a].country[1])=(upcase(acountry[b].country[1])))and(upcase(acountry[a].country[2])=(upcase(acountry[b].country[2])))and(upcase(acountry[a].country[3])=(upcase(acountry[b].country[3])))and(upcase(acountry[a].country[4])=(upcase(acountry[b].country[4])))and(upcase(acountry[a].country[5])=(upcase(acountry[b].country[5])))and(upcase(acountry[a].country[6])=(upcase(acountry[b].country[6]))) then begin
          if (upcase(acountry[a].country[7])>(upcase(acountry[b].country[7]))) then begin
            acountry[temp]:=acountry[a];
            acountry[a]:=acountry[b];
            acountry[b]:=acountry[temp];
          end;
        end;
      end;
      if (upcase(acountry[a].country)<>'')and(upcase(acountry[b].country)<>'') then begin
        if (upcase(acountry[a].country[1])=(upcase(acountry[b].country[1])))and(upcase(acountry[a].country[2])=(upcase(acountry[b].country[2])))and(upcase(acountry[a].country[3])=(upcase(acountry[b].country[3])))and(upcase(acountry[a].country[4])=(upcase(acountry[b].country[4])))and(upcase(acountry[a].country[5])=(upcase(acountry[b].country[5])))and(upcase(acountry[a].country[6])=(upcase(acountry[b].country[6])))and(upcase(acountry[a].country[7])=(upcase(acountry[b].country[7]))) then begin
          if (upcase(acountry[a].country[8])>(upcase(acountry[b].country[8]))) then begin
            acountry[temp]:=acountry[a];
            acountry[a]:=acountry[b];
            acountry[b]:=acountry[temp];
          end;
        end;
      end;
    end;
  end;
  acountry[temp].country:='';
  acountry[temp].attempts:=0;
end;

Procedure ReportOut;
var
  a:integer;
begin
  AssignFile(mccrpt,'rcsmcc.rpt');
  try
  rewrite(mccrpt);
  except
    on E: EInOutError do begin
      writeln('File handling error occurred. Details: ',E.Message);
    end;
  end;
  writeln(mccrpt);
  writeln(mccrpt,PadCenter(systemname,78));
  writeln(mccrpt,PadCenter('Connections by Country',78));
  writeln(mccrpt);
  writeln(mccrpt,PadCenter(dateto+' through '+datefrom,78));
  writeln(mccrpt);
  writeln(mccrpt,PadCenter(' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ',78));
  writeln(mccrpt);
  for a:=1 to lastrec do
  begin
    if acountry[a].country<>'' then begin
      write(mccrpt,'       ');
      write(mccrpt,(PadRight(acountry[a].country,55)));
      write(mccrpt,'     ');
      writeln(mccrpt,acountry[a].attempts);
    end;
  end;
  writeln(mccrpt);
  writeln(mccrpt,PadCenter(' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ',78));
  writeln(mccrpt);
  write(mccrpt,'       ');
  write(mccrpt,PadRight('Blocked Connections',60));
  writeln(mccrpt,IntToStr(blockedcon));
  writeln(mccrpt);
  writeln(mccrpt,PadCenter(' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ',78));
  writeln(mccrpt);
  writeln(mccrpt,PadCenter(prog+' v'+ver+' '+sysos,78));
  writeln(mccrpt,PadCenter(author,78));
  CloseFile(mccrpt);
end;

begin
  ProgramInit;
  ReadMIS;
  x:=1;
  Repeat
    if FileExists('logs'+PathDelim+'mis.'+IntToStr((StrToInt(logdate)+x))+'.log') then begin
      try
      AssignFile(fmislog,'logs'+PathDelim+'mis.'+IntToStr((StrToInt(logdate)+x))+'.log');
      reset(fmislog);
      except
        on E: EInOutError do begin
          writeln('File handling error occurred. Details: ',E.Message);
          ProgramHalt;
        end;
      end;
      ReadMIS;
      inc(x);
    end;
  Until FileExists('logs'+PathDelim+'mis.'+IntToStr((StrToInt(logdate)+x))+'.log')=false;
  DupeCheck;
  DataSort;
  ReportOut;
end.

