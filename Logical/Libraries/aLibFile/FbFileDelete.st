(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Library: aLibFile
 * Function Block: FbFileDelete
 * Author: kay3a 
 * Created: August 27, 2024/4:58 PM 
 ********************************************************************
 * Description: 
 ********************************************************************)
FUNCTION_BLOCK FbFileDelete
				
			
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               FB ENABLE KONTROLU 		        	
	//|_________________________________________________________________________
	
	(* Enable gelirse FB aktiftir. Gelmiyorsa aktif degildir.  *)
	Active := Enable;
	
	(* Aktif degilse Step basa gelsin *)
	IF NOT Active THEN	
		Internal.Step := stepFileDelete_0_Idle;	
	END_IF;
	//|_________________________________________________________________________
	
	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               CHECK FB ERROR 		        	
	//|_________________________________________________________________________
	
	(* Error check *)
	IF (Internal.FB._FileDelete.enable AND Internal.FB._FileDelete.status <> ERR_FUB_BUSY AND Internal.FB._FileDelete.status <> ERR_OK) THEN
		StatusID := Internal.FB._FileDelete.status;
		Internal.Step := stepFileDelete_11_Error;	
	END_IF;
	//|_________________________________________________________________________
	
	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               CHECK CMD FB EXECUTE  		        	
	//|_________________________________________________________________________
	
	(* Captured Execute *)
	IF EDGEPOS(Execute) THEN
		Internal.CapturedExecute := TRUE;
	ELSIF NOT Execute OR Error THEN
		Internal.CapturedExecute := FALSE;
	END_IF;
	//|_________________________________________________________________________
	
	
	
	
	//|=========================================================================
	//|					FILLING PROCESS STATE MACHINE
	//|
	//|
	//|=========================================================================
	CASE Internal.Step OF
		
		//=======================================================
		stepFileDelete_0_Idle: // Idle 
			//=======================================================
			Error := FALSE;
			CommandDone := FALSE;
			CommandBusy := FALSE;
			IF Active THEN
				Internal.Step := stepFileDelete_1_WaitCmd;
			END_IF;
			//=======================================================
		
		
			//=======================================================
		stepFileDelete_1_WaitCmd: // Wait Cmd 
			//=======================================================
			IF (Internal.CapturedExecute) THEN
				CommandBusy := TRUE;
				Internal.Step := stepFileDelete_2_Delete;				
			END_IF;
			//=======================================================
					
			
			//=======================================================
		stepFileDelete_2_Delete: // Delete 
			//=======================================================
			Internal.FB._FileDelete.enable := TRUE;
			Internal.FB._FileDelete.pDevice := ADR(Parameters.DeviceName);  (* name of a linked device *)
			
			Internal.FB._FileDelete.pName := ADR(Parameters.FileName);  (* name of the source file *)
			Internal.FB._FileDelete;  (* call the function*)
			
			IF Internal.FB._FileDelete.status = 0 THEN  (* filedelete successful *)
				Internal.Step := stepFileDelete_10_Done;  (* next Step*)
				
			ELSIF Internal.FB._FileDelete.status = ERR_FUB_BUSY THEN  (* fileDelete not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Loc.file.Status.error Step *)
				Internal.Step := stepFileDelete_11_Error;
			END_IF
			//=======================================================
			
				
			//=======================================================
		stepFileDelete_10_Done: // Done 
			//=======================================================
			CommandDone := TRUE;
			IF NOT Execute THEN
				Internal.Step := stepFileDelete_0_Idle;				
			END_IF;
			//=======================================================
			
				
			//=======================================================
		stepFileDelete_11_Error: // Error 
			//=======================================================
			Error := TRUE;
			Internal.FB._FileDelete(enable := FALSE);			
			IF ErrorReset THEN		
				StatusID := ERR_OK;	
				Internal.Step := stepFileDelete_0_Idle;				
			END_IF;
		//=======================================================
	
	END_CASE;
	//|=========================================================================
	
END_FUNCTION_BLOCK