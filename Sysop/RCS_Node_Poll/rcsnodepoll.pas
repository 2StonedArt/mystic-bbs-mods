program rcsnodepoll;



{$mode objfpc}{$H+}
{$R *.res}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  {$IFDEF WINDOWS}
  windows,
  {$ENDIF}
  SysUtils, strutils, vinfo, versiontypes, DateUtils, classes;
  { you can add units after this }

const
  prog       = 'RCS Mystic Node Poll';
  author     = 'DRPanther(RCS)';
  ConfigFile = 'rcs.ini';

type
  n_connect = record
    node     : string[15];
    bconnect : boolean;
    nyear    : Smallint;
    nmonth   : byte;
    nday     : byte;
    ntime    : string[8];
  end;

var
  ver           : string;
  sysos         : string;
  path          : string;
  TicPath       : string;
  BBSName       : string;
  Sysop         : string;
  LogPath       : string;
  DateLogFormat : byte;
  MysticLogs    : string;
  fmislog       : textfile;   //mis.log
  ffplog        : textfile;   //fidopoll.log
  cffile        : textfile;   //config file mtafile.ini
  nprpt         : textfile;   //node poll report output
  //infile        : textfile;
  //outfile       : textfile;
  npdat         : file of n_connect;
  connect       : n_connect;
  lastrec       : integer;
  x             : integer;
  y             : integer;
  z             : integer;
  fpyear        : string;
  node          : string[15];
  nodeyear      : Smallint;
  nodemonth     : byte;
  nodeday       : byte;
  nodetime      : string[8];
  foundflag     : byte;
  currec        : integer;

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

Procedure ReadConfigFile;
var
  s       : string;
begin
  AssignFile(cffile, ConfigFile);
  lastrec:=1;
  try
  reset(cffile);
  While not eof(cffile) do begin
    s:='';
    readln(cffile, s);
    if AnsiStartsStr('TicPath=',s) then begin
      Delete(s, 1, 8);
      TicPath:=s;
    end;
    if AnsiStartsStr('BBS=',s) then begin
      Delete(s, 1, 4);
      BBSName:=s;
    end;
    if AnsiStartsStr('Sysop=',s) then begin
      Delete(s, 1, 6);
      Sysop:=s;
    end;
    if AnsiStartsStr('LogPath=',s) then begin
      Delete(s, 1, 8);
      LogPath:=s;
    end;
    if AnsiStartsStr('DateFormat=',s) then begin
      Delete(s,1,11);
      DateLogFormat:=StrToInt(s);
    end;
    if AnsiStartsStr('MysticLogs=',s) then begin
      Delete(s,1,11);
      MysticLogs:=s;
    end;
    if AnsiStartsStr('NodePoll=',s) then begin
      Delete(s,1,9);
      connect.node:=s;
      connect.nyear:=0;
      connect.nmonth:=0;
      connect.nday:=0;
      connect.ntime:='';
      connect.bconnect:=false;
      seek(npdat,lastrec);
      write(npdat,connect);
      inc(lastrec);
    end;
  end;
  except
    on E: EInOutError do begin
    writeln('File handling error occurred. Details: ',E.Message);
    end;
  end;
end;

Procedure LogFileCopy(filein,fileout:string);
var
  s,t:TFileStream;
begin
  s:=TFileStream.Create(filein,fmOpenRead);
  try
    t:=TFileStream.Create(fileout,fmCreate);
    try
      T.CopyFrom(s,S.Size);
    finally
      T.Free;
    end;
  finally
    S.Free;
  end;
end;

Procedure ProgramInit;
begin
  OSVersion;
  ProgVersion;
  path:=GetCurrentDir;
  AssignFile(npdat,path+PathDelim+'rcsnp.dat');
  rewrite(npdat);
  ReadConfigFile;
  if FileExists(MysticLogs+'mis.log') then
  begin
    if AnsiStartsStr('Linux',OSVersion) then begin
      LogFileCopy(MysticLogs+'mis.log',MysticLogs+'mis.rcs');
    end;
    try
    AssignFile(fmislog,MysticLogs+'mis.rcs');
    reset(fmislog);
    except
      on E: EInOutError do begin
        writeln('File handling error occurred. Details: ',E.Message);
        ProgramHalt;
      end;
    end;
  end
  else
  begin
    writeln('mis.log not found. Exiting...');
    ProgramHalt;
  end;
  if FileExists(MysticLogs+'fidopoll.log') then
  begin
    try
    AssignFile(ffplog,MysticLogs+'fidopoll.log');
    reset(ffplog);
    except
      on E: EInOutError do begin
        writeln('File handling error occurred. Details: ',E.Message);
        ProgramHalt;
      end;
    end;
  end
  else
  begin
    writeln('fidopoll.log not found. Exiting...');
    ProgramHalt;
  end;
