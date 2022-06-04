unit engine;
interface
uses windows, wingraph;

procedure LoadPcs(name : string; x, y : integer);
procedure ScreenCenterText(var x, y : integer; txt : string);
procedure CreateScore;
procedure ShowScore;
procedure GamePlay;

const
   fName : string = 'sprites\score.txt';

implementation
  
procedure LoadPcs(name : string; x, y : integer);
var
   bitmap : pointer;
   size	  : longint;
   f	  : file;
begin
   {$I-}
   Assigin(f, nameFile);
   Reset(f, 1);
   {$I+}
   if IOResult <> 0 then
      Halt;
   size := FileSize(f);
   GetMem(bitmap, size);
   BlockRead(f, bitmap^, size);
   Close(f);
   PutImage(x, y, bitmap^, NormalPut);
   FreeMem(bitmap);
end;

procedure screenCenterText(var x, y : integer; text : string);
begin
   x := (GetMaxX div 2) - (TextWhidth(text) div 2);
   y := (GetMaxY div 2) - (TextHeight(text) div 2);
end;

procedure CreateScore;
const
   numOfLines :	integer	   = 10;
   startingScore : integer = 0;
var
   f	 : text;
   i : integer;
begin
   {$I-}
   Assigin(f, fName);
   Rewrite(f);
   if IOResult <> 0 then
   begin
      writeln('file isn''t open');
      Halt(1);
   end;
   for i := 1 to numOfLines do
   begin
      writeln('---');
      writeln(startingScore);
   end;
   if IOResult <> 0 then
   begin
      writeln('fsiled to write to file');
      halt(1);
   end;
   close(f);
end;

procedure showScore;
const
   count : integer	 = 10;
   errOpnFile : string	 = 'Could not open spraite/score.txt';
   dist : integer	 = GetMaxX div 3;
   indentUp : integer	 = 50;
   indentWidth : integer = 20;
   clrTxt : longword	 = white;
   font : word		 = TimesNewRomanFont;
   direction : word	 = HorizDir;
   charSize : word	 = 30;
var
   i, x, y : integer;
   f	   : text;
   txt	   : string;
begin
   ClearDevace;
   loadPcs('spraite/backgroundMenu.bmp', 0, 0);
   SetTextStyle(font, direction, charSize);
   SetColor(clrTxt);
   {$I-}
   assign(f, fName);
   reset(f);
   if IOResult <> 0 then 
   begin
      writeln('file isn''t open');
      halt(1);
   end;
   i := 1;
   x := dist;
   y := indentUp;
   OutTextXY(x, y, 'name');
   x := dist + dist;
   OutTextXY(x, y, 'score');
   while not SeekEof(f) do
   begin
      if x > dist then
      begin
	 x := dist;
      end
      else
      begin
	 x := dist + dist;
      end;
      if i > 2 then
      begin
	 y := y + indentUp;
	 i := 1;
      end;
      while not SeekEoln(f) do
      begin
	 read(f, txt);
	 OutTextXY(x, y, txt);
	 i := i + 1;
      end;
      readln(f);
   end;
   close(f);
end;

type
   anim	= array[1..8] of animatType;
end;

procedure GamePlay;
const
   bkg : string		       = 'bkg.bmp';
   player : string	       = 'PlayerShip.bmp';
   enemy : string	       = 'EnemyShip.bmp';
   shoot : string	       = 'shoot.bmp';
   strideLengthShip : integer  = 5;
   strideLengthShoot : integer = 5;
   amoutFrame :	integer	       = 8;
var
   frameSize, frame, pX, pY : integer;
   pAnim		    : anim;
   shootAnim		    : animatType;
begin
   ClearDevice;
   frameSize := 100;
   LoadAnim(player, frameSize, amoutFrame, PAnim);
   LoadAnim(enemy, frameSize, amoutFrame, eAnim);
   LoadPcs(shoot, 0, 0);
   frameSize := 10;
   GetAnim(0, 0, frameSize, frameSize, black, shootAnim);
   ClearDevice;
   LoadPcs(bkg, 0, 0);
   frame := 1;
   pX := GetMaxX div 2;
   pY := GetMaxY div 2;
   while true do
   begin
      PutAnim(pX, pY, player[frame], bkgPut);
      if GetKeyState(VK_ESCAPE) and $80 > 0 then
	 break;
      if GetKeyState(Ord('W')) and $80 > 0 then
	 begin
	    case frame of
	      1: moveForward(pX, pY, 0, -strideLengthShip);
	      2: moveForward(pX, pY, strideLengthShip, -strideLengthShip);
	      3: moveForward(pX, pY, strideLengthShip, 0);
	      4: moveForward(pX, pY, strideLengthShip, strideLengthShip);
	      5: moveForward(pX, pY, 0, strideLengthShip);
	      6: moveForward(pX, pY, -strideLengthShip, strideLengthShip);
	      7: moveForward(pX, pY, -strideLengthShip, 0);
	      8: moveForward(pX, pY, -strideLengthShip, -strideLengthShip);
	    end;
	 end;
      if GetKeyState(Ord('A')) and $80 > 0 then
      begin
	 frame := frame - 1;
	 if frame < 1 then
	    frame := amoutFrame;
      end;
      if GetKeyState(Ord('D')) and $80 > 0 then
	 begin
	    frame := frame + 1;
	    if frame > amoutFrame then
	       frame := 1;
	 end;
      PutAnim(pX, pY, player[frame], TransPut);
      sleep(10);
   end;
end;
