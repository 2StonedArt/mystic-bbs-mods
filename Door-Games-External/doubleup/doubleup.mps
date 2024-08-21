/*

	06/27/2014
	This is the Mystic doorgame Double-Up! by Darryl Perry, aka Gryphon
	of Cyberia BBS (cyberia.darktech.org) 

	Double-Up! is a sliding block puzzle game patterned after the popular
	video game, 2048, by Gabriele Cirulli.

	Double-Up! is witten for Mystic BBS using the MPL scripting language.
	This program requires Mystic BBS v1.10a36 or later to run.

	Place the doubleup.mps script in your scripts directory, and compile it.

	Create a Mystic menu of type 'GX' with the data field of 'doubleup'.
	

*/

Uses Cfg
Uses User

Const SX	= 18 
Const SY	= 2

Const NN = 1
Const EE = 2
Const SS = 3
Const WW = 4

Type	PlyrRec = Record
	Idx	: Integer
	Name	: String[40]
	GameScore	: LongInt
	GameMoves	: Integer
	GameHiMark	: Integer	
	BestScore	: LongInt
	BestMoves	: Integer
	BestHiMark	: Integer	
	GamesPlayed	: Integer
End


Var Grid		: Array [1..4,1..4] of Integer
Var Dirg		: Array [1..4,1..4] Of Integer
Var DirX		: Array [1..4] of Integer
Var DirY		: Array [1..4] of Integer
Var Field	: LongInt
Var ScoreBox: LongInt
Var BestBox	: LongInt
Var MenuBox	: LongInt
Var BeatBox	: LongInt
Var Colors	: Array [1..16] Of Integer
Var Plyr		: PlyrRec
Var GameOver: Boolean = False
Var PlyrCnt	: Integer = 0
Var PlyrFile: String
Var Highest	: PlyrRec
Var ScorAns	: String


Procedure SavePlyr (PlyrNo : Integer)
Var PlyrFilePtr	: File
Begin
	fAssign(PlyrFilePtr,PlyrFile,66)
	fReset(PlyrFilePtr)
	If IOResult <> 0 Then Begin
		fReWrite(PlyrFilePtr)
		Plyr.Idx:=1
	End Else
		fSeek(PlyrFilePtr,(PlyrNo-1)*SizeOf(Plyr))
	fWrite(PlyrFilePtr,Plyr,SizeOf(Plyr))

	fClose(PlyrFilePtr)
End

Function ReadPlyr (PlyrNo : Integer): Boolean
Var X       : Integer
Var Ret     : Boolean = False
Var PlyrFilePtr	: File
Begin
	fAssign(PlyrFilePtr,PlyrFile,66)
	If fileExist(PlyrFile) Then
  		fReset(PlyrFilePtr)
	Else
		fReWrite(PlyrFilePtr)

	fSeek(PlyrFilePtr,(PlyrNo-1)*SizeOf(Plyr))
	If Not fEof(PlyrFilePtr) Then Begin
		fRead(PlyrFilePtr,Plyr,SizeOf(Plyr))
		Ret:=True
	End
	fClose(PlyrFilePtr)
	ReadPlyr:=Ret
End

Function Exp(N:Integer):Integer
Var Ret	: Integer = 1
Begin
	While N > 0 Do Begin
		N:=N-1
		Ret:=Ret*2
	End
	Exp:=Ret
End

