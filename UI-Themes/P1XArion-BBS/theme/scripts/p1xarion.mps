//
// P1XARION THE GAME
// Game written in MPL for Mystic BBS
//
// CC0 Krzysztof Krystian Jankowski
//

type
  tCard = record
    title : string[70];
    aTitle : string[70];
    aDesc : string[70];
    aOutcome: array[1..4] of Integer;
    bTitle : string[70];
    bDesc : string[70];
    bOutcome: array[1..4] of Integer;
  end;
const
  EP=1;
  RH=2;
  DL=3;
  HS=4;
  A=1;
  B=2;
var
  ElectricPower, ResidentsHappiness, DiplomacyLevel, HealthSupport: Integer;
  deck: array[1..100] of tCard;
  isGameOver: Boolean;
  activeCardId: Byte;
  activeChoice: Byte;
  cardsLeft: Byte;
  cardCount: Byte;

Procedure ReadCardsData();
Var
  DataFile : file;
  line: String;
  lineNum: Integer;
  card: tCard;
  cards: Byte;
Begin

  WriteLn('Opening file cards.dat...');
  fassign  (DataFile, 'cards.dat', 66);
  freset(DataFile);

  cards := 0;

  While not feof(DataFile) or fpos(DataFile) <> fsize(DataFile) do
  begin

    freadln(DataFile, line);  // Comment header - type card in the future

    freadln(DataFile, line);  card.Title := line;

    freadln(DataFile, line);  card.aTitle := line;
    freadln(DataFile, line);  card.aDesc := line;
    freadln(DataFile, line);  card.aOutcome[EP] := Str2Int(line);
    freadln(DataFile, line);  card.aOutcome[RH] := Str2Int(line);
    freadln(DataFile, line);  card.aOutcome[DL] := Str2Int(line);
    freadln(DataFile, line);  card.aOutcome[HS] := Str2Int(line);

    freadln(DataFile, line);  card.bTitle := line;
    freadln(DataFile, line);  card.bDesc := line;
    freadln(DataFile, line);  card.bOutcome[EP] := Str2Int(line);
    freadln(DataFile, line);  card.bOutcome[RH] := Str2Int(line);
    freadln(DataFile, line);  card.bOutcome[DL] := Str2Int(line);
    freadln(DataFile, line);  card.bOutcome[HS] := Str2Int(line);

    cards := cards + 1;
    deck[cards] := card;
  end;

  fclose(DataFile);

  cardsLeft := cards;

End;


procedure InitializeGame;
begin
  isGameOver := false;
  activeCardId := 1;
  cardCount := 1;
  ElectricPower := 100;
  ResidentsHappiness := 60;
  DiplomacyLevel := 50;
  HealthSupport := 100;

  ReadCardsData();
end;


procedure DrawBar(val:Byte);
var
  fill: Byte;
  i: Byte;
begin
  fill:= val/10;
  for i := 1 to 10 do
  begin
    if i <= fill then
      Write('Û');
    else
      Write('°');
  end;
end;

procedure DrawBarLong(val:Byte);
var
  fill: Byte;
  step: Byte;
  i: Byte;
begin
 fill := val/2+1;
 for i := 1 to 50 do
 begin
   if i <= fill then
     Write('|15Í');
   else
     Write('|07Í');
 end;
 //Write('|16');
end;

procedure ProcessChoice();
var
  _ep,_rh,_dl,_hs: Integer;
  _title,_desc: String;
