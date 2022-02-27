unit menu;
interface

uses getKeyCrt, wingraph, loadBmp;
type
        mng = record
                newGame, score, quit : boolean;
                end;

procedure mainMenu(var control : mng);

implementation

   function centreX(txt	: string): integer;
   begin
      centreX := (GetMaxX div 2) - (TextWidth(txt) div 2);
   end;

   function centreY(txt	: string): integer;
   begin
      centreY := (GetMaxY div 2) - (TextHeight(txt) div 2);
   end;

   procedure mainMenu(var control : mng);
   const
      font : word		= TimesNewRomanFont;
      direction : word		= HorizDir;
      charSize :  word		= 30;
      indentUp : integer	= 50;
      indentLeft : integer	= 60;
      bit : word		= TransPut;
      bitT: word                = BkgPut;
   var
      pcsWidth, pcsHeight	: integer;
      anim			: animatType;
      key			: integer;
      up, mid, down, pos, shift	: integer;
   begin
      ClearDevice;
      loadPcs('spraite/cursor.bmp', 0, 0);
      pcsWidth := 25;
      pcsHeight := 25;
      GetAnim(0, 0, pcsWidth, pcsHeight, black, anim);
      ClearDevice;
      loadPcs('spraite/backgroundMenu.bmp', 0, 0);
      up := centreY('New Game') + (indentUp * 2);
      mid := centreY('Record') + (indentUp * 3);
      down := centreY('Quit') + (indentUp * 4);
      shift := centreX('New Game') - indentLeft;
      pos := up;
      SetTextStyle(font, direction, 100);
      OutTextXY(centreX('Space War'), centreY('Space War'), 'Space War');
      SetTextStyle(font, direction, charSize);
      OutTextXY(centreX('New Game'), up, 'New Game');
      OutTextXY(centreX('Record'), mid, 'Record');
      OutTextXY(centreX('Quit'), down, 'Quit');
      PutAnim(shift, up, anim, bit);
      while true do
	 begin
	    getKey(key);
	    if (pos = up) and (key = 13) then
	       begin
		  control.newGame := true;
		  break;
	       end;
	    if (pos = mid) and (key = 13) then
	       begin
		  control.score := true;
		  break;
	       end;
	    if (pos = down) and (key = 13) then
	       begin
		  control.quit := true;
		  break;
	       end;
	    if (key = -80) or (key = 115) then
	       begin
                  PutAnim(shift, pos, anim, bitT);
		  pos := pos + indentUp;
		  if pos <= down then
		     begin
			PutAnim(shift, pos, anim, bit);
		     end;
		  if pos > down then
		     begin
			pos := up;
			PutAnim(shift, up, anim, bit);
		     end;
	       end;
	    if (key = -72) or (key = 119) then
	       begin
                  PutAnim(shift, pos, anim, bitT);
		  pos := pos - indentUp;
		  if pos >= up then
		     begin
			PutAnim(shift, pos, anim, bit);
		     end;
		  if pos < up then
		     begin
			pos := down;
			PutAnim(shift, pos, anim, bit);
		     end;
	       end;
	 end;
   end;
 end.
