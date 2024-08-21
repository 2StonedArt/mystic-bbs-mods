(*

				  .,::      .:.::::::.  :::::::::::::::::::..   
                  `;;;,  .,;;,;;'```';;,;;;;;;;;'''';;;;``;;;;  
                    '[[,,[[' [[[     [[[\    [[      [[[,/[[['  
                     Y$$$P   "$$c  cc$$$"    $$      $$$$$$c    
                   oP"``"Yo,  "*8bo,Y88b,    88,     888b "88bo,
                ,m"       "Mm,  "*YP" "M"    MMM     MMMM   "W" 
                --------------------------------------------------
					     TheDraw Fonts in Mystic BBS
                --------------------------------------------------

With this code, you can use TheDraw fonts to your scripts. Supports fonts that
use the block and color format. Only one font in each file can be read, for now.

You can use the tdfonts utility to extract a font if you want... You are free 
to use the code as you want, but please give a credit to me.
 
 DISCLAIMER:
 Although i tested with multiple font files, there is a chance that some fonts,
 cannot be displayed.
 
 For any suggestions, bugs or info send a mail to xqtr.xqtr#gmail.com
 

*)

uses cfg

Const
	HeaderOffset = 233
	
(*	

	This info is used to read Outline Format of Fonts... not implemented yet.

A ═ 205 / CD
B ─ 196 / C4
C │ 179 / B3
D ║ 186 / BA
E ╒ 213 / D5
F ╗ 187 / BB Upper-right outer corner
Right-to-Down outer corner outside
inside
G ╓ 214 / D6 Up-to-Right inner corner
Upper-left inner corner outside
inside
H ┐ 191 / BF Right-to-Down inner corner
Upper-right inner corner outside
inside
I ╚ 200 / C8 Lower-left inner corner inside
J ╛ 190 / BE Lower-right inner corner inside
K └ 192 / C0 Lower-left outer corner outside
L ╜ 189 / BD Lower-right outer corner outside
M ╡ 181 / B5 
N ╟ 199 / C7 
O ≈ 247 / F7 
@ @ 064 / 40 Filler for all leading spaces 
& & Descender mark
*)

type 
  TTDFont = record
	A 				: char  // fixed : 13h
	typo			: Array[1..18] of char
	B				: char	// fixed : 1Ah
	fs				: array[1..4] of byte  // fixed: 55 AA 00 FF
	NameLen			: byte
	FontName		: array[1..12] of char
	nouse			: array[1..4] of byte  // 00 00 00 00
	FontType		: byte // Font Type (byte): 00 = Outline, 01 = Block, 02 = Color
	Spacing			: byte // 00 to 40d or 
	BlockSize		: word	// Block Size (Word, Little Endian) Size of character data after main
							// font definition block, including terminating 0 if followed by another
							// font (last font in collection is not Null terminated
	CharAddr		: Array[1..94] of word
							// 2 bytes (Word, Little Endian) for each character from ASC(33)
							//(“!”) to ASC(126) (“~”) (94 characters total) with the offset
							//(starting at 0) after the font header definition where the character
							// data star
	
	//At 233 begins the font data
end

Type
  TFontChar = Record
    width  : byte 				// 1 <= W <= 30 (1Eh)
    height : byte				// 1 <= H <= 12 (0Ch)
  end

// Supported Characters 33 - 126
// !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO
// PQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~

(*

	This is how looks a font file that contains multiple fonts. 
	Not Implemented yet...

Example of file with multiple fonts...
Font 1 Header 20
Font 1 Data
233
Font 2 Header 232 + Font 1 Block Size + 1
Font 2 Data
Font 2 Header + 212 + 1
Font 3 Header Font 2 Data + Font 2 Block Size + 1
Font 3 Data Font 3 Header + 212 + 1
*)

Var 
  font 			: TTDFont
  Datapath 		: string
  FontFile		: String
  
Procedure GetTDFHeader(f:string)
Var
  fptr : file
  i : integer
begin
  if not fileexist(f) then begin
	 writeln('Font file [ '+f+' ]does not exist');
	 pause
	 halt
  end
  fontfile:=f
  fassign(fptr,f,66)
  freset(fptr)
  fread(fptr,font,sizeof(font))
  fclose(fptr)
end

Procedure TDFWriteCharBL(x,y:byte;c:char):byte
Var
  fptr : file
  i : integer
  FChar : TFontChar
  tbyte : array[1..2] of byte
  sx,sy:byte
  asc:byte
begin
  if c=' ' then begin
	tdfwritecharBL:=1
	exit
  end
  asc:=ord(c)-32
  fassign(fptr,fontfile,66)
  freset(fptr)
  fseek(fptr,headeroffset+font.charaddr[asc])
  fread(fptr,FChar,sizeof(Fchar))
  tbyte[1]:=32
  tbyte[2]:=32
  gotoxy(x,y)
  while tbyte[1]<>0 and not feof(fptr) do begin
	fread(fptr,tbyte[1],1)
	if tbyte[1]=13 then begin
		gotoxy(x,wherey+1)
		if wherey>25 then break
	end
	 else begin
		fread(fptr,tbyte[2],1)
		textcolor(tbyte[2] % 16 + tbyte[2] - (tbyte[2] % 16))
		write(chr(tbyte[1]))
		if wherex>79 then break
	end
  end 
  fclose(fptr)
  tdfwritecharbl:=fchar.width
end

Procedure TDFWriteCharCL(x,y:byte;c:char):byte
Var
  fptr : file
  i : integer
  FChar : TFontChar
  tbyte : array[1..2] of byte
  sx,sy:byte
  asc:byte
begin
  if c=' ' then begin
	tdfwritecharcl:=1
	exit
  end
  asc:=ord(c)-32
  fassign(fptr,fontfile,66)
  freset(fptr)
  fseek(fptr,headeroffset+font.charaddr[asc])
  fread(fptr,FChar,sizeof(Fchar))
  tbyte[1]:=32
  gotoxy(x,y)
  while tbyte[1]<>0 and not feof(fptr) do begin
	fread(fptr,tbyte[1],1)
	if tbyte[1]=13 then begin
		gotoxy(x,wherey+1)
		if wherey>25 then break
	end
	 else begin
		write(chr(tbyte[1]))
		if wherex>79 then break
	end
  end 
  fclose(fptr)
  tdfwritecharcl:=fchar.width
end

procedure TDFWrite(x,y:byte; s:string)
Var
  i:byte
  sx,sy:byte
begin
  gotoxy(x,y)
  sx:=x
  sy:=y
  case font.fonttype of
  2: begin  
		  for i:=1 to length(s) do begin
			sx:=sx+tdfwritecharBL(sx,y,s[i])+font.spacing
		  end
	 end
  1: begin  
		  for i:=1 to length(s) do begin
			sx:=sx+tdfwritecharCL(sx,y,s[i])+font.spacing
		  end
	 end
   end
end

procedure TDFTypeWrite(x,y:byte; s:string; d:integer)
Var
  i:byte
  sx,sy:byte
begin
  gotoxy(x,y)
  sx:=x
  sy:=y
  case font.fonttype of
  2: begin  
		  for i:=1 to length(s) do begin
			sx:=sx+tdfwritecharBL(sx,y,s[i])+font.spacing
			delay(d)
		  end
	 end
  1: begin  
		  for i:=1 to length(s) do begin
			sx:=sx+tdfwritecharCL(sx,y,s[i])+font.spacing
			delay(d)
		  end
	 end
   end
end

// Main Block

begin
  clrscr
  DataPath := JustPath(ProgName);	
  gettdfheader(datapath+'drgx.tdf') 		// Init the font to use
  font.spacing:=1
  tdftypewrite(1,2,'Shall we play',250)		// Write a string
  tdftypewrite(30,6,'a game...',250)
  
  gettdfheader(datapath+'wallx.tdf')
  font.spacing:=1
  tdftypewrite(3,15,'Mystic',250) 
  tdftypewrite(23,20,'BBS',250) 
  gotoxy(1,25)
  pause

end