end;

Function FindRecord(N:String): Integer; { Find Record Routine }
var
  foundrec  : integer;
  III       : integer;
Begin
  foundrec:=0;
  currec:=1;
  III:=0;
  foundflag:=0;
  repeat
   III := III + 1;
   Seek(npdat,III);
   Read(npdat,connect);
   If (connect.node) = (N) then
   begin
     foundrec:=III;
     foundflag:=1;
   end;
  until (III=lastrec) or (foundrec>0) or (eof(npdat));
 if foundrec=0 then
  Begin
   foundflag:=0;
  End;
 if foundrec>0 then
  begin
   currec:=III;
   foundflag:=1;
  end;
 if foundrec=0 then foundflag:=0;
 if foundrec>0 then FindRecord:=III;
End;

Procedure EditRecord;     { Edit Current Record Routine }
Begin
  seek(npdat,currec);
  Read(npdat,connect);
  if (nodeyear>=connect.nyear) then
  begin
    if (nodemonth>=connect.nmonth)then
    begin
      if (nodeday>=connect.nday) then
      begin
        connect.nyear:=nodeyear;
        connect.nmonth:=nodemonth;
        connect.nday:=nodeday;
        connect.ntime:=nodetime;
        connect.bconnect:=true;
        seek(npdat,currec);
        write(npdat,connect);
      end;
    end;
  end;
End;

Procedure ReadMIS;
var
  s : string;
  x : integer;
  p : integer;
  ti: integer;
begin
  x:=1;
  for x:=1 to 10 do
  begin
    while not eof(fmislog) do
    begin
      readln(fmislog,s);
      if AnsiContainsStr(s,'BINKP '+IntToStr(x)) then
        begin
          if AnsiContainsStr(s,'-Authenticating ') then
          begin
            p:=pos('-Authenticating ',s)+16;
            if AnsiContainsStr(s,'@') then
              begin
                node:=(ExtractSubStr(s,p,['@']));
              end
            else node:=(ExtractSubStr(s,p,[' ']));
            p:=pos('+ ',s)+2;
            nodeyear:=StrToInt(ExtractSubStr(s,p,['.']));
            p:=p;
            nodemonth:=StrToInt(ExtractSubStr(s,p,['.']));
            p:=p;
            nodeday:=StrToInt(ExtractSubStr(s,p,[' ']));
            p:=p;
            nodetime:=ExtractSubStr(s,p,[' ']);
            ti:=FindRecord(node);
            if (foundflag=1)and(connect.bconnect=false) then
            begin
              currec:=ti;
              EditRecord;
          end;
        end;
      end;
    end;
  end;
  CloseFile(fmislog);
  //DeleteFile(MysticLogs+'mis.rcs');
end;

Function MonthNumberToWord(tempmonth:integer):string;
var
  z : string;
begin
  case tempmonth of
    1 : z:='Jan';
    2 : z:='Feb';
    3 : z:='Mar';
    4 : z:='Apr';
    5 : z:='May';
    6 : z:='Jun';
    7 : z:='Jul';
    8 : z:='Aug';
    9 : z:='Sep';
    10 : z:='Oct';
    11 : z:='Nov';
    12 : z:='Dec';
  else
    z:='No data found';
  end;
  result:=z;
end;

Function MonthWordToNumber(tempmonth:string):integer;
var
  z : byte;
begin
  case tempmonth of
    'Jan' : z:=1;
    'Feb' : z:=2;
    'Mar' : z:=3;
    'Apr' : z:=4;
    'May' : z:=5;
    'Jun' : z:=6;
    'Jul' : z:=7;
    'Aug' : z:=8;
    'Sep' : z:=9;
    'Oct' : z:=10;
    'Nov' : z:=11;
    'Dec' : z:=12;
  end;
  result:=z;
end;

Procedure ReadFidoPoll;
var
  s         : string;
  p         : integer;
  monthtemp : string;
  ti        : integer;
