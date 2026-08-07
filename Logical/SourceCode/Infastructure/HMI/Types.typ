
TYPE
	LocType : 	STRUCT 
		SelectedStatus : LocSelectedStatus;
		FB : LocFBType;
		PowerStatus : BOOL;
		oldEdgeCaptureStep : Step_EC;
		EdgeCaptureStep : Step_EC;
		FirstInStepEC : BOOL;
		oldActiveUnit : INT;
		OldSpacerType : INT;
		OldMaterialNumber : INT;
		ReferenceStatus : BOOL;
	END_STRUCT;
	LocFBType : 	STRUCT 
		Timer : LocFBTimerType;
	END_STRUCT;
	LocFBTimerPulseType : 	STRUCT 
		ms50 : TON;
		ms100 : TON;
		ms200 : TON;
		ms300 : TON;
		ms500 : TON;
		ms1000 : TON;
	END_STRUCT;
	LocFBTimerType : 	STRUCT 
		Pulse : LocFBTimerPulseType;
		TP_MachineReset : TP;
		TON_SubStepTOut : TON;
		TON_State : TON;
		ProcessTime : TIME;
		TON_ProcessTrace : TON;
		TON_VacuumTimeout : TON; (*//bc25.07.07*)
		TON_VacuumWait : TON;
		TON_ProcessTrackingTime : TON;
		TON_Y_ReturnAfterTakingGlass : TON;
		TON_Y_DelaySecond : TON;
		TON_WaitingTimeBeforeMiter : TON;
	END_STRUCT;
	Step_EC : 
		(
		EC_WAIT_CMD,
		EC_START,
		EC_OFSET,
		EC_FINISH
		);
	LocSelectedStatus : 	STRUCT 
		ExitThicness : BOOL;
		EntryThicness : BOOL;
		Bridges : BOOL;
		Entrys : BOOL;
		ConvWithVacuum : BOOL;
		VacuumWithConv : BOOL;
		Exits : BOOL;
	END_STRUCT;
END_TYPE
