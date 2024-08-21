//
// Phys Org for Mystic BBS
//
// VERSION 0.1
//
// By: Last Sysop
//
// MMXVII a.d.
//


Uses User
Uses Cfg

Begin
Var  Str : String
  dispfile('physorg.txt')
  Write ('Select an article [0-9] or q to quit:')
  Str := Input (1, 2, 1, '')
  If Str >= '0' And str <= '9' Then
  Begin
    Write('|10')
    dispfile('physorg' + Str + '.txt')
    Readkey
  End
  If str = 'q' Then
  Begin
   Halt
  End
End
