Uses Cfg
Uses User
Uses MBase

Const SysopACS	= 's255'
Const	IsFile	= 1
Const	IsDir		= 2

Type	GFilesRec = Record
	FileName: String[80]
	Title		: String[80]
	Owner		: String[30]
	FType		: Byte
End

Type CmdRec = Record
	MCmd	: String[4]
	MData	: String[80]
End


Var Cmd			: CmdRec
Var GFilesPath	: String
Var Entry		: GFilesRec
VAr SI			: Integer=1
Var DoMove		: Boolean = False
Var TotArts		: Integer
Var PageTop		: Byte
Var PageLen		: Byte
Var PageLeft	: Byte
Var PageWide	: Byte
Var MainFile	: String = 'gfmain.ans'
Var HiFile		: String = 'gfhi.ans'
Var LoFile 		: String = 'gflo.ans'
var HelpF		: String = 'gfhelp.ans'
var HelpS		: String = 'gfhelps.ans'
Var TitleLeft	: Byte
Var TitleRight	: Byte
Var TitleLen	: Byte
Var TitleLine	: Byte
Var MenuLeft	: Byte
Var MenuRight	: Byte
Var MenuLen		: Byte
Var MenuLine	: Byte
Var PageTitle	: String
Var LineCnt		: Integer

Function ReadEntry(I : Integer) : Boolean
Var Ret	: Boolean = False
Var Fp	: File
Begin
	fAssign(Fp,GFilesPath+'gfiles.dat',66)
	fReset(Fp)
	If IoResult = 0 Then Begin
		fSeek(Fp,SizeOf(Entry)*(I-1)) 
		If fPos (fp) < fSize(fp)  Then Begin
			fRead(Fp,Entry,SizeOf(Entry))
			Ret:=True
		End
		fClose(Fp)
	End
	ReadEntry:=Ret	
End

Function GetMBaseIDX(S:String):Integer
Var I,Ret	: Integer = 0
Begin
	I:=I+1
	While GetMBase(I) And Ret = 0 Do Begin
		If StripMCI(S) = StripMCI(MBaseName) Then Begin
			Ret:=I
		End
		I:=I+1
	End	
	GetMBaseIDX:=Ret
End

Function SaveEntry(I : Integer) : Boolean
Var Ret	: Boolean = False
Var Fp	: File
Begin
	fAssign(Fp,GFilesPath+'gfiles.dat',66)
	fReset(Fp)
	If IoResult <> 0 Then Begin
		fRewrite(Fp)
	End Else Begin
		If I<0 Then 
			fSeek(Fp,fSize(Fp))
		Else
			fSeek(Fp,SizeOf(Entry)*(I-1)) 
	End

	fWrite(Fp,Entry,SizeOf(Entry))
	Ret:=True
	fClose(Fp)

	SaveEntry:=Ret	
End

Function GetCommand(FN:String):Boolean
Var Ret	: Boolean = False
Var Fp	: File
Var S		: String
Begin
	fAssign(Fp,Fn,66)
	fReset(Fp)
	If IoResult = 0 Then Begin
		If Not fEof(Fp) Then Begin
			fReadLn(Fp,S)
		End
		fClose(Fp)
	End

	If WordCount(S,'^') = 3 Then Begin
		If Upper(WordGet(1,S,'^')) = 'COMMAND' Then Begin
			Cmd.MCmd:=Upper(WordGet(2,S,'^'))
			If Length(Cmd.MCmd) = 2 Then Begin
				Cmd.Mdata:=WordGet(3,S,'^')
				Ret:=True
			End
		End
	End
	GetCommand:=Ret
End

Procedure CountArts
Begin
	TotArts:=1
	While ReadEntry(TotArts) Do Begin
		TotArts:=TotArts+1
	End
End

