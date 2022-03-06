unit scrBoard;
interface

uses wingraph, loadBmp, GetKeyCrt;

   procedure showScore;
   procedure addPlayer(score : integer);
   procedure scoreCounter;
   procedure createScore;
   
implementation

const
   fileName : string	 = 'spraite/score.txt'; //not custom const
   font : word		 = TimesNewRomanFont; // custom const
   direction : word	 = HorizDir;//not custon const
   charSize : word	 = 30;//custom const
   dist : integer	 = GetMaxX div 3;//not cuatom const
   indentUp : integer	 = 50;//custom const
   indentWidth : integer = 20;//custom const
   clrTxt : longword	 = white;//not custom const
   
type
   itemptr = ^item;
   item	   = record
		name  : string;
		score : integer;
		next  : itemptr;
	     end;     

procedure createScore; //creating and populating a list of results
const
   stop : integer  = 10;//not custom const
   score : integer = 0;
var
   f	 : text;
   count : integer;
   
begin
   {$I-}
   assign(f, fileName);
   rewrite(f);
   if IOResult <> 0 then
   begin
      writeln('file isn''t open');
      halt(1);
   end;
   for count := 1 to stop do
   begin
      writeln('---');
      writeln(score);
   end;
   if IOResult <> 0 then
   begin
      writeln('failed to write to file');
      halt(1);
   end;
   close(f);
end;

procedure scoreCounter(var count : integer);
const
   score : integer = 100;
begin
   count := count + score;
end;

procedure sortScore(var list : itemptr);//sorting a linear list 
var
   tmp	: itemptr;
   pp	: ^itemptr;
   i, n	: integer;
begin
   n := 1;
   tmp := list;
   while tmp <> nil do
   begin
      tmp := tmp^next;
      n := n + 1;
   end;
   while n > 10 then
   begin
      tmp := list;
      list := list^.next;
      dispose(tmp);
      n := n - 1;
   end;
   for i := 0 to n-1 do
   begin
      pp := @list;
      while pp^ <> nil do
      begin
	 if (pp^^.next <> nil) and (pp^^.data > pp^^.next^.data) then
	 begin
	    tmp := pp^;
	    pp^ := pp^^.next;
	    tmp^.next := pp^^.next;
	    pp^^.next := tmp;
	 end
	 else
	    pp := @(pp^^.next);
      end;
   end;
end;

procedure showScore;//put score list on screen
const
   count : integer     = 10;//not custom const
   errOpnFile : string = 'Could not open spraite/score.txt';
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
   assign(f, fileName);
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

procedure addPlayer(score : integer);//
const
   msg : string		= 'Please enter your name: ';
   //sumbolSize :	integer	= 5;
var
   key, x, y  : integer;
   pname      : string;
   f	      : text;
   first, tmp : itemptr;
begin
   ClearDevace;
   loadPcs('spraites/backgroundMenu.bmp', 0, 0);
   SetTextStyle(font, direction, charSize);
   SetColor(clrTxt);
   x := (GetMaxX - TextWidth(msg)) div 2;
   y := GetMaxY div 2;
   OutTextXY(x, y, msg);
   x := x;
   while true do
   begin
      GetKey(key);
      if key = 13 then
      begin
	 
	 break;
      end;
      if key > 65 and key < 90 then
      begin
	 x := x + TextWidth(chr(key));
	 OutTextXY(x, y, chr(key));
	 pname := pname + chr(key);
      end;
   end;
   writeln('');
   wruteln(pname);
   {$I-}
   assign(f, fileName);
   reset(f);
   if IOResult <> 0 then
   begin
      writeln('file isn''t open');
      halt(1);
   end;
   first := nil;
   while not SeekEof(f) do
   begin
     while not SeekEoln(f) do
     begin
	new(tmp);
	read(f, tmp^.name);
	read(f, tmp^.score);
	tmp^.next := first;
	first := tmp;
     end;
      readln(f);
   end;
   close(f);
   new(tmp);
   tmp^.name := pname;
   tmp^.score := score;
   tmp^.next := first;
   first := tmp;
   sortScore(first);
   rewrite(f);
   if IOResult <> 0 then
   begin
      writeln('file isn''t open');
      halt(1);
   end;
   tmp := first;
   while tmp <> nil do
   begin
      writeln(f, tmp^.name);
      writeln(f, tmp^.score);
      tmp := tmp^.next;
   end;
   close(f);
   while first <> nil do
   begin
      tmp := first;
      first := first^.next;
      dispose(tmp);
   end;
end;
