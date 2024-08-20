// Mystic Tetris, for Mystic BBS... by xqtr

// Original code and credits to TrSek alias Zdeno Sekerak. I just converted the
// code to work with Mystic BBS. 

// Ansi copied and altered from Blocktronicks
// Used some piece of code, from the Blackjack game, of Mystic BBS
// All credits to the authors and original creators.

// Original Source Code from here:
// TETRIS.PAS                Copyright (c) TrSek alias Zdeno Sekerak 
// Hra tetris v textovom prevedeni.                                  
// Uchovava skore a vykresluje dalsiu kocku.                         
//                                                                   
// Datum:12.12.2004                             http://www.trsek.com 

Uses 
User;

Const 
  F_Save  = 'tetris.ply';
  LEFT   = 53;
  twidth  = 10;
  theight = 22;
  TO_LEV = 10;
  Version     = '0.1';

  S_CUBE = '@';
  S_FOOT = ' ';

  tput = 1;
  tclr = 2;
  tsav = 3;

Type 
  t_top = Record
    meno: string[10];
    body: integer;
  End;

Type 
  PlayerRec = Record
    UserID : LongInt;
    Name   : String[30];
    Score   : LongInt;
    TopScore: LongInt;
    LastOn : LongInt;
  End;

Type 
  TopTenRec = Record
    User : String[35];
    score : LongInt;
    topscore : integer;
    Date : LongInt;
  End;


Var  pole: array[1..twidth,1..theight] Of byte;
  body: integer;
  tlev: integer;
  level: byte;
  typ: byte;
  otoc: byte;
  col: byte;
  xx,yy: integer;
  ch: char;
  DataPath      : String;
  Player        : PlayerRec;
  PlayerNumber  : LongInt = -1;
  Player_Score  : Byte;
  FOOT: array[0..1] Of byte;
  CUBE: array[1..7,1..4,1..4] Of byte;
  //t_option : (Put, Clr, Sav);
  t_option : array[1..3] Of byte;



Procedure LoadPlayer;

Var 
  F : File;
  T : PlayerRec;
Begin
  GetThisUser;

  PlayerNumber  := -1;

  Player.UserID := UserIndex;
  Player.Score   := 0;

  fAssign (F, DataPath + F_Save, 66);
  fReset  (F);

  If IoResult <> 0 Then fReWrite(F);

  While Not fEof(F) Do
    Begin
      fReadRec (F, T);

      If T.UserID = UserIndex Then
        Begin
          Player       := T;
          PlayerNumber := fPos(F) / SizeOf(Player);
          Break;
        End;
    End;

  fClose (F);

  Player.LastOn := DateTime;
  Player.Name   := UserAlias;
  player.score := 0;
End;

Procedure SavePlayer;

Var 
  F : File;
Begin
  fAssign (F, DataPath + F_Save, 66);
  fReset  (F);
  If player.score>player.topscore Then player.topscore := player.score;
  If PlayerNumber <> -1 Then
    fSeek (F, SizeOf(Player) * (PlayerNumber - 1));
  Else
    fSeek (F, fSize(F));

  fWriteRec (F, Player);
  fClose    (F);
End;

Procedure ExecuteTopTen;

Var 
  TopList   : Array[1..10] Of TopTenRec;
  Count1    : Byte;
  Count2    : Byte;
  Count3    : Byte;
  F         : File;
  OnePerson : PlayerRec;