Procedure DrawMainScreen
Var X1, X2, Y1, Y2, Attr: Byte
Begin
	ClrScr
	DispFile(MainFile)
	GetScreenInfo(1,X1,Y1,Attr)
	GetScreenInfo(2,X2,Y2,Attr)
	PageTop:=Y1
	PageLeft:=X1
	PageLen:=Y2-Y1
	PageWide:=X2-X1
	GetScreenInfo(3,X1,Y1,Attr)
	GetScreenInfo(4,X2,Y2,Attr)
	TitleLine:=Y1
	TitleLeft:=X1
	TitleRight:=X2
	TitleLen:=TitleRight-TitleLeft
	WriteXY(TitleLeft,TitleLine,Attr,PadCt(PageTitle,TitleLen,' '))
	GetScreenInfo(5,X1,Y1,Attr)
	GetScreenInfo(6,X2,Y2,Attr)
	MenuLine:=Y1
	MenuLeft:=X1
	MenuRight:=X2
	MenuLen:=MenuRight-MenuLeft
End

Function GetFileDate(P:String):LongInt
Var Ret	: Longint = 128
Begin
	FindFirst(P,16)
	If DOSError = 0 Then Begin
		Ret:=DirTime
	End
	FindClose
	GetFileDate:=Ret
End


Function GetFileSize(P:String):String
Var Ret	: LongInt = 0
Var Fp	: File
Var S	: String
Var Sz	: Integer
Begin
	If DirExist(P) Then S:='<DIR>'
	Else Begin
		fAssign(Fp,P,66)
		fReset(FP)
		Ret:=fSize(FP)
		fClose(FP)

		Sz:=Ret/1024

		S:=Int2Str(Sz+1)+'Kb'

	End
	GetFileSize:=S
End

Function AlreadyThere(FN:String):Boolean
Var Ret	: Boolean = False
Var I	: Integer = 1
Begin
	If FN = 'gfiles.dat' Then Ret:=True
	If FN = 'gfmain.ans' Then Ret:=True
	If FN = 'gfhi.ans' Then Ret:=True
	If FN = 'gflo.ans' Then Ret:=True
	While ReadEntry(I) And Not Ret Do Begin
		If Upper(FN)=Upper(Entry.Filename) Then
			Ret:=True
		I:=I+1
	End
	AlreadyThere:=Ret
End

Procedure SortAuthors
Var F1		: File
Var One, Two	: GFilesRec 
Var A,B,C,T,P	: Integer
Begin
	If Not Acs(SysopACS) Then exit


	P:=1
	While ReadEntry(P) Do Begin
		If Entry.FType = IsDir Then
			Entry.FileName:='111'+Entry.FileName
			SaveEntry(P)
		P:=P+1
	End
	
	fAssign(f1,GFilesPath+'gfiles.dat',66)
	fReset(f1)
	T:=fSize(F1)/SizeOf(Entry)

	If T < 2 Then Exit
	For P:=1 To T+1 Do Begin
		For A:=0 To T-1 Do Begin
			For B:=0 To T-1 Do Begin
				fReset(F1)
				fSeek(F1,(A)*SizeOf(One))
				fRead(F1,One,SizeOf(One))
				fReset(F1)
				fSeek(F1,(B)*SizeOf(Two))
				fRead(F1,Two,SizeOf(Two))
				If Upper(One.Owner) < Upper(Two.Owner) Then Begin
					fReset(F1)
					fSeek(F1,(A)*SizeOf(Two))
					fWrite(F1,Two,SizeOf(Two))
					fReset(F1)
       	     	fSeek(F1,(B)*SizeOf(One))
       	     	fWrite(F1,One,SizeOf(One))
				End Else Begin
					fReset(F1)
					fSeek(F1,(B)*SizeOf(Two))
					fWrite(F1,Two,SizeOf(Two))
					fReset(F1)
					fSeek(F1,(A)*SizeOf(One))
					fWrite(F1,One,SizeOf(One))
				End
			End
		End
	End
	P:=1
	While ReadEntry(P) Do Begin
		If Entry.FType = IsDir Then
			Entry.FileName:=Replace(Entry.FileName,'111','')
			SaveEntry(P)
		P:=P+1
	End
End

