
TYPE
	gMainOut_typ : 	STRUCT 
		Status : gMainOutStatus_typ;
		MainStep : UINT; (*Main step of main program*)
		Error : BOOL; (*Flag that machine has an active error*)
		ErrorCL0 : BOOL; (*Flag that critical error class 0 is active*)
		ErrorID : UDINT; (*Error ID of main logic*)
	END_STRUCT;
	gMain_typ : 	STRUCT 
		In : gMainIn_typ;
		Out : gMainOut_typ;
	END_STRUCT;
	gMainOutStatus_typ : 	STRUCT  (*Main starus structure*)
		Active : BOOL;
		PoweredOn : BOOL; (*Flag to determine that machine axes are powered on*)
		Referenced : BOOL; (*Flag to determine that the machine is referenced*)
		ReadyToPowerOn : BOOL;
		MachineParked : BOOL; (*Flag that whole machine is in parking position*)
		StandStill : BOOL; (*Flag to determine that axes are standstill*)
		MoveActive : BOOL; (*Flag to signalize that some of axes is moving*)
		IO_Parked : BOOL; (*Flag that Inputs and Outputs of machine are in parking position*)
		Ax_Parked : BOOL; (*Flag to determine that Axes are in park (except X5 and X4)*)
		Ax_ParkedArray : ARRAY[0..MAX_AX_NR_MIN1]OF BOOL; (*Aray of flags showing whether is respective axis in parking pos. or not*)
		AxisDisabled : ARRAY[0..MAX_AX_NR_MIN1]OF BOOL; (*Flag that axis is disabled*)
		CurrentAutStep : UINT; (*Indication of actually executed automat Single step.*)
		AutoMode : BOOL; (*Flag that auto mode is active (standstill, running, stoped)*)
	END_STRUCT;
	gMainIn_typ : 	STRUCT 
		Enable : BOOL; (*Command to enable main control*)
		Cmd : gMainInCommands_typ; (*Main command structure*)
		Settings : gMainInSettings_typ; (*Main block settings*)
	END_STRUCT;
	gMainInCommands_typ : 	STRUCT  (*Main command structure*)
		Home : BOOL; (*Comand for starting the homing procedure*)
		Park : BOOL; (*Command for reaching the parking position*)
		Start : BOOL; (*Start command*)
		Stop : BOOL; (*Stop / pause commnad*)
		Load : BOOL; (*Command from pedal to start loading*)
		Reset : BOOL; (*Reset commnad*)
		SetMultiturnEncoder : BOOL; (*Set multiturn offset*)
		MultiturnEncHomeLimSwitch : BOOL; (*Home to limit switch*)
		MultiturnEncHomeOffsetValue : BOOL; (*Home to offset value*)
		Manual : ManualCommands_typ; (*Comands for manual movement*)
	END_STRUCT;
	ManualCommands_typ : 	STRUCT  (*Comands for manual movement*)
		InvJogPos : BOOL; (*Cmd to jog with asynchronous motor*)
		InvJogNeg : BOOL; (*Cmd to jog with asynchronous motor*)
		JogPos : ARRAY[0..MAX_AX_NR_MIN1]OF BOOL; (*Jog Negative commands*)
		JogNeg : ARRAY[0..MAX_AX_NR_MIN1]OF BOOL; (*Jog Positive commands*)
		GoToPos_Stop : BOOL; (*Cmd to go to selected position with axis or stop during movement*)
		SetPos : REAL; (*Position where to move selected axis*)
		ActiveAx : ARRAY[0..MAX_AX_NR_MIN1]OF BOOL; (*Indication which axis is selected in visu - identical indexes with main program*)
	END_STRUCT;
	gMainInSettings_typ : 	STRUCT  (*Main block settings*)
		SelectedMode : USINT; (*Represents the selected operation mode, 0 Manual; 1 - automatic single step mode; 2 continous Automat*)
		AxisSelected : ARRAY[0..MAX_AX_NR_MIN1]OF BOOL; (*Enable or disable axis (0 - Axis disabled, 1 - Axis enabled)*)
		ParkPos : ARRAY[0..MAX_AX_NR_MIN1]OF REAL; (*Parking positions for axes*)
		ParPosZaxis : REAL; (*Parking position of Z axis [units]*)
		MultiEncSettings : gMainInSettingsMultiEnc_typ; (*Structure with parameters for settings multiturn encoders*)
	END_STRUCT;
	gMainInSettingsMultiEnc_typ : 	STRUCT 
		reserved : USINT;
	END_STRUCT;
END_TYPE
