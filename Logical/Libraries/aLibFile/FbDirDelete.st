(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Library: aLibFile
 * Function Block: FbDirDelete
 * Author: kay3a 
 * Created: August 27, 2024/4:58 PM 
 ********************************************************************
 * Description: Bu FB parametreden girilen DeviceName deki folder silme islemini yapar.
********************************************************************)
FUNCTION_BLOCK FbDirDelete

		
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               FB ENABLE KONTROLU 		        	
	//|_________________________________________________________________________
	
	(* Enable gelirse FB aktiftir. Gelmiyorsa aktif degildir.  *)
	Active := Enable;
	
	(* Aktif degilse Step basa gelsin *)
	IF NOT Active THEN	
		Internal.Step := stepDirDelete_0_Idle;	
	END_IF;	
	//|_________________________________________________________________________
		
	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               CHECK FB ERROR 		        	
	//|_________________________________________________________________________
	
	(* Error check *)
	IF Internal.FB._DirDelete.enable AND (Internal.FB._DirDelete.status <> ERR_FUB_BUSY AND Internal.FB._DirDelete.status <> ERR_OK) THEN
		StatusID := Internal.FB._DirDelete.status;
		Internal.Step := stepDirDelete_11_Error;	
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
		stepDirDelete_0_Idle: // Idle 
			//=======================================================
			Error := FALSE;
			CommandDone := FALSE;
			CommandBusy := FALSE;
			IF Active THEN
				Internal.Step := stepDirDelete_1_WaitCmd;	
			END_IF;
			//=======================================================
		
		
			//=======================================================
		stepDirDelete_1_WaitCmd: // Wait Cmd 
			//=======================================================
			IF (Internal.CapturedExecute) THEN
				CommandBusy := TRUE;
				Internal.Step := stepDirDelete_2_Delete;				
			END_IF;
			//=======================================================
			
						
			//=======================================================
		stepDirDelete_2_Delete: // Get Dir info 
			//=======================================================
			(* Create folder for this component on the user file device *)
			Internal.FB._DirDelete.enable := TRUE;
			Internal.FB._DirDelete.pDevice := ADR(Parameters.DeviceName);
			Internal.FB._DirDelete.pName := ADR('\');
			Internal.FB._DirDelete();
			(* Check if folder already exist and if so disabled the function block call *)
			IF (Internal.FB._DirDelete.status = ERR_OK) THEN
				Internal.Step := stepDirDelete_10_Done;
			END_IF			
			//=======================================================
			
			
			//=======================================================
		stepDirDelete_10_Done: // Done 
			//=======================================================
			CommandDone := TRUE;
			IF NOT Execute THEN
				Internal.Step := stepDirDelete_0_Idle;				
			END_IF;
			//=======================================================
			
			
			//=======================================================
		stepDirDelete_11_Error: // Error 
			//=======================================================
			Error := TRUE;
			Internal.FB._DirDelete(enable := FALSE);			
			IF ErrorReset THEN	
				StatusID := ERR_OK;
				Internal.Step := stepDirDelete_0_Idle;				
			END_IF;
		//=======================================================

	END_CASE;	
	//|=========================================================================
	
END_FUNCTION_BLOCK
