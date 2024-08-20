Uses Cfg
Uses User

Const Version = 'v1.0'
Const Program = 'System Bulletins'
Const Copyright = 'Gary Crunk, 2017'
//   This program is an adaptation from Darryl Perry's 2016 version
//   v2.1 of BBS List Admin Manager (gy-blam)
//   Darryl Perry at Cyberia BBS cyberia.darktech.org  port 23
//   A very nice and stable BBS List program that allows a Sysop to
//   Maintain their BBS List in Mystic and adds some great functions
//   to that program.  I've used portions of his program to deal with
//   Datafile management as well as Windows (Boxes) and the scrolling
//   Selection-Bar.  I tried my own version... (Sucked!!!)... So I
//   utilized his implementation for this.

Const   BLK     = 0
Const   BLU     = 1
Const   GRN     = 2
Const   CYN     = 3
Const   RED     = 4
Const   PNK     = 5
Const   YLO     = 6
Const   WHT     = 7
Const   BLD     = 8

Const   WARM     = 1
Const   COLD     = 2

Const   SysopACS = 's255'

Const   ListTop   = 2
Const   ListBot   = 23
Const   ListLt    = 2
Const   ListRt    = 78

Const   EditTop   = 19
Const   EditBot   = 22
Const   EditLt    = 2
Const   EditRt    = 78

Const   MenuTop   = 14
Const   MenuBot   = 22
Const   MenuLt    = 30
Const   MenuRt    = 78

Type BBSRec = Record      // Record Structure for Database!
  Name     : String[70]
  BullFile : String[70]
  Deleted  : Boolean
End

Var Entry       : BBSRec  // Points to the Database.  This is the Item Entry
Var EditHead    : String  = ' [ EDIT BULLETINS ] '
Var ListHead    : String  = ' [ BULLETINS ] '+#30+' Up  '+#31+' Down  Enter-View  ESC-Quit '
Var ListActive  : Byte    = (WHT*16)+(BLU)          // Black on White
Var ListBar     : Byte    = (BLU*16)+(WHT+BLD)      // White on Blue
Var ListDel     : Byte    = (WHT*16)+(BLK)
Var ListDelBar  : Byte    = (RED*16)+(WHT+BLD)
Var EditMain    : Byte    = (WHT*16)+BLK
Var EditItem    : Byte    = (WHT*16)+(GRN+BLD)
Var HdrColor    : Byte    = (RED*16)+(WHT+BLD)
Var HeaderPos   : Integer = 0
Var Style       : Byte    = 2
Var ColorMain   : Byte    = (WHT*16)+(WHT+BLD)
Var ColorEdge   : Byte    = (WHT*16)+(BLK+BLD)
Var ColorBL     : Byte    = (CYN*16)+(WHT+BLD)
Var ColorTR     : Byte    = (CYN*16)+(BLK+BLD)
Var ColorMnuTxt : Byte    = (WHT*16)+(BLU)
Var ListName    : String;
Var ListFile    : String  ='bulls'
Var ListBox     : LongInt
Var EditBox     : LongInt
Var MenuBox     : LongInt
Var InputBox    : LongInt
Var AccessBy    : Array [1..3] of String
Var ADAttr      : Array [1..2] of Byte
Var Ok2Tel      : Byte    = COLD
Var Ok2Use      : Byte    = COLD
Var Ok2Add      : Byte    = COLD
Var EntryCnt    : Integer = 0
Var W           : String
Var L           : Byte
Var AddACS      : String  = 's255'
Var TelACS      : String  = 's1'
Var IniFile     : String  =JustPath(ProgName)+'bulls.ini'
Var TempLI      : LongInt

Procedure ReadIni
Var Fptr : File
VAr Tag,Opt,S : String
Begin
     If FileExist(IniFile) Then Begin
          fAssign(Fptr,IniFile,66)
          fReset(Fptr)
          While Not fEof(Fptr) Do Begin
               fReadLn(Fptr,S)
               Tag:=Upper(WordGet(1,S,'='))
               Opt:=WordGet(2,S,'=')
               Case Tag Of
                 'LISTACTIVE'    : ListActive:=Str2Int(Opt)
                 'LISTBAR'       : ListBar:=Str2Int(Opt)
                 'LISTDEL'       : ListDel:=Str2Int(Opt)
                 'LISTDELBAR'    : ListDelBar:=Str2Int(Opt)
                 'EDITMAIN'      : EditMain:=Str2Int(Opt)
                 'EDITITEM'      : EditItem:=Str2Int(Opt)
                 'HEADERCOLOR'   : HdrColor:=Str2Int(Opt)
                 'STYLE'         : Style:=Str2Int(Opt)
                 'MAINCOLOR'     : ColorMain:=Str2Int(Opt)
                 'EDGECOLOR'     : ColorEdge:=Str2Int(Opt)
                 'BOTTOMLEFT'    : ColorBL:=Str2Int(Opt)
                 'TOPRIGHT'      : ColorTR:=Str2Int(Opt)
                 'MENUHOT'       : ADAttr[WARM]:=Str2Int(Opt)
                 'MENUCOLD'      : ADAttr[COLD]:=Str2Int(Opt)
                 'LISTHDRTXT'    : ListHead:=Opt
                 'EDITHDRTXT'    : EditHead:=Opt
                 'HDRPOS'        : HeaderPos:=Str2Int(Opt)
                 'MENUTEXTCOLOR' : ColorMnuTxt:=Str2Int(Opt)
                 'ADDACS'        : AddACS:=Opt
                 'BULLFILE'      : Listfile:=Opt
               End
          End
          fClose(Fptr)
     End
