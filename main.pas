program spaceBattle;

uses windows, wingraph, engine;
const
   cursor : string	= 'spraite/cursor.bmp';
   bkg : string		= 'spraite/backgroundMenu.bmp';
   font : word		= TimesNewRomanFont;
   direction : word	= HorizDir;
   headerSize :	integer	= 100;
   pcsSize : integer	= 25;
   indentUp : integer	= 50;
   indebtLeft :	integer	= 60;
   textSize : word	= 30;
var
   driver, x, y	: integer;
   anim		: animatType;
   f		: text;
begin
   {$I-}
   Assign(f, fName);
   reset(f);
   {$I+}
   if IOResult <> 0 then
      CreateScore;
   DetectGraph(driver);
   Ititgraph(driver, mFullScr, '');
   ClearDevice;
   LoadPcs(cursor, 0, 0);
   GetAnim(0, 0, pcsSize, pcsSize, black, anim);
   ClearDevice;
   LoadPcs(bkg, 0, 0);
   SetTextStyle(font, direction, headerSize);
   ScreenCenterText(x, y, 'Space War');
   OutTextXY(x, y, 'Space War');
   ScreenCenterText(x, y, 'Quit');
   y := y + (indentUp * 4);
   maxY := y;
   OutText(x, y, 'Quit');
   ScreenCenterText(x, y, 'Record');
   y := y + (indentUp * 3);
   OutTextXY(x, y, 'Record');
   ScreenCenterText(x, y, 'New Game');
   y := y + (indentUp * 2);
   minY := y;
   OutTextXY(x, y, 'New Game');
   x := x + indentLeft;
   while true do
   begin
      PutAnim(x, y, anim, bkgPut);
      if GetKeyState(Ord(VK_SPACE)) and $80 > 0 then
      begin
	 if y = minY then
	    GamePlay;
	 if y = maxY then
	    break;
	 if (y > minY) and (y > maxY) then
	    ShowScore;
      end;
      if GetKeyState(Ord('W')) and $80 > 0 then
	 y := y - indentUp;
      if GetKeyState(Ord('S')) and $80 > 0 then
	 y := y + indentUp;
      if y > maxY then
	 y := minY;
      if y < minY then
	 y := maxY;
      PutAnim(x, y, anim, TransPut);
      sleep(10);
   end;
end.
