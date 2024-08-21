program trivpost;

{$mode objfpc}{$H+}

uses SysUtils, strutils;
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}

Const
  prog    = 'RCS Trivia Post';
  ver     = '2.0.0.0 Linux/64';
  red     = (#27'[1;31m');
  green   = (#27'[1;32m');
  yellow  = (#27'[1;33m');
  blue    = (#27'[1;34m');
  magenta = (#27'[1;35m');
  cyan    = (#27'[1;36m');
  nocolor = (#27'[0m');
 
Var
  qnum    : longint;
  qnum1   : string;
  count   : integer;
  trivq   : textfile;
  trivia  : textfile;
  trivlog : textfile;
  trivdupe: textfile;
  str1    : string;
  str2    : string;
  ran     : LongInt;

Procedure rnum;
begin
  Randomize;
  qnum:=(Random(ran)+1);
end;

Procedure dupecheck;
begin
  if fileexists('trivdupe.log')=true then begin
    reset(trivdupe);
    while not eof(trivdupe) do
      begin
        readln(trivdupe,str1);
        if str1<>'' then begin
        if qnum=(strtoint(str1)) then
          begin
            if (count=ran) then begin
              writeln('All available questions have been posted! ');
              halt;
            end;
            rnum;
            dupecheck;
            inc(count);
          end;
        end;
      end;
    //closefile(trivlog);
    end;
end;

Procedure header;
begin
  write(trivia,blue);
  writeln(trivia,'***********************************');
  writeln(trivia);
end;

Procedure footer;
begin
  header;
  write(trivia,cyan);
  write(trivia,prog);
  write(trivia,' ');
  writeln(trivia,ver);
  writeln(trivia,blue+'(c)'+cyan+'2017-2019');
  //writeln(trivia);
  writeln(trivia,nocolor);
  writeln(trivia,'---');
end;

Procedure quit;
begin
  writeln('Program completed');
end;

Procedure GetMaxEntry;
begin
  while not eof(trivq) do
    begin
      readln(trivq,str2);
    end;
  ran:=strtoint(Copy(str2,1,3));
  ran:=ran-1;
  closefile(trivq);
end;
  {$R *.res}

begin
  qnum:=0;
  qnum1:='* ';
  count:=0;
  assignfile(trivq,'trivia.txt');
  assignfile(trivia,'trivia.rpt');
  assignfile(trivlog,'trivlog.txt');
  assignfile(trivdupe,'trivdupe.log');
  reset(trivq);
  GetMaxEntry;
  rewrite(trivia);
  reset(trivq);
  rnum;
  dupecheck;
  if fileexists('trivlog.txt')=false then Rewrite(trivlog)
    else append(trivlog);
  if fileexists('trivdupe.log')=false then Rewrite(trivdupe)
    else append(trivdupe);
  writeln(trivlog);
  writeln(trivdupe);
  write(trivlog,qnum);
  write(trivdupe,qnum);
  //writeln(qnum);
  header;
  while not eof(trivq) do
    begin
      readln(trivq,str1);
      if AnsiStartsStr((inttostr(qnum)),str1) then begin
        write(trivia,red);
        writeln(trivia,str1);
        repeat
        //writeln(str1);
        readln(trivq,str1);
        if AnsiStartsStr(qnum1,str1) then break;
        write(trivia,red);
        writeln(trivia,str1);
        //readln(trivq,str1);
        until AnsiStartsStr(qnum1,str1);
        break;

      end;
  end;
  footer;
  closefile(trivq);
  closefile(trivia);
  closefile(trivlog);
  closefile(trivdupe);
  quit;
end.