End

Function GetFileDate (F : String) : LongInt
Begin
 FindFirst (F, 7)
  TempLI:=DirTime
 FindClose
  GetFileDate:=TempLI
End

Procedure MakeWindow
Var X,Y : Integer
Var S   : String
Begin
     X:=ListBot-ListTop-1
     Y:=EditLt+1
     ClassCreate(ListBox,'box')
     BoxHeader(ListBox,HeaderPos,HdrColor,ListHead)
     BoxOptions(ListBox,
          Style,
          True,
          ColorMain,
          ColorEdge,
          ColorBL,
          ColorTR,
          False,
          0)

     ClassCreate(EditBox,'box')
     BoxHeader(EditBox,HeaderPos,HdrColor,EditHead)
     BoxOptions(EditBox,
          Style,
          True,
          ColorMain,
          ColorEdge,
          ColorBL,
          ColorTR,
          False,
          0)

     ClassCreate(InputBox,'input')
     ClrScr
     BoxOpen(ListBox,ListLt,ListTop,ListRt,ListBot)
End

Procedure CloseWindow
Begin
     BoxClose(ListBox)
     BoxClose(EditBox)
     ClassFree(ListBox)
     ClassFree(EditBox)
     ClassFree(InputBox)
End

Function ReadEntry(I:Integer):Boolean
Var Ret     : Boolean = False
Var Fp     : File
Begin
     fAssign(Fp,ListName,66)
     fReset(Fp)
     If IoResult = 0 Then Begin
          fSeek(Fp,(I-1)*SizeOf(Entry))
          If Not fEof(Fp) Then Begin
               fRead(Fp,Entry,SizeOf(Entry))
               Ret:=True
          End
          fClose(Fp)
     End
     ReadEntry:=Ret
End

Procedure SaveEntry(I:Integer)
Var Fp     : File
Begin
     fAssign(Fp,ListName,66)
     fReset(Fp)
     If IoResult <> 0 Then
          fReWrite(Fp)
     Else
          fSeek(Fp,(I-1)*SizeOf(Entry))
     fWrite(Fp,Entry,SizeOf(Entry))
     fClose(Fp)
End

Procedure ListEntries(T,B:Integer)
Var X,F,K,I     : Integer
Var S          : String
Begin
     F:=ListBot-ListTop-1    // 22 - 2 - 1  = 19
     X:=ListRt-ListLt-2      // 28 - 2 - 2  = 24
     For I:=1 To F Do Begin
          K:=I+T-1
          If ReadEntry(K) Then Begin
            if UserLastOn > GetFileDate(Entry.Bullfile) then S:='*NEW*'
            if UserLastOn < GetFileDate(Entry.Bullfile) then S:='     '
            if Entry.Deleted then S:='*DEL*'
               S:=S+' '+PadRt(StripMCI(Entry.Name),X-5,' ')
               If I = B Then
                    If Entry.Deleted Then
                         WriteXY(ListLt+1,ListTop+I,ListDelBar,S)
                    Else
                         WriteXY(ListLt+1,ListTop+I,ListBar,S)
               Else
                    If Entry.Deleted Then
                         WriteXY(ListLt+1,Listtop+I,ListDel,S)
                    Else
                         WriteXY(ListLt+1,Listtop+I,ListActive,S)
          End Else Begin
               WriteXY(ListLt+2,ListTop+I,ListActive,PadRt(' ',X,' '))
          End
     End
End

