(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: aIOhand
 * File: aIOhand.st
 * Author: abdullahoglf
 * Created: February 11, 2014
 ********************************************************************
 * Implementation of program aIOhand
 ********************************************************************)

(*********************************************************************************
*With this software various informations about the modules can be obtained. 
 detailed expression can be found on help in the path: Programming/Libraries/
 Direct I/O Access AsIODiag.
*Also a list can automatically be created with the desired values. For instance;
 if in the list the variable moduleState is 1, it means that the specified hardware
 is only configured but not included in the hardware; so on and so forth.
*********************************************************************************)      

PROGRAM _INIT


	TON_0.IN := TRUE;
	TON_0.PT :=  T#5s;
END_PROGRAM


PROGRAM _CYCLIC
	
	(*There are seven cases in the software. These respectively are:
		MAIN: Main state is from where the other cases are managed. Also after an error case, the state is switched back to the MAIN again.
	    CREATE_INFO: This is the case where the function DiagCreateInfo() is used.
					DiagCreateInfo(): Collects information about currently configured and/or inserted hardware modules.
		DISPOSE_INFO: This is the case where the function DiagDisposeInfo() is used.
					DiagDisposeInfo(): Frees up the resources taken up by DiagCreateInfo().
		GET_NUM_INFO: This is the case where the function DiagGetNumInfo() is used.
					DiagGetNumInfo(): Reads the numeric value of a specified information entry. 
		GET_STR_INFO: This is the case where the function DiagGetStrInfo() is used.
					DiagGetStrInfo(): Reads the string value of a specified information entry.
	    GET_LIST: This case handles the list creating.
	    ERROR: At this case, an error flag is put and upon error acknowledgemnt it then switches the state back to MAIN.
     *)


	CASE state OF
		
		//-------------------------
		//Wait before starting
		WAIT_START:
			// Wait few seconds after PLC boots up also for a motion to be in RUN
			
			IF(TON_0.Q)THEN // HMI is out of Init paga and minimum (5s time is elapsed)
				TON_0.IN  := FALSE; 	// reset timer
				state	  := MAIN;		// Change state
				GetList.GetList := TRUE;//NOT(gSimulation);	// Give commad to get list of HW modules
			END_IF
		
		
			//-------------------------
			// Ready for cmd's
		MAIN:		
			IF  (CreateInfoCommand.createInfo <> FALSE) THEN       //According to the command, the state is decided
				state := CREATE_INFO;
			ELSIF (DisposeInfoCommand.disponseInfo <> FALSE) THEN
				state := DISPOSE_INFO;
			ELSIF (GetNumInfoCommand.getNumInfo <> FALSE) THEN
				state := GET_NUM_INFO;
			ELSIF (GetStrInfoCommand.getStrInfo <> FALSE) THEN
				state := GET_STR_INFO;
				//Process for auto-list generation is initiliazed
			ELSIF (GetList.GetList <> FALSE) THEN            
				MyDiagCreateInfo.infoKind := asdiagALL;  //asdiagALL for information about inserted and configured modules
				state                     := CREATE_INFO;
			END_IF;	
	
			//-------------------------
			// Create the information which later on is to be used by other FB's
		CREATE_INFO:
			MyDiagCreateInfo.enable := TRUE;
			MyDiagCreateInfo();
			//If run manually then the function waits for the configuration to be made
			IF (CreateInfoCommand.plugged) THEN
				MyDiagCreateInfo.infoKind := asdiagPLUGGED;			
			ELSIF (CreateInfoCommand.configured) THEN
				MyDiagCreateInfo.infoKind := asdiagCONFIGURED;	       		
			ELSIF (CreateInfoCommand.all) THEN
				MyDiagCreateInfo.infoKind := asdiagALL;				
			END_IF;
			
			//If the FB is finished then resettings are done 
			IF (MyDiagCreateInfo.status = ERR_OK) THEN
				Info.Ident	   			            := MyDiagCreateInfo.ident;
				Info.NumbersEntries    			    := MyDiagCreateInfo.nrEntries;
				MyDiagCreateInfo.enable             := FALSE;
				CreateInfoCommand.createInfo        := FALSE;
				//If an auto-list generation is progress, the state is transferred to GET_NUM_INFO
				IF (GetList.GetList = TRUE) THEN					
					state := GET_NUM_INFO;
					//If otherwise, it goes back to the MAIN and waits
				ELSE
					state := MAIN;
				END_IF;
					
			ELSIF MyDiagCreateInfo.status = ERR_FUB_BUSY THEN		//Not complete, call it again
				state := CREATE_INFO;
			ELSE
				state := ERROR;
			END_IF		
		
			//---------------------------
			// Release the used handles
		DISPOSE_INFO:
			MyDiagDisposeInfo.enable := TRUE;
			MyDiagDisposeInfo.ident  := Info.Ident;
			MyDiagDisposeInfo();
			//If the FB is completed then it goes back to the MAIN state
			IF MyDiagDisposeInfo.status = ERR_OK THEN
				MyDiagDisposeInfo.enable         := FALSE;
				DisposeInfoCommand.disponseInfo  := FALSE;
				state 							 := MAIN;
				//If not it is called again	
			ELSIF MyDiagDisposeInfo.status = ERR_FUB_BUSY THEN
				state := DISPOSE_INFO;
			ELSE
				state := ERROR;
			END_IF;
		
			//--------------------------
			// Get numeric info. about the IO's
		GET_NUM_INFO:
			MyDiagGetNumInfo.enable   := TRUE;
			MyDiagGetNumInfo.ident    := Info.Ident;
			MyDiagGetNumInfo.infoCode := asdiagMODUL_STATE;
			MyDiagGetNumInfo.index    := Info.Index;
			MyDiagGetNumInfo();
			//If the function is completeand the output setting the resettings are done
			IF MyDiagGetNumInfo.status = 0 THEN
				GetNumInfoCommand.desiredNum := MyDiagGetNumInfo.value;
				MyDiagGetNumInfo.enable      := FALSE;
				GetNumInfoCommand.getNumInfo := FALSE;
				//If a auto-list generation is in progress it continues to GET_STR_INFO
				IF GetList.GetList THEN
					state := GET_STR_INFO;
					//If not, the state is switched back to MAIN	
				ELSE
					state := MAIN;					
				END_IF;
				//If it is not completed then it is called again	
			ELSIF MyDiagGetNumInfo.status = ERR_FUB_BUSY THEN
				state := GET_NUM_INFO;
			ELSE
				state := ERROR;
			END_IF;
	
			//-----------------------------
			// Get str. info. about the IO's
		GET_STR_INFO:
			MyDiagGetStrInfo.enable    := TRUE;
			MyDiagGetStrInfo.ident     := Info.Ident;
			MyDiagGetStrInfo.index     := Info.Index;
			MyDiagGetStrInfo.infoCode  := asdiagPLUGGED_MODULE;      // for hardware module name
			MyDiagGetStrInfo.pBuffer   := ADR(GetStrInfoCommand.desiredStr);
			MyDiagGetStrInfo.bufferLen := SIZEOF(GetStrInfoCommand.desiredStr);
			MyDiagGetStrInfo();
			IF MyDiagGetStrInfo.status = ERR_OK AND GetList.GetList THEN
				GetStrInfoCommand.getStrInfo         := FALSE;
				MyDiagGetStrInfo.enable              := FALSE;
				
				//If GetList is enabled then it writes the related values to the list index
				// Check the boundries of GetList array size to avodi writing outside of array
				IF(Info.Index <= (SIZEOF(GetList.List)/ ( SIZEOF(GetList.List[0]) - 1 )) ) THEN // GetList.List size is big enough
					GetList.List[Info.Index].index       := Info.Index;
					GetList.List[Info.Index].name        := GetStrInfoCommand.desiredStr;
					GetList.List[Info.Index].moduleState := GetNumInfoCommand.desiredNum;
					state                                := GET_LIST;
					// Reset IO card positions when entering the GET_LIST step for the first time
					// LT 20140702
					IF(Info.Index = 0)THEN
						diCount 	 := 0;	doCount		 := 0;
						aoCount		 := 0;	aiCount		 := 0;
						diStartIndex := 0;	doStartIndex := 0;
						aiStartIndex := 0;	aoStartIndex := 0;
						ioCfgStart	 := 0;
					END_IF
				ELSE	// Error - GetList.List is smaller than current Info.Index
					state				:= ERROR;	// Go to error state
					brsstrcpy(ADR(Info.errorStatement),ADR('Error - GET_STR_INFO - GetList.List Array too small')); // Give error msg
				END_IF
				
			ELSIF MyDiagGetStrInfo.status = ERR_OK THEN	
				//If not then goes back to the MAIN state
				GetStrInfoCommand.getStrInfo         := FALSE;
				MyDiagGetStrInfo.enable              := FALSE;
				state                                := MAIN;
			ELSIF MyDiagGetStrInfo.status = ERR_FUB_BUSY THEN  //If not completed then it is called again
				state := GET_STR_INFO;
			ELSE
				state := ERROR;
			END_IF;
			
			//----------------------------
			// Create the list
		GET_LIST:
			// access to IO type definition
			checkName ACCESS (ADR(GetList.List[Info.Index].name) + 3);
			
			// DI card
			IF brsmemcmp(ADR(checkName), ADR('DI'), SIZEOF(checkName)) = 0 THEN
				IF diCount = 0 THEN
					diStartIndex := Info.Index;	
				END_IF;
				
				diCount := diCount + 1;
			
				// DO card
			ELSIF brsmemcmp(ADR(checkName), ADR('DO'), SIZEOF(checkName)) = 0 THEN	
				IF doCount = 0 THEN
					doStartIndex := Info.Index;	
				END_IF;
				
				doCount := doCount + 1;
		
				// AI card		
			ELSIF brsmemcmp(ADR(checkName), ADR('AI'), SIZEOF(checkName)) = 0 THEN	
				IF aiCount = 0 THEN
					aiStartIndex := Info.Index;	
				END_IF;
				
				aiCount := aiCount + 1;
			
				// AO card	
			ELSIF brsmemcmp(ADR(checkName), ADR('AO'), SIZEOF(checkName)) = 0 THEN	
				IF aoCount = 0 THEN
					aoStartIndex := Info.Index;	
				END_IF;
				
				aoCount := aoCount + 1;
			END_IF;
			
			//Index is incremented to fill the list.
			Info.Index := Info.Index+1;
			
			//When the final value is reached; GetList and index are reset and then DiagDisposeInfo() is run to release the data that has been used.
			IF Info.Index = Info.NumbersEntries THEN
				Info.Index      := 0;
				GetList.GetList := FALSE;
				ioCfgStart      := MIN(MIN(diStartIndex + MAX_UDINT_NUMBER, doStartIndex + MAX_UDINT_NUMBER), MIN(aiStartIndex + MAX_UDINT_NUMBER, aoStartIndex + MAX_UDINT_NUMBER)) + 1;
				state           := DISPOSE_INFO;
			END_IF;
			
			state := MAIN;							
		
			//----------------------------
			// Error
		ERROR:
			Info.errorFlag := TRUE;
			IF ( 0 = brsstrcmp(ADR(Info.errorStatement), ADR('')) )  THEN
				Info.errorStatement := 'Error! Check statuses of function blocks.';
			END_IF;
			
			IF Info.errorAck THEN
				// reset the error flag
				Info.errorAck       := FALSE;	
				Info.errorFlag      := FALSE;				
				Info.errorStatement := '';
				//				
				// reset the user cmd's
				GetStrInfoCommand.getStrInfo    := FALSE;
				GetNumInfoCommand.getNumInfo    := FALSE;
				CreateInfoCommand.createInfo    := FALSE;
				DisposeInfoCommand.disponseInfo := FALSE;
				GetList.GetList                 := FALSE;
				//
				// reset the FB enables
				MyDiagCreateInfo.enable  := FALSE;
				MyDiagGetStrInfo.enable  := FALSE;
				MyDiagGetNumInfo.enable  := FALSE;
				MyDiagDisposeInfo.enable := FALSE;
				//
				// reset the SW step
				state := MAIN;
			END_IF;		
	END_CASE;	
	
	// Execute help  timer
	TON_0();
	
END_PROGRAM
