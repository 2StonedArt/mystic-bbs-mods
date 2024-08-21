program mtafile;

{ Myst Tic Announce Files

  Copyright (C) 2018 Black Panther aka Dan Richter dan@castlerockbbs.com

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.

  https://www.gnu.org/licenses/gpl-2.0.html
}

{ Version bump for initial open source release }

{ TODO : Insert command to generate report to show hatched files via Mystic log files }


{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils, strutils, DateUtils, vinfo, versiontypes;

{$R *.res}

const
  O_FNAME    = 'mtafile.rpt';
  LogFile    = 'mtafile.log';
  prog       = 'RCS Mys Tic File Announce';
  author     = 'DRPanther(RCS)';
  ConfigFile = 'rcs.ini';

type
  ticfiles = record
    area     : string;
    areadesc : string;
    filename : string;
    size     : integer;
    desc     : array [1..60] of string;
    ldesc    : array [1..60] of string;
    origin   : string;
    magic    : string;
    replaces : string;
    delete   : boolean;
  end;

  datafile = record
    datadate   : string[13];
    dcount     : integer;
    dsize      : integer;
  end;

var
  tic       : array [1..512] of ticfiles;
  filedat   : array [1..365] of datafile;
  datfile   : textfile;
  tfIn      : TextFile;
  tfOut     : TextFile;
  tfLog     : TextFile;
  header    : TextFile;
  footer    : TextFile;
  final     : TextFile;
  cffile    : TextFile;
  tfRepOut  : TextFile;
  TicPath   : string;
  BBSName   : string;
  Sysop     : string;
  LogPath   : string;
  bbs       : string;
  info      : TSearchRec;
  Count     : Int64;
  repbool   : boolean;
  bool2     : boolean;
  bool3     : boolean;
  path      : string;
  path1     : string;
  path2     : string;
  received  : string;
  com1      : string;
  com2      : string;
  lastrec   : integer;
  s         : ansistring;
  i         : LongInt;
  d         : integer;
  p         : integer;
  x         : Int64;
  n         : integer;
  y         : integer;
  z         : integer;
  a         : Longint;
  e         : integer;
  v         : integer;
  b         : integer;
  c         : integer;
  f         : integer;
  sysos     : string;
  ver       : string;
  logbool   : boolean=false;       //debug logging toggle true=debug false=informational

function OSVersion: String;
//Determines the OS and bit on which the program in compiled
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

Function commainsert(com:string):string;
//Inserts a comma into numbers larger than 1000
var
  len : integer;
begin
  result:='';
  len:=Length(com);
  case(len) of
    4:insert(',',com,2);
    5:insert(',',com,3);
    6:insert(',',com,4);
    7:begin
      insert(',',com,5);
      insert(',',com,2);
      end;
    8:begin
      insert(',',com,6);
      insert(',',com,3);
      end;
    9:begin
      insert(',',com,7);
      insert(',',com,4);
      end;
    10:begin
      insert(',',com,8);
      insert(',',com,5);
      insert(',',com,2);
      end;
    11:begin
      insert(',',com,9);
      insert(',',com,6);
      insert(',',com,3);
      end;
  end;
  com2:=com;
  result:=com;
end;

Procedure mtahelp;
//Command line help file
begin
    writeln;
    writeln('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
    writeln;
    writeln(prog+' '+ver);
    writeln;
    writeln('''-a'' - Run MTAFile in Announce mode - mtafile -a');
    writeln('''-r'' - Run MTAFile in Reports mode - mtafile -r #');
    writeln('''-h'' or ''?'' - Show help file - mtafile -h or mtafile ?');
    writeln;
    writeln('All commands must be run individually of each other');
    writeln('You will get an error if you try ''-a -r 7''.');
    writeln;
    writeln('The number sign after the -r, is how many entries the program');
    writeln('should generate the report for. If you use ''-r 7'', you will');
    writeln('get the last 7 entries in the mtafile.dat file.');
    writeln;
    writeln('If the -r command is used, the program will NOT process any .tic');
    writeln('files in that run. It must be run seperately as another command');
    writeln;
    writeln('Example...');
    if OSVersion='Linux' then begin
      writeln(sysos,':');
      writeln('./mtafile -a');
      writeln('./mtafile -r 7');
    end;
    if AnsiStartsStr('Windows',OSVersion) then begin
      writeln(sysos,':');
      writeln('mtafile -a');
      writeln('mtafile -r 7');
    end;
    writeln;
    writeln(author);
    writeln;
    writeln('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
    writeln;
    halt;
end;

Procedure LogDate;
//Saves typing :)
begin
  write(tfLog,FormatDateTime('yyyy mmm dd hh:nn:ss',(Now)));
end;

Procedure LogBreak;
//Ditto :)
begin
  writeln(tfLog,' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ');
end;

Procedure ReadConfig;
//Reads the relevant information from the rcs.ini config file
begin
  AssignFile(cffile, ConfigFile);
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
      LogPath:=s+LogFile;
    end;
  end;
  except
    on E: EInOutError do begin
    writeln('File handling error occurred. Details: ',E.Message);
    end;
  end;
end;

function ProductVersionToString(PV: TFileProductVersion): String;
   begin
     Result := Format('%d.%d.%d.%d', [PV[0],PV[1],PV[2],PV[3]])
   end;

procedure ProgVersion;
//Pulls the version information from Lazarus
var
   Info: TVersionInfo;
begin
   Info := TVersionInfo.Create;
   Info.Load(HINSTANCE);
   ver:=(ProductVersionToString(Info.FixedInfo.FileVersion));
   Info.Free;
end;

Procedure startup;
begin
  path:='';
  ReadConfig;
  AssignFile(tfOut, path+O_FNAME);
  AssignFile(tfLog, LogPath);
  path:=GetCurrentDir;
  path1:=(path+PathDelim+O_FNAME);
  AssignFile(datfile,path+PathDelim+'mtafile.dat'); //should change this to a data file
  if fileexists(LogPath)=false then Rewrite(tfLog)
    else append(tflog);
  Count:=0;
  com1:='';
  com2:='';
  bool2:=false;
  d:=1;
  x:=0;
  n:=1;
  y:=1;
  i:=1;
  c:=1;
  repbool:=false;
  Lastrec:=1;
  LogBreak;
  LogDate;
  writeln(tfLog,' ',prog,' ',ver);
  LogDate;
  write(tfLog,' ');
  for i:=0 to ParamCount do begin
    write (tfLog,ParamStr (i));
    write (tfLog,' ');
  end;
  writeln(tfLog);
end;

Procedure ProgramEnd;
//This should be changed to a function to take the exitcode as a parameter
begin
  CloseFile(tfLog);
  halt(1);
end;

Procedure TicSetup;
//This procedure adds '.tic' to any file that contains .TIC
//This is done, so that all tic files have the same extension in 
//case sensative OS's, such as Linux
begin
  chdir(TicPath);
  If FindFirst ('*.TIC',faAnyFile, Info)=0 then
  begin
    Repeat
      RenameFile(info.Name,info.Name+'.tic');
    until FindNext(info)<>0;
  end;
  FindClose(Info);
  If FindFirst('*.tic',faAnyFile, Info)<>0 then
  begin
    writeln('There are no .tic files in this directory!');
    LogDate;
    LogBreak;
    LogDate;
    writeln(tfLog,' MTAFile is unable to find any .tic files in the given directory');
    ProgramEnd;
  end;
end;

Procedure TicRead;
//There is probably a better way to run this procedure
begin
  If FindFirst ('*.tic',faAnyFile, Info)=0 then
  begin
    Rewrite(tfOut);
    Repeat
      tic[d].area:='';
      tic[d].areadesc:='';
      tic[d].filename:='';
      tic[d].size:=0;
      tic[d].desc[d]:='';
      tic[d].ldesc[d]:='';
      tic[d].origin:='';
      tic[d].magic:='';
      tic[d].replaces:='';
      tic[d].delete:=false;
      if logbool=true then begin
        LogDate;
        LogBreak;
        LogDate;
        write(tfLog,' Reading TIC File Name - ');
        writeln(tfLog,info.Name);
      end;
      AssignFile(tfIn,info.Name);
      try
        {$I-}
        reset(tfIn);
        {$I+}
        if (IOResult<>0) then
        begin
          writeln('The file could not be opened!');
          LogDate;
          writeln(tfLog,' Error: The TIC file could not be opened');
          break;
        end;
        While not eof(tfIn) do
        begin
          s:='';
          readln(tfIn, s);
          //Reads the Area from TIC file
          if AnsiStartsStr('Area ',s) then begin
            p:=6;
            tic[d].area:=(ExtractSubstr(s, p, [' ']));
            if logbool=true then begin
              LogDate;
              write(tfLog,' Area - ');
              writeln(tfLog,tic[d].area);
            end;
          end;
          //Reads the Area Description from TIC file
          if AnsiStartsStr('Areadesc ',s) then begin
            Delete(s,1,9);
            tic[d].areadesc:=s;
          end;
          if tic[d].areadesc='' then begin
            if AnsiStartsStr('AreaDesc ',s) then begin
              Delete(s,1,9);
              tic[d].areadesc:=s;
            end;
          end;
          //Reads the Filename from TIC file
          if AnsiStartsStr('File ',s) then begin
            p:=6;
            tic[d].filename:=(ExtractSubstr(s, p, [' ']));
            if logbool=true then begin
              LogDate;
              Write(tfLog,' Filename - ');
              writeln(tfLog,tic[d].filename);
            end;
          end;
          //Reads the File Size from TIC file
          if AnsiStartsStr('Size ',s) then begin
            p:=6;
            tic[d].size:=(StrToInt(ExtractSubstr(s,p,[' '])));
            x:=x+tic[d].size;
          end;
          //Reads the Long Description from TIC file
          if AnsiStartsStr('LDesc ',s) then begin
            Delete(s,1,5);
            tic[d].ldesc[n]:=s;
            inc(n);
          end;
          //Reads the Description from TIC file
          if (AnsiStartsStr('Desc ',s)) and (bool2=false) then begin
            Delete(s,1,5);
            tic[d].desc[y]:=s;
           inc(y);
            if y=41 then bool2:=true;
          end;
          //Reads the Origin from TIC file
          if AnsiStartsStr('Origin ',s) then begin
            Delete(s,1,7);
            tic[d].origin:=s;
          end;
          //Reads the From, if Origin is absent from TIC file
          if tic[d].origin='' then begin
            if AnsiStartsStr('From ',s) then begin
              Delete(s,1,5);
              tic[d].origin:=s;
            end;
          end;
          //Reads the Magic name from the TIC file
          if AnsiStartsStr('Magic ',s) then begin
            Delete(s,1,6);
            tic[d].magic:=s;
          end;
          //Reads the Replaces from TIC file
          if AnsiStartsStr('Replaces ',s) then begin
            Delete(s,1,9);
            tic[d].replaces:=s;
          end;
        end;
        if tic[d].areadesc='' then tic[d].areadesc:=tic[d].area;

        bool2:=false;
        n:=1;
        y:=1;
        //Remove the processed TIC file
        CloseFile(tfIn);
        DeleteFile(info.Name);

      except
        on E: EInOutError do begin
        writeln('File handling error occurred. Details: ',E.Message);
        LogDate;
        writeln(tfLog,' A File handling error occurred. Details: ',E.Message);

        end;
      end;
      inc(d);
      inc(lastrec);
      inc(count);
    until FindNext(info)<>0;
  end;
  FindClose(Info);
  if FileExists(path1) then DeleteFile(path1);
  RenameFile('mtafile.rpt',path1);

end;

Procedure DupeCheck;
//There's probably a better way to do the dupe checking as well
begin
  z:=1;
  d:=1;
  if logbool=true then begin
    LogDate;
    LogBreak;
  end;
  LogDate;
  writeln(tfLog,' Checking for duplicate file names');
  for d:=1 to lastrec do begin
    for z:=d+1 to lastrec do begin
      if not (tic[d].delete)and not (tic[z].delete) then begin
        if (upcase(tic[d].area))=(upcase(tic[z].area)) then begin
          if (upcase(tic[d].filename))=(upcase(tic[z].filename)) then begin
            if logbool=true then begin
              LogDate;
              LogBreak;
              LogDate;
              write(tfLog,' Found duplicate filename: ');
              write(tfLog,tic[z].filename);
              write(tfLog,' in ');
              writeln(tfLog, tic[z].area);
            end;
            tic[z].filename:='';
            tic[z].area:='';
            tic[z].size:=0;
            tic[z].delete:=true;
          end;
        end;
      end;
    end;
  end;
end;

Procedure FindLowFile;
//This should be in a loop, so it not such a mess
var
  temp:integer;
begin
  z:=1;
  d:=1;
  i:=lastrec-1;
  temp:=lastrec;
  for d:=1 to i do begin
    for z:=d+1 to i do begin
      if (upcase(tic[d].filename)<>'')and(upcase(tic[z].filename)<>'') then begin
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])>(upcase(tic[z].filename[1]))) then begin
          tic[temp]:=tic[d];
          tic[d]:=tic[z];
          tic[z]:=tic[temp];
          tic[temp].area:='';
          tic[temp].filename:='';
        end;
      end;
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])=(upcase(tic[z].filename[1]))) then begin
          if (upcase(tic[d].filename[2])>(upcase(tic[z].filename[2]))) then begin
            tic[lastrec]:=tic[d];
            tic[d]:=tic[z];
            tic[z]:=tic[lastrec];
          end;
        end;
      end;
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])=(upcase(tic[z].filename[1])))and(upcase(tic[d].filename[2])=(upcase(tic[z].filename[2]))) then begin
          if (upcase(tic[d].filename[3])>(upcase(tic[z].filename[3]))) then begin
            tic[lastrec]:=tic[d];
            tic[d]:=tic[z];
            tic[z]:=tic[lastrec];
          end;
        end;
      end;
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])=(upcase(tic[z].filename[1])))and(upcase(tic[d].filename[2])=(upcase(tic[z].filename[2])))and(upcase(tic[d].filename[3])=(upcase(tic[z].filename[3]))) then begin
          if (upcase(tic[d].filename[4])>(upcase(tic[z].filename[4]))) then begin
            tic[lastrec]:=tic[d];
            tic[d]:=tic[z];
            tic[z]:=tic[lastrec];
          end;
        end;
      end;
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])=(upcase(tic[z].filename[1])))and(upcase(tic[d].filename[2])=(upcase(tic[z].filename[2])))and(upcase(tic[d].filename[3])=(upcase(tic[z].filename[3])))and(upcase(tic[d].filename[4])=(upcase(tic[z].filename[4]))) then begin
          if (upcase(tic[d].filename[5])>(upcase(tic[z].filename[5]))) then begin
            tic[lastrec]:=tic[d];
            tic[d]:=tic[z];
            tic[z]:=tic[lastrec];
          end;
        end;
      end;
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])=(upcase(tic[z].filename[1])))and(upcase(tic[d].filename[2])=(upcase(tic[z].filename[2])))and(upcase(tic[d].filename[3])=(upcase(tic[z].filename[3])))and(upcase(tic[d].filename[4])=(upcase(tic[z].filename[4])))and(upcase(tic[d].filename[5])=(upcase(tic[z].filename[5]))) then begin
          if (upcase(tic[d].filename[6])>(upcase(tic[z].filename[6]))) then begin
            tic[lastrec]:=tic[d];
            tic[d]:=tic[z];
            tic[z]:=tic[lastrec];
          end;
        end;
      end;
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])=(upcase(tic[z].filename[1])))and(upcase(tic[d].filename[2])=(upcase(tic[z].filename[2])))and(upcase(tic[d].filename[3])=(upcase(tic[z].filename[3])))and(upcase(tic[d].filename[4])=(upcase(tic[z].filename[4])))and(upcase(tic[d].filename[5])=(upcase(tic[z].filename[5])))and(upcase(tic[d].filename[6])=(upcase(tic[z].filename[6]))) then begin
          if (upcase(tic[d].filename[7])>(upcase(tic[z].filename[7]))) then begin
            tic[lastrec]:=tic[d];
            tic[d]:=tic[z];
            tic[z]:=tic[lastrec];
          end;
        end;
      end;
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])=(upcase(tic[z].filename[1])))and(upcase(tic[d].filename[2])=(upcase(tic[z].filename[2])))and(upcase(tic[d].filename[3])=(upcase(tic[z].filename[3])))and(upcase(tic[d].filename[4])=(upcase(tic[z].filename[4])))and(upcase(tic[d].filename[5])=(upcase(tic[z].filename[5])))and(upcase(tic[d].filename[6])=(upcase(tic[z].filename[6])))and(upcase(tic[d].filename[7])=(upcase(tic[z].filename[7]))) then begin
          if (upcase(tic[d].filename[8])>(upcase(tic[z].filename[8]))) then begin
            tic[lastrec]:=tic[d];
            tic[d]:=tic[z];
            tic[z]:=tic[lastrec];
          end;
        end;
      end;
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])=(upcase(tic[z].filename[1])))and(upcase(tic[d].filename[2])=(upcase(tic[z].filename[2])))and(upcase(tic[d].filename[3])=(upcase(tic[z].filename[3])))and(upcase(tic[d].filename[4])=(upcase(tic[z].filename[4])))and(upcase(tic[d].filename[5])=(upcase(tic[z].filename[5])))and(upcase(tic[d].filename[6])=(upcase(tic[z].filename[6])))and(upcase(tic[d].filename[7])=(upcase(tic[z].filename[7])))and(upcase(tic[d].filename[8])=(upcase(tic[z].filename[8]))) then begin
          if (upcase(tic[d].filename[9])>(upcase(tic[z].filename[9]))) then begin
            tic[lastrec]:=tic[d];
            tic[d]:=tic[z];
            tic[z]:=tic[lastrec];
          end;
        end;
      end;
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])=(upcase(tic[z].filename[1])))and(upcase(tic[d].filename[2])=(upcase(tic[z].filename[2])))and(upcase(tic[d].filename[3])=(upcase(tic[z].filename[3])))and(upcase(tic[d].filename[4])=(upcase(tic[z].filename[4])))and(upcase(tic[d].filename[5])=(upcase(tic[z].filename[5])))and(upcase(tic[d].filename[6])=(upcase(tic[z].filename[6])))and(upcase(tic[d].filename[7])=(upcase(tic[z].filename[7])))and(upcase(tic[d].filename[8])=(upcase(tic[z].filename[8])))and(upcase(tic[d].filename[9])=(upcase(tic[z].filename[9]))) then begin
          if (upcase(tic[d].filename[10])>(upcase(tic[z].filename[10]))) then begin
            tic[lastrec]:=tic[d];
            tic[d]:=tic[z];
            tic[z]:=tic[lastrec];
          end;
        end;
      end;
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])=(upcase(tic[z].filename[1])))and(upcase(tic[d].filename[2])=(upcase(tic[z].filename[2])))and(upcase(tic[d].filename[3])=(upcase(tic[z].filename[3])))and(upcase(tic[d].filename[4])=(upcase(tic[z].filename[4])))and(upcase(tic[d].filename[5])=(upcase(tic[z].filename[5])))and(upcase(tic[d].filename[6])=(upcase(tic[z].filename[6])))and(upcase(tic[d].filename[7])=(upcase(tic[z].filename[7])))and(upcase(tic[d].filename[8])=(upcase(tic[z].filename[8])))and(upcase(tic[d].filename[9])=(upcase(tic[z].filename[9])))and(upcase(tic[d].filename[10])=(upcase(tic[z].filename[10]))) then begin
          if (upcase(tic[d].filename[11])>(upcase(tic[z].filename[11]))) then begin
            tic[lastrec]:=tic[d];
            tic[d]:=tic[z];
            tic[z]:=tic[lastrec];
          end;
        end;
      end;
      if (upcase(tic[d].area)=(upcase(tic[z].area))) then begin
        if (upcase(tic[d].filename[1])=(upcase(tic[z].filename[1])))and(upcase(tic[d].filename[2])=(upcase(tic[z].filename[2])))and(upcase(tic[d].filename[3])=(upcase(tic[z].filename[3])))and(upcase(tic[d].filename[4])=(upcase(tic[z].filename[4])))and(upcase(tic[d].filename[5])=(upcase(tic[z].filename[5])))and(upcase(tic[d].filename[6])=(upcase(tic[z].filename[6])))and(upcase(tic[d].filename[7])=(upcase(tic[z].filename[7])))and(upcase(tic[d].filename[8])=(upcase(tic[z].filename[8])))and(upcase(tic[d].filename[9])=(upcase(tic[z].filename[9])))and(upcase(tic[d].filename[10])=(upcase(tic[z].filename[10])))and(upcase(tic[d].filename[11])=(upcase(tic[z].filename[11]))) then begin
          if (upcase(tic[d].filename[12])>(upcase(tic[z].filename[12]))) then begin
            tic[lastrec]:=tic[d];
            tic[d]:=tic[z];
            tic[z]:=tic[lastrec];
          end;
        end;
       end;
      end;
    end;
  end;
end;

Procedure FindLowArea;
//Finally got the sorting worked out. It's a long process, but it works. I'm sure there's better ways to do this
//This should also be in some type of loop
var
  temp:integer;
begin
  z:=1;
  d:=1;
  i:=lastrec-1;
  temp:=lastrec;
  for d:=1 to i do begin
    for z:=d+1 to i do begin
      if (upcase(tic[z].filename)<>'')and(upcase(tic[d].filename)<>'') then begin
      if (upcase(tic[d].area[1]) > (upcase(tic[z].area[1]))) and (tic[d].area<>'') and (tic[z].area<>'') then begin
        tic[temp]:=tic[d];
        tic[d]:=tic[z];
        tic[z]:=tic[temp];
        tic[temp].area:='';
        tic[temp].filename:='';
      end;
      if (upcase(tic[d].area[1]) = (upcase(tic[z].area[1]))) then begin
        if ((upcase(tic[d].area[2])) > (upcase(tic[z].area[2]))) and (tic[d].area<>'') and (tic[z].area<>'') then begin
          tic[lastrec]:=tic[d];
          tic[d]:=tic[z];
          tic[z]:=tic[lastrec];
        end;
      end;
      if (upcase(tic[d].area[1]) = (upcase(tic[z].area[1]))) and (upcase(tic[d].area[2]) = (upcase(tic[z].area[2]))) then begin
        if ((upcase(tic[d].area[3])) > (upcase(tic[z].area[3]))) and (tic[d].area<>'') and (tic[z].area<>'') then begin
          tic[lastrec]:=tic[d];
          tic[d]:=tic[z];
          tic[z]:=tic[lastrec];
        end;
      end;
      if (upcase(tic[d].area[1])=(upcase(tic[z].area[1])))and(upcase(tic[d].area[2])=(upcase(tic[z].area[2])))and(upcase(tic[d].area[3])=(upcase(tic[z].area[3]))) then begin
        if ((upcase(tic[d].area[4])) > (upcase(tic[z].area[4]))) and (tic[d].area<>'') and (tic[z].area<>'') then begin
          tic[lastrec]:=tic[d];
          tic[d]:=tic[z];
          tic[z]:=tic[lastrec];
        end;
      end;
      if (upcase(tic[d].area[1])=(upcase(tic[z].area[1])))and(upcase(tic[d].area[2])=(upcase(tic[z].area[2])))and(upcase(tic[d].area[3])=(upcase(tic[z].area[3])))and(upcase(tic[d].area[4])=(upcase(tic[z].area[4]))) then begin
        if ((upcase(tic[d].area[5])) > (upcase(tic[z].area[5]))) and (tic[d].area<>'') and (tic[z].area<>'') then begin
          tic[lastrec]:=tic[d];
          tic[d]:=tic[z];
          tic[z]:=tic[lastrec];
        end;
      end;
      if (upcase(tic[d].area[1])=(upcase(tic[z].area[1])))and(upcase(tic[d].area[2])=(upcase(tic[z].area[2])))and(upcase(tic[d].area[3])=(upcase(tic[z].area[3])))and(upcase(tic[d].area[4])=(upcase(tic[z].area[4])))and(upcase(tic[d].area[5])=(upcase(tic[z].area[5]))) then begin
        if ((upcase(tic[d].area[6])) > (upcase(tic[z].area[6]))) and (tic[d].area<>'') and (tic[z].area<>'') then begin
          tic[lastrec]:=tic[d];
          tic[d]:=tic[z];
          tic[z]:=tic[lastrec];
        end;
      end;
      if (upcase(tic[d].area[1])=(upcase(tic[z].area[1])))and(upcase(tic[d].area[2])=(upcase(tic[z].area[2])))and(upcase(tic[d].area[3])=(upcase(tic[z].area[3])))and(upcase(tic[d].area[4])=(upcase(tic[z].area[4])))and(upcase(tic[d].area[5])=(upcase(tic[z].area[5])))and(upcase(tic[d].area[6])=(upcase(tic[z].area[6]))) then begin
        if ((upcase(tic[d].area[7])) > (upcase(tic[z].area[7]))) and (tic[d].area<>'') and (tic[z].area<>'') then begin
          tic[lastrec]:=tic[d];
          tic[d]:=tic[z];
          tic[z]:=tic[lastrec];
        end;
      end;

      end;
    end;
  end;
end;

Procedure LineBreak;
//This should take the parameter of which filename to writeln to
//perhaps:
// Procedure LineBreak(filename:string);
// begin
//   writeln(filename,' -=-=-=-=-=-=-=-=-=-=-=-=-=- ');
// end;
begin
  writeln(tfOut,' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ');
end;

Procedure RepLineBreak;
//So it doesn't have to be duplicated for each output file
begin
  writeln(tfRepOut,' -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ');
end;

Procedure FileBreak;
//Yup. It's a bit redundant
begin
  writeln(tfOut,' --------------------------------------------------------------------------- ');
end;

Procedure AreaBreak;
//Inserts a break between areas in the output file
begin
  LineBreak;
  write(tfOut,' ');
  write(tfOut,PadRight(upcase(tic[c].area),14));
  write(tfOut,' -=:=-      ');
  writeln(tfOut,PadRight(tic[c].areadesc,16));
  LineBreak;
  writeln(tfOut);
end;

Function AddLetter(y:longword):string;
//This function changes long numbers into short numbers followed by k, m, or g
var
  s:string;
  k:boolean;
  m:boolean;
  g:boolean;
begin
  s:='';
  k:=false;
  m:=false;
  g:=false;
  if y >= 1024 then begin
    y:=(y div 1024);
    k:=true;
    if y >= 1024 then begin
      y:=(y div 1024);
      m:=true;
      k:=false;
      if y >= 1024 then begin
        y:=(y div 1024);
        g:=true;
        m:=false;
//        s:=inttostr(y)+'g';
      end;
//    s:=IntToStr(y)+'m';
    end;
//  s:=IntToStr(y)+'k';
  end
  else s:=IntToStr(y)+' bytes';
  if k = true then s:=IntToStr(y)+' Kb';
  if m = true then s:=IntToStr(y)+' Mb';
  if g = true then s:=IntToStr(y)+' Gb';
  result:=s;
end;

Procedure InsertFooter;
//A bit messy, but inserts a footer in the daily output file
begin
  b:=78;
   bbs:='';
   received:='';
   writeln(tfOut);
   LineBreak;
   writeln(tfOut);
   bbs:=BBSName;
   write(tfOut,(PadCenter(bbs,b)));
   //commainsert(IntToStr(x));          //removed when the Kb, Mb, etc was added
   writeln(tfOut);
   bbs:='';
   Insert(' files',received,1);
   str(Count,bbs);
   Insert(bbs,received,1);
   Insert(' in ',received,1);
   Insert(AddLetter(x),received,1);
   //Insert('Received ',received,1);     //Removed the word 'Received', as a system is using to announce hatched files, not incoming
   writeln(tfOut,PadCenter(Received,b));
   writeln(tfOut);
   LineBreak;
   writeln(tfOut);
   bbs:='';
   Insert(sysos,bbs,1);
   Insert(' ',bbs,1);
   Insert(ver,bbs,1);
   Insert(' v',bbs,1);
   Insert(prog,bbs,1);
   writeln(tfOut,PadCenter('Report generated by: ',b));
   writeln(tfOut,PadCenter(bbs,b));
   bbs:=FormatDateTime('dd mmm yyyy hh:nn:ss',(Now));
   writeln(tfOut,PadCenter(bbs,b));
   writeln(tfOut);
   bbs:='';
   Insert('CRBBS(RCS)(2017-2019)',bbs,1);
   writeln(tfOut,PadCenter(bbs,b));
   writeln(tfOut);
end;

Procedure GenericFooter;
//Generic footer for summary report. Does not contain specific information about inbound files
//The specific info from previous footer could conatin a bool to exclude information...
begin
  b:=78;
   bbs:='';
   received:='';
   writeln(tfRepOut);
   RepLineBreak;
   writeln(tfRepOut);
   bbs:=BBSName;
   write(tfRepOut,(PadCenter(bbs,b)));
   writeln(tfRepOut);
   write(tfRepOut,(PadCenter(sysop,b)));
   writeln(tfRepOut);
   bbs:='';
   writeln(tfRepOut);
   RepLineBreak;
   writeln(tfRepOut);
   bbs:='';
   Insert(sysos,bbs,1);
   Insert(' ',bbs,1);
   Insert(ver,bbs,1);
   Insert(' v',bbs,1);
   Insert(prog,bbs,1);
   writeln(tfRepOut,PadCenter('Report generated by: ',b));
   writeln(tfRepOut,PadCenter(bbs,b));
   bbs:=FormatDateTime('dd mmm yyyy hh:nn:ss',(Now));
   writeln(tfRepOut,PadCenter(bbs,b));
   writeln(tfRepOut);
   bbs:='';
   Insert('CRBBS(RCS)(2017-2019)',bbs,1);
   writeln(tfRepOut,PadCenter(bbs,b));
   writeln(tfRepOut);
end;

 Procedure GenerateReport;
//This is also a mess. Had problems getting all the files into the proper areas in report
 begin
  x:=0;
  a:=45;
  p:=1;
  i:=1;
  Count:=0;
  for c:= 1 to lastrec-1 do begin
  if (tic[c].area<>'')and not(tic[c].delete) then begin
  if c=1 then AreaBreak
    else begin
      if (upcase(tic[c-1].area)<>'') then begin
        if ((upcase(tic[c].area))<>(upcase(tic[(c-1)].area)))and not(tic[c-1].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (upcase(tic[c-1].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-2].area)))and not(tic[c-2].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (c>=3)and(upcase(tic[c-2].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-3].area)))and not(tic[c-3].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (c>=4)and(upcase(tic[c-3].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-4].area)))and not(tic[c-4].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (c>=5)and(upcase(tic[c-4].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-5].area)))and not(tic[c-5].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (c>=6)and(upcase(tic[c-5].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-5].area)))and not(tic[c-6].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (c>=7)and(upcase(tic[c-6].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-6].area)))and not(tic[c-7].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (c>=8)and(upcase(tic[c-7].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-7].area)))and not(tic[c-7].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (c>=9)and(upcase(tic[c-8].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-8].area)))and not(tic[c-8].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (c>=10)and(upcase(tic[c-9].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-9].area)))and not(tic[c-9].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (c>=11)and(upcase(tic[c-10].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-10].area)))and not(tic[c-10].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (c>=12)and(upcase(tic[c-11].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-11].area)))and not(tic[c-11].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end

      else if (c>=13)and(upcase(tic[c-12].area)='')and not(repbool) then begin
        if ((upcase(tic[c].area))<>(upcase(tic[c-12].area)))and not(tic[c-12].delete) then begin
          AreaBreak;
          repbool:=true;
        end;
      end;
    end;
  repbool:=false;
    if logbool=true then begin
      LogDate;
      LogBreak;
      LogDate;
      write(tfLog,' Area: ');
      writeln(tfLog,upcase(tic[c].area));
      LogDate;
      write(tfLog,' Filename ');
      writeln(tfLog,UpCase(tic[c].filename));
    end;
  write(tfOut,' ');
  write(tfOut,PadRight(UpCase(tic[c].filename),14));
  inc(e);
  write(tfOut,' -=:=-      ');
  com1:=commainsert(IntToStr(tic[c].size));
  x:=x+tic[c].size;
  write(tfOut,AddLetter(tic[c].size));
  writeln(tfOut);
  writeln(tfOut);
//This was pretty clever, as it performs a word wrap on long descriptions based on TIC specs
  if (length(tic[c].desc[p])>45)and(tic[c].ldesc[1]='') then
  begin
    repeat
      while tic[c].desc[p][a]<>' ' do begin
        a:=a-1;
        if (a=1)and(tic[c].desc[p][1]<> ' ')then begin
          a:=45;
          write(tfOut,'                           ');
          writeln(tfOut,(LeftStr(tic[c].desc[p],a)));
          delete(tic[c].desc[p],1,a);
          break;
        end;
      end;
      write(tfOut,'                           ');
      writeln(tfOut,(LeftStr(tic[c].desc[p],a)));
      delete(tic[c].desc[p],1,a);
      a:=45;
    until Length(tic[c].desc[p])<46;
  end;
  p:=1;
  if (length(tic[c].desc[p])<46)and(tic[c].ldesc[1]='') then begin
    repeat
      write(tfOut,'                           ');
      writeln(tfOut,tic[c].desc[p]);
      inc(p);
      v:=p+1;
    until (tic[c].desc[p]='')and(tic[c].desc[v]='');
  end;

  p:=1;
  while tic[c].ldesc[p]<>'' do begin
    write(tfOut,'                           ');
    writeln(tfOut,tic[c].ldesc[p]);
    inc(p);
  end;
  writeln(tfOut);
  if tic[c].origin<>'' then begin
    write(tfOut,' Origin         -=:=-      ');
    writeln(tfOut,tic[c].origin);
  end;
  if tic[c].magic<>'' then begin
    write(tfOut,' Magic          -=:=-      ');
    writeln(tfOut,tic[c].magic);
  end;
  if tic[c].replaces<>'' then begin
    write(tfOut,' Replaces       -=:=-      ');
    writeln(tfOut,tic[c].replaces);
  end;
  writeln(tfOut);
  FileBreak;
  writeln(tfOut);
  inc(Count);
  tic[c].areadesc:='';
  tic[c].filename:='';
  tic[c].size:=0;
  tic[c].origin:='';
  tic[c].magic:='';
  tic[c].replaces:='';
end;

end;

end;

Procedure PostData;
//This inserts the daily info into the .dat file
begin
 try
  if FileExists(path+PathDelim+'mtafile.dat')then append(datfile)
    else begin
    rewrite(datfile);
    end;
  filedat[1].datadate:=(FormatDateTime('yyyy mmm dd',(Now)));
  filedat[1].dcount:=Count;
  filedat[1].dsize:=x;
  writeln(datfile,filedat[1].datadate);
  writeln(datfile,filedat[1].dcount);
  writeln(datfile,filedat[1].dsize);
  closefile(datfile);
  if logbool=true then begin
    LogDate;
    LogBreak;
  end;
  LogDate;
  writeln(tfLog,' Writing stats to data file');
 except
   on E: Exception do begin
     writeln('Error: '+E.ClassName + #13#10 + E.Message);
     LogDate;
     LogBreak;
     LogDate;
     writeln(tfLog,' Error: '+E.ClassName +' '+ E.Message);
   end;
 end;
 end;

Procedure WrapUp;
//This combines the header and footer, if they exist, to the final.txt output
begin
  closefile(tfOut);
  if FileExists(path2)then DeleteFile(path2);
  RenameFile('mtafile.rpt',path2);
  s:='';
  if FileExists(path+PathDelim+'mtafile.rpt') then bool3:=true;
  Assignfile(final,path+PathDelim+'final.txt');
  rewrite(final);
  if (FileExists(path+PathDelim+'header.txt')) and (bool3=true) then begin
    assignfile(header,path+PathDelim+'header.txt');
    Reset(header);
    While not eof(header) do begin
      readln(header,s);
      writeln(final,s);
    end;
    CloseFile(header);
    if logbool=true then begin
      LogDate;
      LogBreak;
    end;
  Write(tfLog,FormatDateTime('yyyy mmm dd hh:nn:ss',(Now)));
  WriteLn(tfLog,' Combined Header file');
  end
  else begin
    Write(tfLog,FormatDateTime('yyyy mmm dd hh:nn:ss',(Now)));
    WriteLn(tfLog,' Unable to find Header file');
  end;
  if (FileExists(path+PathDelim+'mtafile.rpt')) and (bool3=true) then begin
    assignfile(tfOut,path+PathDelim+'mtafile.rpt');
    Reset(tfOut);
    While not eof(tfOut) do begin
      readln(tfOut,s);
      writeln(final,s);
     end;
     CloseFile(tfOut);
  LogDate;
  WriteLn(tfLog,' Combined New File report file');
  end;
  if (FileExists(path+PathDelim+'footer.txt')) and (bool3=true) then begin
    assignfile(footer,path+PathDelim+'footer.txt');
    Reset(footer);
    While not eof(footer) do begin
      readln(footer,s);
      writeln(final,s);
    end;
    CloseFile(footer);
  LogDate;
  WriteLn(tfLog,' Combined Footer file');
  end
  else begin
    LogDate;
    WriteLn(tfLog,' Unable to find Footer file');
  end;
  write(tfLog,FormatDateTime('yyyy mmm dd hh:nn:ss',(Now)));
  WriteLn(tfLog,' MTAFile completed successfully.');
  CloseFile(tfLog);
  CloseFile(final);
  writeln('MTAFile completed successfully.');
end;

Procedure drawgraph(graphdata,graphhigh:integer);
//This should also be able to be done within a loop
begin
  if (graphdata/graphhigh)*100<=2 then
  begin
    write(tfRepOut,'  *                                                      ');
  end
  else if (graphdata/graphhigh)*100<=4 then
  begin
    write(tfRepOut,'  **                                                     ');
  end
  else if (graphdata/graphhigh)*100<=6 then
  begin
    write(tfRepOut,'  ***                                                    ');
  end
  else if (graphdata/graphhigh)*100<=8 then
  begin
    write(tfRepOut,'  ****                                                   ');
  end
  else if (graphdata/graphhigh)*100<=10 then
  begin
    write(tfRepOut,'  *****                                                  ');
  end
  else if (graphdata/graphhigh)*100<=12 then
  begin
    write(tfRepOut,'  ******                                                 ');
  end
  else if (graphdata/graphhigh)*100<=14 then
  begin
    write(tfRepOut,'  *******                                                ');
  end
  else if (graphdata/graphhigh)*100<=16 then
  begin
    write(tfRepOut,'  ********                                               ');
  end
  else if (graphdata/graphhigh)*100<=18 then
  begin
    write(tfRepOut,'  *********                                              ');
  end
  else if (graphdata/graphhigh)*100<=20 then
  begin
    write(tfRepOut,'  **********                                             ');
  end
  else if (graphdata/graphhigh)*100<=22 then
  begin
    write(tfRepOut,'  ***********                                            ');
  end
  else if (graphdata/graphhigh)*100<=24 then
  begin
    write(tfRepOut,'  ************                                           ');
  end
  else if (graphdata/graphhigh)*100<=26 then
  begin
    write(tfRepOut,'  *************                                          ');
  end
  else if (graphdata/graphhigh)*100<=28 then
  begin
    write(tfRepOut,'  **************                                         ');
  end
  else if (graphdata/graphhigh)*100<=30 then
  begin
    write(tfRepOut,'  ***************                                        ');
  end
  else if (graphdata/graphhigh)*100<=32 then
  begin
    write(tfRepOut,'  ****************                                       ');
  end
  else if (graphdata/graphhigh)*100<=34 then
  begin
    write(tfRepOut,'  *****************                                      ');
  end
  else if (graphdata/graphhigh)*100<=36 then
  begin
    write(tfRepOut,'  ******************                                     ');
  end
  else if (graphdata/graphhigh)*100<=38 then
  begin
    write(tfRepOut,'  *******************                                    ');
  end
  else if (graphdata/graphhigh)*100<=40 then
  begin
    write(tfRepOut,'  ********************                                   ');
  end
  else if (graphdata/graphhigh)*100<=42 then
  begin
    write(tfRepOut,'  *********************                                  ');
  end
  else if (graphdata/graphhigh)*100<=44 then
  begin
    write(tfRepOut,'  **********************                                 ');
  end
  else if (graphdata/graphhigh)*100<=46 then
  begin
    write(tfRepOut,'  ***********************                                ');
  end
  else if (graphdata/graphhigh)*100<=48 then
  begin
    write(tfRepOut,'  ************************                               ');
  end
  else if (graphdata/graphhigh)*100<=50 then
  begin
    write(tfRepOut,'  *************************                              ');
  end
  else if (graphdata/graphhigh)*100<=52 then
  begin
    write(tfRepOut,'  **************************                             ');
  end
  else if (graphdata/graphhigh)*100<=54 then
  begin
    write(tfRepOut,'  ***************************                            ');
  end
  else if (graphdata/graphhigh)*100<=56 then
  begin
    write(tfRepOut,'  ****************************                           ');
  end
  else if (graphdata/graphhigh)*100<=58 then
  begin
    write(tfRepOut,'  *****************************                          ');
  end
  else if (graphdata/graphhigh)*100<=60 then
  begin
    write(tfRepOut,'  ******************************                         ');
  end
  else if (graphdata/graphhigh)*100<=62 then
  begin
    write(tfRepOut,'  *******************************                        ');
  end
  else if (graphdata/graphhigh)*100<=64 then
  begin
    write(tfRepOut,'  ********************************                       ');
  end
  else if (graphdata/graphhigh)*100<=66 then
  begin
    write(tfRepOut,'  *********************************                      ');
  end
  else if (graphdata/graphhigh)*100<=68 then
  begin
    write(tfRepOut,'  **********************************                     ');
  end
  else if (graphdata/graphhigh)*100<=70 then
  begin
    write(tfRepOut,'  ***********************************                    ');
  end
  else if (graphdata/graphhigh)*100<=72 then
  begin
    write(tfRepOut,'  ************************************                   ');
  end
  else if (graphdata/graphhigh)*100<=74 then
  begin
    write(tfRepOut,'  *************************************                  ');
  end
  else if (graphdata/graphhigh)*100<=76 then
  begin
    write(tfRepOut,'  **************************************                 ');
  end
  else if (graphdata/graphhigh)*100<=78 then
  begin
    write(tfRepOut,'  ***************************************                ');
  end
  else if (graphdata/graphhigh)*100<=80 then
  begin
    write(tfRepOut,'  ****************************************               ');
  end
  else if (graphdata/graphhigh)*100<=82 then
  begin
    write(tfRepOut,'  *****************************************              ');
  end
  else if (graphdata/graphhigh)*100<=84 then
  begin
    write(tfRepOut,'  ******************************************             ');
  end
  else if (graphdata/graphhigh)*100<=86 then
  begin
    write(tfRepOut,'  *******************************************            ');
  end
  else if (graphdata/graphhigh)*100<=88 then
  begin
    write(tfRepOut,'  ********************************************           ');
  end
  else if (graphdata/graphhigh)*100<=90 then
  begin
    write(tfRepOut,'  *********************************************          ');
  end
  else if (graphdata/graphhigh)*100<=92 then
  begin
    write(tfRepOut,'  **********************************************         ');
  end
  else if (graphdata/graphhigh)*100<=94 then
  begin
    write(tfRepOut,'  ***********************************************        ');
  end
  else if (graphdata/graphhigh)*100<=96 then
  begin
    write(tfRepOut,'  ************************************************       ');
  end
  else if (graphdata/graphhigh)*100<=98 then
  begin
    write(tfRepOut,'  *************************************************      ');
  end
  else if (graphdata/graphhigh)*100<=100 then
  begin
    write(tfRepOut,'  **************************************************     ');
  end;

end;

Procedure reportgen;
//will generate the summary report based on how many days back is desired
var
  numdays:integer;
  lastrec:integer;
begin
  ReadConfig;
  AssignFile(tfRepOut,'mtafile1.rpt');
  AssignFile(datfile,'mtafile.dat');
  AssignFile(tfLog,LogPath);
  try
  if fileexists(LogPath)=false then Rewrite(tfLog)
    else append(tflog);
  except
    on E: Exception do begin
      writeln('Error: '+E.ClassName + #13#10 + E.Message);
      LogDate;
      LogBreak;
      LogDate;
      writeln(tfLog,' Error: '+E.ClassName +' '+ E.Message);
    end;
  end;
  try
  ReWrite(tfRepOut);
  except
    on E: Exception do begin
      writeln('Error: '+E.ClassName + #13#10 + E.Message);
      LogDate;
      LogBreak;
      LogDate;
      Writeln(tfLog,' Error: '+E.ClassName +' '+ E.Message);
    end;
  end;
  s:='';
  i:=1;
  lastrec:=1;
  numdays:=StrToInt(ParamStr(2));
  LogDate;
  LogBreak;
  LogDate;
  Writeln(tfLog,' Data file is now being read');
  try
    if FileExists(path+PathDelim+'mtafile.dat')then reset(datfile)
      else begin
        writeln('The data file was not found');
        LogDate;
        LogBreak;
        LogDate;
        writeln(tfLog,' The data file (mtafile.dat) was not found');
      end;
    while not eof(datfile) do begin
      readln(datfile,s);
      filedat[i].datadate:=s;
      readln(datfile,s);
      filedat[i].dcount:=(StrToInt(s));
      readln(datfile,s);
      filedat[i].dsize:=(StrToInt(s));
      inc(i);
      inc(lastrec);
    end;
  except
    on E: Exception do begin
      writeln('Error: '+E.ClassName + #13#10 + E.Message);
      LogDate;
      LogBreak;
      LogDate;
      writeln(tfLog,' Error: '+E.ClassName +' '+ E.Message);
    end;
  end;
  if numdays > i then numdays:=i-1;
  LogDate;
  writeln(tfLog,' Generating graphs');
  writeln(tfRepOut);
  writeln(tfRepOut,PadCenter('File Summary',78));
  writeln(tfRepOut,PadCenter('For the last '+IntToStr(numdays)+' days',78));
  writeln(tfRepOut);
  writeln(tfRepOut,' --------------------------------------------------------------------------- ');
  writeln(tfRepOut);
  writeln(tfRepOut,'  Date    Graph                                                  Files ');
  writeln(tfRepOut);
  d:=lastrec-numdays;
  i:=0;
  for i:=lastrec-numdays+1 to lastrec-1 do
  begin
    if filedat[i].dcount>filedat[d].dcount then d:=i;
  end;
  for i:=lastrec-numdays to lastrec-1 do begin
    write(tfRepOut,'  ');
    delete(filedat[i].datadate,1,5);
    write(tfRepOut,filedat[i].datadate);
    drawgraph(filedat[i].dcount,filedat[d].dcount);
    writeln(tfRepOut,filedat[i].dcount);
  end;
  writeln(tfRepOut);
  writeln(tfRepOut,' --------------------------------------------------------------------------- ');
  writeln(tfRepOut);
  writeln(tfRepOut,'  Date    Graph                                                  Size ');
  writeln(tfRepOut);

  d:=lastrec-numdays;
  i:=0;
  for i:=lastrec-numdays+1 to lastrec-1 do
  begin
    if filedat[i].dsize>filedat[d].dsize then d:=i;
  end;
  for i:=lastrec-numdays to lastrec-1 do begin
    write(tfRepOut,'  ');
    write(tfRepOut,filedat[i].datadate);
    drawgraph(filedat[i].dsize,filedat[d].dsize);
    writeln(tfRepOut,commainsert(IntToStr(filedat[i].dsize)));
  end;
  writeln(tfRepOut);
  GenericFooter;
  LogDate;
  writeln(tfLog,' Finished generating statistical output file');
  CloseFile(tfLog);
  CloseFile(datfile);
  CloseFile(tfRepOut);
  Halt;
end;

Procedure ProgramInit;
//Starts the whole process
begin
  OSVersion;
  ProgVersion;
  path:=GetCurrentDir;
  case ParamStr(1) of
    '?': mtahelp;
    '-h': mtahelp;
    '-a': startup;
    '-r': begin
      if ParamStr(2)='' then mtahelp;
        reportgen;
      end
    else mtahelp;
  end;
end;

begin
  ProgramInit;
  TicSetup;
  TicRead;
  LogDate;
  writeln(tfLog,' Putting areas in alphabetical order');
  for f:=1 to lastrec do begin
    FindLowArea;
  end;
  LogDate;
  writeln(tfLog,' Putting files in alphebetical order by areas');
  for f:=1 to lastrec do begin
    FindLowFile;
  end;
  DupeCheck;
  GenerateReport;
  InsertFooter;
  PostData;
  WrapUp;
end.