Procedure SortArts
Var F1		: File
Var One, Two	: GFilesRec 
Var A,B,C,T,P	: Integer
Begin
	If Not Acs(SysopACS) Then exit


	P:=1
	While ReadEntry(P) Do Begin
		If Entry.FType = IsDir Then
			Entry.FileName:='111'+Entry.FileName
			SaveEntry(P)
		P:=P+1
	End
	
	fAssign(f1,GFilesPath+'gfiles.dat',66)
	fReset(f1)
	T:=fSize(F1)/SizeOf(Entry)

	If T < 2 Then Exit
	For P:=1 To T+1 Do Begin
		For A:=0 To T-1 Do Begin
			For B:=0 To T-1 Do Begin
				fReset(F1)
				fSeek(F1,(A)*SizeOf(One))
				fRead(F1,One,SizeOf(One))
				fReset(F1)
				fSeek(F1,(B)*SizeOf(Two))
				fRead(F1,Two,SizeOf(Two))
				If Upper(One.Title) < Upper(Two.Title) Then Begin
					fReset(F1)
					fSeek(F1,(A)*SizeOf(Two))
					fWrite(F1,Two,SizeOf(Two))
					fReset(F1)
       	     	fSeek(F1,(B)*SizeOf(One))
       	     	fWrite(F1,One,SizeOf(One))
				End Else Begin
					fReset(F1)
					fSeek(F1,(B)*SizeOf(Two))
					fWrite(F1,Two,SizeOf(Two))
					fReset(F1)
					fSeek(F1,(A)*SizeOf(One))
					fWrite(F1,One,SizeOf(One))
				End
			End
		End
	End
	P:=1
	While ReadEntry(P) Do Begin
		If Entry.FType = IsDir Then
			Entry.FileName:=Replace(Entry.FileName,'111','')
			SaveEntry(P)
		P:=P+1
	End
End

Procedure AddNewArticles
Begin
	If Not ACS(SysopACS) Then Exit
	FindFirst(GFilesPath+'*',16)
	While DosError = 0 Do Begin
		If Not AlreadyThere(DirName) Then Begin
			If DirExist(GFilesPath+DirName) Then Begin
				Entry.FType:=IsDir
				Entry.Title:='<'+DirName+'>'
				Entry.FileName:=DirName	
			End Else Begin
				Entry.FType:=IsFile
				Entry.Title:=DirName
				Entry.FileName:=DirName	
			End
			Entry.Owner:=StripMCI(UserAlias)
			SaveEntry(-1)
		End
		FindNext
	End
	FindClose
	CountArts
	SortArts
End

Function MoveEntry(B,I:Integer):Integer
Var Ret	: Integer
Var UD	: Char
Var Temp: GFilesRec
VAr J	: Integer
Begin
	Ret:=B
	If ReadEntry(I) Then Begin
		GoToXy(MenuLeft,MenuLine)
		Write('|$X'+PadLt(Int2Str(MenuRight),2,'0')+' ')
		GoToXy(MenuLeft,MenuLine)
		Write('Move '+Entry.Title+' Arrow Up, Down, or [CR] When done : ')
		UD:=ReadKey
		If IsArrow Then Begin
			Case UD Of 
				#72: Begin
					Temp:=Entry
					If I > 1 Then Begin
						J:=I-1
						If ReadEntry(J) Then Begin
							SaveEntry(I)
							Entry:=Temp
							SaveEntry(J)
						End
						If B > 1 Then
							Ret:=B-1
						Else
							Ret:=1
					End
				End
				#80: Begin
					Temp:=Entry
					If I < TotArts-1 Then Begin
						J:=I+1
						If ReadEntry(J) Then Begin
							SaveEntry(I)
							Entry:=Temp
							SaveEntry(J)
						End 
						Ret:=B+1
					End
				End
			End
		End Else Begin
			Case UD Of
				#27,#13: DoMove:=False
			End
		End
	End
	DrawMainScreen
	MoveEntry:=Ret
End

Function DownloadFile(I:Integer):Boolean
Var TT	: String
Begin
	If ReadEntry(I) Then Begin
		If FileExist(GFilesPath+Entry.Filename) Then Begin
			WriteLn('F3 '+GFilesPath+Entry.filename)
			MenuCmd('F3',GFilesPath+Entry.Filename)
			Pause
			DrawMainScreen
		End
	End
End

