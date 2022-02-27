program space_war;

uses menu, intGraphic, scrBoard;

var
   control : mng;

begin
   graphics;
   control.newGame := false;
   control.score := false;
   control.quit := false;
   while not control.quit do
      begin
	 mainMenu(control);
	 if control.newGame then
	    begin
	    end;
	 if control.score then
	    begin
	       scoreBoard;
	       control.score := false;
	    end;
      end;
end.
