unit engine;
{DEFINE DEBUG}
interface
uses windows, wingraph, wincrt;

procedure LoadPcs(name : string; x, y : integer);
procedure ScreenCenterText(var x, y : integer; txt : string);
procedure CreateScore;
procedure ShowScore;
procedure GamePlay;

const
   fName : string   = 'sprites\score.txt';
   bkgMenu : string = 'sprites\backgroundMenu.bmp';
implementation
  
procedure LoadPcs(name : string; x, y : integer);
var
   bitmap : pointer;
   size	  : longint;
   f	  : file;
begin
   {$I-}
   Assign(f, name);
   Reset(f, 1);
   {$I+}
   if IOResult <> 0 then
   begin
      writeln('don''t open file');
      Readln();
      Halt(1);
   end;
   size := FileSize(f);
   GetMem(bitmap, size);
   BlockRead(f, bitmap^, size);
   Close(f);
   PutImage(x, y, bitmap^, NormalPut);
   FreeMem(bitmap);
end;

procedure screenCenterText(var x, y : integer; txt : string);
begin
   x := (GetMaxX div 2) - (TextWidth(txt) div 2);
   y := (GetMaxY div 2) - (TextHeight(txt) div 2);
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
   Assign(f, fName);
   Rewrite(f);
   {$I+}
   if IOResult <> 0 then
   begin
      writeln('file isn''t open');
      Readln();
      Halt(1);
   end;
   for i := 1 to numOfLines do
   begin
      writeln(f, '---');
      writeln(f, startingScore);
   end;
   if IOResult <> 0 then
   begin
      writeln('fsiled to write to file');
      Readln();
      Halt(1);
   end;
   close(f);
end;

procedure getKey(var code : integer);
var
   c : char;
begin
   c := ReadKey;
   if c = #0 then
   begin
      c := ReadKey;
      code := -ord(c);
   end
   else
   begin
      code := ord(c);
   end;
end;


procedure showScore;
const
   count : integer	 = 10;
   errOpnFile : string	 = 'Could not open sprites/score.txt';
   indentUp : integer	 = 50;
   indentWidth : integer = 20;
   font : word		 = TimesNewRomanFont;
   direction : word	 = HorizDir;
   charSize : word	 = 30;
var
   i, x, y, c : integer;
   f	      : text;
   txt	      : string;
   dist	      : integer;
begin
   ClearDevice;
   LoadPcs(bkgMenu, 0, 0);
   SetTextStyle(font, direction, charSize);
   SetColor(white);
   dist := GetMaxX div 3;
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
   y := y + indentUp;
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
   while true do
   begin
      if GetKeyState(VK_ESCAPE) and $80 > 0 then
	 break;
      sleep(100);
   end;
end;

type
   anim	= array[1..8] of animatType;

procedure LoadAnim(name : string; frameSize, amoutFrame : integer; var arr : anim);
var
   i, x, y, x2, y2 : integer;
begin
   x := 0;
   y := 0;
   x2 := frameSize;
   y2 := frameSize;
   LoadPcs(name, x, y);
   for i := 1 to amoutFrame do
   begin
      GetAnim(x, y, x2, y2, black, arr[i]);
      x := x2;
      x2 := x2 + frameSize;
   end;
   ClearDevice;
end;

type
   charArr = array[1..3] of char;
{
procedure AddPlayer;
const
   font : word	    = TimesNewRomanFont;
   direction : word = HorizDir;
   charSize : word  = 30;
   indent : integer = 5;
var
   x, y, count : integer;
   s	       : char;
   name	       : charArr;
begin
   ClearScreen;
   LoadPcs(0, 0, bkgMenu);
   ScreenCenter(x, y);
   SetTextStyle(font, direction, charSize);
   x := x - indent;
   for count := 1 to 3 do
   begin
      OutTextXY(x, y, '_');
      x := x + indent;
   end.
   ScreenCenter(x, y);
   count := 1;
   while true do
   begin
      GetKey(s);
      if s > 60 and s < 90 then
      begin
	 name[count] := s;
	 
}
procedure MoveForward(var pX, pY : integer; x, y : integer);
begin
   pX := pX + x;
   pY := pY + y;
end;

type
   itemptr = ^item;
   item	   = record
		frame, x, y : integer;
		prev, next  : itemptr;
	     end;

