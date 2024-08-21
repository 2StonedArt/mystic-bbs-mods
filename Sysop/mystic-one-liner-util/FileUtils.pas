(* Full credit to Rick Parrish for this code from RMDoor *)
Unit FileUtils;
{$mode objfpc}{$H+}

Interface 
Uses SysUtils;

function GetAbsolutePath(AFileName: String): String;
function OpenFileForOverwrite(out F: File; AFileName: String; ATimeoutInMilliseconds: Integer): Boolean;
function OpenFileForReadWrite(out F: File; AFileName: String; ATimeoutInMilliseconds: Integer): Boolean;

Implementation 

function GetAbsolutePath(AFileName: String): String;
begin
//  AFileName := StringReplace(AFileName, '`*', [rfReplaceAll, rfIgnoreCase]);
  Result := ExpandFileName(AFileName);
end;

function OpenFileForOverwrite(out F: File; AFileName: String; ATimeoutInMilliseconds: Integer): Boolean;
var
  I: Integer;
begin
  Result := false;

  for I := 1 to ATimeoutInMilliseconds div 100 do
  begin
    Assign(F, AFileName);
    {$I-}ReWrite(F, 1);{$I+}
    if (IOResult = 0) then
    begin
      Result := true;
      Exit;
    end;

    Sleep(100); // Wait 1/10th of a second before retrying
  end;
end;

function OpenFileForReadWrite(out F: File; AFileName: String; ATimeoutInMilliseconds: Integer): Boolean;
var
  I: Integer;
begin
  Result := false;

  // TODOX Race condition
  if (FileExists(AFileName)) then
  begin
    for I := 1 to ATimeoutInMilliseconds div 100 do
    begin
      Assign(F, AFileName);
      {$I-}Reset(F, 1);{$I+}
      if (IOResult = 0) then
      begin
        Result := true;
        Exit;
      end;

      Sleep(100); // Wait 1/10th of a second before retrying
    end;
  end else
  begin
    Result := OpenFileForOverwrite(F, AFileName, ATimeoutInMilliseconds);
  end;
end;
end.