Begin
  Write ('|16|CL|10Sorting top scores...');

  For Count1 := 1 To 10 Do
    Begin
      TopList[Count1].User := 'None';
      TopList[Count1].Score := 0;
      TopList[Count1].Date := 0;
      TopList[Count1].topscore := 0;
    End;

  fAssign (F, DataPath + F_Save, 66);
  fReset  (F);

  If IoResult = 0 Then
    While Not fEof(F) Do
      Begin
        fReadRec (F, OnePerson);

        For Count2 := 1 To 10 Do
          If TopList[Count2].topscore <= OnePerson.topscore Then
            Begin
              For Count3 := 10 Downto Count2 + 1 Do
                TopList[Count3] := TopList[Count3 - 1]

                                   TopList[Count2].score := OnePerson.score;
              TopList[Count2].User := OnePerson.Name;
              TopList[Count2].Date := OnePerson.LastOn;
              TopList[Count2].topscore := OnePerson.topscore;

              Break;
            End;
      End;

  ClrScr;

  GotoXY (28, 3);
  Write  ('|07Mystic Tetris - Top 10 ');

  GotoXY (5, 6);
  Write  ('##  User                              Date                      Score');

  GotoXY (5, 7);
  Write  ('|02' + strRep(#196, 68) + '|10');

  For Count1 := 1 To 10 Do
    Begin
      GotoXY (5, 7 + Count1);
      Write  (PadLT(Int2Str(Count1), 2, ' '));

      GotoXY (9, 7 + Count1);
      Write  (TopList[Count1].User);

      GotoXY (42, 7 + Count1);
      Write  (DateStr(TopList[Count1].Date, 1));

      GotoXY (53, 7 + Count1);
      Write  (PadLT(strComma(TopList[Count1].topscore), 20, ' '));

    End;

  GotoXY (5, 18);
  Write  ('|02' + strRep(#196, 68));

  GotoXY (26, 20);
  Write  ('|02Press |08[|15ENTER|08] |02to continue|PN');
End;

Procedure ClrPole;

Var x1,y1: integer;
Begin
  For x1:=1 To twidth Do
    For y1:=1 To theight Do
      Pole[x1,y1] := 0;
End;

Function TPred(otoc1:byte): byte;
Begin
  TPred := otoc1-1;
  If (otoc1=1)Then TPred := 4;
End;

Function TSucc(otoc1:byte): byte;
Begin
  TSucc := otoc1+1;
  If (otoc1=4)Then TSucc := 1;
End;

Function Min(a,b:integer): integer;
Begin
  If (a<b)Then
    Min := a
  Else
    Min := b;
End;

Function byte2color(n:byte): string;
Begin
  byte2color := '|00';
End;

Procedure Kocka(xp,yp,typ1,otoc1,col1:integer;option:byte);

Var x1,y1: integer;
  bod: byte;
  color: byte;
  coll: byte;
Begin

  For y1:=1 To 4 Do
    For x1:=1 To 4 Do
      Begin

        Case otoc1 Of 
          1: bod := CUBE[typ1,x1,y1];
          2: bod := CUBE[typ1,5-y1,x1];
          3: bod := CUBE[typ1,5-x1,5-y1];
          4: bod := CUBE[typ1,y1,5-x1];
        End;

        Case option Of 
          tclr:
                If ( bod=1 )Then
                  Begin
                    coll := (x1+xp) / 2;
                    WriteXY(left+xp+x1,yp+y1,coll,S_FOOT);
                  End;

          tput:
                If ( bod=1 )Then
                  Begin
                    WriteXY(left+xp+x1,yp+y1,col1,S_CUBE);
                  End;

          tsav:
                If ( bod=1 )Then
                  pole[x1+xp,y1+yp] := col1;

        End;
      End;
End;



Function KockaOK(xp,yp,typ1,otoc1:integer): boolean;

Var x,y,xxp: integer;
  bod: byte;
  res: boolean;
Begin

  res := true;


  For y:=1 To 4 Do
    For x:=1 To 4 Do
      Begin

        Case otoc1 Of 
          1: bod := CUBE[typ1,x,y];
          2: bod := CUBE[typ1,5-y,x];
          3: bod := CUBE[typ1,5-x,5-y];
          4: bod := CUBE[typ1,y,5-x];
        End;

        If ( bod=1 )Then
          Begin
            xxp := x+xp;
            If xxp < 1 Then res := false;
            If (xxp >twidth  ) Then res := false;
            xxp := y+yp;
            If (xxp >theight ) Then res := false;
            If (otoc1 <1) Then res := false;
            If (otoc1 >4) Then res := false;


            If ( res )Then
              If ( pole[x+xp,y+yp]<>0 )Then
                res := false;

          End;
      End;


  kockaOK := res;
End;

Procedure ZmazRiadok(yr:integer);

Var x,y: integer;
Begin


  For x:=1 To twidth Do
    Begin
      WriteXY(left+x,yr,0,S_CUBE);
      Delay(20);
    End;


  For y:=yr Downto 2 Do
    For x:=1 To twidth Do
      Begin
        pole[x,y] := pole[x,y-1];

        If ( pole[x,y]=0 )Then
          Begin

            WriteXY(left+x,y,x / 2,S_FOOT);
          End
        Else
          Begin

            WriteXY(left+x,y,pole[x,y],S_CUBE);
          End
      End;
End;



Procedure Skontroluj(yr:integer);

Var x,y: integer;
  del: boolean;
Begin
  For y:=yr To Min(yr+4, theight) Do
    Begin
      del := true;

      For x:=1 To twidth Do
        If ( pole[x,y]=0 )Then
          del := false;

      If ( del )Then
        Begin
          ZmazRiadok(y);
          body := body+level;
          tlev := tlev+1;
          player.score := body;
        End;
    End;


  If ( tlev>=TO_LEV )Then
    Begin
      tlev := 0;
      level := level+1;
    End;
End;

Procedure clearpole;

Var x,y: integer;
Begin
  For x:=1 To twidth Do
    For y:=1 To theight Do
      writexy(left+x,y,0,' ');

End;


Function GetKey(level1:byte): char;

Var i: integer;
  ch1: char;
Begin
  ch1 := #0;

  For i:=1 To 600-level1*5 Do
    Begin

      If ( keypressed )Then
        Begin
          ch1 := readkey;
          If ( ch1=#0 )Then
            ch1 := readkey;
        End;

      delay(1);
    End;

  GetKey := ch1;
End;


Begin
  ClrScr;

  foot[1] := 07;
  foot[0] := 00;


	cube[1,1,1]:=0;cube[1,1,2]:=0;cube[1,1,3]:=0;cube[1,1,4]:=0;
	cube[1,2,1]:=0;cube[1,2,2]:=1;cube[1,2,3]:=1;cube[1,2,4]:=0;
	cube[1,3,1]:=0;cube[1,3,2]:=1;cube[1,3,3]:=1;cube[1,3,4]:=0;
	cube[1,4,1]:=0;cube[1,4,2]:=0;cube[1,4,3]:=0;cube[1,4,4]:=0;
	
	cube[2,1,1]:=0;cube[2,1,2]:=1;cube[2,1,3]:=0;cube[2,1,4]:=0;
	cube[2,2,1]:=0;cube[2,2,2]:=1;cube[2,2,3]:=0;cube[2,2,4]:=0;
	cube[2,3,1]:=0;cube[2,3,2]:=1;cube[2,3,3]:=0;cube[2,3,4]:=0;
	cube[2,4,1]:=0;cube[2,4,2]:=1;cube[2,4,3]:=0;cube[2,4,4]:=0;
	
	cube[3,1,1]:=0;cube[3,1,2]:=1;cube[3,1,3]:=0;cube[3,1,4]:=0;
	cube[3,2,1]:=0;cube[3,2,2]:=1;cube[3,2,3]:=1;cube[3,2,4]:=0;
	cube[3,3,1]:=0;cube[3,3,2]:=1;cube[3,3,3]:=0;cube[3,3,4]:=0;
	cube[3,4,1]:=0;cube[3,4,2]:=0;cube[3,4,3]:=0;cube[3,4,4]:=0;
	
	cube[4,1,1]:=0;cube[4,1,2]:=0;cube[4,1,3]:=0;cube[4,1,4]:=0;
	cube[4,2,1]:=0;cube[4,2,2]:=1;cube[4,2,3]:=1;cube[4,2,4]:=0;
	cube[4,3,1]:=1;cube[4,3,2]:=1;cube[4,3,3]:=0;cube[4,3,4]:=0;
	cube[4,4,1]:=0;cube[4,4,2]:=0;cube[4,4,3]:=0;cube[4,4,4]:=0;
	
	cube[5,1,1]:=0;cube[5,1,2]:=0;cube[5,1,3]:=0;cube[5,1,4]:=0;
	cube[5,2,1]:=1;cube[5,2,2]:=1;cube[5,2,3]:=0;cube[5,2,4]:=0;
	cube[5,3,1]:=0;cube[5,3,2]:=1;cube[5,3,3]:=1;cube[5,3,4]:=0;
	cube[5,4,1]:=0;cube[5,4,2]:=0;cube[5,4,3]:=0;cube[5,4,4]:=0;
	
	cube[6,1,1]:=0;cube[6,1,2]:=0;cube[6,1,3]:=1;cube[6,1,4]:=0;
	cube[6,2,1]:=0;cube[6,2,2]:=0;cube[6,2,3]:=1;cube[6,2,4]:=0;
	cube[6,3,1]:=0;cube[6,3,2]:=1;cube[6,3,3]:=1;cube[6,3,4]:=0;
	cube[6,4,1]:=0;cube[6,4,2]:=0;cube[6,4,3]:=0;cube[6,4,4]:=0;
	
	cube[7,1,1]:=0;cube[7,1,2]:=1;cube[7,1,3]:=0;cube[7,1,4]:=0;
	cube[7,2,1]:=0;cube[7,2,2]:=1;cube[7,2,3]:=0;cube[7,2,4]:=0;
	cube[7,3,1]:=0;cube[7,3,2]:=1;cube[7,3,3]:=1;cube[7,3,4]:=0;
	cube[7,4,1]:=0;cube[7,4,2]:=0;cube[7,4,3]:=0;cube[7,4,4]:=0;

  If Graphics = 0 Then
    Begin
      WriteLn ('Sorry, this game requires ANSI graphics.|CR|PA');
      Halt;
    End;

  DataPath := JustPath(ProgName);

  If Upper(ParamStr(1)) = 'TOP10' Then
    Begin
      ExecuteTopTen;
      Halt;
    End;
  Randomize;

  LoadPlayer;

  DispFile (DataPath + 'tetris');
  GotoXY (25, 24);
  Write('|16|03Mystic Tetris v' + Version + '   Code: |15xqtr');
  ClrPole;
  clearpole;

  body := 0;
  tlev := 0;
  level := 1;

  yy := 1;
  ch := #0;
  Repeat
    gotoxy(67,2);
    write('|02U|10s|14er : |02'+player.name);
    gotoxy(67,3);
    write('|02L|10e|14vel: |02'+Int2Str(level));
    gotoxy(67,4);
    write('|02S|10c|14ore: |02'+Int2Str(player.score));

    If ( yy=1 )Then
      Begin
        xx    := (twidth / 2)-2;
        otoc := random(4)+1;
        typ  := random(7)+1;
        col  := random(15)+1;
      End;


    Kocka(xx,yy,typ,otoc,col,tput);


    If ( ch<>#32 )Then
      ch := GetKey(level);


    Kocka(xx,yy,typ,otoc,0,tclr);

    ch := Upper(ch);
    If (ch='K') And KockaOK(xx-1,yy,typ,otoc) Then xx := xx-1;
    If (ch='M') And KockaOK(xx+1,yy,typ,otoc) Then xx := xx+1;
    If (ch='P') And KockaOK(xx,yy,typ,TPred(otoc)) Then otoc := TPred(otoc);
    If (ch='H') And KockaOK(xx,yy,typ,TSucc(otoc)) Then otoc := TSucc(otoc);


    If ( KockaOK(xx,yy+1,typ,otoc))Then
      yy := yy+1
    Else

      Begin
        Kocka(xx,yy,typ,otoc,col,tput);
        Kocka(xx,yy,typ,otoc,col,tsav);
        Skontroluj(yy);

        ch := #0;
        If (yy=1) Then ch := #27;
        yy := 1;
      End;

  Until ( ch=#27 );


  SavePlayer;

  ExecuteTopTen;
End.
