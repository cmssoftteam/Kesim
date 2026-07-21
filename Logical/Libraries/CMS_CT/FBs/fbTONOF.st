
(* TON And TOF Timer *)
FUNCTION_BLOCK fbTONOF
	
	IF Input  XOR old THEN
		TON_Timer(IN:=FALSE , PT:= SEL(Input, TOF_Time, TON_Time ));
		mode	 := Input;
		old		 := Input;
	END_IF;

	TON_Timer( IN := TRUE);

	IF TON_Timer.Q THEN
		Q := mode;
	END_IF;	
	
	
END_FUNCTION_BLOCK
