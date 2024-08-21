// New MPL program to check a user's calls and posts
// and upgrade them to a new security level if needed
//
// Thanks to StackFault<phENom> for letting me have some
// useful MPL documentation.


Uses
  User;

Var
  version          : String
  callCount        : Integer
  handle           : String
  level            : Byte
  posts            : Integer
  upMsg            : String
  lvl2, lvl3, step : Byte
  msgFile          : String
  baseID           : Byte
  fromName         : String
  toName           : String
  subject          : String

Begin

  version := '0.2a[ml]';  // sec_check version
  lvl2 := 20;             // first new level to promote to
  lvl3 := 30;             // second new level to promote to
  step := 10;             // step to increment upon promote

  GetThisUser;
  handle := UserAlias;
  level := UserSec;
  callCount := UserCalls;
  posts := UserPosts;
  upMsg := '|CL|DFsec_upgrade.ans| |PA';

  // message settings
  msgFile    := '/mystic/themes/default/text/your_upgraded_mail.ans'  //updated for newer version of Mystic (BP)
  baseID     := 1
  fromName   := 'MeaTLoTioN'
  toName     := handle
  subject    := 'You''re upgraded!'

  If level < lvl2 Then
  Begin
    If callCount > 20 OR posts > 20 Then
    Begin
      UpUser (UserSec + step);
      WriteLn (upMsg);
      menucmd('MX', msgFile + ';' + Int2Str(baseID) + ';' + fromName + ';' + toName + ';' + subject);
    End
  End

  If level > lvl2-1 AND level < lvl3 Then
  Begin
    If callCount > 50 AND posts > 50 Then
    Begin
      UpUser (UserSec + step);
      WriteLn (upMsg);
      menucmd('MX', msgFile + ';' + Int2Str(baseID) + ';' + fromName + ';' + toName + ';' + subject);
    End
  End

End.

