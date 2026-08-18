
ACTION Reference: 
	
	
	IF gMain.Out.Error THEN
		gMain.Out.MainSubStep			:= SUB_ERROR;		
	END_IF	
	
	
	CASE gMain.Out.MainSubStep  OF
		
		SUB_INIT:
			
			IF Loc.FirstInHomeState THEN
				gIO.Out.CT.CuttingHeadDown 		:= FALSE;
				gIO.Out.CT.LowEMotorDown   		:= FALSE;
				gIO.Out.CT.FanStart		   		:= FALSE;
				gIO.Out.CT.XYGlassBreakControl  := FALSE;
				gIO.Out.CT.TransferBelt			:= FALSE;
				gIO.Out.CT.SquareForward		:= FALSE;
				Loc.Timers.TON_HomeState.IN		:= FALSE;
				gAxBasic[AX_X].Home				:= FALSE;
				gAxBasic[AX_Y].Home				:= FALSE;
				gAxBasic[AX_C].Home				:= FALSE;				
			ELSE
				
				Loc.Timers.TON_HomeState.IN := TRUE;
				Loc.Timers.TON_HomeState.PT := T#1s;
				IF Loc.Timers.TON_HomeState.Q THEN
					Loc.Timers.TON_HomeState.IN := FALSE;	
					Loc.HomeState			:= HOME_CHECK_IO;
				END_IF	
				
			END_IF;	
			
		SUB_CHECK_IO:
			
			IF NOT gIO.In.CT.HeadMaxDownSensor THEN	
				gMain.Out.Error 	:= TRUE;
				gMain.Out.ErrorID 	:= 999; // Diamond Is Not Back
				gMain.Out.MainSubStep   	:= SUB_ERROR;
				RETURN;	
			
			ELSIF gParameters.MachineType = OCKM THEN
				IF NOT gIO.In.CT.TableDownStopSwicth OR gIO.In.CT.TableUpSlowSwicth ELSE
					gMain.Out.Error 	:= TRUE;
					gMain.Out.ErrorID 	:= 999; // CT_Is_Not_Down
					gMain.Out.MainSubStep   	:= SUB_ERROR;
					RETURN;
				ELSIF NOT gIO.In.CT.TableSquareBack THEN	
					gMain.Out.Error 	:= TRUE;
					gMain.Out.ErrorID 	:= 999; // CT_Is_Squares_Are_Not_Back
					gMain.Out.MainSubStep   	:= SUB_ERROR;
					RETURN;	
				ELSE					
				;
				END_IF // OCKM	
			ELSIF gParameters.MachineType = FCL THEN
				IF NOT gIO.In.CT.GlassTransBeltIsDown ELSE
					gMain.Out.Error 	:= TRUE;
					gMain.Out.ErrorID 	:= 999; // CT_Belt Is Not Down
					gMain.Out.MainSubStep   	:= SUB_ERROR;
					RETURN;	
				END_IF // FCL	
			ELSE
					// Home Start
					gMain.Out.MainSubStep   	:= SUB_HOME_START;			
					
			END_IF;	
		
		SUB_HOME_START:
					
				IF Loc.FirstInSubState THEN
					gAxBasicPar[AX_X].Homing.Mode					:= mcHOMING_ABSOLUTE_SWITCH; 
					gAxBasicPar[AX_X].Homing.Options.SensorOffset   := gParameters.LengthParametes.X_HomeOffsetPos; //gFixData.Ax[AX_X].Config.MultiturnEncOffset; //Home yaptiktan sonra kaçinci pozisyona kadar gitsin
					gAxBasicPar[AX_X].Homing.Position 			  	:= 0; /gFixData.Ax[AX_X].Par.Homing.Position; //Home yapip Sensor offset kadar gidip bunuda üstüne ekliyor
					gAxBasicPar[AX_X].Homing.Options.SwitchEdge     := mcDIR_NEGATIVE; //Switch nerede aranacak
					gAxBasicPar[AX_X].Homing.Options.HomingDirection:= mcDIR_POSITIVE; //switch ten kurtulduktan sonra offset için hangi yöne gidecek
					gAxBasicPar[AX_X].Homing.Options.StartDirection := mcDIR_NEGATIVE;
					gAxBasicPar[AX_X].Homing.Options.StartVelocity  := 100;
					gAxBasicPar[AX_X].Homing.Options.HomingVelocity := 30;
					gAxBasicPar[AX_X].Homing.Options.Acceleration   := 150;	
					gAxBasicPar[AX_X].Stop.Deceleration			 	:= 2000;
					gAxBasicPar[AX_X].Deceleration					:= 2000;
					gAxBasic[AX_X].Home							:= TRUE;
					
					gAxBasicPar[AX_Y].Homing.Mode					:= mcHOMING_ABSOLUTE_SWITCH; 
					gAxBasicPar[AX_Y].Homing.Options.SensorOffset   := gParameters.LengthParametes.Y_HomeOffsetPos; //gFixData.Ax[AX_X].Config.MultiturnEncOffset; //Home yaptiktan sonra kaçinci pozisyona kadar gitsin
					gAxBasicPar[AX_Y].Homing.Position 			  	:= 0; /gFixData.Ax[AX_X].Par.Homing.Position; //Home yapip Sensor offset kadar gidip bunuda üstüne ekliyor
					gAxBasicPar[AX_Y].Homing.Options.SwitchEdge     := mcDIR_NEGATIVE; //Switch nerede aranacak
					gAxBasicPar[AX_Y].Homing.Options.HomingDirection:= mcDIR_POSITIVE; //switch ten kurtulduktan sonra offset için hangi yöne gidecek
					gAxBasicPar[AX_Y].Homing.Options.StartDirection := mcDIR_NEGATIVE;
					gAxBasicPar[AX_Y].Homing.Options.StartVelocity  := 100;
					gAxBasicPar[AX_Y].Homing.Options.HomingVelocity := 30;
					gAxBasicPar[AX_Y].Homing.Options.Acceleration   := 150;	
					gAxBasicPar[AX_Y].Stop.Deceleration			 	:= 2000;
					gAxBasicPar[AX_Y].Deceleration					:= 2000;
					gAxBasic[AX_Y].Home							:= TRUE;					

					gAxBasicPar[AX_C].Homing.Mode					:= mcHOMING_ABSOLUTE_SWITCH; 
					gAxBasicPar[AX_C].Homing.Options.SensorOffset   := gParameters.LengthParametes.C_HomeOffsetPos; //gFixData.Ax[AX_X].Config.MultiturnEncOffset; //Home yaptiktan sonra kaçinci pozisyona kadar gitsin
					gAxBasicPar[AX_C].Homing.Position 			  	:= 0; /gFixData.Ax[AX_X].Par.Homing.Position; //Home yapip Sensor offset kadar gidip bunuda üstüne ekliyor
					gAxBasicPar[AX_C].Homing.Options.SwitchEdge     := mcDIR_NEGATIVE; //Switch nerede aranacak
					gAxBasicPar[AX_C].Homing.Options.HomingDirection:= mcDIR_POSITIVE; //switch ten kurtulduktan sonra offset için hangi yöne gidecek
					gAxBasicPar[AX_C].Homing.Options.StartDirection := mcDIR_NEGATIVE;
					gAxBasicPar[AX_C].Homing.Options.StartVelocity  := 100;
					gAxBasicPar[AX_C].Homing.Options.HomingVelocity := 30;
					gAxBasicPar[AX_C].Homing.Options.Acceleration   := 150;	
					gAxBasicPar[AX_C].Stop.Deceleration			 	:= 2000;
					gAxBasicPar[AX_C].Deceleration					:= 2000;
					gAxBasic[AX_C].Home							:= TRUE;					
					
				ELSE
					IF gMain.Out.Status.Referenced  THEN
						gMain.Out.MainSubStep   	:= SUB_CMD_DONE;
					END_IF;	
				
				END_IF;						
		
		SUB_CMD_DONE:
			IF gMain.Out.Status.Referenced  THEN
				gMain.Out.MainSubStep			:= SUB_INIT;
		//		gMain.Out.MainStep		:= MAIN_WAIT_CMD;		
			END_IF;	

		SUB_STOP:
			IF Loc.FirstInSubState THEN
				gAxBasic[AX_X].Home			:= FALSE;
				gAxBasic[AX_Y].Home			:= FALSE;
				gAxBasic[AX_C].Home			:= FALSE;	
				Loc.Timers.TON_State.IN 	:= FALSE;	
			ELSE
				gMain.Out.MainSubStep			:= SUB_INIT;
				//gMain.Out.MainStep		:= MAIN_WAIT_CMD;						
			END_IF;	
					
		SUB_ERROR:
			IF Loc.FirstInSubState THEN
				gAxBasic[AX_X].Home			:= FALSE;
				gAxBasic[AX_Y].Home			:= FALSE;
				gAxBasic[AX_C].Home			:= FALSE;	
				Loc.Timers.TON_HomeState.IN := FALSE;	
			ELSE
				IF gMain.In.Cmd.Reset THEN
					gAxBasic[AX_X].ErrorReset	:= TRUE;
					gAxBasic[AX_Y].ErrorReset	:= TRUE;
					gAxBasic[AX_C].ErrorReset	:= TRUE;	
				ELSE
					gAxBasic[AX_X].ErrorReset	:= FALSE;
					gAxBasic[AX_Y].ErrorReset	:= FALSE;
					gAxBasic[AX_C].ErrorReset	:= FALSE;							
				END_IF			
						
				IF NOT gAxBasic[AX_X].Error AND NOT gAxBasic[AX_Y].Error NOT gAxBasic[AX_C].Error THEN
					gMain.Out.MainSubStep			:= SUB_INIT;
					//gMain.Out.MainStep		:= MAIN_WAIT_CMD;	
				END_IF;	
		
			END_IF;			
		
	END_CASE;
	
	Loc.Timers.TON_HomeState();

END_ACTION
