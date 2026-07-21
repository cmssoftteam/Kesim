
(* TODO: Toggle *)
FUNCTION_BLOCK fbToggle

IF Enable THEN	
	
	IF Rst THEN
		Rst := 0;
		Q 	:= 0;
	ELSIF CLK AND NOT _edge THEN
		Q := NOT Q;
	END_IF;
ELSE
	Q 	:= 0;		
END_IF		
 _edge := CLK;
END_FUNCTION_BLOCK
