program spaceBattle;
{$DEFINE DEBUG}
uses windows, wingraph, engine;
const
   cursor : string	= 'sprites\cursor.bmp';
   bkg : string		= 'sprites\backgroundMenu.bmp';
   font : word		= TimesNewRomanFont;
   direction : word	= HorizDir;
   headerSize :	integer	= 100;
   pcsSize : integer	= 25;
   indentUp : integer	= 50;
   indentLeft :	integer	= -50;
   textSize : word	= 30;
var
   driver, mode, x, y, maxY, minY : integer;
   anim				  : animatType;
   f				  : text;
   quit				  : boolean;
begin
   {$I-}
   Assign(f, fName);
   reset(f);
   {$I+}
   if IOResult <> 0 then
      CreateScore;
   close(f);
   DetectGraph(driver, mode);
   mode := mFullScr;
   Initgraph(driver, mode, '');
   ClearDevice;
   quit := true;
   while quit do
   begin
      LoadPcs(cursor, 0, 0);
      GetAnim(0, 0, pcsSize, pcsSize, black, anim);
      ClearDevice;
      LoadPcs(bkg, 0, 0);
      SetTextStyle(font, direction, headerSize);
      ScreenCenterText(x, y, 'Space War');
      OutTextXY(x, y, 'Space War');
      SetTextStyle(font, direction, 25);
      ScreenCenterText(x, y, 'Quit');
      y := y + (indentUp * 4);
      maxY := y;
      OutTextXY(x, y, 'Quit');
      ScreenCenterText(x, y, 'Record');
      y := y + (indentUp * 3);
      OutTextXY(x, y, 'Record');
      ScreenCenterText(x, y, 'New Game');
      y := y + (indentUp * 2);
      minY := y;
      OutTextXY(x, y, 'New Game');
      x := x + indentLeft;
      PutAnim(x, y, anim, TransPut);
      while true do
      begin
	 PutAnim(x, y, anim, bkgPut);
	 if GetKeyState(VK_SPACE) and $80 > 0 then
	 begin
	    {$IFDEF DEBUG}
	    writeln('Space y =', y);
	    {$ENDIF}
	    if y = minY then
	    begin
	       GamePlay;
	       Break;
	    end;
	    if y = maxY then
	    begin
	       quit := false;
	       break;
	    end;
	    if (y > minY) and (y < maxY) then
	    begin
	       ShowScore;
	       {$IFDEF DEBUG}
	       writeln('Show score');
	       {$ENDIF}
	       break;
	    end;
	    sleep(200);
	 end;
	 if GetKeyState(Ord('W')) and $80 > 0 then
	 begin
	    y := y - indentUp;
	    if y < minY then
	       y := maxY;
	    sleep(200);
	 end;
	 if GetKeyState(Ord('S')) and $80 > 0 then
	 begin
	    y := y + indentUp;
	    if y > maxY then
	       y := minY;
	    {$IFDEF DEBUG}
	    writeln('S y =', y);
	    {$ENDIF}
	    sleep(200);
	 end;
	 PutAnim(x, y, anim, TransPut);
	 sleep(10);
      end;
   end;
end.
