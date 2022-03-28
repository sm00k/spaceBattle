unit gamePlay;
interface
uses winGraph, getKeyCrt, loadBmp;

implementation

type
   anim	= array[1..16] of animatType;

const
   bkgGame : string = 'bkg.bmp';
   player : string  = 'playerModel.bmp';
   enemy : string   = 'enemyModel.bmp';
var
   i, hieght, width, key : integer;
   pAnim, eAnim	     : anim;
begin
   i := 16;
   hieght := 50;
   width := 50;
   loadAnim(player, hieght, width, pAnim, i);// clear divice and load bmp in procedure
   loadAnim(enemy, hieght, width, eAnim, i);
   loadPcs(bkgGame, 0, 0);
   while hp > 0 do
   begin
      if keypressed then
	 getkey(key);
      
   end;
   
