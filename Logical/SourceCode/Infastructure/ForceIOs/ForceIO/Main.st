(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * PROGRAM: ForceIO
 * File: ForceIO.st
 * Author: abdullahoglf
 * Created: December 18, 2013
 ********************************************************************
 * Implementation OF PROGRAM ForceIO
 ********************************************************************)

PROGRAM _INIT

	forceStep   := FORCE_WAIT;
	
	// run GetSignalStr once so that GetDPStatus has a valid datapoint to start with
	GetSignalStr_1.uNumStation    := slotIndex + 1;    // configured for GetSignalStr
	GetSignalStr_1.uNumSignal     := j + 1;		    // configured for GetSignalStr
	GetSignalStr_0.uNumStation    := slotIndex + 1;    // configured for GetSignalStr
	GetSignalStr_0.uNumSignal     := j + 1;		    // configured for GetSignalStr
	
	GetSignalStr_0();
	GetSignalStr_1();
	
END_PROGRAM


PROGRAM _CYCLIC	
	//-----------------------------------------------------------------
	// This program can be used for I/O forcing
	// The variable slotIndex should mapped to I/O module selection
	// in the HMI. That is, slotIndex = 0 is your first module in 
	// the HW configuration. Furthermore you should map ForceValue 
	// and ForceStatus variables to corresponding module layers
	// respectively. As an example, your HMI should look like as
	// Module's I/O mapping page in monitor mode; that is, a selection
	// box to represent ForceStatus and then a ForceValue input...
	//
	// The FB BuildSignalStr; builds the specific channel address
	// string according to the selection made from the HMI
    //
	// MAX_DP_INDEX should be configured. It is the number of channels
	// on the selected IO card (e.g. There are 12 channels on X20 DO9322
	// thus the value for MAX_DP_INDEX should be 11)
	//
	// The program will automatically do everything according to the 
	// selection made from the HMI.
	//
	//-----------------------------------------------------------------
	// abdullahoglf, 20.12.2013
	//-----------------------------------------------------------------	
	
	//-----------------------------------
	// Get cmd from the HMI
	HMImap;
	
	// DI card
	IF (slotIndex + ioCfgStart) >= diStartIndex AND (slotIndex + ioCfgStart <= diStartIndex + diCount - 1) THEN
		GetSignalStr_0.eTypeSignal  := DI_IO;
		GetSignalStr_1.eTypeSignal  := DI_IO;
		MAX_DP_INDEX := 15;	
		
		// DO card	
	ELSIF (slotIndex + ioCfgStart) >= doStartIndex AND (slotIndex + ioCfgStart <= doStartIndex + doCount - 1) THEN
		GetSignalStr_0.eTypeSignal  := DO_IO;
		GetSignalStr_1.eTypeSignal  := DO_IO;
		MAX_DP_INDEX := 15;
	
		// AI card	
	ELSIF (slotIndex + ioCfgStart) >= aiStartIndex AND (slotIndex + ioCfgStart <= aiStartIndex + aiCount - 1) THEN
		GetSignalStr_0.eTypeSignal  := AI_IO;
		GetSignalStr_1.eTypeSignal  := AI_IO;
		// AI2632 has two input channels
		IF slotIndex + ioCfgStart = aoStartIndex - 1 THEN
			MAX_DP_INDEX := 3;			
		ELSE
			MAX_DP_INDEX := 3;
		END_IF;
		
		// AO card	
	ELSIF (slotIndex + ioCfgStart) >= aoStartIndex AND (slotIndex + ioCfgStart <= aoStartIndex + aoCount - 1) THEN	
		GetSignalStr_0.eTypeSignal  := AO_IO;
		GetSignalStr_1.eTypeSignal  := AO_IO;
		MAX_DP_INDEX := 3;
		
		
	END_IF;
	
	GetSignalStr_0();
	GetSignalStr_1();
	(* ------------------------------------------------------------------ *)
	(*  ----------------------     MAIN CONTROL     --------------------- *)
	(*  ----------------------------------------------------------------- *)    
	HMIforceStep:= forceStep;
	CASE forceStep OF
		FORCE_WAIT:				
			IF NOT loopBypass THEN
				// Check if the force should be activated
				FOR i := 0 TO 15 DO
					// Give the command for forcing if the request is done from the Visu
					IF ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[i] = 1 AND ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatusOld[i] = 0 THEN
						ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatusOld[i] := ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[i];
						ForceHandle.Cmd.Force                                             := TRUE;
						loopBypass                                                        := TRUE;
						EXIT;
					END_IF;
	
				END_FOR;	
			END_IF;

			IF NOT loopBypass THEN
				// Check if the force should be deactivated
				FOR i := 0 TO 15 DO
					// Give the command for forcing if the request is done from the Visu
					IF ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[i] = 0 AND ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatusOld[i] = 1 THEN
						ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatusOld[i] := ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[i];
						ForceHandle.Cmd.DisableForce                                      := TRUE;
						loopBypass                                                        := TRUE;
						EXIT;
					END_IF;
	
				END_FOR;
			END_IF;

			IF NOT loopBypass THEN
				// Check the force values from the HMI; if there is a change and the realted channel is forced, write it to the channel
				FOR i := 0 TO 15 DO 
					IF ((ForceHandle.Status.ModuleForceStatus[slotIndex].ForceValue[i] <> ForceHandle.Status.ModuleForceStatus[slotIndex].ForceValueOld[i]) AND
						ForceHandle.Status.ModuleForceStatus[slotIndex].IsForced[i] = TRUE) THEN
						ForceHandle.Status.ModuleForceStatus[slotIndex].ForceValueOld[i] := ForceHandle.Status.ModuleForceStatus[slotIndex].ForceValue[i];
						ForceHandle.Cmd.WriteForceValue := TRUE;
						loopBypass                      := TRUE;
						
						//-------- configure GetSignalStr ------
						GetSignalStr_0.uNumStation  := slotIndex + 1;    // configured for GetSignalStr
						GetSignalStr_0.uNumSignal   := i + 1;		     // configured for GetSignalStr				
						
						GetSignalStr_0();
						//---------------------------------------						
						
						EXIT;
					END_IF;

				END_FOR;
			END_IF;
			
			// Enable forcing for a specific channel
			IF ForceHandle.Cmd.Force THEN
				ForceHandle.Cmd.Force := FALSE;				
				
				//-------- configure GetSignalStr ------
				GetSignalStr_0.uNumStation  := slotIndex + 1;    // configured for GetSignalStr
				GetSignalStr_0.uNumSignal   := i + 1;		     // configured for GetSignalStr
			
				GetSignalStr_0();
				//---------------------------------------
				
				// datapoint of the channel is already known
				EnableIOForcing.pDatapoint := ADR(GetSignalStr_0.sStrSignal);
				EnableIOForcing.enable     := TRUE;
				forceStep               := FORCE_ENABLE_FORCE;
				
				// write the force value
			ELSIF ForceHandle.Cmd.WriteForceValue THEN
				ForceHandle.Cmd.WriteForceValue := FALSE;
				SetForceValue.enable            := TRUE;
				SetForceValue.pDatapoint        := ADR(GetSignalStr_0.sStrSignal);
				SetForceValue.value             := ForceHandle.Status.ModuleForceStatus[slotIndex].ForceValue[i];
				forceStep                    := FORCE_WRITE;
			
				// Disable forcing for a specific channel	
			ELSIF ForceHandle.Cmd.DisableForce THEN
				ForceHandle.Cmd.DisableForce := FALSE;
				//-------- configure GetSignalStr ------
				GetSignalStr_0.uNumStation  := slotIndex + 1;    // configured for GetSignalStr
				GetSignalStr_0.uNumSignal   := i + 1;		      // configured for GetSignalStr			
			
				GetSignalStr_0();
				//---------------------------------------
				forceStep               := FORCE_DISABLE_SPECIFIC_FORCE;				

			
				// Disable global forcing
			ELSIF ForceHandle.Cmd.DisableForceGlobal THEN 
				ForceHandle.Cmd.DisableForceGlobal := FALSE;
				DisableAllForcing.enable           := TRUE;
				forceStep                       := FORCE_DISABLE_ALL;
			END_IF;	

		
			//----------------------------------------------	
			// Enable Forcing for a specific datapoint
		FORCE_ENABLE_FORCE:
			IF EnableIOForcing.status = ERR_OK AND NOT ForceHandle.Cmd.WriteForceValue THEN	// FB completed w/o an error
				EnableIOForcing.enable                                       := FALSE;
				ForceHandle.Status.ModuleForceStatus[slotIndex].IsForced[i]  := TRUE;
				forceStep              								         := FORCE_WAIT;
				
			ELSIF EnableIOForcing.status = ERR_OK AND ForceHandle.Cmd.WriteForceValue THEN  // FB completed w/o an error, forcing is in progress
				EnableIOForcing.enable                                            := FALSE;
				ForceHandle.Status.ModuleForceStatus[slotIndex].IsForced[i]       := TRUE;
				ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[i]    := TRUE;
				ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatusOld[i] := ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[i]; 
				SetForceValue.enable                                              := TRUE;
				SetForceValue.pDatapoint                                          := lastDataPoint;
				SetForceValue.value                                               := ForceHandle.Status.ModuleForceStatus[slotIndex].ForceValue[i];
				ForceHandle.Cmd.WriteForceValue                                   := FALSE;
				forceStep                                                         := FORCE_WRITE;
				
			ELSIF EnableIOForcing.status <> ERR_OK AND EnableIOForcing.status <> ERR_FUB_BUSY THEN // FB completed w/ an error
				forceErrorID           := EnableIOForcing.status;
				forceWaitMsg           := 'FORCE_ENABLE_FORCE - Something went wrong during trying to force';
				EnableIOForcing.enable := FALSE;
				TEST_INT			:= 10;
				forceStep           := FORCE_ERROR;
			END_IF;
		
			//----------------------------------------------	
			// Write the forcing value
		FORCE_WRITE:
			IF SetForceValue.status = ERR_OK THEN   // FB completed w/o an error
				SetForceValue.enable := FALSE;
				forceStep            := FORCE_WAIT;
				
			ELSIF SetForceValue.status <> ERR_OK AND SetForceValue.status <> ERR_FUB_BUSY THEN  // FB completed w/ an error
				SetForceValue.enable := FALSE;
				forceWaitMsg         := 'FORCE_WRITE - Something went wrong while writing the force value';
				forceErrorID         := SetForceValue.status;
				TEST_INT			:= 20;
				forceStep            := FORCE_ERROR;
			END_IF;
		
		
			//----------------------------------------------	
			// Disable Forcing for a specific datapoint
		FORCE_DISABLE_SPECIFIC_FORCE:
			DisableForcing.enable      := TRUE;
			DisableForcing.pDatapoint  := ADR(GetSignalStr_0.sStrSignal);
			IF DisableForcing.status = ERR_OK THEN	// FB completed w/o an error
				DisableForcing.enable := FALSE;
				forceStep             := FORCE_WAIT;
				ForceHandle.Status.ModuleForceStatus[slotIndex].IsForced[i]       := FALSE;  // reset the module forced flag
				ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[i]    := 0;
				
			ELSIF DisableForcing.status <> ERR_OK AND DisableForcing.status <> ERR_FUB_BUSY AND DisableForcing.status <> ERR_FUB_ENABLE_FALSE THEN // FB completed w/ an error
				forceWaitMsg := 'FORCE_DISABLE_SPECIFIC_FORCE - Something went wrong disabling specific forcing';
				forceErrorID := DisableForcing.status;
				TEST_INT			:=30;
				forceStep    := FORCE_ERROR;
			END_IF;
			
			//----------------------------------------------	
			// Disable Forcing globally
		FORCE_DISABLE_ALL:
			IF DisableAllForcing.status = ERR_OK THEN     // FB completed w/o an error
				DisableAllForcing.enable := FALSE;
				FOR slotIndex := 0 TO NUMBER_OF_MODULES_MINUS_ONE DO
					FOR i := 0 TO 15 DO
						ForceHandle.Status.ModuleForceStatus[slotIndex].IsForced[i]       := FALSE;
						ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[i]    := 0;
						ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatusOld[i] := 0;
					END_FOR;
				END_FOR;
				
				slotIndex    := 0;
				forceStep    := FORCE_WAIT;
				
			ELSIF DisableAllForcing.status <> ERR_OK AND DisableAllForcing.status <> ERR_FUB_BUSY THEN // FB completed w/ an error
				forceWaitMsg := 'FORCE_DISABLE_ALL - Something went wrong during disabling forcing globally';
				forceErrorID := DisableAllForcing.status;

				TEST_INT			:=40;
				forceStep    := FORCE_ERROR;
			END_IF;
			
			//----------------------------------------------	
			// Error state
		FORCE_ERROR:
			// Disable all the user commands & FB enables
			ForceHandle.Cmd.DisableForce       := FALSE;
			ForceHandle.Cmd.DisableForceGlobal := FALSE;
			ForceHandle.Cmd.Force              := FALSE;
			
			EnableIOForcing.enable             := FALSE;
			GetIOListDP.enable                 := FALSE;
			DisableAllForcing.enable           := FALSE;
			DisableForcing.enable              := FALSE;
			
			// Reset the error ID and error msg upon acknowledgement and go back to FORCE_WAIT
			IF ForceHandle.Cmd.ErrAck THEN
				// reset the cmd's
				ForceHandle.Cmd.ErrAck             := FALSE;
				ForceHandle.Cmd.DisableForce       := FALSE;
				ForceHandle.Cmd.DisableForceGlobal := FALSE;
				ForceHandle.Cmd.Force              := FALSE;
				ForceHandle.Cmd.WriteForceValue    := FALSE;
				// Reset variables for GetSignalStr
				GetSignalStr_0.uNumSignal := 0;
				GetSignalStr_0();
				// Reset error msg & program step
				forceWaitMsg           := ' ';
				forceErrorID           := 0;
				forceStep              := FORCE_WAIT;
				
				// Reset force statuses
				FOR slotIndex := 0 TO NUMBER_OF_MODULES_MINUS_ONE DO
					FOR i := 0 TO 15 DO
						ForceHandle.Status.ModuleForceStatus[slotIndex].IsForced[i]       := FALSE;
						ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[i]    := FALSE;
						ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatusOld[i] := ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[i];
					END_FOR;
				END_FOR;
				// Reset the HMI selection variable
				slotIndex := 0;
				i         := 0;
			END_IF;
	END_CASE;	
	
	IF forceStep <> FORCE_WAIT AND loopBypass THEN
		loopBypass := FALSE;
	END_IF;
	
	//Check if error is active - flag is used in HMI for color datapoint of status text
	IF(forceStep = FORCE_ERROR)THEN
		ForceHandle.Status.ErrorActive := 1;
	ELSE
		ForceHandle.Status.ErrorActive := 0;
	END_IF
	
	

	
	(******************	             FB CALLS                  *****************)
	GetIOListDP();
	EnableIOForcing();
	DisableForcing();
	DisableAllForcing();
	SetForceValue();
	
//	IF NOT gSimulation THEN
		GetPhsyicalStatus;  // call the action to see the physical statuses of the datapoints	
//	END_IF;
	
	
END_PROGRAM
