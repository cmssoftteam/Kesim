(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * PROGRAM: gCSV_Ctrl
 * File: gCSV_CtrlCyclic.st
 * Author: blanca-gutim
 * Created: December 06, 2012
 ********************************************************************
 * Implementation OF PROGRAM gCSV_Ctrl
 ********************************************************************)

PROGRAM _CYCLIC

	//Update inputs
	Action_Input;
	
	//====================================================================================================
	//	
	//									MAIN STATE MACHINE
	//	
	//====================================================================================================
	IF TON_Init.Q THEN
		TON_Init.IN := FALSE;
		//FUB execution
		Init_CSVHandling();
	
		//Check if the FUB is done
		IF (Init_CSVHandling.status = ERR_FUB_BUSY) THEN
			//The FUB is busy
		ELSE
			IF (Init_CSVHandling.status = ERR_OK) THEN
				//FUB executed successfully
			ELSE
				//Error -> Save information about error
				gCSV_Ctrl.Out.Stat.Error.Number		:= Init_CSVHandling.status;
				gCSV_Ctrl.Out.Stat.Error.Text.Line1	:= TaskName;
				gCSV_Ctrl.Out.Stat.Error.Text.Line2	:= StateStrings[MainState];
				ErrorState							:= MainState;					
				MainState							:= C_MS_CSV_FILE_HAND_ERROR;
			END_IF	
		END_IF	
	END_IF;
	CASE MainState OF
		
		//============================================================================================	
		C_MS_CSV_FILE_HAND_INIT:					//INITIALIZATION STATE
			//============================================================================================	

			//Initialization done -> Go to Wait Command state		
			MainState 			:= C_MS_CSV_FILE_HAND_WAIT_CMD;
												
		//============================================================================================						
		C_MS_CSV_FILE_HAND_WAIT_CMD:				//STANDSTILL STATE
			//============================================================================================			
													
			//WAIT FOR COMMANDS
			IF (gCSV_Ctrl.Out.Stat.ReadyForCmd = TRUE) THEN
				IF (gCSV_Ctrl.In.Cmd.ReadFile > OldInputs.Cmd.ReadFile) THEN				
					//Go to Read CSV file state
					MainState			:= C_MS_CSV_FILE_HAND_READ;
				ELSIF (gCSV_Ctrl.In.Cmd.WriteFile > OldInputs.Cmd.WriteFile) THEN
					//Go to the first state when a file is written
					MainState			:= C_MS_CSV_FILE_HAND_SEARCH_FILE;								
				ELSE
					//Stay in Wait Command state
					MainState 			:= C_MS_CSV_FILE_HAND_WAIT_CMD;
				END_IF	
			END_IF

			//Update the output ReadyForCmd
			IF (MainState = C_MS_CSV_FILE_HAND_WAIT_CMD) THEN
				gCSV_Ctrl.Out.Stat.ReadyForCmd	:= TRUE;
			ELSE
				gCSV_Ctrl.Out.Stat.ReadyForCmd	:= FALSE;
			END_IF		
				
		//============================================================================================	
		C_MS_CSV_FILE_HAND_READ:				//READ CSV FILE
			//============================================================================================		
			
			//FUB parameters
			ReadFile_CSVHandling.pDevice			:= ADR(gCSV_Ctrl.In.Par.FileDeviceName);
			ReadFile_CSVHandling.pPath				:= ADR(gCSV_Ctrl.In.Par.Path);
			ReadFile_CSVHandling.pFileName			:= ADR(gCSV_Ctrl.In.Par.FileName);
			ReadFile_CSVHandling.Separator			:= C_SEPARATOR;	//Check constant to see the ASCII code of the actual separator
			ReadFile_CSVHandling.No_DatatypControl	:= 1;
			ReadFile_CSVHandling.IgnoreError		:= 1;
			ReadFile_CSVHandling.Options			:= 0;
			
			//FUB execution
			ReadFile_CSVHandling();
	
			//Chec if the FUB is done
			IF (ReadFile_CSVHandling.status = ERR_FUB_BUSY) THEN
				//The FUB is busy
			ELSE
				IF (ReadFile_CSVHandling.status = ERR_OK) THEN
					//FUB executed successfully -> Go to wait command state
					MainState							:= C_MS_CSV_FILE_HAND_WAIT_CMD;
					//Set output status command done
					gCSV_Ctrl.Out.Stat.CmdDone.ReadFile	:= TRUE;
				ELSE
					//Error -> Save information about error
					gCSV_Ctrl.Out.Stat.Error.Number		:= ReadFile_CSVHandling.status;
					gCSV_Ctrl.Out.Stat.Error.Text.Line1	:= TaskName;
					gCSV_Ctrl.Out.Stat.Error.Text.Line2	:= StateStrings[MainState];
					ErrorState							:= MainState;					
					MainState							:= C_MS_CSV_FILE_HAND_ERROR;
				END_IF	
			END_IF			
		
		//============================================================================================	
		C_MS_CSV_FILE_HAND_SEARCH_FILE:				//SEARCH FOR THE SPECIFIED FILE NAME
			//============================================================================================		
			
			//FUB parameters
			ToSearchFileName						:= gCSV_Ctrl.In.Par.Path;
			strcat(ADR(ToSearchFileName), ADR(gCSV_Ctrl.In.Par.FileName));
			SearchFileName_CSVHandling.pFileName	:= ADR(ToSearchFileName);
			SearchFileName_CSVHandling.pDevice		:= ADR(gCSV_Ctrl.In.Par.FileDeviceName);
			
			//FUB execution
			SearchFileName_CSVHandling();
	
			//Chec if the FUB is done
			IF (SearchFileName_CSVHandling.status = ERR_FUB_BUSY) THEN
				//The FUB is busy
			ELSE
				IF (SearchFileName_CSVHandling.status = FILE_NOT_FOUND) THEN
					//FUB executed successfully, and the file does not exist -> Go to search variables that are part of the CSV file
					MainState							:= C_MS_CSV_FILE_HAND_SEARCH_VAR;
				ELSIF  (SearchFileName_CSVHandling.status = FILE_FOUND) THEN	
					//FUB executed successfully, the file already exists -> Set flag to show this state, wait for confirmation to overwrite the file
					gCSV_Ctrl.Out.Stat.FileAlreadyExists := TRUE;
					MainState							:= C_MS_CSV_FILE_HAND_WAIT_OVRW_OK;		
				ELSE
					//Error -> Save information about error
					gCSV_Ctrl.Out.Stat.Error.Number		:= SearchFileName_CSVHandling.status;
					gCSV_Ctrl.Out.Stat.Error.Text.Line1	:= TaskName;
					gCSV_Ctrl.Out.Stat.Error.Text.Line2	:= StateStrings[MainState];
					ErrorState							:= MainState;					
					MainState							:= C_MS_CSV_FILE_HAND_ERROR;
				END_IF	
			END_IF		
		
		//============================================================================================	
		C_MS_CSV_FILE_HAND_WAIT_OVRW_OK:			//WAIT FOR USER CONFIRMATION TO OVERWRITE THE FILE
			//============================================================================================		
			
			//Wait for an user command about the possibility of overwriting the file
			IF (gCSV_Ctrl.In.Cmd.OverwriteFile > OldInputs.Cmd.OverwriteFile) THEN
				//Reset flag and go to search variables that are part of the CSV file
				gCSV_Ctrl.Out.Stat.FileAlreadyExists 		:= FALSE;
				MainState									:= C_MS_CSV_FILE_HAND_SEARCH_VAR;
			ELSIF (gCSV_Ctrl.In.Cmd.NotOverwriteFile > OldInputs.Cmd.NotOverwriteFile) THEN
				//Set output status commands done, flag and go to wait command
				gCSV_Ctrl.Out.Stat.CmdDone.WriteFile			:= TRUE;
				gCSV_Ctrl.Out.Stat.CmdDone.NotOverwriteFile	:= TRUE;
				gCSV_Ctrl.Out.Stat.FileAlreadyExists 		:= FALSE;
				MainState									:= C_MS_CSV_FILE_HAND_WAIT_CMD;
			END_IF	
		
		//============================================================================================	
		C_MS_CSV_FILE_HAND_SEARCH_VAR:				//SEARCH VARIABLES THAT ARE PART OF THE CSV FILE
			//============================================================================================		
			
			//FUB parameters
			Search_CSVHandling.pStructName		:= Init_CSVHandling.pStructName;
			Search_CSVHandling.NumOfStructs		:= Init_CSVHandling.NumOfStructs;
			Search_CSVHandling.pStructMem		:= Init_CSVHandling.pStructMem;
			Search_CSVHandling.MemLen			:= Init_CSVHandling.MemCounter;
			Search_CSVHandling.Options			:= 0;
			Search_CSVHandling.FullNameLenght	:= C_SHOW_VAR_NAME_OPTION;
			Search_CSVHandling.FileHeader		:= gCSV_Ctrl.In.Par.Header.Enable;
			Search_CSVHandling.Separator		:= C_SEPARATOR; //Check constants to see the ASCII code
			Search_CSVHandling.pMaschineNo		:= ADR(gCSV_Ctrl.In.Par.Header.MachineNr);
			Search_CSVHandling.pComment			:= ADR(gCSV_Ctrl.In.Par.Header.Comment);
			Search_CSVHandling.pVersion			:= ADR(gCSV_Ctrl.In.Par.Header.Version);
			
			//FUB execution
			Search_CSVHandling;
	
			//Chec if the FUB is done
			IF (Search_CSVHandling.status = ERR_FUB_BUSY) THEN
				//The FUB is busy
			ELSE
				IF (Search_CSVHandling.status = ERR_OK) THEN
					//FUB executed successfully -> Go to write CSV file
					MainState							:= C_MS_CSV_FILE_HAND_WRITE;
				ELSE
					//Error -> Save information about error
					gCSV_Ctrl.Out.Stat.Error.Number		:= Search_CSVHandling.status;
					gCSV_Ctrl.Out.Stat.Error.Text.Line1	:= TaskName;
					gCSV_Ctrl.Out.Stat.Error.Text.Line2	:= StateStrings[MainState];
					ErrorState							:= MainState;					
					MainState							:= C_MS_CSV_FILE_HAND_ERROR;
				END_IF	
			END_IF		
		
		//============================================================================================	
		C_MS_CSV_FILE_HAND_WRITE:				//WRITE THE CSV FILE
			//============================================================================================		
			
			//FUB parameters
			WriteFile_CSVHandling.pFileName		:= ADR(gCSV_Ctrl.In.Par.FileName);
			WriteFile_CSVHandling.pDevice		:= ADR(gCSV_Ctrl.In.Par.FileDeviceName);
			WriteFile_CSVHandling.pPath			:= ADR(gCSV_Ctrl.In.Par.Path);
			WriteFile_CSVHandling.pStructMem	:= Init_CSVHandling.pStructMem;
			WriteFile_CSVHandling.MemLen		:= Search_CSVHandling.FileLen;	
			WriteFile_CSVHandling.Mode			:= FILE_OW; 
			
			//FUB execution
			WriteFile_CSVHandling;
	
			//Chec if the FUB is done
			IF (WriteFile_CSVHandling.status = ERR_FUB_BUSY) THEN
				//The FUB is busy
			ELSE
				IF (WriteFile_CSVHandling.status = ERR_OK) THEN
					//FUB executed successfully -> Go to wait command
					MainState									:= C_MS_CSV_FILE_HAND_WAIT_CMD;
					//Set output status command done
					gCSV_Ctrl.Out.Stat.CmdDone.WriteFile			:= TRUE;
					IF (gCSV_Ctrl.In.Cmd.OverwriteFile = TRUE) THEN
						gCSV_Ctrl.Out.Stat.CmdDone.OverwriteFile	:= TRUE;	
					END_IF	
				ELSE
					//Error -> Save information about error
					gCSV_Ctrl.Out.Stat.Error.Number				:= WriteFile_CSVHandling.status;
					gCSV_Ctrl.Out.Stat.Error.Text.Line1			:= TaskName;
					gCSV_Ctrl.Out.Stat.Error.Text.Line2			:= StateStrings[MainState];
					ErrorState									:= MainState;					
					MainState									:= C_MS_CSV_FILE_HAND_ERROR;
				END_IF	
			END_IF		
		
		//============================================================================================	
		C_MS_CSV_FILE_HAND_ERROR:				//ERROR HANDLING
			//============================================================================================	

			//Wait for user acknowledge
			IF (gCSV_Ctrl.In.Cmd.ErrorAcknowledge > OldInputs.Cmd.ErrorAcknowledge) THEN
				//The user wants to acknowledge the error -> Next step: Go to Acknowledge Error State
				MainState 				:= C_MS_CSV_FILE_HAND_ACK_ERROR;
			END_IF	
			
		//============================================================================================	
		C_MS_CSV_FILE_HAND_ACK_ERROR:			//ACKNOWLEDGE ERROR
			//============================================================================================				
			
			//Clear error information
			gCSV_Ctrl.Out.Stat.Error.Number				:= 0;
			memset(ADR(gCSV_Ctrl.Out.Stat.Error.Text), 0, SIZEOF(gCSV_Ctrl.Out.Stat.Error.Text));
			ErrorState									:= C_MS_CSV_FILE_HAND_NOERROR;
			MainState									:= C_MS_CSV_FILE_HAND_WAIT_CMD;
			//Error acknowledged
			gCSV_Ctrl.Out.Stat.CmdDone.ErrorAcknowledge	:= TRUE;
			//Acknowledge done -> Next step: Go to Init State 
			MainState 									:= C_MS_CSV_FILE_HAND_INIT;
		
		ELSE
						
			//============================================================================================		
						
			//The program sould not come here
			MainState 								:= C_MS_CSV_FILE_HAND_ERROR;
			gCSV_Ctrl.Out.Stat.Error.Number			:= 0;
			gCSV_Ctrl.Out.Stat.Error.Text.Line1		:= TaskName;
			gCSV_Ctrl.Out.Stat.Error.Text.Line2		:= 'Not defined state in state machine';
			ErrorState								:= MainState;
			MainState								:= C_MS_CSV_FILE_HAND_ERROR;
									
			//============================================================================================	
					
	END_CASE	

	TON_Init();
	//Update old inputs variable
	OldInputs	:= gCSV_Ctrl.In;	
	
	//Update outputs
	Action_Output;
	
END_PROGRAM
