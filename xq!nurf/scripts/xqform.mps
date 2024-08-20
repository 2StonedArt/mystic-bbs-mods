(*
                                                             /\
                                                          ___/  \___
_______________________  >> dEMONIC pRODUCTIONZ // 2023  /___ o0 ___\__________
\_______         _____/_______________        _____________/__/\__\   /_______/
  /    /    /   ___/__\______        /________\________    /____\    /     /jp
 /    /    /   /            /  /    /   _________/   /    /     /   '     /
/_________/___________/    /  /    /    /     /     /    /_____/_________/
                     /____/__/_____    /     ______/____/
                                  \_________/



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
    
   READ THE INCLUDED GPL3 LICENSE FILE FOR MORE INFORMATION
*)

uses cfg,user;

const
  maxtries = 2;
  handle_minlength = 2;
  formfolder = '/tmp/';
  formprefix = 'reg-';
  logoffansi = 'cp-demon.ans';
  
  TEdit = 0;
  TToggle = 1
  TNum = 2;
  TYesNo = 3
  TPhone = 4;
  TBtn = 5;
  TDate = 6;
  TPass = 7;
  
  KeyUp = #72;
  KeyLeft = #75;
  KeyRight = #77;
  KeyDown = #80;
  
  
  maxfields = 15;

type
  TField = record
     default  : string[80];
     value    : string[80];
     help     : string[80];
     typeof   : byte;
     tag      : string[80];
     width    : byte;
     fx       : byte;
     fy       : byte;
  end;

var
  Fields : Array [1..maxfields] Of TField;
  TotalFields     : Byte = 0;
  
  bchar :char =':';
  echar :char = chr(250); //'·'; //'—'; //
  bbchar:char ='<';
  bechar:char ='>';
  lowcl :byte = 7;
  hicl  :byte = 6+4*16;
  incl  :byte = 15+6*16;
  passchar : char = '#';
  showhelp :boolean= false;
  helpx :byte = 1;
  helpy :byte = 24;
  helpwidth :byte = 79;
  helpattr : byte = 6;
  sx : byte = 1;
  sy : byte = 1;
  
  tries : byte = 0;
  
  ihandle : string = '';
  ipassword : string = '';
  iverify: string = '';
  imail : string = '';
  irealname : string = '';
  iaddress : string = '';
  icity: string = '';
  izip : string = '';
  iphone : string = '';
  igender : string = 'male';
  ibirthdate : string = '00/00/0000';
  
  ihavebbs : string = 'No';
  ibbsname : string = '';
  ibbsaddress : string = '';
  ibbsinfo : string = '';
  ibbscomment : string = '';
  ibbssoftware : string = '';
  ibbsmodded : string = 'No';
  ibbswarez : string = 'No';
  
  imodding : string = 'No';
  ilanguages : string = '';
  idrawing : string = 'No';
  iansitype : string = '';
  isincemem : string = '';
  isincemod : string = '';
  igroupmem : string = 'No';
  igroup : string = '';
  irequests : string = 'No';
  iopensource : string = 'No';
  ijoin : string = 'No';
  iaffils : string = '';
  
procedure cursoroff; begin write('|[0');end;
procedure cursoron; begin write('|[1');end;
procedure SaveCursor; begin sx:=wherex; sy:=wherey;end;
procedure restorecursor; begin gotoxy(sx,sy);end;
function  pad(st:string; ind:integer):string;begin pad:=padrt(st,ind,' '); end;
procedure clr; begin write('|16|07|CL'); end;

function str2bool(st:string):boolean;
begin
  if upper(st)='YES' then str2bool:=true else str2bool:=false;
end;

procedure error(str:string);
begin
  writexy(1,11,14+64,padct(str,79,' '));
  write('|DE|DE|DE|DE');
end;

Function  btos(b: boolean): String;
Begin
  if b then btos := 'Yes' else btos := 'No';
End;

procedure writeform;
var
  f:file;
