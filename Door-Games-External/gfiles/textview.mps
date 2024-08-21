Uses Cfg
Uses User

Var TheFile	: String
Var Title	: String
Var ScreenFile	: String = 'textview.ans'
Var Top		: Byte
Var Left	: Byte
Var Right	: Byte
Var Attr	: Byte
Var Bottom	: Byte
Var PageLen	: Byte
Var PageWid	: Byte
Var TitlWid	: Byte
Var LineCnt	: Integer = 1
Var TotPages	: Integer = 1
Var T1X,T2X	: Byte
Var T1Y,T2Y	: Byte
Var TAttr	: Byte


Var TextLine	: String[254]

Function ReadTemp(I:Integer):Boolean
Var Ret	: Boolean = False
Var Fp	: File
Begin
	fAssign(Fp,CfgTempPath+'textview.dat',66)
	fReset(fp)
	If IoResult = 0 Then Begin
		fSeek(Fp,(I-1)*SizeOf(TextLine))
		fRead(Fp,TextLine,SizeOf(TextLine))
		Ret:=True
		fClose(Fp)
	End
	ReadTemp:=Ret
End

Procedure Add2TmpFile(S:String)
Var F1	: File
Begin
	fAssign(F1,CfgTempPath+'textview.dat',66)
	fReset(F1)
	If IoResult <> 0 Then 
		fReWrite(F1)
	Else 
		fSeek(F1,fSize(F1))
	fWrite(F1,S,SizeOf(TextLine))
	fClose(F1)	
End

Procedure LoadFile
Var Fp	: File
Begin
	fAssign(fp,TheFile,66)
	fReset(fp)
	If IoResult = 0 Then Begin
		While Not fEof(Fp) Do Begin
			TextLine:=''
			fReadLn(Fp,TextLine)
//			TextLine:=StripMCI(TextLine)
			TextLine:=Replace(TextLine,#9,'        ')
			Add2TmpFile(TextLine)
			LineCnt:=LineCnt+1
		End
		fClose(Fp)
	End
End

Procedure DrawElevator(P:Integer)
Var Y		: Byte
Var ESize	: Byte 
Var S		: Real
Begin
	P:=P+1
	ESize:=(PageLen/TotPages)+1
	If ESize<1 Then ESize:=1

	S:=(PageLen/TotPages)

	For Y:=1 To PageLen Do Begin
		WriteXY(PageWid+Left+1,Y+Top-1,9,#178)
	End

	For Y:=1 To ESize Do Begin
		WriteXY(PageWid+Left+1,Y+Top+(S*P)-ESize,9,#219)
	End
//	WriteXY(PageWid+Left+1,Bottom,10,PadLt(Int2Str(P),2,' '))
End

Procedure ReadScreenFile
Begin
	ClrScr
	DispFile(ScreenFile)
	GetScreenInfo(1,Left,Top,Attr)
	GetScreenInfo(2,Right,Bottom,Attr)
	GetScreenInfo(3,T1X,T1Y,TAttr)
	GetScreenInfo(4,T2X,T2Y,TAttr)
	PageLen:=Bottom-Top+1
	PageWid:=Right-Left
	TitlWid:=T2X-T1X
	WriteXY(T1X,T1Y,TAttr,PadCt(Copy(Title,1,TitlWid),TitlWid,' '))
End

Function Line2Page(L:Integer):Integer
Begin
	Line2Page:=(L/PageLen)
End

Procedure ListLines(L:Integer)
Var X,Y	: Byte
Var P	: Integer
Begin
	For Y:=1 To PageLen Do Begin
		If ReadTemp(L+Y-1) Then 
			WriteXY(Left,Y+Top-1,Attr,PadRt(Copy(TextLine,1,PageWid),PageWid,' '))
		Else
			WriteXY(Left,Y+Top-1,Attr,PadRt(' ',PageWid,' '))
	End
	P:=Line2Page(L)
	DrawElevator(P)
End

Procedure Main
Var Done : Boolean = False
Var Ch	 : Char
Var Line : Integer = 1
Var LineStop : Integer = LineCnt-PageLen-1
Begin
	While Not Done Do Begin
		ListLines(Line)
		Ch:=ReadKey
		If IsArrow Then Begin
			Case Ch Of
				#71: Begin	// Home
					Line:=1
				End
				#79: Begin	// End
					Line:=LineStop
				End
				#75: Begin	//Left - Page Up
					If Line > PageLen Then Begin
						Line:=Line-PageLen
					End Else Begin
						Line:=1
					End
				End
				#77: Begin	//Right - Page Down	
					If Line < LineStop Then
						Line:=Line+PageLen
					If Line > LineStop Then
						Line:=LineStop
				End
				#72: Begin 
					If Line > 1 Then
						Line:=Line-1
				End
				#80: Begin
					If Line < LineStop Then
						Line:=Line+1
				End
			End
		End Else Begin
			Ch:=Upper(Ch)
			Case Ch Of
				#27: Done:=True
				#13: Begin	//Right - Page Down	
					If Line < LineStop Then
						Line:=Line+PageLen
					If Line > LineStop Then 
						Line:=LineStop
				End
			End	
		End
	End
End

Begin
	GetThisUser
	If FileExist(CfgTempPath+'textview.dat') Then
		FileErase(CfgTempPath+'textview.dat')
	If ParamCount < 1 Then Halt
	TheFile:=ParamStr(1)
	If ParamCount > 1 Then Begin
		Title:=ParamStr(2)
		Title:=Replace(Title,'_',' ')
	End
	LoadFile
	ReadScreenFile	
	TotPages:=LineCnt/PageLen+1
	SysopLog(UserAlias + ' read '+Thefile)
	Main
End
