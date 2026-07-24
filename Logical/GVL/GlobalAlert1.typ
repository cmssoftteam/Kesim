(**)

TYPE
	gAlertType : 	STRUCT 
		Abort : gAlertCommonType;
		Stop : gAlertCommonType;
		Pause : gAlertCommonType;
		Info : gAlertCommonType;
	END_STRUCT;
	gAlertCommonType : 	STRUCT 
		Status : BOOL;
		IDX : ARRAY[0..MAX_SINGLE_ALARM_MIN1]OF BOOL;
	END_STRUCT;
END_TYPE

(**)
