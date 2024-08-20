{
   ====================================================================
   Ansi Tools Utility                                              xqtr
   ====================================================================
   You found this gile here: https://github.com/xqtr/
   
   For contact look at Another Droid BBS [andr01d.zapto.org:9999],
   FSXNet and ArakNet.
   
   --------------------------------------------------------------------
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
}

program ansitools;
{$mode objfpc}

uses 
  crt,
  classes,
  sysutils,
  xstrings;

const
  cl = '|CL';
  po = '|PO';
  LF = #10;
  CR = #13;
  CRLF = #13#10;

type  
  RecSauceInfo = packed record
    ID:             array [1..5] of char; // "SAUCE"
    Version:        array [1..2] of byte;
    Title:          array [1..35] of char;
    Author:         array [1..20] of char;
    Group:          array [1..20] of char;
    Date:           array [1..8] of char;   // YYMMDD
    FileSIze :      Uint32;

    DataFileType :  UInt16;
    TInfo1 :        Uint16;
    TInfo2 :        Uint16;
    TInfo3 :        Uint16;
    TInfo4 :        Uint16;
    Comments:       Byte;
    TFlags:         Byte;
    TInfoS:         array [1..22] of char;  // null terminated - FontName
  end;

var
  fi          : TFileStream;
  fo          : TFileStream;
  i           : byte;
  addcl       : boolean = false;
  addpo       : boolean = false;
  recl        : boolean = false;
  repo        : boolean = false;
  removesauce : boolean = false;
  addsauce    : boolean = false;
  le          : string = '';
  yn          : char;
  clpos       : longint=-1;
  popos       : longint=-1;
  do24        : smallint = -1;
  b           : byte;
  count       : longint = 0;
  sauce       : RecSauceInfo;
  fileend     : longint = -1;
  progress    : byte = 0;
  
function b2s(d:boolean):string;
begin
  if d then result:='True' Else result:='False';
end;

Function ReadSauceInfo (F:tfilestream; Var Sauce: RecSauceInfo) : Boolean;
Var
  Res : LongInt;
Begin
  Result := False;
  fillbyte(sauce,sizeof(sauce),0);
  try
    f.seek(-128,soFromEnd);
    res:=f.Read (Sauce, sizeof(sauce));
  except
    exit;
  End;
  Result := copy(sauce.id,1,5) = 'SAUCE';
End;

Function isSauce(S:RecSauceInfo):Boolean;
Begin
  Result := copy(S.id,1,5) = 'SAUCE';
End;
  
function detectcr(f:tfilestream):boolean;
var
  c:byte;
begin
  result:=false;
  f.Seek(0,0);
  While (fi.position < fi.size) Do Begin
    f.read(c,1);
    if c=13 then begin
      result := true;
      break;
    end;
  end;
end;

function detectcl(f:tfilestream):longint;
var
  buf: array[1..3] of char;
begin
  result:=-1;
  f.seek(0,0);
  f.read(buf,3);
  if (buf[1]='|') and (locase(buf[2])='c') and (locase(buf[3])='l') then begin
    result:=f.position-3;
    exit;
  end;
  f.read(buf,3);
  if (buf[1]='|') and (locase(buf[2])='c') and (locase(buf[3])='l') then begin
    result:=f.position-3;
    exit;
  end;
end;

function detectpo(f:tfilestream):longint;
var
  buf: array[1..3] of char;
begin
  result:=-1;
  f.seek(0,0);
  f.read(buf,3);
  if (buf[1]='|') and (locase(buf[2])='p') and (locase(buf[3])='o') then begin
    result:=f.position-3;
    exit;
  end;
  f.read(buf,3);
  if (buf[1]='|') and (locase(buf[2])='p') and (locase(buf[3])='o') then begin
    result:=f.position-3;
    exit;
  end;
end;
  
procedure showhelp;
begin
  writeln;
  writeln('Pipe Ansi Tools  v1.0');
  writeln;
  writeln('  Usage:');
  writeln('         ansitool <infile> <outfile> [switches]');
  writeln;
  writeln('  Switches');
  writeln('         -cl     : add clear screen pipecode');
  writeln('         -po     : add not pause  pipecode');
  writeln('         --cl    : remove clear screen pipecode');
  writeln('         --po    : remove not pause  pipecode');
  writeln('         -sauce  : add sauce data');
  writeln('         --sauce : remove sauce data');
  writeln('         -lf     : convert line endings to LFs/Unix');
  writeln('         -crlf   : convert line endings to CRLFs/Windows');
  writeln('         -23     : keep only 23 lines');
  writeln('         -24     : keep only 24 lines');
  writeln('         -25     : keep only 25 lines');
  writeln;
  writeln(' made by xqtr of another droid bbs / andr01d.zapto.org:9999');
  writeln;
  halt;
end;

function dolf:boolean;
begin
  result:=false;
  if length(le)=1 then result:=true;
