unit menu;
interface

uses wingraph, winCrt, engine;
type
        mng = record
                newGame, score, quit : boolean;
                end;

procedure mainMenu(var control : mng);

implementation

type
   move	= record
	     pos, up, down, shift : integer;
	     anim		  : animatType;
	     above, under	  : word;
	  end;

procedure goUp(var loc : move; indentUp : integer);
begin
   PutAnim(loc.shift, loc.pos, loc.anim, loc.under);
   loc.pos := loc.pos + indentUp;
   if loc.pos > loc.up then
      loc.pos := loc.down;
end;

procedure goDown(var loc : move, indentUp : integer);
begin
   PutAnim(loc.shift, loc.pos, loc.anim, loc.under);
   loc.pos := loc.pos - indentUp;
   if loc.pos < loc.down then
      loc.pos := loc.up;
end;

procedure mainMenu(var control : mng);
const
   font : word	   = TimesNewRomanFont;
   direction : word	   = HorizDir;
   mItemSize :  word	   = 30;
   indentUp : integer   = 50;
   indentLeft : integer = 60;
   pcsSize : integer	   = 25;
   headerSize : integer = 100;
var
   loc	     : move;
   key, x, y : integer;
begin
   ClearDevice;
   loadPcs('spraite/cursor.bmp', 0, 0);
   GetAnim(0, 0, pcsSize, pcsSize, black, anim);
   ClearDevice;
   loadPcs('spraite/backgroundMenu.bmp', 0, 0);
   SetTextStyle(font, direction, headerSize);
   screenCenterText(x, y, 'Space War');
   OutTextXY(x, y, 'Space War');
   loc.above := TransPut;
   loc.under := BkgPut;
   SetTextStyle(font, direction, mItemSize);
   screenCenterText(x, y, 'New Game');
   loc.up := y + (indentUp * 2);
   loc.pos := loc.up;
   loc.shift := x - indentLeft;
   OutTextXY(x, up, 'New Game');
   screenCenterText(x, y, 'Record');
   OutTextXY(x, y + (indentUp * 3), 'Record');
   screenCenterText(x, y, 'Quit');
   loc.down := y + (indentUp * 4);
   OutTextXY(x, loc.down, 'Quit');
   PutAnim(loc.shift, loc.up, loc.anim, loc.above);
   while true do
   begin
      getKey(key);
      if key = 13 then
      begin
	 case pos of
	   up	: control.newGame := true;
	   mid	: control.score := true;
	   down	: control.quit := true;
	 end;
	 break;
      end;
      case key of
	-80 : goUp(loc, indentUp);
	115 : goUp(loc, indentUp);// check number key
	-72 : goDown(loc, indentUp);
	119 : goDown(loc, indentUp);
      end;
      PutAnim(loc.shift, loc.pos, loc.anim, loc.above);
   end;
end;
end.
