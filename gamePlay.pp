unit gamePlay;
interface
uses {$ifdef unix}cthreads, {$endif} sysutils, windows, wingraph, winCrt,
engine;

implementation

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
var
   frameSize, frame : integer;
   pAnim, sAnim	    : anim;
   pDead	    : boolean;
   botCount	    : integer;
   pShoot	    : boolean;
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
   loadAnim(sAnim, frameSize, 1, shoot);
   loadPcs(bkgGame, 0, 0);
   finished := 0;
   BeginThread(@enemy);
   pDead := false;
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
	    //shoot
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
      end;
   until pDead;
end.
   
