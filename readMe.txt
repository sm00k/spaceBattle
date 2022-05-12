List of features and changes in the unit engine:
procedure graphics; creates a maximum resolution window without a border.
procedure getKey(var code : integer); has one parameter which returns the 
	  character code.
procedure loadPcs(nameFile : string; x, y : integer); has three parameters 
	  file name (or file path) and coordinates of placement on the screen. 
procedure screenCenter(var x, y : integer); has two parameters, returns the 
	  coordinates of the center of the screen.
prcodedure screenCenterText(var x, y : integer; text : string); has three 
	   parameters, returns the coordinates of the center of the screen 
	   for the give line of text.
