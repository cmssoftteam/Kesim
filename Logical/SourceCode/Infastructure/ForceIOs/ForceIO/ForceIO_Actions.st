(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: ForceIO
 * File: ForceIO_Actions.st
 * Author: abdullahoglf
 * Created: January 15, 2014
 *******************************************************************)

(* Comm with the HMI *)
ACTION HMImap: 

	// Assign max. number of chanels in curent card
	gHMI.IO_Control.MaxDpIndex := MAX_DP_INDEX;
	
	IF slotIndex = gHMI.IO_Control.SelectedSlotOld THEN
		FOR j := 0 TO 15 DO
			ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[j]    := gHMI.IO_Control.ForceStatus[j];
			ForceHandle.Status.ModuleForceStatus[slotIndex].ForceValue[j]     := gHMI.IO_Control.FoceValue[j];
		END_FOR;
	END_IF;

	//----------------------------
	// Reset the cmd's if the user 
	// changes the active slot
	IF slotIndex <> gHMI.IO_Control.SelectedSlotOld THEN
		k  := 0;  // iteration variable for status monitoring is reset
		FOR j := 0 TO 15 DO
			gHMI.IO_Control.FoceValue[j]                                      := ForceHandle.Status.ModuleForceStatus[slotIndex].ForceValueOld[j];
			gHMI.IO_Control.ForceStatus[j]                                    := ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatusOld[j];
			ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[j]    := gHMI.IO_Control.ForceStatus[j];
			ForceHandle.Status.ModuleForceStatus[slotIndex].ForceValue[j]     := gHMI.IO_Control.FoceValue[j];
			
			ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatusOld[j] := ForceHandle.Status.ModuleForceStatus[slotIndex].ForceStatus[j];
			ForceHandle.Status.ModuleForceStatus[slotIndex].ForceValueOld[j]  := ForceHandle.Status.ModuleForceStatus[slotIndex].ForceValue[j];
		END_FOR;
		
	END_IF;	
	

END_ACTION


(* Gets the physical status of the I/O datapoints *)
ACTION GetPhsyicalStatus:
	IF GetDPStatus.status <> ERR_OK AND GetDPStatus.status <> ERR_FUB_BUSY AND GetDPStatus.status <> ERR_FUB_ENABLE_FALSE THEN
		GetDPStatus.enable := FALSE;
		k                  := 0;     // reset the channel index in case of any error
	ELSE
		GetDPStatus.enable := TRUE;
	END_IF;
	
	GetDPStatus.pDatapoint := ADR(GetSignalStr_1.sStrSignal);

	// FB completed w/o an error
	IF GetDPStatus.status = ERR_OK THEN
		
		IF (GetDPStatus.flags AND (2#0000_0100)) = 0 THEN  // the datapoint is not forced
			gHMI.IO_Control.PhysicalStatus[k] := GetDPStatus.value;
			
		ELSE   // the datapoint is forced, map the forced value
			gHMI.IO_Control.PhysicalStatus[k] := GetDPStatus.forceValue;
		END_IF;
		
		IF k <> MAX_DP_INDEX THEN
			k := k + 1;
			
		ELSE
			k := 0;
		END_IF;
		
		
		//-------- configure GetSignalStr ------
		GetSignalStr_1.uNumStation  := slotIndex + 1;    // configured for GetSignalStr
		GetSignalStr_1.uNumSignal   := k + 1;		     // configured for GetSignalStr				
		
		GetSignalStr_1();
		//---------------------------------------
	END_IF;
	
	// reset the physical value if the DP is not existing
	FOR t := 0 TO 15 DO
		IF t > MAX_DP_INDEX THEN
			gHMI.IO_Control.PhysicalStatus[t] := 0;
		END_IF;
	END_FOR;
	
	GetDPStatus();

END_ACTION
