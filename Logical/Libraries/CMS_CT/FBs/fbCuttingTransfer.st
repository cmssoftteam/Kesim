
(* Transfer Glass To Cutting OR To Breaker *)
FUNCTION_BLOCK fbCuttingTransfer
	
		//==============================
	//		FB Enable Check
	//==============================
	IF inEnable THEN
		outActive := TRUE;
	ELSE
		outActive 		:= FALSE;
		outError		:= FALSE;
		outErrorID		:= NO_ERROR;
		outState		:= CT_INIT;
		brsmemset(ADR(outDO), 0, SIZEOF(outDO));
		brsmemset(ADR(Loc), 0, SIZEOF(Loc));
		brsmemset(ADR(inSensors), 0, SIZEOF(inSensors));
		RETURN;
	END_IF;
	//==============================
	
	//State Timer
	Loc.StepTimer();	
	
	// Error ID ler yazilacak
	outGlassTransferActive := (Loc.GlassTransferActive OR Loc.GlassGettingActive);
	
	
	CASE outState OF
		CT_INIT:
			outError				:= FALSE;
			outErrorID				:= NO_ERROR;			
			brsmemset(ADR(outDO), 0, SIZEOF(outDO));
			brsmemset(ADR(Loc), 0, SIZEOF(Loc));
			inGlassTransfer 		:= FALSE;
			outGlassTransferDone 	:= FALSE;
			outGlassTransferActive	:= FALSE;
			outCommandDone			:= FALSE;
			Loc.StepTimer.IN 		:= FALSE;
			outState				:= CT_WAIT_CMD;
			
		CT_WAIT_CMD:
			
			IF      inGlassTransfer AND inCTReadyToTransfer
				AND inLoaderReadyToTransfer AND NOT inSensors.BeltStop_SW
				AND NOT Loc.GlassGettingActive AND NOT Loc.GlassTransferActive THEN
				outState				:= CT_BELT_UP;
				Loc.GlassGettingActive 	:= TRUE;
			END_IF

			IF      inGlassTransfer AND inCTReadyToTransfer
				AND  inSensors.BeltStop_SW AND inSensors.BT_DownSW
				AND NOT Loc.GlassGettingActive AND NOT Loc.GlassTransferActive  THEN
				outState			 	:= CT_BELT_UP;
				Loc.GlassTransferActive := TRUE;
				outDO.BT_FanStart  		:= TRUE;
			END_IF;			
			
		
		CT_BELT_UP: 	(***********WAIT BELT UP FOR CT TRANSFER MOTOR START******************)
			IF Loc.FirstInStep THEN
				outDO.CT_TransportBeltUp 	:= TRUE;
				outDO.CT_YCARRIERDOWNVALVE 	:= FALSE;
				Loc.StepTimer.PT 			:= T#5000ms;
				Loc.StepTimer.IN			:= TRUE;	
			ELSE
				IF 	inSensors.YCarrBack_SW AND inSensors.BeltUp_SW THEN
					Loc.StepTimer.IN := FALSE;
					outDO.CT_GLASSTRANSPORTMOTORSTART := TRUE;
					outState 						  := CT_GET_OR_TRANSFER_GLASS;
				END_IF;	
			END_IF;	
			
			IF inSimulation THEN
				IF Loc.StepTimer.Q THEN
					Loc.StepTimer(IN:= FALSE);				
				ELSIF Loc.StepTimer.ET >= T#2000ms THEN
					// Belt Is Up
					inSensors.BeltUp_SW		:= TRUE;
					inSensors.BeltDown_SW 	:= FALSE;					
				ELSIF Loc.StepTimer.ET >= T#200ms THEN	
					// Belt Still Down
					inSensors.BeltUp_SW		:= FALSE;
					inSensors.BeltDown_SW 	:= TRUE;
				END_IF;	
			END_IF	
		
		CT_GET_OR_TRANSFER_GLASS:
			
			IF Loc.GlassGettingActive  THEN
				outDO.L_GLASSTRANSPORTSTART := TRUE; 
				outState := CT_WAIT_FINISH_TRANS;
			ELSIF Loc.GlassTransferActive THEN
				outDO.L_GLASSTRANSPORTSTART := FALSE; 
				outState := CT_WAIT_FINISH_TRANS;				
			END_IF;	
		
		CT_WAIT_FINISH_TRANS:
			IF Loc.GlassGettingActive AND inSensors.BeltStop_SW THEN
				outDO.L_GLASSTRANSPORTSTART 		:= FALSE; 				
				outDO.CT_GLASSTRANSPORTMOTORSTART 	:= FALSE;
				
				Loc.StepTimer.IN 			:= TRUE;
				Loc.StepTimer.PT 			:= T#5s;
				// Wait Belt Stop Down Ramp
				IF Loc.StepTimer.Q THEN
					Loc.StepTimer.IN 		:= FALSE;
					outState 				:= CT_BELT_DOWN;
				END_IF	
			ELSIF Loc.GlassGettingActive AND NOT inSensors.BeltStop_SW AND NOT inSensors.BeltGlassExit_SW AND NOT inLoaderReadyToTransfer THEN	
				outDO.L_GLASSTRANSPORTSTART 		:= FALSE; 				
				outDO.CT_GLASSTRANSPORTMOTORSTART 	:= FALSE;
				outState 							:= CT_BELT_DOWN;
			ELSIF Loc.GlassTransferActive AND NOT inSensors.BeltStop_SW AND NOT inSensors.BeltGlassExit_SW AND inLoaderReadyToTransfer  THEN
				Loc.GlassTransferActive 			:= FALSE;
				Loc.GlassGettingActive  			:= TRUE;
				outState 							:= CT_BELT_UP;
			ELSIF Loc.GlassTransferActive AND NOT inSensors.BeltStop_SW AND NOT inSensors.BeltGlassExit_SW AND NOT inLoaderReadyToTransfer  THEN
				Loc.GlassTransferActive 			:= FALSE;
				Loc.GlassGettingActive  			:= TRUE;
				outState 							:= CT_BELT_DOWN;				
			END_IF;	
			
			IF Loc.GlassGettingActive AND NOT Loc.LoaderGlassExitDelay.Q THEN
				outDO.L_GLASSTRANSPORTSTART 		:= FALSE; 
			END_IF;	
			
		CT_BELT_DOWN:
			
			IF Loc.FirstInStep THEN
				Loc.StepTimer.IN 			:= TRUE;
				Loc.StepTimer.PT 			:= T#5s;
				outDO.CT_TransportBeltUp 	:= FALSE;
			ELSE	
				IF Loc.TON_BeltDown.Q THEN
					outState := CT_WAIT_CMD_DONE;	
					
				ELSIF Loc.StepTimer.Q AND NOT inSimulation THEN
					outState 			:= CT_TRANS_ERROR;
					outErrorID			:= CT_BELT_IS_NOT_DOWN;
					
				END_IF;	
			END_IF
			
			IF inSimulation THEN
				IF Loc.StepTimer.Q THEN
					Loc.StepTimer(IN:= FALSE);				
				ELSIF Loc.StepTimer.ET >= T#2000ms THEN
					// Belt Is Up
					inSensors.BeltUp_SW		:= FALSE;
					inSensors.BeltDown_SW 	:= TRUE;					
				ELSIF Loc.StepTimer.ET >= T#200ms THEN	
					// Belt Still Down
					inSensors.BeltUp_SW		:= TRUE;
					inSensors.BeltDown_SW 	:= FALSE;
				END_IF;	
			END_IF	
			
		
		CT_WAIT_CMD_DONE:	
			IF Loc.FirstInStep THEN
				outCommandDone := TRUE;
				Loc.StepTimer.IN := FALSE;	
			ELSE
				IF NOT inGlassTransfer THEN
					// Waiting fb Input cmd's are OFF
					outState := CT_INIT;
				END_IF;	
			END_IF;			

		CT_TRANS_ERROR:
			IF Loc.FirstInStep THEN
				brsmemset(ADR(outDO), 0, SIZEOF(outDO));
				outError 	:= TRUE;
				Loc.StepTimer(IN:= FALSE);	
			ELSE
				IF inReset THEN
					outErrorID := CT_BELT_IS_NOT_DOWN;
					outState := CT_INIT;
				END_IF;	
			END_IF;			
		
	END_CASE;
	
	// Errors
	IF inSensors.CT_BeltMotFault THEN
		outErrorID := CT_TRANS_BELT_MOT_FAULT;
		outState   := CT_TRANS_ERROR;
	END_IF;	
	
	// Timers
	// Glass Exit TOF Delay
	Loc.LoaderGlassExitDelay.IN := inSensors.BeltGlassExit_SW;
	Loc.LoaderGlassExitDelay.PT := T#1.5s;
	Loc.LoaderGlassExitDelay();
	
	// Belt Down TON Delay
	Loc.TON_BeltDown.IN := NOT outDO.CT_TransportBeltUp AND inSensors.BeltDown_SW;
	Loc.TON_BeltDown.PT := T#1s;		
	Loc.TON_BeltDown();		
	
	// First In Step Control
	IF (outState <> Loc.OldState) THEN
		Loc.FirstInStep := TRUE;
	ELSE
		Loc.FirstInStep := FALSE;		
	END_IF;	
	Loc.OldState 	:= outState;
	
	
END_FUNCTION_BLOCK
