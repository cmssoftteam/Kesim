
(* Table Up Down Movement for OCKM And Breaker *)
FUNCTION_BLOCK fbTableUpDown

	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               Table Is Ready To Cut       	
	//|_________________________________________________________________________			
	Out.ReadyToWork := 
	In.Sensors.TableSquaresAreBack AND In.Sensors.TableIsDown AND 
	In.ParkPos AND NOT In.Sensors.TableIsUp AND 
	NOT In.Sensors.TableUpSlow AND In.ParkPos;	
	
	IF Enable = FALSE THEN
		brsmemset( ADR(Out.Hyd),0,SIZEOF(Out.Hyd) ); 
		Out.ReadyToWork := FALSE;
		Step			:= 0;
		RETURN;
	ELSE
		
		IF In.Sensors.TableMotFault THEN
			Step 		:= 999;
			Out.ErrorID := TABLE_MOTOR_FAULT;			
		END_IF;
		
		IF In.Cmd.Stop AND NOT Out.Error THEN		
			Step		:= 50;
		END_IF;	
		
		IF ( Step <> 10 ) AND ( Step <> 40 ) THEN
			Out.CommandBusy := TRUE;
		ELSE
			Out.CommandBusy := FALSE;			
		END_IF	
		
		CASE Step OF
			0: // INIT
				Out.Error 	:= FALSE;
				Out.ErrorID := ERR_NONE;
				Out.Stoped 	:= FALSE;
				brsmemset( ADR(Out.Hyd),0,SIZEOF(Out.Hyd) ); 
				Step 		:= 10;
			10: // Wait Cmd
				IF In.Cmd.Up OR In.Cmd.Down  THEN
					IF In.Sensors.TableSquaresAreBack THEN
						Step 		:= 999;
						Out.ErrorID := SQUARES_ARE_NOT_UP;
						RETURN;
					ELSIF In.HomingDone = FALSE THEN	
						Step 		:= 999;
						Out.ErrorID := HOMING_IS_REQUIRED;	
						RETURN;
					ELSIF In.ParkPos = FALSE THEN
						Step 		:= 999;
						Out.ErrorID := MACHINE_IS_NOT_PARK_POS;	
						RETURN;
					ELSE
						// Command Active
						IF In.Cmd.Up THEN
							Step		:= 20;
						ELSIF In.Cmd.Down THEN
							Step		:= 30;	
						END_IF;		
					END_IF;	

				END_IF;	
							
			20: // Command Up
				IF 	In.Cmd.Up = FALSE THEN
					Step 		:= 0;				
				ELSE
					IF 	In.Sensors.TableIsUp THEN
						Out.Hyd.UpSlowValve := FALSE;
						Out.Hyd.UpValve     := FALSE;
						Step 				:= 40; // Command Done					
					ELSIF In.Sensors.TableUpSlow THEN
						Out.Hyd.UpValve  	:= TRUE;				
						Out.Hyd.UpSlowValve := TRUE;
					ELSE
						Out.Hyd.UpValve  	:= TRUE;
						Out.Hyd.UpSlowValve := FALSE;
					END_IF;	
				END_IF;	
							
			30: // Command Down
				IF 	In.Cmd.Down = FALSE THEN
					Step 		:= 0;				
				ELSE
					IF 	In.Sensors.TableIsDown THEN
						Out.Hyd.DownSlow	:= FALSE;
						Out.Hyd.DownValve   := FALSE;
						Step 				:= 40; // Command Done					
					ELSIF In.Sensors.TableDownSlow THEN
						Out.Hyd.DownSlow	:= TRUE;				
						Out.Hyd.DownValve  := TRUE;
					ELSE
						Out.Hyd.DownSlow	:= TRUE;
						Out.Hyd.DownValve  := FALSE;
					END_IF;	
				END_IF;								
			
			40: // Command Done
				Out.CommandDone := TRUE;
				brsmemset( ADR(Out.Hyd),0,SIZEOF(Out.Hyd) ); 
				
				IF NOT In.Cmd.Down AND
					NOT In.Cmd.Up AND
					NOT In.Cmd.Pause AND
					NOT In.Cmd.Stop THEN
					Step := 0;
				END_IF;	
				
			50: // Stop Command	
				Out.Stoped 		:= TRUE;
				brsmemset( ADR(Out.Hyd),0,SIZEOF(Out.Hyd) ); 				
				Step 			:= 40; // Command Done				
				
			999: // Error
				Out.Error := TRUE;
				brsmemset( ADR(Out.Hyd),0,SIZEOF(Out.Hyd) ); 
				Out.ReadyToWork  := FALSE;
				IF In.Cmd.Reset THEN
					Step := 0;
				END_IF;	
							
		END_CASE;	
		
		// Hydraulic Motor Output
		Loc.TOF_Hyd.IN 		:= Out.Hyd.UpValve OR Out.Hyd.DownValve OR Out.Hyd.UpSlowValve OR Out.Hyd.UpSlowValve ;
		Loc.TOF_Hyd.PT 		:= T#3s;
		Out.Hyd.HydStart 	:= Loc.TOF_Hyd.Q;
		
		Loc.TOF_Hyd(); 
		
		
	END_IF;	
	
	Loc.FirstInStep := Loc.OldStep <> Step;
	Loc.OldStep 	:= Step;
	
END_FUNCTION_BLOCK
