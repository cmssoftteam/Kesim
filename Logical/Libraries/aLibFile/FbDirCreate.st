(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Library: aLibFile
 * Function Block: FbDirCreate
 * Author: kay3a 
 * Created: August 27, 2024/4:58 PM 
 ********************************************************************
 * Description: Bu FB parametreden girilen DeviceName e folder olusturma islemini yapar.
 ********************************************************************)
FUNCTION_BLOCK FbDirCreate
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               FB ENABLE KONTROLU 		        	
	//|_________________________________________________________________________
	
	(* Enable gelirse FB aktiftir. Gelmiyorsa aktif degildir.  *)
	Active := Enable;
	
	(* Aktif degilse Step basa gelsin *)
	IF NOT Active THEN	
		Internal.Step := stepDirCreate_0_Idle;	
	END_IF;
	//|_________________________________________________________________________

	
	
			
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               CHECK FB ERROR 		        	
	//|_________________________________________________________________________
	
	(* Error check *)
	IF Internal.FB._DirCreate.enable AND (Internal.FB._DirCreate.status <> ERR_FUB_BUSY AND Internal.FB._DirCreate.status <> ERR_OK AND Internal.FB._DirCreate.status <> fiERR_DIR_ALREADY_EXIST) THEN
		StatusID := Internal.FB._DirCreate.status;
		Internal.Step := stepDirCreate_11_Error;	
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
		stepDirCreate_0_Idle: // Idle
			//=======================================================
			Error := FALSE;
			CommandDone := FALSE;
			CommandBusy := FALSE;
			IF Active THEN
				Internal.Step := stepDirCreate_1_WaitCmd;	
			END_IF;
			//=======================================================
		
		
			//=======================================================
		stepDirCreate_1_WaitCmd: // Wait Cmd
			//=======================================================
			IF (Internal.CapturedExecute) THEN
				CommandBusy := TRUE;
				Internal.Step := stepDirCreate_2_CrateDevLink;				
			END_IF;
			//=======================================================
			
			
			//=======================================================
		stepDirCreate_2_CrateDevLink:
			//=======================================================
			Internal.FB._DevLink.enable := TRUE;
			Internal.FB._DevLink.pDevice := ADR(Parameters.DeviceName);
			Internal.FB._DevLink.pParam := ADR(Parameters.DirPath);
			Internal.FB._DevLink();
			IF (Internal.FB._DevLink.status = ERR_OK) OR (Internal.FB._DevLink.status = fiERR_DEVICE_ALREADY_EXIST) THEN
				Internal.Step := stepDirCreate_3_CreateDir;
			END_IF;
			//=======================================================
			
			
			//=======================================================
		stepDirCreate_3_CreateDir: // Get Dir info 
			//=======================================================
			(* Create folder for this component on the user file device *)
			Internal.FB._DirCreate.enable := TRUE;
			Internal.FB._DirCreate.pDevice := ADR(Parameters.DeviceName);
			Internal.FB._DirCreate.pName := ADR('/');
			Internal.FB._DirCreate();
			(* Check if folder already exist and if so disabled the function block call *)
			IF (Internal.FB._DirCreate.status = fiERR_DIR_ALREADY_EXIST) OR (Internal.FB._DirCreate.status = ERR_OK) THEN
				Internal.Step := stepDirCreate_10_Done;
			END_IF			
			//=======================================================
			
			
			//=======================================================
		stepDirCreate_10_Done: // Done
			//=======================================================
			CommandDone := TRUE;
			IF NOT Execute THEN
				Internal.Step := stepDirCreate_0_Idle;				
			END_IF;
			//=======================================================
			
				
			//=======================================================
		stepDirCreate_11_Error: // Error
			//=======================================================
			Error := TRUE;
			Internal.FB._DirCreate(enable := FALSE);			
			IF ErrorReset THEN	
				StatusID := ERR_OK;
				Internal.Step := stepDirCreate_0_Idle;				
			END_IF;
		//=======================================================
	
	END_CASE;
	//|=========================================================================

	
END_FUNCTION_BLOCK