Procedure GetHighest
Var X	: Integer
Var MeMe	: PlyrRec
Var S	: String
Begin

	MeMe:=Plyr	
	Highest.BestScore:=0
	X:=1
	While ReadPlyr(X) Do Begin
		If Plyr.BestScore > Highest.BestScore Then
			Highest:=Plyr
		X:=X+1
	End
	WriteXY(4,15,95,Copy(Highest.Name,1,16))
	WriteXY(12,17,94,PadLt(StrComma(Highest.BestScore),8,' '))

	S:='|19|00'+PadCt(Int2Str(Exp(Highest.BestHiMark)),4,' ')
	WriteXY(14,19,Colors[Highest.BestHiMark+1],PadCt(#219,6,#219))
	GoToXy(15,19); Write(S)

	Plyr:=MeMe
End

Function FindPlyr(PlyrName : String) : Integer
Var Ret     : Integer = 0
Var X       : Integer
Var Found   : Boolean = False
Begin
	X:=1
	While ReadPlyr(X) And Not Found Do Begin
		If Upper(Plyr.Name)=Upper(UserAlias) Then Begin
			Ret:=X
			Found:=True
		End
		X:=X+1
	End
	FindPlyr:=Ret
End

Procedure DrawSpot(X,Y:Byte)
Var S	: String
Var C	: Integer
Begin
	C:=Grid[X,Y]+1
	S:=PadCt(Int2Str(Exp(C-1)),4,' ')
	WriteXY(SX+(X*8),SY+(Y*4)-1,Colors[C],PadCt(#219,6,#219))
	WriteXY(SX+(X*8),SY+(Y*4)  ,Colors[C],PadCt(#219,6,#219))
	WriteXY(SX+(X*8),SY+(Y*4)+1,Colors[C],PadCt(#219,6,#219))
	If Exp(C-1) > 1 Then
		WriteXY(SX+(X*8)+1,SY+(Y*4),(16*7),S)
End

Procedure DrawGrid
Var D,C	: Integer
Var X,Y	: Byte
Var T,S	: String
Begin
	For X:=1 To 4 Do Begin
		For Y:=1 To 4 Do Begin
		DrawSpot(X,Y)
//			C:=Grid[X,Y]+1
//			S:=PadCt(Int2Str(Exp(C-1)),4,' ')
//			WriteXY(SX+(X*8),SY+(Y*4)-1,Colors[C],PadCt(#219,6,#219))
//			WriteXY(SX+(X*8),SY+(Y*4)  ,Colors[C],PadCt(#219,6,#219))
//			WriteXY(SX+(X*8),SY+(Y*4)+1,Colors[C],PadCt(#219,6,#219))
//			If Exp(C-1) > 1 Then
//				WriteXY(SX+(X*8)+1,SY+(Y*4),(16*7),S)
		End
	End
End

Procedure AddRandom
Var C,X,Y	: Byte
Var Done	: Boolean = False
Begin
	C:=0
	Repeat
		X:=Random(4)+1
		Y:=Random(4)+1
		If Grid[X,Y]=0 Then Begin 
			Grid[X,Y]:=1
			Done:=True
		End
		C:=C+1
	Until Done Or C > 100
End

Procedure DrawField
Begin
	ClassCreate (Field, 'box');
	ClassCreate(ScoreBox,'box')
	ClassCreate(BestBox,'box')
	ClassCreate(MenuBox,'box')
	ClassCreate(BeatBox,'box')

	BoxHeader	(ScoreBox,1,78,' Game Scores ')
	BoxHeader	(BestBox ,1,31,' Best Scores ')
	BoxHeader	(Field   ,1,31,' Double-Up! ')
	BoxHeader	(MenuBox ,1,31,' Menu ')
	BoxHeader   (BeatBox ,1,31,' One To Beat ')

	BoxOptions(Field   ,6,True, 127, 120, 127, 120, False,0);
	BoxOptions(ScoreBox,5,True,  19,  23,  15,  15, False,0);
	BoxOptions(BeatBox ,5,True,  83,  83,  15,  15, False,0);
	BoxOptions(BestBox ,5,True,  71,  71,  15,  15, False,0);
	BoxOptions(MenuBox ,5,True,  99,  99,  15,  15, False,0);


	BoxOpen (ScoreBox,    2, SY+1,  SX+3, SY+9)
	BoxOpen (BeatBox ,    2, SY+11, SX+3, SY+19)
	BoxOpen (Field   , SX+5, SY+1, SX+40, SY+19)
	BoxOpen (BestBox ,SX+42, SY+1,    79, SY+9)
	BoxOpen (MenuBox ,SX+42, SY+11,   79, SY+19)

	GoToXy(1,1)
	Write('|16|11 |19|15 '+PadCt('Double-Up!  By Darryl Perry 2014',76,' ')+' |16')

	WriteXY(4,5 ,30,'Score  :')
	WriteXY(4,7 ,30,'Moves  :')
	WriteXY(4,9 ,30,'Highest:')
	WriteXY(SX+45,5,78,'Score  :')
	WriteXY(SX+45,7,78,'Moves  :')
	WriteXY(SX+45,9,78,'Highest:')

	WriteXY(4,17,94,'Score  :')
	WriteXY(4,19,94,'Highest:')

	WriteXY(SX+45,15,110,#16+','+#17+','+#30+','+#31+' = Move')
	WriteXY(SX+45,16,110,'Q, ESC  = QUIT')
	WriteXY(SX+45,17,110,'L = Players  ')
	WriteXY(SX+45,18,110,'? = Help     ')
End

Procedure DeInit
Begin
	BoxClose(Field)
	BoxClose(ScoreBox)
	BoxClose(BestBox)
	BoxClose(MenuBox)
	BoxClose(BeatBox)
	ClassFree(Field)
	ClassFree(ScoreBox)
	ClassFree(BestBox)
	ClassFree(MenuBox)
	ClassFree(BeatBox)
End

Procedure ResetPlayer
Begin
	Plyr.GameMoves:=0
	Plyr.GameHiMark:=1
	Plyr.GameScore:=1
	Plyr.GamesPlayed:=Plyr.GamesPlayed+1
	SavePlyr(Plyr.Idx)
End

Procedure ResetGame
Var X,Y	: Byte
Begin
	For X:=1 To 4 Do Begin
		For Y:=1 To 4 Do Begin
			Grid[X,Y]:=0
		End
	End

	AddRandom
	AddRandom
	GameOver:=False

End

Procedure NewPlayer
Begin
	PlyrCnt:=PlyrCnt+1
	Plyr.Idx:=PlyrCnt
	Plyr.Name:=UserAlias
	Plyr.BestMoves:=0
	Plyr.BestScore:=0
	Plyr.BestHiMark:=1
	Plyr.GamesPlayed:=1
	ResetPlayer
	SavePlyr(Plyr.Idx)
End

Procedure Init
Var X,C	: Integer=0
Begin

	DirX[NN]:=0;	DirY[NN]:=-1
	DirX[EE]:=1;	DirY[EE]:=0
	DirX[SS]:=0;	DirY[SS]:=1
	DirX[WW]:=-1;	DirY[WW]:=0

	Colors[1]:=7
	Colors[2]:=1
	Colors[3]:=2
	Colors[4]:=3
	Colors[5]:=4
	Colors[6]:=5
	Colors[7]:=6
	Colors[8]:=9
	Colors[9]:=+10
	Colors[10]:=11
	Colors[11]:=12
	Colors[13]:=13
	Colors[14]:=14
	Colors[15]:=10

	ScorAns:=CfgTextPath+'duscore.ans'
	If ParamCount > 0 Then Begin
		ScorAns:=ParamStr(1)
	End

	GetThisUser
	PlyrFile:=CfgDataPath+PathChar+'dblup.ply'
	
	MenuCmd('NA','Playing Double-Up!')

	PlyrCnt:=0
	While ReadPlyr(PlyrCnt+1) Do PlyrCnt:=PlyrCnt+1

	X:=FindPlyr(UserAlias)
	If X < 1 Then NewPlayer
	Else	ReadPlyr(X)

	DrawField
	GetHighest
	ResetGame
	ResetPlayer
End

Procedure GoWest
Var Z,X,Y	: Byte
Begin
	For Y:=1 To 4 Do Begin
		For Z:=1 To 4 Do Begin
			For X:=1 To 3 Do Begin
				If Grid[X,Y] = 0 Then Begin
					Grid[X,Y]:=Grid[X+1,Y]
					Grid[X+1,Y]:=0
					DrawSpot(X,Y)
					DrawSpot(X+1,Y)
				End
			End
		End
	End
	For Y:=1 To 4 Do Begin
		For X:=1 To 3 Do Begin
			If Grid[X,Y]>0 Then Begin
				If Grid[X,Y]=Grid[X+1,Y] Then Begin
					Grid[X,Y]:=Grid[X,Y]+1
					If Grid[X,Y] > Plyr.GameHiMark Then
						Plyr.GameHiMark:=Grid[X,Y]
					Plyr.GameScore:=Plyr.GameScore+Exp(Grid[X,Y])
					Grid[X+1,Y]:=0
					DrawSpot(X,Y)
					DrawSpot(X+1,Y)
				End
			End
		End
	End
	For Y:=1 To 4 Do Begin
		For Z:=1 To 4 Do Begin
			For X:=1 To 3 Do Begin
				If Grid[X,Y] = 0 Then Begin
					Grid[X,Y]:=Grid[X+1,Y]
					Grid[X+1,Y]:=0
					DrawSpot(X,Y)
					DrawSpot(X+1,Y)
				End
			End
		End
	End
End

Procedure GoEast
Var Z,X,Y	: Byte
Begin
	For Y:=1 To 4 Do Begin
		For Z:=1 To 4 Do Begin
			For X:=4 Down To 2 Do Begin
				If Grid[X,Y] = 0 Then Begin
					Grid[X,Y]:=Grid[X-1,Y]
					Grid[X-1,Y]:=0
					DrawSpot(X,Y)
					DrawSpot(X-1,Y)
				End
			End
		End
	End
	For Y:=1 To 4 Do Begin
		For X:=4 Down To 2 Do Begin
			If Grid[X,Y]>0 Then Begin
				If Grid[X,Y]=Grid[X-1,Y] Then Begin
					Grid[X,Y]:=Grid[X,Y]+1
					If Grid[X,Y] > Plyr.GameHiMark Then
						Plyr.GameHiMark:=Grid[X,Y]
					Plyr.GameScore:=Plyr.GameScore+Exp(Grid[X,Y])
					Grid[X-1,Y]:=0
					DrawSpot(X,Y)
					DrawSpot(X-1,Y)
				End
			End
		End
	End
	For Y:=1 To 4 Do Begin
		For Z:=1 To 4 Do Begin
			For X:=4 Down To 2 Do Begin
				If Grid[X,Y] = 0 Then Begin
					Grid[X,Y]:=Grid[X-1,Y]
					Grid[X-1,Y]:=0
					DrawSpot(X,Y)
					DrawSpot(X-1,Y)
				End
			End
		End
	End
End

Procedure GoNorth
Var Z,X,Y	: Byte
Begin
	For X:=1 To 4 Do Begin
		For Z:=1 To 4 Do Begin
			For Y:=1 To 3 Do Begin
				If Grid[X,Y] = 0 Then Begin
					Grid[X,Y]:=Grid[X,Y+1]
					Grid[X,Y+1]:=0
					DrawSpot(X,Y)
					DrawSpot(X,Y+1)
				End
			End
		End
	End
	For X:=1 To 4 Do Begin
		For Y:=1 To 3 Do Begin
			If Grid[X,Y]>0 Then Begin
				If Grid[X,Y]=Grid[X,Y+1] Then Begin
					Grid[X,Y]:=Grid[X,Y]+1
					If Grid[X,Y] > Plyr.GameHiMark Then
						Plyr.GameHiMark:=Grid[X,Y]
					Plyr.GameScore:=Plyr.GameScore+Exp(Grid[X,Y])
					Grid[X,Y+1]:=0
					DrawSpot(X,Y)
					DrawSpot(X,Y+1)
				End
			End
		End
	End
	For X:=1 To 4 Do Begin
		For Z:=1 To 4 Do Begin
			For Y:=1 To 3 Do Begin
				If Grid[X,Y] = 0 Then Begin
					Grid[X,Y]:=Grid[X,Y+1]
					Grid[X,Y+1]:=0
					DrawSpot(X,Y)
					DrawSpot(X,Y+1)
				End
			End
		End
	End
End

Procedure GoSouth
Var Z,X,Y	: Byte
Begin
	For X:=1 To 4 Do Begin
		For Z:=1 To 4 Do Begin
			For Y:=4 Down To 2 Do Begin
				If Grid[X,Y] = 0 Then Begin
					Grid[X,Y]:=Grid[X,Y-1]
					Grid[X,Y-1]:=0
					DrawSpot(X,Y)
					DrawSpot(X,Y-1)
				End
			End
		End
	End
	For X:=1 To 4 Do Begin
		For Y:=4 Down To 2 Do Begin
			If Grid[X,Y]>0 Then Begin
				If Grid[X,Y]=Grid[X,Y-1] Then Begin
					Grid[X,Y]:=Grid[X,Y]+1
					If Grid[X,Y] > Plyr.GameHiMark Then
						Plyr.GameHiMark:=Grid[X,Y]
					Plyr.GameScore:=Plyr.GameScore+Exp(Grid[X,Y])
					Grid[X,Y-1]:=0
					DrawSpot(X,Y)
					DrawSpot(X,Y-1)
				End
			End
		End
	End
	For X:=1 To 4 Do Begin
		For Z:=1 To 4 Do Begin
			For Y:=4 Down To 2 Do Begin
				If Grid[X,Y] = 0 Then Begin
					Grid[X,Y]:=Grid[X,Y-1]
					Grid[X,Y-1]:=0
					DrawSpot(X,Y)
					DrawSpot(X,Y-1)
				End
			End
		End
	End
End

Function CountEmpty:Integer
Var Ret	: Integer = 0
Var X,Y	: Byte
Begin
	For X:=1 To 4 Do Begin
		For Y:=1 To 4 Do Begin
			If Grid[X,Y]=0 Then Ret:=Ret+1
		End
	End
	CountEmpty:=Ret
End

Function CountMoves:Integer
Var Ret	: Integer = 0
Var X,Y	: Integer
Begin
	For X:=1 To 3 Do 
		For Y:=1 To 4 Do 
			If Grid[X,Y]=Grid[X+1,Y] Then Ret:=Ret+1

	For Y:=1 To 3 Do
		For X:=1 To 4 Do
			If Grid[X,Y]=Grid[X,Y+1] Then Ret:=Ret+1
	CountMoves:=Ret
End

Procedure Check4Best
Begin
	If Plyr.GameScore>Plyr.BestScore Then Begin
		Plyr.BestScore:=Plyr.GameScore
		Plyr.BestMoves:=Plyr.GameMoves
		Plyr.BestHiMark:=Plyr.GameHiMark
	End
End

Procedure Move(DD:Byte)
Var X,Y	: Byte
Var Changed: Boolean = False
Begin

	Changed:=False
	For Y:=1 To 4 Do 
		For X:=1 To 4 Do 
			Dirg[X,Y]:=Grid[X,Y]

	Case DD Of
		NN: GoNorth
		SS: GoSouth
		EE: GoEast
		WW: GoWest
	End

	For Y:=1 To 4 Do 
		For X:=1 To 4 Do 
			If Grid[X,Y]<>Dirg[X,Y] Then Changed:=True

	If CountEmpty < 1 And CountMoves < 1 Then GameOver:=True
	If Not GameOver Then Begin
		If Changed Then Begin
			Plyr.GameMoves:=Plyr.GameMoves+1
			AddRandom
		End
	End Else Begin
		Check4Best
		SavePlyr(Plyr.Idx)
	End
End

Procedure UpdateScoreBoard
Var S	: String
Begin
	S:='|19|00'+PadCt(Int2Str(Exp(Plyr.GameHiMark)),4,' ')
	WriteXY(12,5 ,30,PadLt(StrComma(Plyr.GameScore),8,' '))
	WriteXY(12,7 ,30,PadLt(StrComma(Plyr.GameMoves),8,' '))
	WriteXY(14,9,Colors[Plyr.GameHiMark+1],PadCt(#219,6,#219))
	GoToXy(15,9); Write(S)
	WriteXY(SX+53,5,78,PadLt(StrComma(Plyr.BestScore),7,' '))
	WriteXY(SX+53,7,78,PadLt(StrComma(Plyr.BestMoves),7,' '))
	S:='|19|00'+PadCt(Int2Str(Exp(Plyr.BestHiMark)),4,' ')
	WriteXY(SX+54,9,Colors[Plyr.BestHiMark+1],PadCt(#219,6,#219))
	GoToXy(SX+55,9); Write(S)
End

Function KeepPlaying:Boolean
Var KPBox	: LongInt
Var Ret		: Boolean = False
Begin
	ClassCreate (KPBox, 'box');
	BoxHeader (KPBox,      // Box class handle
               0,           // Header justify (0=center, 1=left, 2=right)
               31,          // Header attribute
               'Game Over!');     // Header text


	BoxOpen (KPBox,       // Box class handle
           32,              // top X corner of box
           6,               // top Y corner of box
           48,              // bottom X corner of box
           11);             // bottom Y corner of box


	WriteXY(35, 8,(16*7),'Play Again?')	
	WriteXY(35,10,(16*7),'  (Y/N): ')	
	Ret:=False
	If OneKey('YN',False) = 'Y' Then Ret:=True

	BoxClose(KPBox)
	ClassFree(KPBox)
	
	KeepPlaying:=Ret
End

Procedure Help
Var X	: Integer
Var Box	: LongInt
Var S	: String
VAr Sav	: PlyrRec
Begin

	Sav:=Plyr
	ClassCreate (Box, 'box');
	BoxOptions  (Box,5,False,78,78,15,15,False,0)
	BoxHeader	(Box,1,(16*1)+15,' How To Play ' )
	BoxOpen (Box, 14, SY+3, 66, 20)

	WriteXY(16, 7,78,'Double-Up! is played on a simple gray 4x4       ')
   WriteXY(16, 8,78,'grid with tiles of varying colors that slide    ')
	WriteXY(16, 9,78,'when moved using the four arrow keys.           ')
	WriteXY(16,10,78,'                                                ')
	WriteXY(16,11,78,'The tiles slide as far as possible in the chosen')
	WriteXY(16,12,78,'direction until they are stopped by either      ')
	WriteXY(16,13,78,'another tile or the edge of the grid.  If two   ')
	WriteXY(16,14,78,'tiles of the same number collide while moving,  ')
   WriteXY(16,15,78,'they will "double-Up" and merge into a tile with')
   WriteXY(16,16,78,'the combined value.  The resulting tile cannot  ')
   WriteXY(16,17,78,'merge with another tile again in the same move. ')
   WriteXY(16,18,78,'Every turn, a new tile will randomly appear in  ')
   WriteXY(16,19,78,'an empty spot with a value of 2.                ')
	ReadKey
	BoxClose(Box)
	ClassFree(Box)	
	Plyr:=Sav
End

Procedure MakeHighScores
VAr Sav		: PlyrRec
Var I,C			: Integer
Var S			: String
Var Fp		: File
Begin
	Sav:=Plyr

	fAssign(Fp,ScorAns,66)
	fReWrite(Fp)
	fWriteLn(Fp,'|CL|CR|14'+PadCt('DoubleUp! by Darryl Perry',78,' '))
	fWriteLn(Fp,'')
	fWriteLn(Fp,'              |15Player                         |10Score   |12Highest Tile ')
	fWriteLn(Fp,'              |02------------------------- ---------- -------------- ') 
	C:=1
	While ReadPlyr(C) Do Begin
		S:='              |16|15'+PadRt(StripMCI(Plyr.Name),25,' ')+' |10'
		S:=S+PadLt(StrComma(Plyr.BestScore),10,' ')+'      '
		S:=S+'|'+PadLt(Int2Str(Colors[Plyr.BestHiMark+1]),2,'0')+#219
		S:=S+'|23|00'+PadCt(Int2Str(Exp(Plyr.BestHiMark)),4,' ')
		S:=S+'|'+PadLt(Int2Str(Colors[Plyr.BestHiMark+1]),2,'0')+#219+'|16|11'
		fWriteLn(Fp,S)
		C:=C+1
	End	

	fClose(Fp)
	Plyr:=Sav
End

Procedure ListPlayers
Var J,C,X	: Integer
Var Box		: LongInt
Var S			: String
VAr Sav		: PlyrRec
Begin

	Sav:=Plyr
	ClassCreate (Box, 'box');
	BoxOptions  (Box,5,False,46,46,15,15,False,0)
	BoxHeader	(Box,1,(16*4)+15,' Player List ' )
	BoxOpen (Box, 10, SY+4, 70, 22)
	X:=1; C:=1	

	WriteXY(12,SY+5+X,(16*2)+15,'Player')
	WriteXY(53,SY+5+X,(16*2)+10,'Score')
	WriteXY(60,SY+5+X,(16*2)+4 ,'Highest')
	WriteXY(12,SY+6+X,(16*2)+14,PadCt(#254,57,#254))

	While ReadPlyr(C) Do Begin
		WriteXY(12,SY+8+C,(16*2)+15,Plyr.Name)
		WriteXY(50,SY+8+C,(16*2)+10,PadLt(StrComma(Plyr.BestScore),8,' '))
//		WriteXY(60,SY+8+C,(16*2)+15,PadLt(StrComma(Exp(Plyr.BestHiMark)),6,' '))

		S:='|19|00'+PadCt(Int2Str(Exp(Plyr.BestHiMark)),4,' ')
		WriteXY(60,SY+8+C,Colors[Plyr.BestHiMark+1],PadCt(#219,6,#219))
		GoToXy(61,SY+8+C); Write(S)
		X:=X+1
		C:=C+1
		If C % 10 = 0 Then Begin 
			WriteXY(12,SY+18,(16*2)+12,PadCt('< MORE >',57,' '))
			ReadKey
			For J:=1 To 10 Do Begin
				WriteXY(12,SY+8+J,(16*2)+11,PadCt(' ',58,' '))		
			End
		End
	End
	ReadKey
	BoxClose(Box)
	ClassFree(Box)	
	Plyr:=Sav
End

Procedure Q2BBS
Begin
	Check4best
	SavePlyr(Plyr.Idx)
	ListPlayers
	MakeHighScores
	WriteLn('|16|14|CL|CR|CRReturning to |BN|CR|CR|PA')
	Halt
End

Procedure Main
Var Ch	: Char
Var Done	: Boolean = False
Begin
	While Not Done Do Begin
		If GameOver Then 
			If KeepPlaying Then Begin
				ResetGame	
				ResetPlayer
				GetHighest
			End Else
				Q2BBS

		UpdateScoreBoard
		DrawGrid
		Ch:=ReadKey
		If IsArrow Then Begin
			Case Ch Of
				#72: Move(NN)
				#75: Move(WW)
				#77: Move(EE)
				#80: Move(SS)
			End
		End Else Begin
			Ch:=Upper(CH)
			Case Ch Of
				'Q': Done:=True
				#27: Done:=True
				'8': Move(NN)
				'4': Move(WW)
				'6': Move(EE)
				'2': Move(SS)
				'L': ListPlayers
				'?': Help
			End
		End
	End
	Q2BBS
End

Begin
	ClrScr
	Init
	Main
	DeInit
End
