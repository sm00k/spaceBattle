unit engine;
interface

procedure graphics;
procedure getKey(var code : integer);
procedure loadPcs(nameFile : string; x, y : integer);
procedure screenCenter(var x, y : integer);
procedure screenCenterText(var x, y : integer; text : string);

implementation

procedure graphics;
var
   driver, mode	: integer;
   title	: shortstring;
begin
   DetectGraph(driver, mode);
   mode := mFullScr;
   initgraph(driver, mode, '');
end;

procedure getKey(var code : integer);
var
   c : char;
begin
   c := ReadKey;
   if c := #0 then
   begin
      c := ReadKey;
      code := -ord(c);
   end
   else
   begin
      code := ord(c);
   end;
end;

procedure loadPcs(nameFile : string; x, y : integer);
var 
   bitmap : pointer;
   size	  : longint;
   f	  : file;
begin
   {$I-}
   Assign(f, nameFile);
   Reset(f, 1);
   {$I+}
   if (IOResult <> 0) then
      Exit;
   size := FileSize(f);
   GetMem(bitmap, size);
   BlockRead(f, bitmap^, size);
   Close(f);
   PutImage(x, y, bitmap^, NormalPut);
   FreeMem(bitmap);
end;

procedure screenCenter(var x, y : integer);
begin
   x := GetMaxX div 2;
   y := GetMaxY div 2;
end;

procedure screenCenterText(var x, y : integer; text : string);
begin
   x := (GetMaxX div 2) - (TextWhidth(text) div 2);
   y := (GetMaxY div 2) - (TextHeight(text) div 2);
end;

procedure loadAnim(var anim : ?);
begin
end;

end.