begin
  fassign  (f, formfolder+formprefix+ihandle+'.txt',66);
  frewrite (f);
  fwriteln (f, ' ');
  fwriteln (f, 'Registration form for user: '+ihandle);
  fwriteln (f, ' ');
  fwriteln (f, strrep('-',80));
  fwriteln (f, ' ');
  fwriteln (f, padlt(' Personal Information ',80, '-'));
  fwriteln (f, ' ');
  fwriteln (f, 'Date:'+DateStr(DateTime,2)+' Time: '+StrMci('|TI'));
  fwriteln (f, 'Email: '+imail);
  fwriteln (f, 'Real Name: '+irealname);
  fwriteln (f, 'Address: '+iaddress);
  fwriteln (f, 'City/Area: '+icity);
  fwriteln (f, 'Zip Code: '+izip );
  fwriteln (f, 'Phone Num.: '+iphone);
  fwriteln (f, 'Gender: '+igender);
  fwriteln (f, 'Birthdate: '+ibirthdate );
  fwriteln (f, ' ');
  fwriteln (f, padlt(' BBS Information ',80,'-'));
  fwriteln (f, ' ');
  fwriteln (f, 'Does he have a BBS: '+ihavebbs);
  fwriteln (f, 'BBS Name: '+ibbsname );
  fwriteln (f, 'BBS Address: '+ibbsaddress);
  fwriteln (f, 'BBS Info: '+ibbsinfo);
  fwriteln (f, 'BBS Comment: '+ibbscomment);
  fwriteln (f, 'BBS Software: '+ibbssoftware );
  fwriteln (f, 'Is the BBS modded: '+ibbsmodded); 
  fwriteln (f, 'Does he provide warez/hpavc: '+ibbswarez );
  fwriteln (f, ' ');
  fwriteln (f, padlt(' Scene Information ',80,'-'));
  fwriteln (f, ' ');
  fwriteln (f, 'Is he a modder: '+imodding );
  fwriteln (f, 'Prog. languages he knows: '+ilanguages);
  fwriteln (f, 'Is he an ANSI artist: '+idrawing );
  fwriteln (f, 'Type of ANSI art: '+iansitype );
  fwriteln (f, 'Member since: '+isincemem );
  fwriteln (f, 'Modding since: '+isincemod );
  fwriteln (f, 'Is he a group member: '+igroupmem );
  fwriteln (f, 'Name of group: '+igroup );
  fwriteln (f, 'Does he takes requests: '+irequests);
  fwriteln (f, 'Does he support open source soft.: '+iopensource);
  fwriteln (f, 'Would he like to join Demonic: '+ijoin );
  fwriteln (f, 'Other affiliations: '+iaffils );
  fwriteln (f, ' ');
  fwriteln (f, strrep('-',80));
  fclose(f);

end;
  
Procedure InitFields;
var g : byte;
begin
  for g := 1 to maxfields do begin
     fields[g].default  := '';
     fields[g].value    := '';
     fields[g].help     := '';
     fields[g].typeof   := 0;
     fields[g].tag      := '';
     fields[g].width    := 0;
     fields[g].fx       := 1;
     fields[g].fy       := 1;
  end;
  totalfields:=0;
  
end;

Function isanumber(S: string): Boolean;
var 
  i: byte;
  c: char;
  r: boolean = True;
Begin
  isanumber := true;
  for i := 1 to length(s) do begin
    c := s[i];
    if (ord(c)<48) and (ord(c)>57) then r:=false;
  end;
  isanumber:=r;
End;

function getnum(default,min,max:longint):longint;
var 
  r : string;
begin
  savecursor;
  repeat
    restorecursor;
    r := input(length(int2str(max)),length(int2str(max)),1,int2str(default));
    
  until isanumber(r) and (str2int(r)>=min) and (str2int(r) <=max);
  getnum := str2int(r);
end;

function gettruefalse(def:boolean;truech,falsech:char):boolean;
var
  c:char;
  r : boolean;
  done : boolean;
begin
  truech := upper(truech);
  falsech  := upper(falsech);
  done := false;
  repeat
    c:=upper(readkey);
    if c = truech then begin
      r := true;
      done:=true;
    end else if c = falsech then begin
      r:= false;
      done := true;
    end else if c = #13 then begin
      r := def;
      done:=true;
    end else if c = #27 then begin
      r := false;
      done:=true;
    end;
  until done;
  gettruefalse := r;
end;

function getyn:boolean;
begin
  getyn := gettruefalse(false,'y','n');
end;

Procedure AddField (px,py,wid:byte; typo: byte; svalue,def,extra: String);
Begin
  If Totalfields >= MaxFields Then Exit;
  TotalFields:=TotalFields+1;
  
  Fields[Totalfields].default := def;
  Fields[Totalfields].value   := svalue;
  Fields[Totalfields].typeof  := typo;
  Fields[Totalfields].width   := wid;
  Fields[Totalfields].tag     := extra;    
  Fields[Totalfields].fx       := px;
  Fields[Totalfields].fy       := py;
  Fields[Totalfields].help    := '';