Function UpdateTitle(B,I:Integer):Boolean
Var Ret	: Boolean = False
Var X,Y,A : Byte
Begin
	If Not ACS(SysopACS) Then Exit
	If ReadEntry(I) Then Begin
		GetScreenInfo(8,X,Y,A)
		GoToXy(X,Y)
		Entry.Title:=Input(79-X,60,1,Entry.Title)	
		SaveEntry(I)
		WriteXY(1,25,10,PadLt(Int2Str(X),2,' ')+':'+PadLt(Int2Str(Y),2,' '))
	End
	UpdateTitle:=Ret
End

Procedure EditFile(FX,Subject:String)
Var
  Lines    : Integer = 0;
  WrapPos  : Integer = 80;
  MaxLines : Integer = 250;
  Forced   : Boolean = False
  Template : String  = 'ansiedit';
  Count	  : Integer;
  F1       : File;
  S        : String
Begin
	If FileExist(FX) Then Begin
		fAssign(F1,FX,66)
		fReset(F1)
		If IOResult = 0 Then Begin
			While Not fEof(F1) Do Begin
				fReadLn(F1,S)
				Lines:=Lines+1
				MsgEditSet(Lines,S)
			End
			fClose(F1)
		End
	End

	MaxLines:=Lines+200

  	SetPromptInfo(1, FX);  // if template uses &1 for "To:" display

	If MsgEditor(0,Lines,WrapPos,MaxLines,Forced,Template, Subject) Then Begin
		fAssign(F1,FX,66)
		fReWrite(F1)
		For Count := 1 to Lines Do Begin
			fWriteLn(F1,MsgEditGet(Count));
		End
	End
	CountArts
	DrawMainScreen
End

Procedure EditArticle(I:Integer)
Begin
	If Not ACS(SysopAcs) Then Exit
	If ReadEntry(I) Then Begin
		EditFile(GFilesPath+Entry.Filename,Entry.Title)
	End
	DrawMainScreen
End


Function DeleteEntry(I:Integer):Boolean
Var Ret	: Boolean = False
Var J	: Integer
Var Fx	: File
Var TT	: String
Begin
	If Not ACS(SysopACS) Then Exit
	If ReadEntry(I) Then Begin
		GoToXy(MenuLeft,MenuLine)
		Write('|$X'+PadLt(Int2Str(MenuRight),2,'0')+' ')
		GoToXy(MenuLeft,MenuLine)
		If InputYN(' Delete '+Entry.Title+'? ') Then Begin
			TT:=Entry.Filename
			If FileExist(GFilesPath+Entry.Filename) Then Begin
				GoToXy(MenuLeft,MenuLine)
				Write('|$X'+PadLt(Int2Str(MenuRight),2,'0')+' ')
				GoToXy(MenuLeft,MenuLine)
				If InputYN(' Delete file "'+Entry.Filename+'" too? ') Then 
					fileErase(GFilesPath+Entry.Filename)
			End
			fAssign(Fx,GFilesPath+'gfiles.dat.tmp',66)
			fRewrite(Fx)
			J:=1
			While ReadEntry(J) Do Begin
//				If Entry.Filename <> TT Then 
				If J <> I Then
					fWrite(Fx,Entry,SizeOf(Entry))
				J:=J+1
			End
			fClose(Fx)
			fileErase(GFilesPath+'gfiles.dat')
			fileCopy(GFilesPath+'gfiles.dat.tmp',GFilesPath+'gfiles.dat')
			fileErase(GFilesPath+'gfiles.dat.tmp')
				
		End
	End
	CountArts
	DrawMainScreen
	DeleteEntry:=Ret
End

Function GetAgo(File:String):String
Var DG	: String
Var DY	: Integer
Begin
	DY:=DaysAgo(Date2Julian(DateStr(GetFileDate(File),1)))
	If DY > 0 Then Begin
		If DY > 7 Then Begin
			If DY > 30 Then Begin
				If DY > 365 Then Begin
					DY:=DY/364
					DG:=Int2Str(DY)
					If DY > 1 Then
						DG:=DG+' years'
					Else
						DG:=DG+' year'
				End Else Begin
					DY:=DY/30
					DG:=Int2Str(DY)
					If DY > 1 Then
						DG:=DG+' months'
					Else
						DG:=DG+' month'
				
				End
			End Else Begin
				DY:=DY/7
				DG:=Int2Str(DY)
				If DY > 1 Then
					DG:=DG+' weeks'
				Else
					DG:=DG+' week'
			End
		End Else Begin
			If DY > 1 Then
				DG:=Int2Str(DY)+' days'
			Else
				DG:='Yesterday'
				
		End
	End Else Begin
		DG:='Today'
	End
	GetAgo:=DG
