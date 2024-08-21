// =========================================================================
// TESTGAME.MPS : MPL learning file
// =========================================================================

Program MoveCharacter;

Uses
  MPL;

Var
  X, Y: Byte;
  Key: Char;

Begin
  // Initialize position
  X := 40; // Middle of the screen horizontally
  Y := 12; // Middle of the screen vertically

  // Clear the screen
  CLRSCR;

  // Set initial position of "@"
  WriteXY(X, Y, 7, '@'); // 7 is for white color

  // Enable arrow key processing
  AllowArrow(True);

  // Main loop
  Repeat
    // Wait for a key press
    Key := ReadKey;

    // Erase the old position
    WriteXY(X, Y, 0, ' ');

    // Update position based on arrow key
    Case Key Of
      #0: Begin
            Key := ReadKey; // Get the arrow key code
            Case Key Of
              #72: If Y > 1 Then Dec(Y); // Up
              #80: If Y < 24 Then Inc(Y); // Down
              #75: If X > 1 Then Dec(X); // Left
              #77: If X < 80 Then Inc(X); // Right
            End;
          End;
    End;

    // Draw "@" at new position
    WriteXY(X, Y, 7, '@');

  Until Key = #27; // Exit on ESC key press

  // Optional: Clear the screen before exit
  CLRSCR;
End.
