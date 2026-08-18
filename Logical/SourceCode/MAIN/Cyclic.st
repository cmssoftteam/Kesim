
PROGRAM _CYCLIC
	IF gCncAdress > 0 THEN
		pCNC ACCESS gCncAdress;
	ELSE
		RETURN;
	END_IF;	

	fbCuttingTransfer_0();
	 
	fbTableUpDown_0();
	
	AxesStatus;

	
	CASE gMain.Out.MainStep OF
		
		MAIN_INIT:
			
			IF Loc.FirstInMainState THEN
				gMain.Out.MainSubStep := SUB_INIT;
			ELSE
				;
			END_IF;
			
		MAIN_WAIT_CMD:
		MAIN_MANUAL_MOVE:
		MAIN_START:
		MAIN_STOP:
		MAIN_PAUSE:
		MAIN_PARK:
		MAIN_HOME:
		MAIN_RESET:
		MAIN_NEW_LAYOUT:
		MAIN_AUTO_STANDSTILL:
		MAIN_AUTO_RUNNING:
		MAIN_AUTO_STOPPED:
		MAIN_MULTI_ENCODER_OFFSET:
		MAIN_HOME_LIMIT_SWITCH:
		MAIN_GO_SET_ORIJIN:
		MAIN_AUTO_DETECT_ORIGIN:
		MAIN_TRANSFER_TO_BT:
		MAIN_TRANSFER_FROM_LD:
		MAIN_GET_ENC_OFFSET_AXIS_B:
		MAIN_ERROR:

	END_CASE;
	
	Loc.FirstInMainState := gMain.Out.MainStep <> Loc.OldMainState;
	Loc.OldMainState	 := gMain.Out.MainStep;
	
	Loc.FirstInSubState	:= gMain.Out.MainSubStep <> Loc.OldSubState;
	Loc.OldSubState 	:= gMain.Out.MainSubStep;
	
	
END_PROGRAM