End;

Procedure AddNumField(px,py,wid:byte; value,min,max : String);
Begin
  AddField (px,py,wid, tnum,value,min,max);
End;

Procedure AddYesNoField(px,py,wid:byte; default:boolean);
Begin
  AddField (px,py,wid, tyesno,btos(default),'','');
End;

Procedure AddEditField(px,py,wid:byte; default: String);
Begin
  AddField (px,py,wid, tedit,default,default,'');
End;

Procedure AddButtonField(px,py,wid:byte; value:string);
Begin
  AddField (px,py,wid, tbtn,value,'','');
End;

Procedure AddPhoneField(px,py,wid:byte; value: String);
Begin
  AddField (px,py,wid, tphone,value,'','');
End;

Procedure AddDateField(px,py:byte; value : String);
Begin
  AddField (px,py,10, tdate,value,'','');
End;

Procedure AddPassField(px,py,wid:byte; value : String);
Begin
  AddField (px,py,wid, tpass,value,'','');
End;

Procedure AddToggleField(px,py,wid:byte; value,list,seperator : String);
Begin
  AddField (px,py,wid, ttoggle,value,list,seperator);
End;

Procedure SetHelp(item:byte; atext:string);
begin
  fields[item].help := atext;
end;

function itemlistch(list:string; default:byte;sep:char):string;
var
  c:char;
  TotalWords : byte;
  done : boolean;
  index:byte;
  i:byte;
begin
  TotalWords := 0;
  index:=default;
  done:=false;
  If Length(list) > 0 Then TotalWords:=TotalWords+1;
  For I := 1 to Length(list) Do Begin
    If (list[i] = sep) and (list[i+1] <> sep) Then TotalWords:=TotalWords+1;
  End;
  if (TotalWords=0) or (default>TotalWords) then begin
    itemlistch := 'error!';
    exit;
  end;
  
  SaveCursor;
  repeat 
    restorecursor;
    write(WordGet(index,list,sep));
    c:=readkey;
    if isArrow then begin
      c:=readkey;
      case c of
        keyright,keyup :  begin
                            index:=index+1;
                            if index>TotalWords then index:=1;
                          end;
        keyleft,keydown:  begin
                            index:=index-1;
                            if index=0 then index:=TotalWords;
                          end;
      end;
    end else begin
      case c of
        #13 : begin
               itemlistch:=WordGet(index,list,sep);
               done:=true;
              end;
        #32 : begin
                index:=index+1;
                if index>TotalWords then index:=1;
              end;
      end;
    end;
  until done = true;
end;

Function DoForm(defChoice : byte) : string;
Var 
  I  : Byte;
  Ch : Char;
  done : boolean;
  tbool: boolean;
  tint : longint;
  res:string = '';
