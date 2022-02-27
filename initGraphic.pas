unit initGraphic;
interface
uses wingraph;

procedure graphics;

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
end.