End

Procedure ListArts(B,T:Integer)
Var R,I	: Integer
Var DS,TS: String
Var DG	: String
Var DY	: Integer
Var SZ	: String
Begin
	For R:=1 To PageLen+1 Do Begin
		I:=R+T-1
		GoToXy(PageLeft,R+PageTop-1)
		If ReadEntry(I) Then Begin
			DS:=DateStr(GetFileDate(GFilesPath+Entry.FileName),1)
			TS:=TimeStr(GetFileDate(GFilesPath+Entry.FileName),False)
			DG:=GetAgo(GFilesPath+Entry.FileName)
			SZ:=GetFileSize(GFilesPath+Entry.FileName)

			SetPromptInfo(1,Entry.Title)
			SetPromptInfo(2,DG)
			SetPromptInfo(3,DS)
			SetPromptInfo(4,TS)
			SetPromptInfo(5,SZ)
			SetPromptInfo(6,Entry.FileName)
			SetPromptInfo(7,Entry.Owner)

			If R = B Then 
				DispFile(HiFile)
			Else 
				DispFile(LoFile)
		End Else Begin
			Write(PadRt(' ',PageWide,' '))
		End
	End
End

Procedure PostArticle(I:Integer)
Var MB,TF,TL,TT	: String
Var X				: Integer
Var PStr			: String
Begin
	If Not Acs(SysopACS) Then Exit
	PStr:='|[Y'+PadLt(Int2Str(MenuLine),2,'0')
	PStr:=PStr+'|[X'+PadLt(Int2Str(MenuLeft),2,'0')+'|11 '
	PStr:=PStr+'Edit before posting? |08:|11'
	If ReadEntry(I) Then Begin
		TL:=Entry.Title
		TF:=GFilesPath+Entry.FileName
		TT:=CfgTempPath+Entry.FileName
		FileCopy(TF,TT)
		WriteXY(MenuLeft,MenuLine,0,PadRt(' ',MenuRight-MenuLeft,' '))
		If InputYN(PStr) Then
			EditFile(TT,Entry.Title)
		MenuCmd('MG','')
		MenuCmd('MA','')
		MB:=StripMCI(MCI2Str('MB'))
		X:=GetMBaseIDX(MB)
		WriteXY(MenuLeft,MenuLine,11,MB + '('+Int2Str(X)+')')
		If InputYN(': Post here? : ') Then Begin
			MenuCmd('MX',TT+';'+Int2Str(X)+';'+UserAlias+';All;'+TL)
		End
		If FileExist(TT) Then FileErase(TT)
		DrawMainScreen	
	End
End

Procedure DoHelp
Begin
	If Acs(SysopACS) Then DispFile(HelpS)
	Else DispFile(HelpF)
	ReadKey
	DrawMainScreen	
End

Procedure ShowFile
Var FN,TL	: String
Begin
	FN:=Upper(Entry.FileName)
	TL:=Replace(Entry.Title,' ','_')
	If Pos('.ANS',FN) > 0 Or Pos('.ASC',FN) > 0 Then Begin
		ClrScr
		DispFile(GFilesPath+Entry.FileName)
		Pause
	End Else Begin
		If FileExist(CfgMPEPath+'textview.mpx') Then Begin
			MenuCmd('GX','textview '+GFilesPath+Entry.Filename+' '+TL)
		End Else Begin
			MenuCmd('GV','ansiviewer;ansihelp;d;'+GFilesPath+Entry.Filename)
		End
	End
	DrawMainScreen
End

Procedure RunCommand
Begin
	MenuCmd(Cmd.MCmd,Cmd.MData)
	DrawMainScreen
