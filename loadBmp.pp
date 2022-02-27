unit loadBmp;
interface

uses wingraph;

procedure loadPcs(nameFile : string; x, y : integer);

implementation

   procedure loadPcs(nameFile : string; x, y : integer);
   var 
      bitmap : pointer;
      size   : longint;
      f	     : file;
   begin
      {$I-} Assign(f, nameFile); Reset(f, 1); {$I+}
      if (IOResult <> 0) then Exit;
      size := FileSize(f);
      GetMem(bitmap, size);
      BlockRead(f, bitmap^, size);
      Close(f);
      PutImage(x, y, bitmap^, NormalPut);
      FreeMem(bitmap);
   end;
end.
      
