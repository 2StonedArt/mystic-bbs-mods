# .------------------------------------------------------------------------.
# | GO-PAWZ.MPS  : animated pause prompt engine                            |
# +------------------------------------------------------------------------+
# |                                                                        |
# | You may modify this program for your own needs, but you CANNOT release |
# | it to the public.  If you feel you've made changes that are useful to  |
# | many people, either send the code to me and I may give you PERMISSION  |
# | to release it, or suggest those features to me and I may take your     |
# | suggestions and implement them.                                        |
# |                                                                        |
# | You can contact me at mysticbbs@geocities.com                          |
# `------------------------------------------------------------------------'

Uses CFG

Var A      Byte
Var FN     String 
Var Ext    String 
Var SavedX Byte    
Var tStart LongInt  
Var tNow   LongInt 
Var dTime  Integer   
Var Ch     Char 

Var Txt    String Array(1..50)         
Var TxtMax Byte

Proc Get_File_Name  
  If Not fExist(FN + Ext)
    WriteLn ('|CR|12ERROR: |14Animated pause data not found.')
    Halt
  EndIf

  If fExist(FN + 'TX1')
    Repeat
      A := Random(10)
      If A = 0
        Ext := 'TXT'
      Else
        Ext := 'TX' + Int2Str(A)
      EndIf
    Until fExist(FN + Ext)
  EndIf

  A := 1

  fOpen (1, Text, Reset, FN + Ext)

  fReadLn (1, Txt(1))
  dTime := Str2Int(Txt(1))

  While Not Eof(1) and A < 50
    fReadLn (1, Txt(A))
    A := A + 1
  Wend
  fClose (1)
  TxtMax := A - 1
Pend Get_File_Name

Proc CheckTimeOut
  tNow := Timer - tStart
  If tNow > 180
    WriteLn ('|12Inactivity timeout.')
    SysopLog ('GO-PAWZ: Timeout')
    Hangup
  EndIf
PEnd CheckTimeOut

Proc DoPause
  A := 1
  Repeat
    CheckTimeOut 
    MoveX (SavedX)
    Write (Txt(A))
    If A = TxtMax Then
      A := 1
    Else
      A := A + 1
    EndIf
    Delay (dTime)
  Until KeyPressed
PEnd DoPause

###############################
# START of main program block #
###############################

tStart := Timer 

If Graphics = 0
  Write ('[Press any key]')
  Repeat
    CheckTimeOut
  Until KeyPressed
  Halt
EndIf

GetCFG

FN     := CfgTextPath + 'ANIPAUSE.'
Ext    := 'TXT'
SavedX := WhereX

Get_File_Name                # Randomly select an ANIPAUSE.TX? file.
DoPause                      # Do animated pause prompt.