End

Procedure CreateNew
Var FN	: String
Begin
	If Not Acs(SysopACS) Then exit
	WriteXY(MenuLeft,MenuLine,0,PadRt(' ',MenuRight-MenuLeft,' '))
	GoToXY(MenuLeft,MenuLine)
	Write(' |11Filename: ')
	FN:=Input(50,50,1,'')
	EditFile(GFilesPath+FN,'New Article')
	AddNewArticles
End

Procedure Main
Var I,First,H,Test: Integer
Var Done, M: Boolean = False
Var Ch  : Char
Var Bar	: Byte = 1
Var TS,DS: String
Begin
	CountArts
	First:=1
	DrawMainScreen
	While Not Done Do Begin
		H:=Bar+First-1
		ListArts(Bar,First)
		If DoMove Then Begin
			Test:=Bar+First
			Bar:=MoveEntry(Bar,H)
			If Bar > PageLen Then Begin
				Bar:=PageLen
				First:=First+1
			End
			If Bar < 1 Then Begin
				Bar:=1
				First:=First-1
				If Test < 1 Then Begin
					Bar:=1
					First:=1
				End
			End
		End Else Begin
			Ch:=ReadKey
			If IsArrow Then Begin
				Case Ch Of
					#77:	Begin
						If H+PageLen<TotArts Then
							First:=First+PageLen
					End
					#75: Begin
						If H-PageLen>0 Then
							First:=First-PageLen
					End
					#71: Begin // Home Key	
						Bar:=1
						First:=1
					End
					#79: Begin // End Key
						If TotArts < PageLen Then Begin
							Bar:=TotArts-1
							First:=1
						End Else Begin
							Bar:=PageLen+1
							First:=TotArts-PageLen-1
						End
					End
					#72: Begin
						If Bar > 1 Then
							Bar:=Bar-1
						Else Begin
							Bar:=1
							If First > 1 Then First:=First-1
						End
					End
					#80: Begin
						If Bar <= PageLen Then Begin
							If H < TotArts-1 Then Begin
								Bar:=Bar+1
							End
						End Else Begin
							Bar:=PageLen+1
							If H < TotArts-1 Then
								First:=First+1
						End
					End
					#27: Done:=True
				End
			End Else Begin
				Ch:=Upper(CH)
				Case Ch Of
					#13: Begin
						I:=Bar+First-1
						ReadEntry(I)
						If Entry.FType = IsDir Then Begin
							MenuCmd('GX','gfiles '+GFilesPath+Entry.Filename+PathChar+' '+Replace(Entry.Title,' ','_'))
							DrawMainScreen
						End Else Begin
							If GetCommand(GFilesPath+Entry.FileName) Then 
								RunCommand	
							Else
								ShowFile
						End
					End
					'A': AddNewArticles
					'C': CreateNew
					'E': EditArticle(Bar+First-1)
					'D': DeleteEntry(Bar+First-1)
					'U': UpdateTitle(Bar,Bar+First-1)
					'N': DownloadFile(Bar+First-1)
					'P': PostArticle(Bar+First-1)
					'M': If Acs(SysopACS) Then DoMove:=True
					'S': SortArts
					'T': SortAuthors
					'X': Done:=True
					'?': DoHelp
					#27: If DoMove Then DoMove:=False Else Done:=True
				End
			End
		End
	End
End

Begin
	GetThisUser
	GFilesPath:=AddSlash(ParamStr(1))
	If FileExist(GFilesPath+'gfmain.ans') Then MainFile:=GFilesPath+'gfmain.ans'
	If FileExist(GFilesPath+'gflo.ans') Then LoFile:=GFilesPath+'gflo.ans'
	If FileExist(GFilesPath+'gfhi.ans') Then HiFile:=GFilesPath+'gfhi.ans'
	PageTitle:=''
	If ParamStr(2) <> '' Then Begin
		PageTitle:=StripMCI(Replace(ParamStr(2),'_',' '))
	End
	MenuCmd('NA','Reading '+StripMCI(PageTitle))
	MenuCmd('-S','Reading '+StripMCI(PageTitle))
	Main
End
