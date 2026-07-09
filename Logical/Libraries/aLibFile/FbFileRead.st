(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Library: aLibFile
 * Function Block: FbFileRead
 * Author: kay3a 
 * Created: August 27, 2024/4:58 PM 
 ********************************************************************
 * Description: Bu FB file içerisini okur.
 ********************************************************************)
FUNCTION_BLOCK FbFileRead
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               FB ENABLE KONTROLU 		        	
	//|_________________________________________________________________________
	
	(* Enable gelirse FB aktiftir. Gelmiyorsa aktif degildir.  *)
	Active := Enable;
	
	(* Aktif degilse Step basa gelsin *)
	IF NOT Active THEN	
		Internal.Step := stepFileRead_0_Idle;	
	END_IF;
	//|_________________________________________________________________________
	
	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               CHECK FB ERROR 		        	
	//|_________________________________________________________________________
	
	(* Error check *)
	IF (Internal.FB._FileClose.enable AND Internal.FB._FileClose.status <> ERR_FUB_BUSY AND Internal.FB._FileClose.status <> ERR_OK) THEN
		StatusID := Internal.FB._FileClose.status;
		Internal.Step := stepFileRead_11_Error;	
		
	ELSIF (Internal.FB._FileReadEx.enable AND Internal.FB._FileReadEx.status <> ERR_FUB_BUSY AND Internal.FB._FileReadEx.status <> ERR_OK) THEN
		StatusID := Internal.FB._FileReadEx.status;
		Internal.Step := stepFileRead_11_Error; 
		
	ELSIF (Internal.FB._FileOpen.enable AND Internal.FB._FileOpen.status <> ERR_FUB_BUSY AND Internal.FB._FileOpen.status <> ERR_OK) THEN
		StatusID := Internal.FB._FileOpen.status;
		Internal.Step := stepFileRead_11_Error;
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
		stepFileRead_0_Idle: // Idle 
			//=======================================================
			Error := FALSE;
			CommandDone := FALSE;
			CommandBusy := FALSE;
			IF Active THEN
				Internal.Step := stepFileRead_1_WaitCmd;
			ELSE				
				brsmemset(ADR(ReadData), 0, SIZEOF(ReadData));	
			END_IF;
			//=======================================================
		
		
			//=======================================================
		stepFileRead_1_WaitCmd: // Wait Cmd 
			//=======================================================
			IF (Internal.CapturedExecute) THEN
				CommandBusy := TRUE;
				Internal.Step := stepFileRead_2_FileOpen;				
			END_IF;
			//=======================================================
						
			
			//=======================================================
		stepFileRead_2_FileOpen: // File Open 
			//=======================================================
			Internal.FB._FileOpen.enable := TRUE;
			Internal.FB._FileOpen.pDevice := ADR(Parameters.DeviceName);  (* name of the linked device *)
			
			Internal.FB._FileOpen.pFile :=  ADR(Parameters.FileName);  (* name of the file *)
			Internal.FB._FileOpen.mode := fiREAD_ONLY; (* write access *)
			Internal.FB._FileOpen();  (* call the function*)

			IF Internal.FB._FileOpen.status = 0 THEN  (* fileOpen successful *)
				brsmemset(ADR(ReadData), 0, SIZEOF(ReadData));
				Internal.Step := stepFileRead_3_Read;  (* next Step*)
			ELSIF Internal.FB._FileOpen.status = ERR_FUB_BUSY THEN  (* fileOpen not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Loc.file.Status.error Step *)
				Internal.Step := stepFileRead_11_Error;
			END_IF	
			//=======================================================
						
			
			//=======================================================
		stepFileRead_3_Read: // File read 
			//=======================================================
			Internal.FB._FileReadEx.enable := TRUE;
			Internal.FB._FileReadEx.ident := Internal.FB._FileOpen.ident;  (* ident of the previous "fileOpen" *)
			Internal.FB._FileReadEx.offset := 0;  (* start at the beginning of the file *)
			Internal.FB._FileReadEx.pDest := ADR(ReadData);  (* adress of the destination of reaaded datas *)
			Internal.FB._FileReadEx.len := SIZEOF(ReadData);  (* lenght of data, which should be readed *)			
			Internal.FB._FileReadEx;  (* call the function*)

			IF Internal.FB._FileReadEx.status = 0 THEN  (* fileReadEx successful *)
				(* Internal.FB._FileReadEx.bytesread includes the lenght of the readed data *)
				Internal.Step := stepFileRead_4_FileClose;  (* next Step*)
			ELSIF Internal.FB._FileReadEx.status = ERR_FUB_BUSY THEN  (* fileReadEx not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Loc.file.Status.error Step *)
				Internal.Step := stepFileRead_11_Error;
			END_IF
			//=======================================================
						
			
			//=======================================================
		stepFileRead_4_FileClose: // File Close 
			//=======================================================
			Internal.FB._FileClose.enable := TRUE;
			Internal.FB._FileClose.ident := Internal.FB._FileOpen.ident; (* ident for fileCreate-functionblock*)
			Internal.FB._FileClose();  (* call the function*)
			
			IF Internal.FB._FileClose.status = 0 THEN  (* fileClose successful *)
				Internal.Step := stepFileRead_10_Done;  (* next Step*)
				
			ELSIF Internal.FB._FileClose.status = ERR_FUB_BUSY THEN  (* fileClose not finished -> redo *)			
				(* Busy *)	
			ELSE  (* Goto Loc.file.Status.error Step *)
				Internal.Step := stepFileRead_11_Error;
			END_IF
			//=======================================================
			
			
			//=======================================================
		stepFileRead_10_Done: // Done 
			//=======================================================
			CommandDone := TRUE;
			IF NOT Execute THEN
				Internal.Step := stepFileRead_0_Idle;				
			END_IF;
			//=======================================================
			
				
			//=======================================================
		stepFileRead_11_Error: // Error 
			//=======================================================
			Error := TRUE;
			Internal.FB._FileOpen(enable := FALSE);
			Internal.FB._FileClose(enable := FALSE);
			Internal.FB._FileReadEx(enable := FALSE);			
			IF ErrorReset THEN		
				StatusID := ERR_OK;	
				Internal.Step := stepFileRead_0_Idle;				
			END_IF;
		//=======================================================
		
	END_CASE;
	//|=========================================================================
	
END_FUNCTION_BLOCK