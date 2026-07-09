(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Library: aLibFile
 * Function Block: FbFileWrite
 * Author: kay3a 
 * Created: August 27, 2024/4:58 PM 
 ********************************************************************
 * Description: 
 ********************************************************************)
FUNCTION_BLOCK FbFileWrite
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               FB ENABLE KONTROLU 		        	
	//|_________________________________________________________________________
	
	(* Enable gelirse FB aktiftir. Gelmiyorsa aktif degildir.  *)
	Active := Enable;
	
	(* Aktif degilse Step basa gelsin *)
	IF NOT Active THEN	
		Internal.Step := stepFileWrite_0_Idle;	
	END_IF;
	//|_________________________________________________________________________
	
	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               CHECK FB ERROR 		        	
	//|_________________________________________________________________________
	
	(* Error check *)
	IF (Internal.FB._FileClose.enable AND Internal.FB._FileClose.status <> ERR_FUB_BUSY AND Internal.FB._FileClose.status <> ERR_OK) THEN
		StatusID := Internal.FB._FileClose.status;
		Internal.Step := stepFileWrite_11_Error;	
		
	ELSIF (Internal.FB._FileWriteEx.enable AND Internal.FB._FileWriteEx.status <> ERR_FUB_BUSY AND Internal.FB._FileWriteEx.status <> ERR_OK) THEN
		StatusID := Internal.FB._FileWriteEx.status;
		Internal.Step := stepFileWrite_11_Error; 
		
	ELSIF (Internal.FB._FileOpen.enable AND Internal.FB._FileOpen.status <> ERR_FUB_BUSY AND Internal.FB._FileOpen.status <> ERR_OK) THEN
		StatusID := Internal.FB._FileOpen.status;
		Internal.Step := stepFileWrite_11_Error;
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
		stepFileWrite_0_Idle: // Idle 
			//=======================================================
			Error := FALSE;
			CommandDone := FALSE;
			CommandBusy := FALSE;
			IF Active THEN
				Internal.Step := stepFileWrite_1_WaitCmd;	
			END_IF;
			//=======================================================
		
		
			//=======================================================
		stepFileWrite_1_WaitCmd: // Wait Cmd 
			//=======================================================
			IF (Internal.CapturedExecute) THEN
				CommandBusy := TRUE;
				Internal.Step := stepFileWrite_2_FileOpen;				
			END_IF;
			//=======================================================
						
			
			//=======================================================
		stepFileWrite_2_FileOpen: // File Open 
			//=======================================================
			Internal.FB._FileOpen.enable := TRUE;
			Internal.FB._FileOpen.pDevice := ADR(Parameters.DeviceName);  (* name of the linked device *)
			
			Internal.FB._FileOpen.pFile :=  ADR(Parameters.FileName);  (* name of the file *)
			Internal.FB._FileOpen.mode := fiWRITE_ONLY; (* write access *)
			Internal.FB._FileOpen();  (* call the function*)

			IF Internal.FB._FileOpen.status = 0 THEN  (* fileOpen successful *)
				Internal.Step := stepFileWrite_3_Write;  (* next Step*)
			ELSIF Internal.FB._FileOpen.status = ERR_FUB_BUSY THEN  (* fileOpen not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Loc.file.Status.error Step *)
				Internal.Step := stepFileWrite_11_Error;
			END_IF	
			//=======================================================
			
			
			//=======================================================
		stepFileWrite_3_Write: // File Write 
			//=======================================================
			Internal.FB._FileWriteEx.enable := TRUE;
			Internal.FB._FileWriteEx.option := fiTruncate;
			Internal.FB._FileWriteEx.ident := Internal.FB._FileOpen.ident;	
			Internal.FB._FileWriteEx.offset := 0; (* start at the beginning of the file *)		
			Internal.FB._FileWriteEx.pSrc := ADR(WriteData);
			Internal.FB._FileWriteEx.len := brsstrlen( ADR(WriteData) );
			Internal.FB._FileWriteEx();  (* call the function*)

			IF Internal.FB._FileWriteEx.status = 0 THEN  (* fileWrite successful *)
				Internal.Step := stepFileWrite_4_FileClose;  (* next Step*)
			ELSIF Internal.FB._FileWriteEx.status = ERR_FUB_BUSY THEN  (* fileWrite not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Loc.file.Status.error Step *)
				Internal.Step := stepFileWrite_11_Error;
			END_IF	
			//=======================================================
						
			
			//=======================================================
		stepFileWrite_4_FileClose: // File Close 
			//=======================================================
			Internal.FB._FileClose.enable := TRUE;
			Internal.FB._FileClose.ident := Internal.FB._FileOpen.ident; (* ident for fileCreate-functionblock*)
			Internal.FB._FileClose();  (* call the function*)
			
			IF Internal.FB._FileClose.status = 0 THEN  (* fileClose successful *)
				Internal.Step := stepFileWrite_10_Done;  (* next Step*)
				
			ELSIF Internal.FB._FileClose.status = ERR_FUB_BUSY THEN  (* fileClose not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Loc.file.Status.error Step *)
				Internal.Step := stepFileWrite_11_Error;
			END_IF
			//=======================================================
			
			
			//=======================================================
		stepFileWrite_10_Done: // Done 
			//=======================================================
			CommandDone := TRUE;
			IF NOT Execute THEN
				Internal.Step := stepFileWrite_0_Idle;				
			END_IF;
			//=======================================================
			
				
			//=======================================================
		stepFileWrite_11_Error: // Error
			//=======================================================
			Error := TRUE;
			Internal.FB._FileOpen(enable := FALSE);
			Internal.FB._FileClose(enable := FALSE);
			Internal.FB._FileWriteEx(enable := FALSE);			
			IF ErrorReset THEN		
				StatusID := ERR_OK;	
				Internal.Step := stepFileWrite_0_Idle;				
			END_IF;
		//=======================================================
	
	END_CASE;
	//|=========================================================================
	
END_FUNCTION_BLOCK