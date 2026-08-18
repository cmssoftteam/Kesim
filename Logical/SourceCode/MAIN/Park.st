
ACTION Park: 
 
	CASE gMain.Out.MainSubStep OF
		
		SUB_INIT:
			
			IF Loc.FirstInSubState THEN			
				gAxBasic[AX_X].MoveAbsolute		:= FALSE;
				gAxBasic[AX_Y].MoveAbsolute		:= FALSE;
				gAxBasic[AX_C].MoveAbsolute		:= FALSE;
				gIO.Out.CT.CuttingHeadDown 		:= FALSE;
				gIO.Out.CT.LowEMotorDown   		:= FALSE;
				gIO.Out.CT.FanStart		   		:= FALSE;
				gIO.Out.CT.XYGlassBreakControl  := FALSE;
				gIO.Out.CT.TransferBelt			:= FALSE;
				gIO.Out.CT.SquareForward		:= FALSE;
			ELSE
				Loc.Timers.TON_ParkState.IN := TRUE;
				Loc.Timers.TON_ParkState.PT := T#1s;
				IF Loc.Timers.TON_ParkState.Q THEN
					Loc.Timers.TON_ParkState.IN := FALSE;	
					gMain.Out.MainSubStep			:= PARK_CHECK_IO;
				END_IF					
			END_IF;		
			
		PARK_CHECK_IO:
			IF NOT gIO.In.CT.HeadMaxDownSensor THEN	
				gMain.Out.Error 	:= TRUE;
				gMain.Out.ErrorID 	:= 999; // Diamond Is Not Back
				gMain.Out.MainSubStep   	:= SUB_ERROR;
				RETURN;	
			
			ELSIF gParameters.MachineType = OCKM THEN
				IF NOT gIO.In.CT.TableDownStopSwicth OR gIO.In.CT.TableUpSlowSwicth ELSE
					gMain.Out.Error 	:= TRUE;
					gMain.Out.ErrorID 	:= 999; // CT_Is_Not_Down
					gMain.Out.MainSubStep   	:= PARK_ERROR;
					RETURN;
					ELSIF NOT gIO.In.CT.TableSquareBack THEN	
					gMain.Out.Error 	:= TRUE;
					gMain.Out.ErrorID 	:= 999; // CT_Is_Squares_Are_Not_Back
					gMain.Out.MainSubStep   	:= PARK_ERROR;
					RETURN;	
				ELSE				
					gMain.Out.MainSubStep   	:= SUB_PARK_START;
				END_IF // OCKM	
			ELSIF gParameters.MachineType = FCL THEN
				IF NOT gIO.In.CT.GlassTransBeltIsDown ELSE
					gMain.Out.Error 	:= TRUE;
					gMain.Out.ErrorID 	:= 999; // CT_Belt Is Not Down
					gMain.Out.MainSubStep   	:= SUB_ERROR;
					RETURN;	
				END_IF // FCL	
			ELSE
				gMain.Out.MainSubStep := SUB_PARK_START;		
			END_IF;	
			
			
			SUB_PARK_START:	
				IF Loc.FirstInSubState THEN			

					// X Axis Go Park	
					gAxBasicPar[AX_X].Acceleration	:= 200.0;
					gAxBasicPar[AX_X].Deceleration 	:= 200.0;
					gAxBasicPar[AX_X].Velocity		:= (gParameters.LengthParametes.ParkSpeed / 100) * C_MAX_CUT_SPEED * (1000/60);				
					gAxBasicPar[AX_X].Position 		:= gMain.In.Settings.ParkPos[AX_X];
					gAxBasic[AX_X].MoveAbsolute		:= TRUE;	
					
					// Y Axis Go Park	
					gAxBasicPar[AX_Y].Acceleration	:= 200.0;
					gAxBasicPar[AX_Y].Deceleration 	:= 200.0;
					gAxBasicPar[AX_Y].Velocity		:= (gParameters.LengthParametes.ParkSpeed / 100) * C_MAX_CUT_SPEED * (1000/60);				
					gAxBasicPar[AX_Y].Position 		:= gMain.In.Settings.ParkPos[AX_Y];
					gAxBasic[AX_Y].MoveAbsolute		:= TRUE;
					
					// C Axis Go Park	
					gAxBasicPar[AX_C].Acceleration	:= 200.0;
					gAxBasicPar[AX_C].Deceleration 	:= 200.0;
					gAxBasicPar[AX_C].Velocity		:= 200.0;				
					gAxBasicPar[AX_C].Position 		:= gMain.In.Settings.ParkPos[AX_C];
					gAxBasic[AX_C].MoveAbsolute		:= TRUE;	
					
					
				ELSE
					IF gAxBasic[AX_X].MoveDone AND gAxBasic[AX_Y].MoveDone AND gAxBasic[AX_C].MoveDone THEN
						gMain.Out.MainSubStep			:= PARK_DONE;	
					END_IF;	
				END_IF;	
					
					
			SUB_CMD_DONE:
				IF gMain.Out.Status.Ax_Parked  THEN
					Loc.HomeState			:= SUB_INIT;
					//		gMain.Out.MainStep		:= MAIN_WAIT_CMD;		
				END_IF;	
					
			SUB_STOP:

			SUB_ERROR:
			IF Loc.FirstInSubState THEN
				gAxBasic[AX_X].MoveAbsolute		:= FALSE;
				gAxBasic[AX_Y].MoveAbsolute		:= FALSE;
				gAxBasic[AX_C].MoveAbsolute		:= FALSE;	
				Loc.Timers.TON_ParkState.IN		:= FALSE;
			ELSE
				IF gMain.In.Cmd.Reset THEN
					gAxBasic[AX_X].ErrorReset		:= TRUE;
					gAxBasic[AX_Y].ErrorReset		:= TRUE;
					gAxBasic[AX_C].ErrorReset		:= TRUE;	
				ELSE
					gAxBasic[AX_X].ErrorReset		:= FALSE;
					gAxBasic[AX_Y].ErrorReset		:= FALSE;
					gAxBasic[AX_C].ErrorReset		:= FALSE;							
				END_IF;		
				
				IF NOT gAxBasic[ AX_X].Error AND NOT gAxBasic[ AX_Y].Error NOT gAxBasic[ AX_C].Error THEN
					gMain.Out.MainSubStep			:= SUB_INIT;
					//gMain.Out.MainStep		:= MAIN_WAIT_CMD;	
				END_IF;	
					
			END_IF;	
			
			
		END_CASE;

		Loc.Timers.TON_ParkState();		


		END_ACTION
