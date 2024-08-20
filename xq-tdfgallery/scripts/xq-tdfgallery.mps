Uses User
Uses Cfg

// Change the following constants to configure the script

const
	max_items = 200
	const searchx = 9
	const searchy = 24
	const searchcol = '|15'
	
	list_left = 4
	list_top = 8
	list_width = 15
	list_on = '|15|17'
	list_off = '|07'
	list_max = 15

	morex = 7
	morey = 23

	HeaderOffset = 233
	fx = 28
	fy = 8
	fstr = 'adb'
	
	cx = 28
	cy = 8
	cwidth = 47
	cheight = 13
	cch = ' '

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

var
	
  font 			: TTDFont
  Datapath 		: string
  FontFile		: String
	
  filename:string
  ListFile     : File;
  OutFile      : File;
  OutName      : String;
  tmpfile		: string;
  buffer		: byte;
var basedir : string = '/home/x/mystic'  
Var Totalitems:byte
Var Temp      :byte
Var Temp2     :byte  
Var dirdepth  :array[1..10] of String
Var dirindex   : byte
Var item      :array[1..max_items] of String
Var Idx       :Array[1..max_items] of byte
Var TopPage   :byte
Var BarPos    :byte
Var Done      : Boolean
Var Ch         :Char
Var Ch2        :Char
Var More      :byte
Var LastMore  :byte
Var CurDir    :string
var ti        :integer
var kk        :char;
var rootdir   :string
var search   :string
var search_idx:integer
var ii : integer

Procedure ClearArea
var o:byte
Begin
  for o:=1 to cheight do begin
    gotoxy(cx,cy+o)
    write(strrep(cch,cwidth))
  end
end

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

Procedure BarON
begin
  GotoXY (list_left, list_top + BarPos - TopPage)
  Write (list_on+' ' + PadLT(StripMCI(item[BarPos]), list_width, ' ') + '|16')
end

Procedure BarOFF
begin
  GotoXY (list_left, list_top + BarPos - TopPage)
  Write (list_off+' ' + PadLT(item[BarPos], list_width, ' '))
end 

procedure clearitems
  var i:integer
begin
    for i:=1 to max_items do item[i]:=''
    TopPage  := 1
	BarPos   := 1
	Done     := False
	More     := 0
	LastMore := 0
end

Procedure DrawPage
begin
  Temp2 := BarPos
  For Temp := 0 to (list_max-1) do begin 
    BarPos := TopPage + Temp
    BarOFF
  end
  BarPos := Temp2
  BarON
end 


Procedure fuckSort;
Var
	i, j:integer
   temp1 : string
Begin
	for j:=1 to totalitems do
	For i := 2 to totalitems do begin
	  if item[i-1]>item[i] then begin
	    temp1:=item[i-1]
	    item[i-1]:=item[i]
	    item[i]:=temp1
	  end
	  
	end
End

procedure getdir(dir:string)
var
  i:integer
begin
i:=0
//item[1]:='..'
FindFirst (dir+'*', 63)
                        While DosError = 0 do begin
                                if direxist(dir+dirname) then
									if dirname<>'.' and dirname<>'..'then begin
									if i<=max_items then begin
										i:=i+1
										item[i]:=DirName
									end
                                end
                            FindNext
                        end
                FindClose
  totalitems:=i
  fucksort
end

procedure getfiles(dir:String)
var
  i:integer
begin
i:=0
//item[1]:='..'
FindFirst (dir+'*.*', 63)
                        While DosError = 0 do begin
                                if dirname<>'.' and dirname<>'..'then begin
									if i<=max_items then begin
										i:=i+1
										item[i]:=DirName
									end
                                end
                            FindNext
                        end
                FindClose
	totalitems:=i                
end

procedure getnewdir(s:string)
  var i:byte
begin
  dirindex:=dirindex+1
  dirdepth[dirindex]:=s
  curdir:=''
  for i:=1 to dirindex do curdir:=curdir+dirdepth[i]+pathchar
  curdir:=basedir+curdir
end

procedure getpredir
var i:byte
begin
  dirindex:=dirindex-1
  dirdepth[dirindex+1]:=''
  curdir:=''
  for i:=1 to dirindex do curdir:=curdir+dirdepth[i]+pathchar
  curdir:=basedir+curdir
end

//Main loop

begin
clrscr

if paramcount<1 then begin
  writeln('|16|15No paramaters . Exiting... |PA')
  Halt
end

If Graphics = 0 Then begin
  writeln('|16|15No Graphics support. Exiting... |PA')
  Halt
End

for ti:=1 to 10 do dirdepth[ti]:=''
dirindex:=1

GetThisUser


getnewdir(paramstr(1))
rootdir:=basedir + pathchar +paramstr(1) + pathchar
tmpfile:=CfgSysPath  + 'temp' + Int2Str(NodeNum) + PathChar + outname

clearitems
getdir(curdir)

If Totalitems = 0 Then begin
  WriteLn ('No files or directories to display')
  writeln('|PA')
  Halt
End

DispFile (CfgTextPath + 'tdfgallery')

TopPage  := 1
BarPos   := 1
Done     := False
More     := 0
LastMore := 0

search:='';
search_idx:=0

DrawPage

