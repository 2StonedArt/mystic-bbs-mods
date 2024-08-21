Program MysticOLUtil;
{$mode objfpc}{$H+}
{$MODESWITCH ADVANCEDRECORDS}

Uses Generics.Collections, StrUtils, SysUtils, Crt, Door, FileUtils;

Const 
  OneLinerFileName = 'oneliner.dat';

Type 
(* ONELINERS.DAT found in the data directory.  This file contains all the
   one-liner data.  It can be any number of records in size. *)

  OneLineRec = Record
    Text : String[79];
    From : String[30];
  End;

procedure PhenomTitle;
begin
DoorWriteln('                   $$sss  s$"                              5m  ');
DoorWriteln('                   $$  $$ $$                                   ');
DoorWriteln('|03                   $$"""" $$""$e $"//  $$""s  $$""$$ $$sssss   |07');
DoorWriteln('|02                   $$     $$  $$ $SSSS $$  $$ $$$$$$ $$ $$ $$  |07');
DoorWriteln; 
DoorWriteln('|05                         --- P R O D U C T I O N S ---       |07');
DoorWriteln('|05                                  EST : 2018                 |07'); 
DoorWriteln;
DoorWriteln;
DoorWriteln('                   |0AMystic One-Liner Utility                    |07');
DoorWriteln('                   By: |0AHayes Zyxel (Baud Games)|07');
end;

procedure ListOneLiners;
var
  OneLinerFullPath: string;
  F: File Of OneLineRec;
  Rec: OneLineRec;
  idx: integer;
begin
  OneLinerFullPath := GetAbsolutePath(OneLinerFileName);

  if NOT (OpenFileForReadWrite(F, OneLinerFullPath, 2500)) then
  begin 
    DoorWriteln('|04Unable to open ' + OneLinerFullPath + ' for append.|07');
    halt;
  end;

  try
    idx:=0;
    //Writeln('FileSize:' + IntToStr(FileSize(F)) + ' Rec Size:' + IntToStr(SizeOf(OneLineRec)));
    Writeln('Num Records:' + IntToStr(FileSize(F) div SizeOf(OneLineRec)));
    repeat
      Read(F, Rec);
      Writeln('[' + IntToStr(idx) + '] ' + '(' + Rec.From + ') : ' + Rec.Text);
      Inc(idx);
    until EOF(F);
  finally
    Close(F);  
  end;
end;

procedure DeleteOneLiner;
var
  OneLinerFullPath: string;
  F: File Of OneLineRec;
  Rec: OneLineRec;
  idxRecToDelete, idxRecsToMove, idxCurrRec: integer;
  yn: char;
  onelinerRecs: specialize TList<OneLineRec>;
begin
  OneLinerFullPath := GetAbsolutePath(OneLinerFileName);

  if NOT (OpenFileForReadWrite(F, OneLinerFullPath, 2500)) then
  begin 
    DoorWriteln('|04Unable to open ' + OneLinerFullPath + ' for append.|07');
    halt;
  end;

  Write('Enter the record to delete: (0-' + IntToStr((FileSize(F) div SizeOf(OneLineRec))-1) + ') -> ');
  Readln(idxRecToDelete);

  try
    onelinerRecs:=specialize TList<OneLineRec>.Create();
    //Writeln('FileSize:' + IntToStr(FileSize(F)) + ' Rec Size:' + IntToStr(SizeOf(OneLineRec)));
    DoorWriteln('|02Num Records:' + IntToStr(FileSize(F) div SizeOf(OneLineRec)) + '|07');
    if (idxRecToDelete <= FileSize(F) div SizeOf(OneLineRec)) then 
    begin 
      Seek(F, SizeOf(OneLineRec)*idxRecToDelete);
      Read(F, Rec);
      DoorWriteln('[' + IntToStr(idxRecToDelete) + '] ' + '(' + Rec.From + ') : ' + Rec.Text);
      DoorWriteln('|02Delete this entry (Y/N) -> ');
      Readln(yn);
      if (UpCase(yn)='Y') then 
      begin
        (* Read the remaining records *)
        Seek(F, 0);
        idxCurrRec := 0;
        repeat
          Read(F, Rec);
          if (idxCurrRec <> idxRecToDelete) then
            onelinerRecs.Add(Rec);
          Inc(idxCurrRec);
        until EOF(F);
        Close(F);

        (* Rewrite the file with the deleted record removed *)
        if NOT (OpenFileForOverwrite(F, OneLinerFullPath, 2500)) then
        begin 
          DoorWriteln('|04Unable to open ' + OneLinerFullPath + ' for append.|07');
          halt;
        end;
 
        (* Move all of the files *)
        for idxRecsToMove := 0 to onelinerRecs.Count-1 do 
          Write(F, onelinerRecs[idxRecsToMove]);
      end;
    end;
  finally
    Close(F);  
    FreeAndNil(onelinerRecs);
  end;
end;

procedure Help;
begin
  DoorWriteln;
  DoorWriteln('|02Options|07');
  DoorWriteln('|02-------|07');
  DoorWriteln('|02L|07)ist One-Liners');
  DoorWriteln('|02D|07)elete One-Liner');
  DoorWriteln('|02Q|07)uit');
  DoorWriteln;
end;

{Here the main program block starts}
var
  selection: char;
begin
  ClrScr;
  PhenomTitle;
  repeat
    Help;
    selection:=UpCase(ReadKey);
    case selection of 
    '?': Help;
    'L': ListOneLiners;
    'D': DeleteOneLiner;
    end; 
  until (selection='Q');
end.