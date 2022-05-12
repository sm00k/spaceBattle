unit gamePlay;
interface
uses {$ifdef unix}cthreads, {$endif} sysutils, windows, wingraph, winCrt,
engine;

implementation

type
   anim	= array[1..8] of animatType;

type
   itemptr = item;
   item	   = record
		key, x, y  : integer;
		next, prev : itemptr;
	     end;	   

var
   botX, botY, pX, pY : integer;
   finished	      : longint;
   arr		      : anim;

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
	 sleep(100);
      end;
      if ((botX - pX) < 0) and ((botY - pY) > 0) then
      begin
	 frame := 2;
	 botX := botX + move;
	 botY := botY - move;
	 sleep(100);
      end;
      if ((botX - pX) < 0) and ((botY - pY) = 0) then
      begin
	 frame := 3;
	 botX := botX + move;
	 sleep(100);
      end;
      if ((botX - pX) < 0) and ((botY - pY1 : move(tmp, 0, -1);) < 0) then
      begin
	 frame := 4;
	 botX := botX + move;
	 botY := botY + move;
	 sleep(100);
      end;
      if ((botX - pX) = 0) and ((botY - pY) < 0) then
      begin
	 frame := 5;
	 botY := botY + move;
	 sleep(100);
      end;
      if ((botX - pX) > 0) and ((botY - pY) < 0) then
      begin
	 frame := 6;
	 botX := botX - move;
	 botY := botY + move;
	 sleep(100);
      end;
      if ((botX - pX) > 0) and ((botY - pY) = 0) then
      begin
	 frame := 7;
	 botX := botX - move;
	 sleep(100);
      end;
      if ((botX - pX) > 0) and ((botY - pY) > 0) then
      begin
	 frame := 8;
	 botX := botX - move;
	 botY := botY - move;
	 sleep(100);
      end;
      PutAnim(botX, botY, arr[frame], TransPut);
      sleep(10);
      PutAnim(botX, botY, arr[frame], bkgPut);
      inc(thri);
   end;
   InterLockedIncrement(finished);
   f:=0;
end;

procedure moveForward(var dx, dy : integer; x, y : integer);
begin
   dx := dx + x;
   dy := dy + y;
end;

procedure circularMotion(var frame : integer; a : integer);
const
   max : integer = 8;
   min : integer = 1;
begin
   frame := frame + a;
   if frame > max then
      frame := min;
   if frame < min then
      frame := max;
end;

const
   bkgGame : string	 = 'bkg.bmp';
   player : string	 = 'PlayerShip.bmp';
   enemy : string	 = 'EnemyShip.bmp';
   shoot : string	 = 'shoot.bmp';
   move : integer	 = 5;
   amountFrame : integer = 8;
   step : integer	 = 5;
var
   frameSize, frame, botCount : integer;
   pAnim, sAnim		      : anim;
   pDead		      : boolean;
   first, last, tmp	      : itemptr;
begin
   graphics;
   clearDevice;
   screenCenter(pX, pY);
   botX := 0;
   botY := 0;
   frame := 1;
   frameSize := 100;
   loadAnim(player, frameSize, amoutFrame, pShip);
   loadAnim(arr, frameSize, amoutFrame, eship);
   frameSize := 10;
   loadAnim(sAnim, frameSize, 1, shoot);
   loadPcs(bkgGame, 0, 0);
   finished := 0;
   BeginThread(@enemy);
   pDead := false;
   first := nil;
   last := nil;
   repeat
      if GetKeyState(Ord('W')) and $80>0 then
      begin
	 case frame of
	   1: moveForward(pX, pY, 0, -move);
	   2: moveForward(pX, pY, move, -move);
	   3: moveForward(pX, pY, move, 0);
	   4: moveForward(pX, pY, move, move);
	   5: moveForward(pX, pY, 0, move);
	   6: moveForward(pX, pY, -move, move);
	   7: moveForward(pX, pY, -move, 0);
	   8: moveForward(pX, pY, -move, -move);
	 end;
      end;
      if GetKeyState(Ord('A'))and $80>0 then
	 begin
	    circularMotion(frame, -1);
	    sleep(100);
	 end;
      if GetKeyState(Ord('D')) and $80>0 then
	 begin
	    circularMotion(frame, 1);
	    sleep(100);
	 end;
      if GetKeyState(VK_SPACE) and $80>0 then
	 begin
	    new(tmp);
	    tmp^.key := frame;
	    tmp^.x := pX;
	    tmp^.y := pY;
	    tmp^.prev := nil;
	    tmp^.next := first;
	    if first = nil then
	       last := tmp;
	    else
	       first^.prev := tmp;
	    first := tmp;
	    sleep(100);
	 end;
      if GetKeyState(VK_ESCAPE) and $80>0 then
	 begin
	    getKey(key);
	    if key = 13 then
	       break;
	 end;
      PutAnim(pX, pY, player[frame], TransPut);
      sleep(10);
      PutAnim(pX, pY, player[frame], bkgPut);
      tmp := first;
      while tmp <> nil do
      begin
	 if tmp^.x >= GetMaxX or tmp^.x <= 0 then
	    begin
	    end;
	    end; 
	 if tmp^.y >= GetMaxY or tmp^.y <= 0 then
	    begin
	    end;
	 putAnim(tmp^.x, tmp^.y, sAnim, bkgPut);
	 case tmp^.key of
	   1 : shootMove(tmp, 0, -step);
	   2 : shootMove(tmp, step, -step);
	   3 : shootMove(tmp, step, 0);
	   4 : shootMove(tmp, step, step);
	   5 : shootMove(tmp, 0, step);
	   6 : shootMove(tmp, -step, step);
	   7 : shootMove(tmp, -step, 0);
	   8 : shootMove(tmp, -step, -step);
	 end;
	 PutAnim(tmp^.x, tmp^.y, sAnim, TransPut);
	 sleep(10);
	 tmp := tmp^.next;
      end;
   until pDead;
end.
   