begin
  while not eof(ffplog) do
  begin
    readln(ffplog,s);
    if AnsiContainsStr(s,'Queued') then
    begin
      p:=pos(' to ',s)+4;
      node:=(ExtractSubStr(s,p,[' ']));
      repeat
        if AnsiContainsStr(s,' R: OK ') then
        begin
          p:=1;
          monthtemp:=(ExtractSubStr(s,p,[' ']));
          nodeday:=StrToInt(ExtractWord(2,s,[' ']));
          nodemonth:=MonthWordToNumber(monthtemp);
          fpyear:=(FormatDateTime('YYYY',(Today-1)));
          nodeyear:=StrToInt(fpyear);
          nodetime:=ExtractWord(3,s,[' ']);
          ti:=FindRecord(node);
          if (foundflag=1)and(connect.bconnect=false) then
          begin
            currec:=ti;
            editrecord;
          end;
        end;
        readln(ffplog,s);
      until (AnsiContainsStr(s,' Scanning '))or(eof(ffplog));
    end;
  end;
end;

Procedure ReportOut;
var
  a:integer;
begin
  AssignFile(nprpt,'rcsnp.rpt');
  try
  rewrite(nprpt);
  except
    on E: EInOutError do begin
      writeln('File handling error occurred. Details: ',E.Message);
    end;
  end;
  writeln(nprpt);
  writeln(nprpt,PadCenter('Node Latest Connections',78));
  writeln(nprpt,PadCenter(BBSName,78));
  writeln(nprpt);
  writeln(nprpt,PadCenter(' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ',78));
  writeln(nprpt);
  writeln(nprpt,'                      Node           Date        Time');
  writeln(nprpt);
  for a:=1 to lastrec-1 do
  begin
    seek(npdat,a);
    read(npdat,connect);
    if connect.node<>'' then begin
      if DateLogFormat=1 then
      begin
        write(nprpt,'                      ');
        write(nprpt,PadRight(connect.node,15));
        if connect.nday<>0 then write(nprpt,(AddChar('0',(IntToStr(connect.nday)),2)));
        write(nprpt,' ');
        write(nprpt,(AddChar('0',(MonthNumberToWord(connect.nmonth)),2)));
        write(nprpt,' ');
        if connect.nyear<>0 then write(nprpt,(AddCharR('0',(IntToStr(connect.nyear)),4)));
        writeln(nprpt,PadLeft(connect.ntime,10));
      end;
      if DateLogFormat=2 then
      begin
        write(nprpt,'                      ');
        write(nprpt,PadRight(connect.node,15));
        if connect.nday<>0 then write(nprpt,(AddChar('0',(IntToStr(connect.nday)),2)));
        write(nprpt,'/');
        if connect.nmonth=0 then write(nprpt,(' No data found '))
        else write(nprpt,(AddChar('0',(IntToStr(connect.nmonth)),2)));
        write(nprpt,'/');
        if connect.nyear<>0 then write(nprpt,(AddCharR('0',(IntToStr(connect.nyear)),4)));
        writeln(nprpt,PadLeft(connect.ntime,10));
      end;
      if DateLogFormat=3 then
      begin
        write(nprpt,'                      ');
        write(nprpt,PadRight(connect.node,15));
        if connect.nmonth=0 then write(nprpt,(' No data found '))
        else write(nprpt,(AddChar('0',(IntToStr(connect.nmonth)),2)));
        write(nprpt,'/');
        if connect.nday<>0 then write(nprpt,(AddChar('0',(IntToStr(connect.nday)),2)));
        write(nprpt,'/');
        if connect.nyear<>0 then write(nprpt,(AddCharR('0',(IntToStr(connect.nyear)),4)));
        writeln(nprpt,PadLeft(connect.ntime,10));
      end;
    end;
  end;
  writeln(nprpt);
  writeln(nprpt,PadCenter(' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ',78));
  writeln(nprpt);
  writeln(nprpt,PadCenter('* All dates and times are local system time *',78));
  writeln(nprpt,PadCenter('Report Generated: '+FormatDateTime('dd mmm yyyy hh:nn:ss',(now)),78));
  writeln(nprpt);
  writeln(nprpt,PadCenter(prog+' v'+ver+' '+sysos,78));
  writeln(nprpt,PadCenter(author,78));
  CloseFile(nprpt);
end;

Procedure wrapup;
var
  x:integer;