procedure del(var last : itemptr);
var
   tmp : itemptr;
begin
   tmp := last;
   if tmp^.prev <> nil then
   begin
   last := tmp^.prev;
   last^.next := nil;
   end
   else
      last := nil;
   dispose(tmp);
end;

procedure GamePlay;
label
   quitGamePlay;
const
   bkg : string		       = 'sprites\bkgGame.bmp';
   player : string	       = 'sprites\PlayerShip.bmp';
   enemy : string	       = 'sprites\EnemyShip.bmp';
   shoot : string	       = 'sprites\shoot.bmp';
   pause : string	       = 'sprites\Pause.bmp';
   strideLengthShip : integer  = 5;
   strideLengthShoot : integer = 5;
   amoutFrame :	integer	       = 8;
   pauseSizeX :	integer	       = 300;
   pauseSizeY :	integer	       = 150;
var
   frameSize, frame, pX, pY, pauseX, pauseY : integer;
   pAnim, eAnim				    : anim;
   shootAnim, pauseAnim			    : animatType;
   first, last, tmp			    : itemptr;
begin
   first := nil;
   last := nil;
   ClearDevice;
   LoadPcs(pause, 0, 0);
   frameSize := 300;
   GetAnim(0, 0, frameSize, frameSize, black, pauseAnim);
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
      PutAnim(pX, pY, pAnim[frame], bkgPut);
      if GetKeyState(VK_ESCAPE) and $80 > 0 then
      begin
	 pauseX := (GetMaxX div 2) - (pauseSizeX div 2);
	 pauseY := (GetMaxY div 2) - (pauseSizeY div 2);
	 PutAnim(pauseX, pauseY, pauseAnim, TransPut);
	 sleep(200);
	 while true do
	 begin
	    if GetKeyState(VK_SPACE) and $80 > 0 then
	    begin
	       PutAnim(pauseX, pauseY, pauseAnim, bkgPut);
	       sleep(200);
	       break;
	    end;
	    if GetKeyState(VK_ESCAPE) and $80 > 0 then
	    begin
	       sleep(200);
	       ClearDevice;
	       //AddPlayer;
	       ShowScore;
	       goto quitGamePlay;
	    end;
	 end;
      end;
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
	 Sleep(200);
      end;
      if GetKeyState(Ord('D')) and $80 > 0 then
	 begin
	    frame := frame + 1;
	    if frame > amoutFrame then
	       frame := 1;
	    Sleep(200);
	 end;
      if GetKeyState(VK_SPACE)and $80 > 0 then
      begin
	 new(tmp);
	 tmp^.frame := frame;
	 tmp^.x := pX;
	 tmp^.y := pY;
	 tmp^.prev := nil;
	 tmp^.next := first;
	 if first = nil then
	    last := tmp
	 else
	    first^.prev := tmp;
	 first := tmp;
	 sleep(100);
      end;
      PutAnim(pX, pY, pAnim[frame], TransPut);
      tmp := last;
      while tmp <> nil do
      begin
	 PutAnim(tmp^.x, tmp^.y, shootAnim, bkgPut);
	 case tmp^.frame of
	   1: moveForward(tmp^.x, tmp^.y, 0, -strideLengthShip);
	   2: moveForward(tmp^.x, tmp^.y,
			  strideLengthShoot, -strideLengthShoot);
	   3: moveForward(tmp^.x, tmp^.y, strideLengthShip, 0);
	   4: moveForward(tmp^.x, tmp^.y,
			  strideLengthShoot, strideLengthShoot);
	   5: moveForward(tmp^.x, tmp^.y, 0, strideLengthShip);
	   6: moveForward(tmp^.x, tmp^.y,
			  -strideLengthShoot, strideLengthShoot);
	   7: moveForward(tmp^.x, tmp^.y, -strideLengthShoot, 0);
	   8: moveForward(tmp^.x, tmp^.y,
			  -strideLengthShoot, -strideLengthShoot);
	 end;
	 if ((tmp^.x < GetMaxX) and (tmp^.x > 0)) and
	    ((tmp^.y < GetMaxY) and (tmp^.y > 0))then
	    PutAnim(tmp^.x, tmp^.y, shootAnim, TransPut)
	 else
	    del(last);
	 tmp := tmp^.prev;
	 sleep(10);
      end;
      sleep(10);
   end;
   quitGamePlay:
end;
end.
