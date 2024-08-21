(*
   ---------------------------------------------------------------------------
   startup menu for mystic bbs 1.12+                                    xqtr
   --------------------------------------------------------------------------- 

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   _            _   _              ___          _    _       
  /_\  _ _  ___| |_| |_  ___ _ _  |   \ _ _ ___(_)__| |               8888
 / _ \| ' \/ _ \  _| ' \/ -_) '_| | |) | '_/ _ \ / _` |            8 888888 8
/_/ \_\_||_\___/\__|_||_\___|_|   |___/|_| \___/_\__,_|            8888888888
                                                                   8888888888
         DoNt Be aNoTHeR DrOiD fOR tHe SySteM                      88 8888 88
                                                                   8888888888
    .o HaM RaDiO    .o ANSi ARt!       .o MySTiC MoDS              "88||||88"
    .o NeWS         .o WeATheR         .o FiLEs                     ""8888""
    .o GaMeS        .o TeXtFiLeS       .o PrEPardNeSS                  88
    .o TuTors       .o bOOkS/PdFs      .o SuRVaViLiSM          8 8 88888888888
    .o FsxNet       .o SurvNet         .o More...            888 8888][][][888
                                                               8 888888##88888
   TeLNeT : andr01d.zapto.org:9999                             8 8888.####.888
   SySoP  : xqtr                   eMAiL: xqtr@gmx.com         8 8888##88##888
*)

uses cfg;
uses user;

const
  keyHome          = #71;      
  keyCursorUp      = #72;     
  keyPgUp          = #73;
  keyCursorLeft    = #75;      
  KeyNum5          = #76;     
  keyCursorRight   = #77;
  keyEnd           = #79;
  keyCursorDown    = #80;
  keyPgDn          = #81;
  mi = 5;
  ansifile = 'startup.ans';

type
  menuitem = record
    x:byte;
    y:byte;
    on : string;
    off: string;
  end;
  
  
  
var
  menu : array[1..6] of menuitem;
  idx  : byte = 1;
  c    : char;
  done : boolean = false;
  d    : byte;
  hg   : boolean = false;
  
Procedure DispANSI(A:String);
Begin
  If FileExist(A) Then MenuCMD('GD','@0@false@'+A)
    Else If FileExist(CfgMPEPath+A) Then MenuCMD('GD','@115000@false@'+CfgMPEPath+A);
End;

procedure drawmenu;
begin
  for d:=1 to mi do writexypipe(menu[d].x,menu[d].y,8,10,menu[d].off);
  writexypipe(menu[idx].x,menu[idx].y,8,10,menu[idx].on);
end;

procedure clear;
var g:byte;
begin
  for g:=1 to 11 do writexy(18,8+g,7,strrep(' ',45));
end;

procedure info;
begin
  clear;
  writexypipe(22,10,8,30,'SYSOP : |15'+strmci('|SN'));
  writexypipe(22,11,8,30,'DATE  : |15'+strmci('|DA'));
  writexypipe(22,12,8,30,'TIME  : |15'+strmci('|TI'));
  writexypipe(22,13,8,30,'IP    : |15'+strmci('|UY'));
  writexypipe(22,14,8,30,'HOST  : |15'+strmci('|UX'));
 
  writexy(27,19,8,'Press any key to continue...');
  readkey;
  clear;
  drawmenu;
end;

procedure hangupb;
begin
  hg:=true;
  done:=true;
end;

procedure apply;
begin
  clear;
  textcolor(8);
  gotoxy(20,14);if INPUTNY('Register for new account?') then begin
    UserLoginNew:=true;
    done:=true;
  end;
  clear;
  drawmenu;
end;

procedure msgsys;
begin
  textcolor(7);clrscr;
  menucmd('MW','/to:sysop /subj:feedback');
  
  textcolor(7);clrscr;
  dispansi(cfgtextpath+ansifile);
  clear;
  drawmenu;
end;  

procedure login;
var
  user:string;
  pass:string;
begin
  clear;
  done:=true;
end;

begin
  textcolor(7);clrscr;
  dispansi(cfgtextpath+ansifile);
  clear;
  
  menu[1].x:=5;
  menu[1].y:=8;
  menu[1].on:='|23|00LOGIN';
  menu[1].off:='|16|15L|08OGIN';
  
  menu[2].x:=5;
  menu[2].y:=9;
  menu[2].on:='|23|00INFO';
  menu[2].off:='|16|15I|08NFO';
  
  menu[3].x:=5;
  menu[3].y:=10;
  menu[3].on:='|23|00APPLY';
  menu[3].off:='|16|15A|08PPLY';
  
  menu[4].x:=5;
  menu[4].y:=11;
  menu[4].on:='|23|00FEEDBACK';
  menu[4].off:='|16|15F|08EEDBACK';
  
  menu[5].x:=5;
  menu[5].y:=12;
  menu[5].on:='|20|00HANG UP ';
  menu[5].off:='|16|15H|08ANG UP';
  drawmenu;
  repeat
    
    if keypressed then begin
      
      c:=readkey;
      if isarrow then begin
        case c of 
          keyhome,keypgup: idx:=1;
          keyend,keypgdn : idx:=mi;
          keycursordown : begin
                          idx:=idx+1;
                          if idx>mi then idx:=1;
                        end;
          keycursorup : begin
                          if idx=1 then idx:=mi else idx:=idx-1;
                        end;
        end;
      end else begin
        case c of
          #27 : begin hg:=true;done:=true;end;
          #13 : case idx of
                  5: hangupb;
                  4: msgsys;
                  1: login;
                  2: info;
                  3: apply;
                end;
          'i','I': info;
          'h','H': hangupb;
          'a','A': apply;
          'l','L': login;
          'm','M': msgsys;
        end;
      
      end;
      drawmenu;
    end;
  until done;
  if hg then menucmd('GH','');
  
end;