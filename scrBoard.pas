unit scrBoard;
interface

uses wingraph, loadBmp, winCrt;

   procedure showScore;
   procedure addPlayer(name : string);
   procedure scoreCounter(count: integer);
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

procedure addPlayer(name : string);//
var
   key : integer;
begin
   ClearDevace;
   loadPcs('spraite/backgroundMenu.bmp', 0, 0);
   
end;