Begin
  cursoroff;
  done := false;
  res := '';
  For I := 1 To TotalFields Do
    case fields[i].typeof of
      tbtn : writexy(fields[i].fx, fields[i].fy, lowcl, bbchar+pad(fields[i].value,fields[i].width)+bechar);
      tpass : writexy(fields[i].fx, fields[i].fy, lowcl, bchar+pad(STRREP(passchar,fields[i].width),fields[i].width)+echar);
    else
      writexy(fields[i].fx, fields[i].fy, lowcl, bchar+pad(fields[i].value,fields[i].width)+echar);
    end;

  I := defchoice;
  Repeat
    case fields[i].typeof of
      tbtn : writexy(fields[i].fx, fields[i].fy, hicl, bbchar+pad(fields[i].value,fields[i].width)+bechar)
      tpass : writexy(fields[i].fx, fields[i].fy, hicl, bchar+pad(STRREP(passchar,fields[i].width),fields[i].width)+echar);
    else
      writexy(fields[i].fx, fields[i].fy, hicl, bchar+pad(fields[i].value,fields[i].width)+echar);
    end;
    
    if showhelp then begin
      //writexy(helpx,helpy,helpattr,pad(fields[i-1].help,helpwidth));
      writexypipe(helpx,helpy,helpattr,helpwidth,fields[i].help);
    end;
    
    Ch := readkey;
    if isArrow then begin
      case ch of
        keyup,keyleft: begin
          case fields[i].typeof of
            tbtn : writexy(fields[i].fx, fields[i].fy, lowcl, bbchar+pad(fields[i].value,fields[i].width)+bechar)
            tpass : writexy(fields[i].fx, fields[i].fy, lowcl, bchar+pad(STRREP(passchar,fields[i].width),fields[i].width)+echar);
          else
            writexy(fields[i].fx, fields[i].fy, lowcl, bchar+pad(fields[i].value,fields[i].width)+echar);
          end;
          i:=i-1;
          If I = 0 Then I := Totalfields;
        end;
        keydown,keyright: begin
          case fields[i].typeof of
            tbtn : writexy(fields[i].fx, fields[i].fy, lowcl, bbchar+pad(fields[i].value,fields[i].width)+bechar)
            tpass : writexy(fields[i].fx, fields[i].fy, lowcl, bchar+pad(STRREP(passchar,fields[i].width),fields[i].width)+echar);
          else
            writexy(fields[i].fx, fields[i].fy, lowcl, bchar+pad(fields[i].value,fields[i].width)+echar);
          end;
          i:=i+1;
          If I > Totalfields Then I := 1;
        end;
      end;    
    end else begin
      case ch of
        #13 : begin
                case fields[i].typeof of
                  tbtn : writexy(fields[i].fx, fields[i].fy, incl, bbchar+pad(fields[i].value,fields[i].width)+bechar)
                  tpass : writexy(fields[i].fx, fields[i].fy, incl, bchar+pad(STRREP(passchar,fields[i].width),fields[i].width)+echar);
                else
                  writexy(fields[i].fx, fields[i].fy, incl, bchar+pad(fields[i].value,fields[i].width)+echar);
                end;
                cursoron;
                case fields[i].typeof of
                  tedit : begin
                            gotoxy(fields[i].fx+1,fields[i].fy);
                            textcolor(incl);
                            fields[i].value := INPUT (fields[i].width, fields[i].width, 1, fields[i].value);
                          end;
                  ttoggle : begin
                            gotoxy(fields[i].fx+1,fields[i].fy);
                            textcolor(incl);
                            fields[i].value := itemlistch(fields[i].default,1,fields[i].tag[1])
                          end;
                  tphone  : begin
                            gotoxy(fields[i].fx+1,fields[i].fy);
                            textcolor(incl);
                            fields[i].value := INPUT (fields[i].width, fields[i].width, 4, fields[i].value);
                          end;
                  tdate   : begin
                            gotoxy(fields[i].fx+1,fields[i].fy);
                            textcolor(incl);
                            fields[i].value := INPUT (fields[i].width, fields[i].width, 5, fields[i].value);
                          end;
                  tpass   : begin
                            gotoxy(fields[i].fx+1,fields[i].fy);
                            textcolor(incl);
                            fields[i].value := INPUT (fields[i].width, fields[i].width, 6, fields[i].value);
                          end;
                  tbtn  : begin
                            res := fields[i].value;
                            done := true;
                          end;
                  tyesno: begin
                            gotoxy(fields[i].fx+1,fields[i].fy);
                            textcolor(incl);
                            write(fields[i].value);
                            tbool := getyn;
                            fields[i].value:=btos(tbool);
                          end;
                  tnum  : begin
                            gotoxy(fields[i].fx+1,fields[i].fy);
                            textcolor(incl);
                            tint := getnum(str2int(fields[i].value),str2int(fields[i].value),str2int(fields[i].tag));
                            fields[i].value := int2str(tint);
                          end;
                end;
                cursoroff;
              end;
        #27 : begin
                res := #27;
                done:=true;
              end;
      end;    
    end;

  Until done;
  DoForm := res;
  cursoron;
End;