Repeat
  More := 0
  Ch   := ' '
  Ch2  := ' '

  If TopPage > 1 Then begin
    More := 1
    Ch   := Chr(244)
  End

  If TopPage + (list_max-1) < Totalitems Then begin
    Ch2  := Chr(245)
    More := More + 2
  End

  If More <> LastMore Then begin
    LastMore := More
    GotoXY (morex,morey)
    Write (' |08(|07' + Ch + Ch2 + ' |15m|07ore|08) ')
  End

  Ch := ReadKey
 If IsArrow Then begin
	//HOME key
	if ch = chr(71) then begin
	search_idx:=1
		TopPage := 1
		BarPos  := 1
		drawpage
    end
	//END Key
	if ch = chr(79) then begin
	search_idx:=1
		if Totalitems > list_max then begin
			TopPage := Totalitems - (list_max-1)
			BarPos  := Totalitems
		end else begin
			BarPos  := Totalitems
		end
		drawpage
    end
  
    If Ch = Chr(72) Then begin
    search_idx:=1
      If BarPos > TopPage Then begin
        BarOFF
        BarPos := BarPos - 1
        BarON
        end
      Else
      If TopPage > 1 Then begin
        TopPage := TopPage - 1
        BarPos  := BarPos  - 1
        DrawPage
      End
    end
  
     If Ch = Chr(73) Then begin
    search_idx:=1
      If TopPage - list_max > 0 Then begin
        TopPage := TopPage - list_max
        BarPos  := BarPos  - list_max
        DrawPage
        end
      Else begin
        TopPage := 1
        BarPos  := 1
        DrawPage
      End
    end
  
    If Ch = Chr(80) Then begin
    search_idx:=1
      If BarPos < Totalitems Then
        If BarPos < TopPage + (list_max-1) Then begin
          BarOFF
          BarPos := BarPos + 1
          BarON
          end
        Else
        If BarPos < Totalitems Then begin
          TopPage := TopPage + 1
          BarPos  := BarPos  + 1
          DrawPage
        End
      End        
  
    If Ch = Chr(81) Then begin
    search_idx:=1
      If Totalitems > list_max Then
        If TopPage + list_max < Totalitems - list_max Then begin
          TopPage := TopPage + list_max
          BarPos  := BarPos  + list_max
          DrawPage
          end
        Else
        begin
          TopPage := Totalitems - (list_max-1)
          BarPos  := Totalitems
          DrawPage
        End
      Else
      begin
        BarOFF
        BarPos := Totalitems
        BarON
      End
    End    
  ch:=#0
  end else
  
  If Ch = Chr(26) Then begin
    DispFile('tdfgalleryh')
      Ch := ReadKey
      DispFile (CfgTextPath + 'tdfgallery')
      DrawPage
    //End
    end
  Else If Ch =chr(4) Then begin
		if fileexist(curdir+item[barpos]) then begin
			menucmd('GT','|#V#1#20#10# Download Font #Y-Yes             ,N-No             #')
			kk:=readkey
			if upper(kk)='Y' then MenuCmd ('F3', curdir+item[barpos])
			clrscr
			DispFile (CfgTextPath + 'tdfgallery')
			DrawPage
		end
	end else if Ch = Chr(5) then begin
	DispFile (CfgTextPath + 'tdfgallery')
    DrawPage
  end else if Ch = Chr(13) then begin
	
	search:=''
	search_idx:=0
	
	(*if item[barpos]='..' then begin
		if dirindex>2 then begin
		getpredir
	    clearitems
	    getdir(curdir)
	    DispFile (CfgTextPath + 'tdfgallery')
	    DrawPage
	    end
	end *)
	if direxist(curdir+item[barpos]) then begin
			  getnewdir(item[barpos])
			  clearitems
			  getdir(curdir)
			  getfiles(curdir)
			  DispFile (CfgTextPath + 'tdfgallery')
			  DrawPage
	end else if fileexist(curdir+item[barpos]) then begin
				//menucmd('GV','ansiviewtxt;ansiviewh;0;'+curdir+item[barpos])
				cleararea
				gotoxy(fx,fy)
				write('|15'+item[barpos])
				gettdfheader(curdir+item[barpos])
				font.spacing:=1
				tdfwrite(fx,fy+1,fstr)
    end
  end
  If Ch = Chr(27) Then begin
    if curdir = rootdir then Done := True
    if dirindex>2 then begin
		getpredir
	    clearitems
	    getdir(curdir)
	    search:=''
	    search_idx:=0
	    DispFile (CfgTextPath + 'tdfgallery')
		DrawPage
	    end
  End else
   if ch = chr(1) then begin
    for ii:=search_idx+1 to max_items do begin
		if pos(search,upper(item[ii]))>0 then begin
			TopPage := ii
            BarPos  := ii
            search_idx:=ii
            DrawPage
            break
		end
	end	
  end else
  if ch = chr(25) then begin
    gotoxy(searchx,searchy)
	write(strrep(' ',length(search)))
	search:='';
	search_idx:=0
  end else
  if ch>=chr(32) and ch<=chr(128) then begin
	search:=search+upper(ch)
	gotoxy(searchx,searchy)
	write(searchcol+upper(search))	
	for ii:=1 to max_items do begin
		if pos(search,upper(item[ii]))>0 then begin
			TopPage := ii
            BarPos  := ii
            search_idx:=ii
            DrawPage
            break
		end
	end	
  end
Until Done

GotoXY (1, 23)

end
