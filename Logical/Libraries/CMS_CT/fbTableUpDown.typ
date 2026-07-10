
TYPE
	fbTableUpDownInCmd_type : 	STRUCT 
		Up : BOOL;
		Down : BOOL;
		Error : BOOL;
		Pause : BOOL;
		Reset : BOOL;
		Stop : BOOL;
	END_STRUCT;
	fbTableUpDownOut_type : 	STRUCT 
		Hyd : fbTableUpDownOutHyd_type;
		ReadyToWork : BOOL;
		Stoped : BOOL;
		CommandDone : USINT;
		CommandBusy : USINT;
		ErrorID : fbTableUpDownErrorID_enm;
		Error : BOOL;
	END_STRUCT;
	fbTableUpDownInSensors_type : 	STRUCT 
		TableDownSlow : BOOL;
		TableUpSlow : BOOL;
		TableIsDown : BOOL;
		TableSquaresAreBack : BOOL;
		TableIsUp : BOOL;
		TableMotFault : BOOL;
	END_STRUCT;
	fbTableUpDownOutHyd_type : 	STRUCT 
		BypassValve : BOOL;
		DownValve : BOOL;
		DownSlow : BOOL;
		UpValve : BOOL;
		UpSlowValve : BOOL;
		HydStart : BOOL;
	END_STRUCT;
	fbTableUpDownIn_type : 	STRUCT 
		Sensors : fbTableUpDownInSensors_type;
		HomingDone : BOOL;
		ParkPos : BOOL;
		Cmd : fbTableUpDownInCmd_type;
	END_STRUCT;
	fbTableUpDownErrorID_enm : 
		(
		ERR_NONE := 0,
		SQUARES_ARE_NOT_DOWN := 10,
		SQUARES_ARE_NOT_UP := 20,
		MACHINE_IS_NOT_PARK_POS := 30,
		TABLE_IS_NOT_DOWN := 40,
		HOMING_IS_REQUIRED := 50,
		TABLE_MOTOR_FAULT := 60
		);
	fbTableUpDownLoc_type : 	STRUCT 
		FirstInStep : BOOL;
		OldStep : UINT;
		TOF_Hyd : TOF;
	END_STRUCT;
END_TYPE
