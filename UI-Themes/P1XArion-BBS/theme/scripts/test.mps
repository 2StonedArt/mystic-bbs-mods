
type
  tEvent = record
    Title : string[60];
    Desc : string[60];
    Outcoms: array[1..4] of Integer;
  end;

  tCard = record
    Title : string[60];
    Events: array[1..2] of tEvent;
  end;

var 
  ElectricPower, ResidentsHappiness, DiplomacyLevel, HealthSupport: Integer;
  EventDeck: array[1..100] of tCard;



procedure InitializeGame;
begin
  ElectricPower := 100;
  ResidentsHappiness := 100;
  DiplomacyLevel := 100;
  HealthSupportResources := 100;

  // Populate EventDeck with event strings or references to event data
end;

procedure MainGameLoop;
var choice: Char;
begin
  while (ElectricPower > 0) and (ResidentsHappiness > 0) and (DiplomacyLevel > 0) and (HealthSupportResources > 0) do
  begin
    

    // Draw an event card
    DisplayEvent();
   HighlightChoice(0);

    // Get player's choice
    Case OneKey(#09 + #13 + #27, False) of
        #09 : HighlightChoice(1);
        #10 : HighlightChoice(2);
        #99: ShowStats;
        #13: ProcessChoice;
        #27 : Break;
      End;
    

    // Check for game over conditions
    if IsGameOver then Break;
  end;
  
end;

procedure DisplayEvent();
begin
EventDeck[cardId]
  // Code to display the event text and choices
end;

procedure ProcessChoice(choice: Char);
begin
  // Update game state based on the player's choice
  cardId := Random(High(EventDeck));
  
end;

procedure DisplayStats;
begin
  WriteLn('|07Electric Power: ', ElectricPower);
  WriteLn('|07Residents Happiness: ', ResidentsHappiness);
  WriteLn('|07DiplomacyLevel: ', DiplomacyLevel);
  WriteLn('|07HealthSupport: ', ResidentsHappiness);
end;

begin
  InitializeGame;

  DispFile('menu.asc');
  DispFile('brief.asc');
  
  DispFile('main.asc');
  cardId := Random(High(EventDeck));

  MainGameLoop;

  if IsGameOver then
    DisplayGameOverMessage;
end.
