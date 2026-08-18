
ACTION AxesStatus: 


	//------------------
	// Checks all Axes are enabled or not 
	EnabledFlag := TRUE;
	FOR i := 0 TO MAX_AX_NR_MIN1 DO 
		IF NOT  gAxBasic[i].Active AND gParameters.DriverParameters[i].Enabled  THEN 
			EnabledFlag := FALSE; 
			EXIT;
		END_IF; 
	END_FOR; 
	//------------------
	
	//------------------
	// Checks all Axes are powered or not 
	PowerFlag := TRUE;
	FOR i := 0 TO MAX_AX_NR_MIN1 DO 

		IF NOT  gAxBasic[i].PowerOn AND gParameters.DriverParameters[i].Enabled THEN 
			PowerFlag := FALSE; 
			EXIT;
		END_IF;

	END_FOR; 
	//------------------
	
	//------------------
	// Checks all Axes are referenced or not 
	ReferencedFlag := TRUE;
	FOR i := 0 TO MAX_AX_NR_MIN1 DO 

		IF NOT  gAxBasic[i].IsHomed AND gParameters.DriverParameters[i].Enabled  THEN 
			ReferencedFlag := FALSE; 
			EXIT;
		END_IF; 

	END_FOR; 
	
	//--------------
	// Drive Ready Flag 
	DrivesReadyFlag   := TRUE;
	FOR i := 0 TO MAX_AX_NR_MIN1 DO 
		IF NOT  gAxBasic[i].Info.ReadyToPowerOn  AND gParameters.DriverParameters[i].Enabled THEN 
			DrivesReadyFlag := FALSE; 
			EXIT;
		END_IF; 
	END_FOR; 

	
	// ----------------------------------------																
	//Standstill
	// ----------------------------------------
	StandStillFlag := TRUE;
	FOR i := 0 TO MAX_AX_NR_MIN1 BY 1 DO
		IF  NOT (gAxBasic[i].Info.AxisAdditionalInfo.PLCopenState = mcAXIS_STANDSTILL) AND  gParameters.DriverParameters[i].Enabled THEN
			StandStillFlag := FALSE;
			EXIT;
		END_IF
	END_FOR 
	
	// ----------------------------------------																
	//MoveActive
	// ----------------------------------------
	MoveActiveFlag := TRUE;
	FOR i := 0 TO MAX_AX_NR_MIN1 BY 1 DO
		IF  (gAxBasic[i].MoveActive) AND  gParameters.DriverParameters[i].Enabled THEN
			MoveActiveFlag := FALSE;
			EXIT;
		END_IF
	END_FOR 
	
	gMain.Out.Status.Active				:= EnabledFlag;
	
	gMain.Out.Status.PoweredOn 			:= PowerFlag;
	
	gMain.Out.Status.Referenced 		:= ReferencedFlag;
	
	gMain.Out.Status.ReadyToPowerOn 	:= DrivesReadyFlag;
	
	gMain.Out.Status.StandStill 		:= StandStillFlag;
	
	gMain.Out.Status.MoveActive 		:= MoveActiveFlag;
	
	
END_ACTION