begin
  if activeChoice > 0 then
  begin
    ClrScr;

    DispFile('g1_outcome.ans');

    GotoXY(34,6);
    case activeChoice of
      1: begin
        _title := deck[activeCardId].aTitle;
        _desc := deck[activeCardId].aDesc;
        _ep := deck[activeCardId].aOutcome[EP];
        _rh := deck[activeCardId].aOutcome[RH];
        _dl := deck[activeCardId].aOutcome[DL];
        _hs := deck[activeCardId].aOutcome[HS];
        end;
      2: begin
        _title := deck[activeCardId].bTitle;
        _desc := deck[activeCardId].bDesc;
        _ep := deck[activeCardId].bOutcome[EP];
        _rh := deck[activeCardId].bOutcome[RH];
        _dl := deck[activeCardId].bOutcome[DL];
        _hs := deck[activeCardId].bOutcome[HS];
        end;
    end;
    GotoXY(9,8);
    Write('|19|15'+_title);
    GotoXY(9,10);
    Write('|14'+_desc);

    ElectricPower := ElectricPower + _ep;
    ResidentsHappiness := ResidentsHappiness + _rh;
    DiplomacyLevel := DiplomacyLevel + _dl;
    HealthSupport := HealthSupport + _hs;

    // for ech turn
    HealthSupport := HealthSupport - 2;
    ElectricPower := ElectricPower - 1;

    if ElectricPower > 100 then ElectricPower := 100;
    if ResidentsHappiness > 100 then ResidentsHappiness := 100;
    if DiplomacyLevel > 100 then DiplomacyLevel := 100;
    if HealthSupport > 100 then HealthSupport := 100;

    if ElectricPower < 0 then ElectricPower := 0;
    if ResidentsHappiness < 0 then ResidentsHappiness := 0;
    if DiplomacyLevel < 0 then DiplomacyLevel := 0;
    if HealthSupport < 0 then HealthSupport := 0;

    Write('|19');
    GotoXY(12,15);
    Write('|14');
    DrawBar(ElectricPower);
    GotoXY(21,15);
    Write(' '+Int2Str(ElectricPower)+'%');
    Write(' Electric Power');
    GotoXY(50,15);
    Write('|07-1 per turn');

    GotoXY(12,16);
    Write('|13');
    DrawBar(ResidentsHappiness);
    GotoXY(21,16);
    Write(' '+Int2Str(ResidentsHappiness)+'%');
    Write(' Residents Happiness');

    GotoXY(12,17);
    Write('|11');
    DrawBar(DiplomacyLevel);
    GotoXY(21,17);
    Write(' '+Int2Str(DiplomacyLevel)+'%');
    Write(' Diplomacy Level');

    GotoXY(12,18);
    Write('|07');
    DrawBar(HealthSupport);
    GotoXY(21,18);
    Write(' '+Int2Str(HealthSupport)+'%');
    Write(' Health Support');
    GotoXY(50,18);
    Write('|07-2 per turn');
    Write('|16');

    cardsLeft := cardsLeft -1;
    cardCount := cardCount + 1;
    activeCardId := activeCardId + 1;
    activeChoice := 0;

    ReadKey;
  end;
end;

procedure DisplayEvent();
var
  outcome: Integer;
begin
  case activeChoice of
    0: DispFile('g1_card0.ans');
    1: DispFile('g1_card1.ans');
    2: DispFile('g1_card2.ans');
  end;

  // FILL CARDS WITH DATA

  // TITLE
  DispFile('g1_today.ans');
  GotoXY(7,4);
  Write('|15|17'+deck[activeCardId].Title);
  GotoXY(7,5);
  Write('Here will be the (optional) second line...');

  GotoXY(9,6);
  DrawBarLong(cardCount);

  GotoXY(60,6);
  Write('|17DAY '+Int2Str(cardCount)+' of 100');

  Write('|23');
  // CARD A
  GotoXY(4,9);
  Write('|00'+deck[activeCardId].aTitle);
  GotoXY(4,10);
  Write('|15'+deck[activeCardId].aDesc);

  outcome := deck[activeCardId].aOutcome[EP];
  GotoXY(6,12);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|00 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' |14Electric Power');

  outcome := deck[activeCardId].aOutcome[RH];
  GotoXY(6,13);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|00 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' |13Residents Happiness');

  outcome := deck[activeCardId].aOutcome[HS];
  GotoXY(36,12);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|00 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' |15Health Support');

  outcome := deck[activeCardId].aOutcome[DL];
  GotoXY(36,13);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|00 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' |11Diplomacy Level');

  // CARD B

  GotoXY(15,17);
  Write('|00'+deck[activeCardId].bTitle);
  GotoXY(15,18);
  Write('|15'+deck[activeCardId].bDesc);

  outcome := deck[activeCardId].bOutcome[EP];
  GotoXY(17,20);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|00 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' |13Electric Power');

  outcome := deck[activeCardId].bOutcome[RH];
  GotoXY(17,21);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|00 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' |14Residents Happiness');

  outcome := deck[activeCardId].bOutcome[HS];
  GotoXY(47,20);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|00 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' |00Health Support');

  outcome := deck[activeCardId].bOutcome[DL];
  GotoXY(47,21);
  if outcome>0 then Write('|10+');
  if outcome=0 then Write('|00 ');
  if outcome<0 then Write('|12');
  Write(Int2Str(outcome)+' |00Diplomacy Level');