Procedure Edit(I:Integer)
Var InPos     : Byte = 1
Var X          : Byte = EditLt+8
Var Done     : Boolean = False
Var S          : String
Begin
     BoxOpen(Editbox,EditLt,EditTop,EditRt,Editbot)
     PurgeInput
     InputOptions (InputBox, // Input class handle
                31,          // Attribute of inputted text
                25,          // Attribute to use for field input filler
                #176,        // Character to use for field input filler
                #9 + #27,    // Input will exit on these "low" ascii characters
                             // TAB
          #75+#77+#72+#80);  // Input will exit on these "extended" characters
                             // UP and DOWN arrows

     If I > 0 Then
          ReadEntry(I)
     Else Begin
          EntryCnt:=EntryCnt+1
          I:=EntryCnt
     End

     While Not Done Do Begin
          WriteXY(4,EditTop+1,EditItem,'Name:')
          WriteXY(X,EditTop+1,EditItem,PadRt(Entry.Name,60,' '))
          WriteXY(4,EditTop+2,EditItem,'File:')
          WriteXY(X,EditTop+2,EditItem,PadRt(Entry.Bullfile,60,' '))
          WriteXY(X+25,EditTop+3,(RED*16)+WHT+BLD,' SAVE ')
          WriteXY(X+33,EditTop+3,(RED*16)+WHT+BLD,' QUIT ')

          Case InPos of
               1:Entry.Name  :=InputString(InputBox,X,EditTop+1,68,68,1,Entry.Name);
               3:Entry.Bullfile:=InputString(InputBox,X,EditTop+2,68,68,1,Entry.Bullfile);
               9:If InputEnter(InputBox,X+25,EditTop+3,6,#016+'SAVE'+#017) Then Begin
                   SaveEntry(I)
                   Done:=True;
                 End
              10:If InputEnter(InputBox,X+33,EditTop+9,6,#016+'QUIT'+#017) Then Done:=True;
          End

          Case InputExit(InputBox) of
           #09,#77,#80 : If InPos < 10 Then InPos := InPos + 1 Else InPos := 1;
               #75,#72 : If InPos > 1  Then InPos := InPos - 1 Else InPos := 10;
               #27 : Done:=True;
          End
     End
  BoxCLose (EditBox)
End

Procedure AddNew
Begin
     Entry.Name:='Your Title Goes Here'
     Entry.Bullfile:='c:\mystic\text\bullet1.asc'
     Entry.Deleted:=False
End

Procedure DeleteEntry(I:Integer)
Begin
     If ReadEntry(I) Then Begin
          If Entry.Deleted Then Entry.Deleted:=False
          Else     Entry.Deleted:=True
          SaveEntry(I)
     End
End

Procedure ShowFile(I:Integer)
Begin
     If ReadEntry(I) Then Begin
          CloseWindow
          Write('|16|15|CL')
     If Not Entry.Deleted then Begin
          DispFile(Entry.Bullfile)
          Readkey
     End
      MakeWindow
     End
End

Procedure Main
Var Done     : Boolean = False
Var Ch     : Char
Var Y,X,Top,Bar     : Integer = 1
Var R          : Integer
Begin
     X:=ListBot-ListTop-1
     Y:=EditLt+1

     While Not Done Do Begin
          R:=Top+Bar-1
          Ok2Use:=COLD
          ListEntries(Top,Bar)

          Ch:=ReadKey
          If IsArrow Then Begin
               Case Ch Of
                    #77:     Begin    // Right Arrow
                         If R+X<EntryCnt Then
                              Top:=Top+X
                    End
                    #75: Begin       // Left Arrow
                         If R-X>0 Then
                              Top:=Top-X
                    End
                    #80:      Begin  // Down Arrow
                              If Bar+Top-1 < EntryCnt Then Begin
                                   If Bar < X Then
                                        Bar:=Bar+1
                                   Else Begin
                                        Bar:=X
                                        Top:=Top+1
                                   End
                              End
                    End
                    #72:      If Bar > 1 Then  // Up Arrow
                                   Bar:=Bar-1
                              Else Begin
                                   Bar:=1
                                   If Top > 1 Then
                                        Top:=Top-1
                              End
               End
          End Else Begin
               Ch:=Upper(Ch)
               Case Ch Of
                    #27: Done:=True
                    #13: If Ok2Tel = WARM Then ShowFile(Top+Bar-1)
                    'A': If Acs(AddACS) And Ok2Add=WARM Then Begin
                           AddNew;
                           Edit(-1);
                         End
                    'D': If Ok2Add = WARM Then DeleteEntry(Top+Bar-1)
                    'E': If Acs(AddACS) And Ok2Add=WARM Then Edit(Top+Bar-1)
               End
          End
     End
End

Begin
     ADAttr[WARM]:=(WHT*16)+(WHT+BLD)
     ADAttr[COLD]:=(WHT*16)+(BLK)
     If ParamCount > 0 Then
          IniFile:=ProgParams

     ReadINI

     Ok2Add:=COLD
     If Acs(AddAcs) Then Ok2Add:=Warm
     If Acs(TelACS) Then Ok2Tel:=Warm

     GetThisUser
     ListName := JustPath(ProgName)+ListFile +'.dat';

     While ReadEntry(EntryCnt+1) Do EntryCnt:=EntryCnt+1
     MakeWindow
     Main
     CloseWindow
     Write('|11|16')
End


