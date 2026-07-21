
(* State History LOgger *)
FUNCTION_BLOCK fbStateHistory
	
	IF inReset THEN
		
		FOR i:=0 TO N DO
			outStateHistory[i]:= 0;
			inReset	:= FALSE;
		END_FOR

	ELSIF inActState <> OldActState THEN

		FOR i:= N TO 1 BY -1 DO
			outStateHistory[i] := outStateHistory[i-1];
		END_FOR
		outStateHistory[0] := inActState;
		

		IF inAlarm THEN // bc25.07.14
			//			outErrorHistory := outStateHistory;
				
			FOR i:= N TO 1 BY -1 DO
				outErrorHistory[2,i] := outErrorHistory[1,i];
				outErrorHistory[1,i] := outErrorHistory[0,i];
				outErrorHistory[0,i] := outStateHistory[i];
			END_FOR	

		END_IF		
		
	END_IF
	OldActState := inActState;	
	
END_FUNCTION_BLOCK