function PersonalForm:string;
var res:string ='';
begin
  clr;
  dispfile('form.ans');
  initfields;
  AddEditField(11,14,35,ihandle);  //handle
  sethelp(1,'press ENTER to input your handle: |12(|15mandatory|12)');
  AddPassField(13,15,20,ipassword); //pass
  sethelp(2,'isn''t it obvious? |12(|15mandatory|12)');
  AddPassField(43,15,20,iverify); //verify pass
  sethelp(3,'verify password to be sure! |12(|15mandatory|12)');
  AddEditField(10,16,50,imail); //email
  sethelp(4,'if you didn''t get it yet...  |12(|15mandatory|12)');
  AddEditField(14,17,50,irealname); //name
  sethelp(5,'...you may be worthless:');
  AddEditField(12,18,50,iaddress); //address
  sethelp(6,'don''t write just bullshit...');
  AddEditField(9,19,50,icity); //city
  sethelp(7,'...be creative, at least:');
  AddNumField(8,20,10,izip,'0','999999'); //zip
  sethelp(8,'only numbers plz!');
  AddPhoneField(27,20,15,iphone); //phone
  sethelp(9,'numbers only!');
  AddToggleField(53,20,10,igender,'male  ;female;trans ;artist;modder',';');
  sethelp(10,'ENTER to input, SPACE to select:');
  AddDateField(14,21,ibirthdate);
  sethelp(11,'i bet you lie about your age :p');
  
  AddButtonField(37,24,5,' bbs ');
  AddButtonField(45,24,7,' scene ');
  AddButtonField(66,24,9,' d 0 n e ');
  res:=doform(1);
  
  ihandle := stripmci(fields[1].value);
  ipassword := stripmci(fields[2].value);
  iverify := stripmci(fields[3].value);
  imail := stripmci(fields[4].value);
  irealname := stripmci(fields[5].value);
  iaddress := stripmci(fields[6].value);
  icity:= stripmci(fields[7].value);
  izip := stripmci(fields[8].value);
  iphone := stripmci(fields[9].value);
  igender := stripmci(fields[10].value);
  ibirthdate := stripmci(fields[11].value);
  
  PersonalForm:=res;
end;

function BBSForm:string;
var res:string ='';
begin
  clr;
  dispfile('form2.ans');
  initfields;
  
  AddYesNoField(22,14,3,str2bool(ihavebbs));
  sethelp(1,'press ENTER, then Y/N to answer:');
  AddEditField(16,15,50,ibbsname);
  sethelp(2,'what''s your bbs name, is it cool?');
  AddEditField(19,16,50,ibbsaddress);
  sethelp(3,'gime the address... and hope is valid!');
  AddEditField(22,17,49,ibbsinfo);
  sethelp(4,'other shit about your bbs:');
  AddEditField(26,18,50,ibbscomment);
  sethelp(5,'any other shit you wanna tell me!');
  AddEditField(16,19,50,ibbssoftware);
  sethelp(6,'what bbs software is your bbs using?');
  AddYesNoField(27,20,3,str2bool(ibbsmodded));
  sethelp(7,'you know, No is not for answer!');
  AddYesNoField(35,21,3,str2bool(ibbswarez));
  sethelp(8,'anything you say, will be used against you:');
  
  AddButtonField(24,24,10,' personal ');
  AddButtonField(45,24,7,' scene ');
  AddButtonField(66,24,9,' d 0 n e ');
  res:=doform(1);
  
  ihavebbs := stripmci(fields[1].value);
  ibbsname := stripmci(fields[2].value);
  ibbsaddress := stripmci(fields[3].value);
  ibbsinfo := stripmci(fields[4].value);
  ibbscomment := stripmci(fields[5].value);
  ibbssoftware := stripmci(fields[6].value);
  ibbsmodded := stripmci(fields[7].value);
  ibbswarez := stripmci(fields[8].value);
  
  BBSForm:=res;
end;

function OtherForm:string;
var res:string ='';
begin
  clr;
  dispfile('form3.ans');
  initfields;
  
  AddYesNoField(22,14,3,str2bool(imodding));
  sethelp(1,'press ENTER, then Y/N to answer:');
  AddEditField(50,14,25,ilanguages);
  sethelp(2,'programming languages you know');
  AddYesNoField(27,15,3,str2bool(idrawing));
  sethelp(3,'...and i mean well, not like shit:');
  AddEditField(44,15,25,iansitype);
  sethelp(4,'i mean, menus? abstract? animation? for packs? other?');
  AddEditField(41,16,30,isincemem);
  sethelp(5,'let see how old are you:');
  AddEditField(38,17,30,isincemod);
  sethelp(6,'it''s never old enough!');
  AddYesNoField(28,18,3,str2bool(igroupmem));
  sethelp(7,'i bet you are not :p');
  AddEditField(46,18,30,igroup);
  sethelp(8,'if it aint dem0nic, it suxx:');
  AddYesNoField(26,19,3,str2bool(irequests));
  sethelp(9,'what kind of modder/artist are you?');
  AddYesNoField(62,19,3,str2bool(iopensource));
  sethelp(10,'knowledge must be free!');
  AddYesNoField(31,20,3,str2bool(ijoin));
  sethelp(11,'do you think we care?');
  AddEditField(11,21,60,iaffils);
  sethelp(12,'with what are you affiliated?');
  
  
  AddButtonField(24,24,10,' personal ');
  AddButtonField(37,24,5,' bbs ');
  AddButtonField(66,24,9,' d 0 n e ');
  res:=doform(1);
  
  imodding := stripmci(fields[1].value);
  ilanguages := stripmci(fields[2].value);
  idrawing := stripmci(fields[3].value);
  iansitype := stripmci(fields[4].value);
  isincemem := stripmci(fields[5].value);
  isincemod := stripmci(fields[6].value);
  igroupmem := stripmci(fields[7].value);
  igroup := stripmci(fields[8].value);
  irequests := stripmci(fields[9].value);
  iopensource := stripmci(fields[10].value);
  ijoin := stripmci(fields[11].value);
  iaffils := stripmci(fields[12].value);
  
  OtherForm:=res;
