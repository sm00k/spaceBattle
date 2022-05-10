unit engine;
interface
uses {$ifdef unix}cthreads, {$endif} sysutils, wingraph, winCrt;

procedure graphics;
procedure getKey(var code : integer);
procedure loadPcs(nameFile : string; x, y : integer);
procedure screenCenter(var x, y : integer);
procedure screenCenterText(var x, y : integer; text : string);
procedure loadAnim(var arr : anim; frameSize, numOfFrame : integer;
fileName :	       string);
function enemy(p : pointer) : ptrint;

type
   anim	= array[1..8] of animatType;
var
   arr		      : anim;
   botX, botY, pX, pY : integer;
   finished	      : longint;

threadvar
   thri : ptrint;
   
implementation

procedure graphics;
var
   driver, mode	: integer;
   title	: shortstring;
begin
   DetectGraph(driver, mode);
   mode := mFullScr;
   initgraph(driver, mode, '');
end;

procedure getKey(var code : integer);
var
   c : char;
begin
   c := ReadKey;
   if c := #0 then
   begin
      c := ReadKey;
      code := -ord(c);
   end
   else
   begin
      code := ord(c);
   end;
end;

procedure loadPcs(nameFile : string; x, y : integer);
var 
   bitmap : pointer;
   size	  : longint;
   f	  : file;
begin
   {$I-}
   Assign(f, nameFile);
   Reset(f, 1);
   {$I+}
   if (IOResult <> 0) then
      Exit;
   size := FileSize(f);
   GetMem(bitmap, size);
   BlockRead(f, bitmap^, size);
   Close(f);
   PutImage(x, y, bitmap^, NormalPut);
   FreeMem(bitmap);
end;

procedure screenCenter(var x, y : integer);
begin
   x := GetMaxX div 2;
   y := GetMaxY div 2;
end;

procedure screenCenterText(var x, y : integer; text : string);
begin
   x := (GetMaxX div 2) - (TextWhidth(text) div 2);
   y := (GetMaxY div 2) - (TextHeight(text) div 2);
end;

procedure loadAnim(var sprt : anim; frameSize, numOfFrame : integer;
                   fileName : string);
var
   i, x, y, x2, y2 : integer;
begin
   x := 0;
   y := 0;
   x2 := frameSize;
   y2 := frameSize;
   loadPcs(fileName, x, y);
   for i := 1 to numOfFrame do
   begin
      GetAnim(x, y, x2, y2, black, sprt[i]);
      x := x2;
      x2 := x2 + frameSize;
   end;
   clearDevice;
end;

function enemy(p : pointer) : ptrint;
const
   move : integer = 5;
var
   frame : integer;
begin
   while true do
   begin
      if ((botX - pX) = 0) and ((botY - pY) > 0) then
      begin
	 frame := 1;
	 botY := botY - move;
      end;
      if ((botX - pX) < 0) and ((botY - pY) > 0) then
      begin
	 frame := 2;
	 botX := botX + move;
	 botY := botY - move;
      end;
      if ((botX - pX) < 0) and ((botY - pY) = 0) then
      begin
	 frame := 3;
	 botX := botX + move;
      end;
      if ((botX - pX) < 0) and ((botY - pY) < 0) then
      begin
	 frame := 4;
	 botX := botX + move;
	 botY := botY + move;
      end;
      if ((botX - pX) = 0) and ((botY - pY) < 0) then
      begin
	 frame := 5;
	 botY := botY + move;
      end;
      if ((botX - pX) > 0) and ((botY - pY) < 0) then
      begin
	 frame := 6;
	 botX := botX - move;
	 botY := botY + move;
      end;
      if ((botX - pX) > 0) and ((botY - pY) = 0) then
      begin
	 frame := 7;
	 botX := botX - move;
      end;
      if ((botX - pX) > 0) and ((botY - pY) > 0) then
      begin
	 frame := 8;
	 botX := botX - move;
	 botY := botY - move;
      end;
      PutAnim(botX, botY, arr[frame], TransPut);
      sleep(10);
      PutAnim(botX, botY, arr[frame], bkgPut);
      inc(thri);
   end;
   InterLockedIncrement(finished);
   f:=0;
end;
end.
