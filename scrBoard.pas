unit scrBoard;
interface

uses wingraph, loadBmp, winCrt;

   procedure showScore;
   procedure addPlayer;
   procedure scoreCounter(count	: integer);
   
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

procedure createScore; //completed
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

procedure sortScore;//not complited
var
   tmp, first : itemptr;
   f	      : text;
begin
   {$I-}
   assign(f, fileName);
   reset(f);
   if IOResult <> 0 then
   begin
      writeln('failed open this file');
      halt(1);
   end;
   first := nil;
   tmp := nil;
   while not SeekEof(f) do
   begin
      while not SeekEoln(f) do
      begin
	 new(tmp)
	 read(f, tmp^.name);
	 read(f, tmp^.score);
	 tmp^.next := first;
	 first := tmp;
      end;
      readln(f);
   end;
   close(f);
   
end;

procedure showScore;//complited
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
      createScore;
      reset(f);
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