end;

procedure DisplayHeader();
begin
  //DispFile('g1_header');
  GotoXY(15,1);
  Write('|14|16'+Int2Str(ElectricPower)+'%');
  GotoXY(4,1);
  DrawBar(ElectricPower);

  GotoXY(34,1);
  Write('|13|16'+Int2Str(ResidentsHappiness)+'%');
  GotoXY(22,1);
  DrawBar(ResidentsHappiness);

  GotoXY(70,1);
  Write('|11|16'+Int2Str(DiplomacyLevel)+'%');
  GotoXY(59,1);
  DrawBar(DiplomacyLevel);

  GotoXY(52,1);
  Write('|07|16'+Int2Str(HealthSupport)+'%');
  GotoXY(41,1);
  DrawBar(HealthSupport);

end;

procedure DisplayFooter();
begin
  DispFile('g1_footer');
end;

procedure DisplayStats();
begin
  ClrScr;
  DispFile('g1_stats.ans');
  GotoXY(36,6);
  Write('|14'+Int2Str(ElectricPower)+'%');
  GotoXY(25,6);
  DrawBar(ElectricPower);

  GotoXY(36,15);
  Write('|13'+Int2Str(ResidentsHappiness)+'%');
  GotoXY(25,15);
  DrawBar(ResidentsHappiness);

  GotoXY(74,15);
  Write('|11'+Int2Str(DiplomacyLevel)+'%');
  GotoXY(63,15);
  DrawBar(DiplomacyLevel);

  GotoXY(74,6);
  Write('|07'+Int2Str(HealthSupport)+'%');
  GotoXY(63,6);
  DrawBar(HealthSupport);

  ReadKey;
end;

procedure DisplayGameOver();
begin
  ClrScr;

  if ElectricPower < 1 then
    DispFile('g1_end1.ans');
  else
  if ResidentsHappiness < 1 then
    DispFile('g1_end2.ans');
  else
  if DiplomacyLevel < 1 then
    DispFile('g1_end3.ans');
  else
  if HealthSupport < 1 then
    DispFile('g1_end4.ans');
  else
  if cardsLeft < 1 then
    DispFile('g1_win.ans');
  else
    DispFile('g1_abort.ans');

  ReadKey;
end;

procedure MainGameLoop;
begin
  while (ElectricPower > 0) and (ResidentsHappiness > 0) and (DiplomacyLevel > 0) and (HealthSupport > 0) and (cardsLeft > 0) do
  begin
    ClrScr;

    DisplayHeader();
    DisplayEvent();
    DisplayFooter();

    Case OneKey(#65 + #66 + #13 + #27 + #32, False) of
      #65 : activeChoice:=1;
      #66 : activeChoice:=2;
      #32: DisplayStats;
      #13: ProcessChoice;
      #27 : Break;
    End;

    //isGameOver := True;
 end;
end;

begin
  PurgeInput;
  ClrScr;
  InitializeGame;

  while True do
  begin
    ClrScr;

    DispFile('g1_intro.ans');
    ReadKey;

    ClrScr;
    DispFile('g1_menu.ans');

    Case OneKey(#13+#27, False) of
      #27: Break;
    End;

    ClrScr;
    DispFile('g1_brief.ans');
    ReadKey;

    MainGameLoop;

    DisplayGameOver();

    InitializeGame;
  end;

  ClrScr;
  DispFile('g1_bye.ans');
  ReadKey;
end.