begin
  x:=1;
  if (FileExists(MysticLogs+'mis.rcs'))then DeleteFile(MysticLogs+'mis.rcs');
  Repeat
    if (FileExists(MysticLogs+'mis.'+IntToStr(x)+'.rcs'))then DeleteFile(MysticLogs+'mis.'+IntToStr(x)+'.rcs');
    inc(x);
  until FileExists(MysticLogs+'mis.'+IntToStr(x)+'.rcs')=false;
end;

begin
  ProgramInit;
  ReadMIS;
  x:=1;
  y:=1;
  z:=1;
  Repeat
    if FileExists(MysticLogs+'mis.'+IntToStr(x)+'.log') then begin
      try
      LogFileCopy(MysticLogs+'mis.'+IntToStr(x)+'.log',MysticLogs+'mis.'+IntToStr(x)+'.rcs');
      AssignFile(fmislog,MysticLogs+'mis.'+IntToStr(x)+'.log');
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
  Until FileExists(MysticLogs+'mis.'+IntToStr(x)+'.log')=false;
  x:=1;
  ReadFidoPoll;
  Repeat
    if FileExists(MysticLogs+'fidopoll.'+IntToStr(x)+'.log') then begin
      try
      AssignFile(ffplog,MysticLogs+'fidopoll.'+IntToStr(x)+'.log');
      reset(ffplog);
      except
        on E: EInOutError do begin
          writeln('File handling error occurred. Details: ',E.Message);
          ProgramHalt;
        end;
      end;
      ReadFidoPoll;
      inc(x);
    end;
  Until FileExists(MysticLogs+'fidopoll.'+IntToStr(x)+'.log')=false;
  if DirectoryExists(MysticLogs+fpyear)then
  begin
    For x:=12 downto 1 do
    begin
      if DirectoryExists(MysticLogs+fpyear+PathDelim+IntToStr(x)) then
      begin
        For y:=31 downto 1 do
        begin
          if DirectoryExists(MysticLogs+fpyear+PathDelim+IntToStr(x)+PathDelim+IntToStr(y)) then
          begin
            if FileExists(MysticLogs+fpyear+PathDelim+IntToStr(x)+PathDelim+IntToStr(y)+PathDelim+'mis.log') then
            begin
              AssignFile(fmislog,MysticLogs+fpyear+PathDelim+IntToStr(x)+PathDelim+IntToStr(y)+PathDelim+'mis.log');
              reset(fmislog);
              ReadMIS;
            end;
            repeat
              if FileExists(MysticLogs+fpyear+PathDelim+IntToStr(x)+PathDelim+IntToStr(y)+PathDelim+'mis.'+IntToStr(z)+'.log') then
              begin
                AssignFile(fmislog,MysticLogs+fpyear+PathDelim+IntToStr(x)+PathDelim+IntToStr(y)+PathDelim+'mis.'+IntToStr(z)+'.log');
                reset(fmislog);
                ReadMIS;
                inc(z);
              end;
            until FileExists(MysticLogs+fpyear+PathDelim+IntToStr(x)+PathDelim+IntToStr(y)+PathDelim+'mis.'+IntToStr(z)+'.log')=false;
            z:=1;
            if FileExists(MysticLogs+fpyear+PathDelim+IntToStr(x)+PathDelim+IntToStr(y)+PathDelim+'fidopoll.log') then
            begin
              AssignFile(fmislog,MysticLogs+fpyear+PathDelim+IntToStr(x)+PathDelim+IntToStr(y)+PathDelim+'fidopoll.log');
              reset(ffplog);
              ReadFidoPoll;
            end;
            repeat
              if FileExists(MysticLogs+fpyear+PathDelim+IntToStr(x)+PathDelim+IntToStr(y)+PathDelim+'fidopoll.'+IntToStr(z)+'.log') then
              begin
                AssignFile(fmislog,MysticLogs+fpyear+PathDelim+IntToStr(x)+PathDelim+IntToStr(y)+PathDelim+'fidopoll.'+IntToStr(z)+'.log');
                reset(ffplog);
                ReadFidoPoll;
                inc(z);
              end;
            until FileExists(MysticLogs+fpyear+PathDelim+IntToStr(x)+PathDelim+IntToStr(y)+PathDelim+'fidopoll.'+IntToStr(z)+'.log')=false;
          end;
        end;
      end;
    end;
  end;
  ReportOut;
  wrapup;
end.