end;

function checkform:boolean;
var 
  cr:boolean = false;
begin
  //check handle
  ihandle := striplow(stripb(ihandle,' '));
  If (ihandle = '') or (Str2Int(ihandle) > 0) or (length(ihandle) < handle_minlength) or (pos('|',ihandle)>0) Then begin
    error('invalid username... retry!');
    checkform := false;
    exit;
  end Else If IsUser(ihandle) Then begin
    error('allready taken...');
    checkform := false;
    exit;
  end
  //check password
  else If ValidPW(ipassword) <> 0 Then begin
    error('password doesn''t comply with password pol1cy!')
    checkform := false;
    exit;
  end Else if ipassword<>iverify then begin
    error('passwords do not match!')
    checkform := false;
    exit;
  end else If (Pos(' ', imail) > 0) or (Str2Int(imail) > 0) or (Pos('@', imail) = 0) or (pos('|',ihandle)>0) then begin
    error('invalid email address')
    checkform := false;
    exit;
  end;
  checkform := true;
end;

procedure saveuserdata;
begin
  UserAlias := ihandle;
  UserName := irealname;
  UserEMail := imail;
  SetPW (ipassword);
  PutThisUser;
end;

procedure makeform;
var 
  r:string;
  check : string = '';
  mdone:boolean = false;
begin
  r:=PersonalForm;
  repeat 
    case stripb(r,' ') of 
      'bbs' : r:=bbsform;
      'personal' : r:=personalform;
      'scene' : r:=otherform;
      'd 0 n e': begin
                  if tries>maxtries then begin
                    write('|15|20|CL');
                    error('you have reached the maximum number of tries to enter valid info...');
                    write('|DE|DE|DE');
                    menucmd('GH','');
                    mdone:=true;
                  end else if checkform then begin
                    saveuserdata;
                    writeform;
                    mdone:=true;
                  end else begin
                    if tries = maxtries then begin 
                      error('last try... make it count!');
                      write('|DE|DE');
                    end;
                    r:='personal';
                  end;
                  tries := tries + 1;
                 end;
      #27 : begin
              mdone:=true;
              menucmd('GD','@56600@FALSE@'+logoffansi);
              writeln('');
              write('|04pRESS a kEY tO cONTINUE...|PN');
              menucmd('GH','');
            end;
    end;
    
  until mdone;
end;

begin
  
  showhelp:=true;
  helpx:=6;
  helpy:=23;
  helpwidth:=70;
  helpattr:=6;
  makeform;
  clr;
end.


(*
         _____         _   _              ____          _   _ 
        |  _  |___ ___| |_| |_ ___ ___   |    \ ___ ___|_|_| |        8888
        |     |   | . |  _|   | -_|  _|  |  |  |  _| . | | . |     8 888888 8
        |__|__|_|_|___|_| |_|_|___|_|    |____/|_| |___|_|___|     8888888888
                                                                   8888888888
                DoNt Be aNoTHeR DrOiD fOR tHe SySteM               88 8888 88
                                                                   8888888888
 /: HaM RaDiO   /: ANSi ARt!     /: MySTiC MoDS   /: DooRS         '88||||88'
 /: NeWS        /: WeATheR       /: FiLEs         /: zer0net        ''8888"'
 /: GaMeS       /: TeXtFiLeS     /: PrEPardNeSS   /: FsxNet            88
 /: TuTors      /: bOOkS/PdFs    /: SuRVaViLiSM   /:            8 8 88888888888
                                                              888 8888][][][888
   TeLNeT : andr01d.zapto.org:9999 / ssh: 8888                  8 888888##88888
   SySoP  : xqtr                   eMAiL: xqtr@gmx.com          8 8888.####.888
   DoNaTe : https://paypal.me/xqtr                              8 8888##88##888

*)
