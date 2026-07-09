(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Library: aLibFile
 * Function Block: FbDirRead
 * Author: kay3a 
 * Created: August 27, 2024/4:58 PM 
 ********************************************************************
 * Description:  Bu FB parametreden girilen DeviceName de bulunan folder içerisindeki tüm file lati okur.
 ********************************************************************)
FUNCTION_BLOCK FbDirRead
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               FB ENABLE KONTROLU 		        	
	//|_________________________________________________________________________
	
	(* Enable gelirse FB aktiftir. Gelmiyorsa aktif degildir.  *)
	Active := Enable;
	
	(* Aktif degilse Step basa gelsin *)
	IF NOT Active THEN	
		Internal.Step := stepDirRead_0_Idle;	
	END_IF;
	//|_________________________________________________________________________
	
	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               CHECK FB ERROR 		        	
	//|_________________________________________________________________________
	
	(* Error check *)
	IF (Internal.FB._DirInfo.enable AND Internal.FB._DirInfo.status <> ERR_FUB_BUSY AND Internal.FB._DirInfo.status <> ERR_OK) THEN
		StatusID := Internal.FB._DirInfo.status;
		Internal.Step := stepDirRead_11_Error;	
		
	ELSIF (Internal.FB._DirRead.enable AND Internal.FB._DirRead.status <> ERR_FUB_BUSY AND Internal.FB._DirRead.status <> ERR_OK) THEN
		StatusID := Internal.FB._DirRead.status;
		Internal.Step := stepDirRead_11_Error;
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
		stepDirRead_0_Idle: // Idle
			//=======================================================
			Error := FALSE;
			CommandDone := FALSE;
			CommandBusy := FALSE;
			IF Active THEN
				Internal.Step := stepDirRead_1_WaitCmd;	
			ELSE				
				brsmemset(ADR(ListedFile), 0, SIZEOF(ListedFile));	
			END_IF;
			//=======================================================
		
		
			//=======================================================
		stepDirRead_1_WaitCmd: // Wait Cmd 
			//=======================================================
			IF (Internal.CapturedExecute) THEN
				CommandBusy := TRUE;
				Internal.Step := stepDirRead_2_GetInfo;				
			END_IF;
			//=======================================================
						
			
			//=======================================================
		stepDirRead_2_GetInfo: // Get Dir info 
			//=======================================================
			Internal.FB._DirInfo.enable := TRUE;
			Internal.FB._DirInfo.pDevice := ADR(Parameters.DeviceName);  (* name of the device *)
			Internal.FB._DirInfo.pPath := 0;
			Internal.FB._DirInfo();  (* call the function*)
				
			IF Internal.FB._DirInfo.status = 0 THEN  (* DirInfo successful *)
				Internal.CountFile := 0;  (* reset Internal.CountFile *)
				brsmemset( ADR(ListedFile), 0, SIZEOF(ListedFile) );  (* clear list*)
				Internal.Step := stepDirRead_3_Read;  (* next step*)
			ELSIF Internal.FB._DirInfo.status = ERR_FUB_BUSY THEN  (* DirInfo not finished -> redo *)			
				(* Busy *)		
			ELSE  (* Goto internal.status.errorID Step *)
				Internal.Step := stepDirRead_11_Error;
			END_IF
			//=======================================================
						
			
			//=======================================================
		stepDirRead_3_Read: // Dir Read 
			//=======================================================
			Internal.FB._DirRead.enable := TRUE;
			Internal.FB._DirRead.pDevice := ADR(Parameters.DeviceName);  (* name of the device *)
			Internal.FB._DirRead.pPath := 0;
			Internal.FB._DirRead.option := fiBOTH;  (* read files and folders *)
			Internal.FB._DirRead.entry := Internal.CountFile;
			Internal.FB._DirRead.pData := ADR(Internal.ReadFile);
			Internal.FB._DirRead.data_len := SIZEOF(Internal.ReadFile);
			Internal.FB._DirRead();  (* call the function*)
				
			IF Internal.FB._DirRead.status = 0 THEN  (* DirRead successful *)
				(* copy found name into string-array *)
				brsstrcpy( ADR(ListedFile[Internal.CountFile]), ADR(Internal.ReadFile.Filename[0]) );
				(* increase Internal.CountFile *)
				Internal.CountFile := Internal.CountFile + 1;
				(* are all files and folders readed out? *)
				IF ( Internal.CountFile < (Internal.FB._DirInfo.dirnum + Internal.FB._DirInfo.filenum) ) THEN
					Internal.Step := stepDirRead_3_Read;  (* read next element *)	
				ELSE
					Internal.Step := stepDirRead_10_Done;  (* next step *)
				END_IF			
			ELSIF Internal.FB._DirRead.status = ERR_FUB_BUSY THEN  (* DirRead not finished -> redo *)			
				(* Busy *)		
			ELSE  (* Goto internal.status.errorID Step *)
				Internal.Step := stepDirRead_11_Error;
			END_IF
			//=======================================================
			
			
			//=======================================================
		stepDirRead_10_Done: // Done 
			//=======================================================
			CommandDone := TRUE;
			IF NOT Execute THEN
				Internal.Step := stepDirRead_0_Idle;				
			END_IF;
			//=======================================================
			
				
			//=======================================================
		stepDirRead_11_Error: // Error 
			//=======================================================
			Error := TRUE;
			Internal.FB._DirInfo(enable := FALSE);
			Internal.FB._DirRead(enable := FALSE);			
			IF ErrorReset THEN	
				StatusID := ERR_OK;
				Internal.Step := stepDirRead_0_Idle;				
			END_IF;
		//=======================================================
			
	END_CASE;
	//|=========================================================================
	
END_FUNCTION_BLOCK