end;

function docrlf:boolean;
begin
  result:=false;
  if length(le)=2 then result:=true;
end;

begin
  if paramcount < 3 then showhelp;
  for i:=3 to paramcount do begin
    if upper(paramstr(i))='-CL' then addcl:=true else
    if upper(paramstr(i))='-PO' then addpo:=true else
    if upper(paramstr(i))='--CL' then recl:=true else
    if upper(paramstr(i))='--PO' then repo:=true else
    if upper(paramstr(i))='--SAUCE' then removesauce:=true else
    if upper(paramstr(i))='-SAUCE' then addsauce:=true else
    if upper(paramstr(i))='-LF' then le:=LF else
    if upper(paramstr(i))='-CRLF' then le:=CRLF else
    if upper(paramstr(i))='-23' then do24:=23 else
    if upper(paramstr(i))='-24' then do24:=24 else
    if upper(paramstr(i))='-25' then do24:=25 else
      begin
        writeln('Unknown switch command ['+paramstr(i)+']. Aborting...');
        halt;
      end;
  end;
  
  //check errors
  
  if addsauce and removesauce then begin
    writeln('You can''t add and remove SAUCE data... choose what you want :p');
    halt;
  end;
  
  if not fileexists(paramstr(1)) then begin
    writeln('Source file, doesn''t exist. Aborting...');
    halt;
  end;
  
  if addcl and recl then begin
    writeln('You can''t add and remove CL code... choose what you want :p');
    halt;
  end;
  
  if addpo and repo then begin
    writeln('You can''t add and remove PO code... choose what you want :p');
    halt;
  end;
  
  fi:= TFileStream.Create(paramstr(1),fmOpenReadWrite or fmShareDenyNone);
  
  if removesauce and (readsauceinfo(fi,sauce)=false) then begin
    writeln('File contains no SAUCE data. Aborting...');
    writeln;
    fi.free;
    halt;
  end;
  
  if detectcr(fi) and (le=crlf) then begin
    writeln('The file all ready contains CRs. Aborting...');
    writeln;
    fi.free;
    halt;
  end;
  
  if (detectcr(fi)=false) and (le=lf) then begin
    writeln('The file all ready is in LF/Unix format. Aborting...');
    writeln;
    fi.free;
    halt;
  end;
  
  if addsauce then writeln('Writing SAUCE data is not implemented yet. Proceeding anyway...');
  
  clpos:=detectcl(fi);
  popos:=detectpo(fi);
     
  if (clpos=-1) and (recl=true) then begin
    writeln('The file doesn''contain any CL code. Aborting...');
    writeln;
    fi.free;
    halt;
  end;
  
  if (popos=-1) and (repo=true) then begin
    writeln('The file doesn''contain any PO code. Aborting...');
    writeln;
    fi.free;
    halt;
  end;
  
  if (popos>=0) and (addpo=true) then begin
    writeln('The file all ready contains a PO code. Aborting...');
    writeln;
    fi.free;
    halt;
  end;
  
  if (clpos>=0) and (addcl=true) then begin
    writeln('The file all ready contains a CL code. Aborting...');
    writeln;
    fi.free;
    halt;
  end;
  writeln;
  if fileexists(paramstr(2)) then begin
    writeln('File all ready exists. Overwrite? (y/n): ');
    yn:=readkey;
    if locase(yn)='n' then begin
      writeln('Aborting...');
      writeln;
      fi.free;
      halt;
    end;
  end;
  
  fo:= TFileStream.Create(paramstr(2),fmCreate or fmShareDenyNone);
  
  // "copy" file and add changes or make conversions 
  
  if addcl then fo.write(cl,3);
  if addpo then fo.write(po,3);
  fi.seek(0,0);
  fileend:=fi.size;
  if removesauce then fileend:=fi.size - 128;
  write('Progress: ...');
  While (fi.position < fileend) Do Begin
    if recl and (clpos=fi.position) then begin
      //writeln('cl found');
      fi.seek(fi.position+3,0);
    end;
    if repo and (popos=fi.position) then begin
      //writeln('po found');
      fi.seek(fi.position+3,0);
    end;
    fi.read(b,1);
    case b of
    10 : begin
           if docrlf then begin
              b:=13;
              fo.write(b,1);
              b:=10;
              fo.write(b,1);
           end else fo.write(b,1);
           count:=count+1;
           if (do24<>-1) and (count=do24) then break;
         end;
    13 : if dolf then begin
           b:=10;
           fo.write(b,1);
           fi.read(b,1);
         end else fo.write(b,1);
    else
      fo.write(b,1);
    end;
    progress:=fi.position * 100 div fi.size;
    gotoxy(wherex-4,wherey);
    write(strpadl(int2str(progress),3,' ')+'%');
  end;
  writeln;
  writeln;
  
  fi.free;
  fo.free;
  
end.
