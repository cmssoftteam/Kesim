(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Library: aLibFile
 * Function Block: FbFileCreate
 * Author: kay3a 
 * Created: August 27, 2024/4:58 PM 
 ********************************************************************
 * Description: Bu FB secili DeviceName altinda bulunan foler içerisine file olusturur.
 ********************************************************************)
FUNCTION_BLOCK FbFileCreate
		
			
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               FB ENABLE KONTROLU 		        	
	//|_________________________________________________________________________
	
	(* Enable gelirse FB aktiftir. Gelmiyorsa aktif degildir.  *)
	Active := Enable;
	
	(* Aktif degilse Step basa gelsin *)
	IF NOT Active THEN	
		Internal.Step := stepFileCreate_0_Idle;	
	END_IF;
	//|_________________________________________________________________________
	
	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               CHECK FB ERROR 		        	
	//|_________________________________________________________________________
	
	(* Error check *)
	IF (Internal.FB._FileClose.enable AND Internal.FB._FileClose.status <> ERR_FUB_BUSY AND Internal.FB._FileClose.status <> ERR_OK) THEN
		StatusID := Internal.FB._FileClose.status;
		Internal.Step := stepFileCreate_11_Error;	
		
	ELSIF (Internal.FB._FileCreate.enable AND Internal.FB._FileCreate.status <> ERR_FUB_BUSY AND Internal.FB._FileCreate.status <> ERR_OK AND Internal.FB._FileCreate.status <> fiERR_EXIST) THEN
		StatusID := Internal.FB._FileCreate.status;
		Internal.Step := stepFileCreate_11_Error;
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
		stepFileCreate_0_Idle: // Idle 
			//=======================================================
			Error := FALSE;
			CommandDone := FALSE;
			CommandBusy := FALSE;
			IF Active THEN
				Internal.Step := stepFileCreate_1_WaitCmd;	
			END_IF;
			//=======================================================
		
		
			//=======================================================
		stepFileCreate_1_WaitCmd: // Wait Cmd 
			//=======================================================
			IF (Internal.CapturedExecute) THEN
				CommandBusy := TRUE;
				Internal.Step := stepFileCreate_2_Create;				
			END_IF;
			//=======================================================
			
						
			//=======================================================
		stepFileCreate_2_Create: // File Create
			//=======================================================
			Internal.FB._FileCreate.enable := TRUE;
			Internal.FB._FileCreate.pDevice := ADR(Parameters.DeviceName);  (* name of the linked device *)
			Internal.FB._FileCreate.pFile := ADR(Parameters.FileName);  (* name of the file *)
			Internal.FB._FileCreate();  (* call the function*)
			
			IF Internal.FB._FileCreate.status = ERR_OK THEN  (* fileCreate successful *)
				Internal.Step := stepFileCreate_3_Close;  (* next Step*)				
			ELSIF Internal.FB._FileCreate.status = fiERR_EXIST THEN
				Internal.Step := stepFileCreate_10_Done;  (* next Step*)
			ELSIF Internal.FB._FileCreate.status = ERR_FUB_BUSY THEN  (* fileCreate not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Loc.file.Status.error Step *)
				Internal.Step := stepFileCreate_11_Error;
			END_IF	
			//=======================================================
			
			
			//=======================================================
		stepFileCreate_3_Close: // File Close 
			//=======================================================
			Internal.FB._FileClose.enable := TRUE;
			Internal.FB._FileClose.ident := Internal.FB._FileCreate.ident; (* ident for fileCreate-functionblock*)
			Internal.FB._FileClose;  (* call the function*)
			
			IF Internal.FB._FileClose.status = ERR_OK THEN  (* fileClose successful *)
				Internal.Step := stepFileCreate_10_Done;  (* next Step*)
				
			ELSIF Internal.FB._FileClose.status = ERR_FUB_BUSY THEN  (* fileClose not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Loc.file.Status.error Step *)
				Internal.Step := stepFileCreate_11_Error;
			END_IF
			//=======================================================
			
			
			//=======================================================
		stepFileCreate_10_Done: // Done 
			//=======================================================
			CommandDone := TRUE;
			IF NOT Execute THEN
				Internal.Step := stepFileCreate_0_Idle;				
			END_IF;
			//=======================================================
			
				
			//=======================================================
		stepFileCreate_11_Error: // Error 
			//=======================================================
			Error := TRUE;
			Internal.FB._FileCreate(enable := FALSE);
			Internal.FB._FileClose(enable := FALSE);			
			IF ErrorReset THEN		
				StatusID := ERR_OK;	
				Internal.Step := stepFileCreate_0_Idle;				
			END_IF;
		//=======================================================
		
	END_CASE;
	//|=========================================================================
	
END_FUNCTION_BLOCK
