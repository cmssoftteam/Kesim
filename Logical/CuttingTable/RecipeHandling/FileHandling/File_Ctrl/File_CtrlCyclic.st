(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: gFile_Ctrl
 * File: gFile_CtrlCyclic.st
 * Author: blanca-gutim
 * Created: December 06, 2012
 ********************************************************************
 * Implementation of program gFile_Ctrl
 ********************************************************************)

 (********************************************************************
  * FORMAT OF FILE DEVICES STRING PARAMETERS
  *	CF: 		'/DEVICE=C:\\'																			
  *				-> The path of the directory that will be the file device is needed												
  * USB:		'/DEVICE=IF4.ST1'																		
  *				-> The path of the directory that will be the file device is needed	
  * FTP:		'/SIP=172.16.1.198 /SNAME=FTP_SERV1 /PROTOCOL=ftp /USER=max /PASSWORD=passw'			
  *				-> Only the IP address of the FTP server is needed
  * NETWORK: 	'/PROTOCOL=cifs /SIP=192.168.90.121 /SHARE=ShareDir /USER=blanca-gutim /PASSWORD=passw /DOMAIN=BRATEGGE'
  *				-> The following requirements must be done to work with NETWORK file devices
  *					-> SIP=192.168.90.121 	= IP address of the system (PC for example) where the Shared Directory is located
  *					-> SHARE 				= Name of the Sagred folder in the network 
  *					-> USER					= User name in the network (there must be a user defined in the network in order to have access to it)
  *					-> PASSWORD				= User password in the network (there must be a user defined in the network in order to have access to it)
  *					-> DOMAIN				= Name of the network Workgroup (it is possibel to check the name in "Windows Explorer -> Network section" in the left side of the screen)
  *					-> The Shared Directory in the network must be created in the source system and configured properly to permit access
  ********************************************************************)

PROGRAM _CYCLIC
	
	//Update inputs
	Action_Input;
	
	//====================================================================================================
	//	
	//									MAIN STATE MACHINE
	//	
	//====================================================================================================

	CASE MainState OF
		
		//============================================================================================	
		C_MS_FILE_HAND_INIT:						//INITIALIZATION STATE
		//============================================================================================	

			//The file handling task doesn´t need to perform any special action
			MainState 			:= C_MS_FILE_HAND_WAIT_CMD;
												
		//============================================================================================						
		C_MS_FILE_HAND_WAIT_CMD:					//READY STATE
		//============================================================================================			
													
			//WAIT FOR COMMANDS
			IF (gFile_Ctrl.Out.Stat.ReadyForCmd = TRUE) THEN
				IF (gFile_Ctrl.In.Cmd.LinkFileDevice > OldInputs.Cmd.LinkFileDevice) THEN
					//Go to Link File Device state
					MainState			:= C_MS_FILE_HAND_LINK_FILE_DEV;
				ELSIF (gFile_Ctrl.In.Cmd.GetFileDeviceInfo > OldInputs.Cmd.GetFileDeviceInfo) THEN
					//Go to Get File Device Information state
					MainState			:= C_MS_FILE_HAND_GET_DEV_INFO;				
				ELSIF (gFile_Ctrl.In.Cmd.UnlinkFileDevice > OldInputs.Cmd.UnlinkFileDevice) THEN
					//Go to Unlink File Device state
					MainState			:= C_MS_FILE_HAND_UNLINK_FILE_DEV;
				ELSIF (gFile_Ctrl.In.Cmd.DeleteFile > OldInputs.Cmd.DeleteFile) THEN	
					//Go to Delete File state
					MainState			:= C_MS_FILE_HAND_DELETE_FILE;
				ELSIF (gFile_Ctrl.In.Cmd.ReadDirectory > OldInputs.Cmd.ReadDirectory) THEN	
					//Reset the memory area where the data is stored
					memset(ADR(gFile_Ctrl.Out.Stat.DirectoryInformation.ElementsInfo), 0, SIZEOF(gFile_Ctrl.Out.Stat.DirectoryInformation.ElementsInfo));				
					//Go to Open Directory state
					MainState			:= C_MS_FILE_HAND_OPEN_DIR;				
				ELSE
					//Stay in Wait Command state
					MainState 			:= C_MS_FILE_HAND_WAIT_CMD;
				END_IF	
			END_IF
				
			//Update the output ReadyForCmd
			IF (MainState = C_MS_FILE_HAND_WAIT_CMD) THEN
				gFile_Ctrl.Out.Stat.ReadyForCmd	:= TRUE;
			ELSE
				gFile_Ctrl.Out.Stat.ReadyForCmd	:= FALSE;
			END_IF	

		//============================================================================================	
		C_MS_FILE_HAND_LINK_FILE_DEV:		//LINK FILE DEVICE
		//============================================================================================	
	
			//Enable FUB
			DevLink_FileHandling.enable		:= TRUE;
			
			//Update FUB parameters
			DevLink_FileHandling.pDevice	:= ADR(gFile_Ctrl.In.Par.DeviceName);
			DevLink_FileHandling.pParam		:= ADR(gFile_Ctrl.In.Par.ParameterString);
			
			//FUB execution
			DevLink_FileHandling();
	
			//Wait for FUB execution
			IF (DevLink_FileHandling.status = ERR_FUB_BUSY) THEN
				//FUB busy
			ELSE	
				//Check if the FUB execution is finished or there is an error
				IF (DevLink_FileHandling.status = ERR_OK) THEN
					//FUB executed successfully -> Save output information and go to Wait command state
					gFile_Ctrl.Out.Stat.FileDeviceInfo.FileDeviceLinked 	:= TRUE;
					gFile_Ctrl.Out.Stat.FileDeviceInfo.FileDeviceHandle	:= DevLink_FileHandling.handle;
					gFile_Ctrl.Out.Stat.FileDeviceInfo.Name				:= gFile_Ctrl.In.Par.DeviceName;
					MainState											:= C_MS_FILE_HAND_WAIT_CMD;
					//Set command done
					gFile_Ctrl.Out.Stat.CmdDone.LinkFileDevice			:= TRUE;
				ELSE
					//ERROR in FUB -> Save error information and go to Error State
					gFile_Ctrl.Out.Stat.Error.Number		:= UINT_TO_UDINT(DevLink_FileHandling.status);
					gFile_Ctrl.Out.Stat.Error.Text.Line1	:= TaskName;
					gFile_Ctrl.Out.Stat.Error.Text.Line2	:= StateStrings[MainState];
					ErrorState							:= MainState;					
					MainState							:= C_MS_FILE_HAND_ERROR;
				END_IF	
				//Reset enable FUB input
				DevLink_FileHandling.enable	:= FALSE;
			END_IF		
	
		//============================================================================================	
		C_MS_FILE_HAND_GET_DEV_INFO:		//GET FILE DEVICE INFORMATION
		//============================================================================================	
	
			//Enable FUB
			DevMemInfo_FileHandling.enable		:= TRUE;
		
			//Update FUB parameters
			DevMemInfo_FileHandling.pDevice		:= ADR(gFile_Ctrl.Out.Stat.FileDeviceInfo.Name);			
			
			//FUB execution
			DevMemInfo_FileHandling();
	
			//Wait for FUB execution
			IF (DevMemInfo_FileHandling.status = ERR_FUB_BUSY) THEN
				//FUB busy
			ELSE	
				//Check if the FUB execution is finished or there is an error
				IF (DevMemInfo_FileHandling.status = ERR_OK) THEN
					//FUB executed successfully -> Save output information and go to Wait command state
					gFile_Ctrl.Out.Stat.FileDeviceInfo.FreeMem		:= DevMemInfo_FileHandling.freemem;
					gFile_Ctrl.Out.Stat.FileDeviceInfo.TotalMem		:= DevMemInfo_FileHandling.memsize;
					MainState										:= C_MS_FILE_HAND_WAIT_CMD;
					//Set command done
					gFile_Ctrl.Out.Stat.CmdDone.GetFileDeviceInfo	:= TRUE;
				ELSE
					//ERROR in FUB -> Save error information and go to Error State
					gFile_Ctrl.Out.Stat.Error.Number					:= UINT_TO_UDINT(DevMemInfo_FileHandling.status);
					gFile_Ctrl.Out.Stat.Error.Text.Line1				:= TaskName;
					gFile_Ctrl.Out.Stat.Error.Text.Line2				:= StateStrings[MainState];
					ErrorState										:= MainState;										
					MainState										:= C_MS_FILE_HAND_ERROR;					
				END_IF	
				//Reset enable FUB input
				DevMemInfo_FileHandling.enable						:= FALSE;
			END_IF		
	
		//============================================================================================	
		C_MS_FILE_HAND_UNLINK_FILE_DEV:		//UNLINK FILE DEVICE
		//============================================================================================	
	
			//Enable FUB
			DevUnlink_FileHandling.enable		:= TRUE;
		
			//Update FUB parameters
			DevUnlink_FileHandling.handle		:= gFile_Ctrl.Out.Stat.FileDeviceInfo.FileDeviceHandle;			
			
			//FUB execution
			DevUnlink_FileHandling();
	
			//Wait for FUB execution
			IF (DevUnlink_FileHandling.status = ERR_FUB_BUSY) THEN
				//FUB busy
			ELSE	
				//Check if the FUB execution is finished or there is an error
				IF (DevUnlink_FileHandling.status = ERR_OK) THEN
					//FUB executed successfully -> Save output information and go to Wait command state
					gFile_Ctrl.Out.Stat.FileDeviceInfo.FileDeviceLinked 	:= FALSE;
					gFile_Ctrl.Out.Stat.FileDeviceInfo.FileDeviceHandle	:= 0;
					gFile_Ctrl.Out.Stat.FileDeviceInfo.Name				:= '';		
					gFile_Ctrl.Out.Stat.FileDeviceInfo.FreeMem			:= 0;
					gFile_Ctrl.Out.Stat.FileDeviceInfo.TotalMem			:= 0;
					MainState											:= C_MS_FILE_HAND_WAIT_CMD;
					//Set command done
					gFile_Ctrl.Out.Stat.CmdDone.UnlinkFileDevice			:= TRUE;
				ELSE
					//ERROR in FUB -> Save error information and go to Error State
					gFile_Ctrl.Out.Stat.Error.Number					:= UINT_TO_UDINT(DevUnlink_FileHandling.status);
					gFile_Ctrl.Out.Stat.Error.Text.Line1				:= TaskName;
					gFile_Ctrl.Out.Stat.Error.Text.Line2				:= StateStrings[MainState];
					ErrorState											:= MainState;									
					MainState											:= C_MS_FILE_HAND_ERROR;
				END_IF	
				//Reset enable FUB input
				DevUnlink_FileHandling.enable	:= FALSE;
			END_IF		
	
		//============================================================================================	
		C_MS_FILE_HAND_DELETE_FILE:			//DELETE FILE
		//============================================================================================	
	
			//Enable FUB
			FileDelete_FileHandling.enable		:= TRUE;
		
			//Update FUB parameters
			FileDelete_FileHandling.pDevice		:= ADR(gFile_Ctrl.Out.Stat.FileDeviceInfo.Name);
			FileDelete_FileHandling.pName		:= ADR(gFile_Ctrl.In.Par.FileName);			
			
			//FUB execution
			FileDelete_FileHandling();
	
			//Wait for FUB execution
			IF (FileDelete_FileHandling.status = ERR_FUB_BUSY) THEN
				//FUB busy
			ELSE	
				//Check if the FUB execution is finished or there is an error
				IF (FileDelete_FileHandling.status = ERR_OK) THEN
					//FUB executed successfully -> Go to Wait command state
					MainState								:= C_MS_FILE_HAND_WAIT_CMD;
					//Set command done
					gFile_Ctrl.Out.Stat.CmdDone.DeleteFile	:= TRUE;
				ELSE
					//ERROR in FUB -> Save error information and go to Error State
					gFile_Ctrl.Out.Stat.Error.Number			:= UINT_TO_UDINT(FileDelete_FileHandling.status);
					gFile_Ctrl.Out.Stat.Error.Text.Line1		:= TaskName;
					gFile_Ctrl.Out.Stat.Error.Text.Line2		:= StateStrings[MainState];
					ErrorState								:= MainState;									
					MainState								:= C_MS_FILE_HAND_ERROR;
				END_IF	
				//Reset enable FUB input
				FileDelete_FileHandling.enable	:= FALSE;
			END_IF			
	
		//============================================================================================	
		C_MS_FILE_HAND_OPEN_DIR:			//OPEN DIRECTORY
		//============================================================================================	
	
			//Enable FUB
			DirOpen_FileHandling.enable		:= TRUE;
		
			//Update parameters
			DirOpen_FileHandling.pDevice	:=	ADR(gFile_Ctrl.Out.Stat.FileDeviceInfo.Name);
			DirOpen_FileHandling.pName		:= 	ADR(gFile_Ctrl.In.Par.DirectoryName);
			
			//FUB execution
			DirOpen_FileHandling();
	
			//Wait for FUB execution
			IF (DirOpen_FileHandling.status = ERR_FUB_BUSY) THEN
				//FUB busy
			ELSE	
				//Check if the FUB execution is finished or there is an error
				IF (DirOpen_FileHandling.status = ERR_OK) THEN
					//FUB executed successfully -> Go to Read Directory state
					MainState					:= C_MS_FILE_HAND_READ_DIR;
					//Reset index to count elements into the directory
					jj 							:= 0;
					//Reset output information about directory
					memset(ADR(gFile_Ctrl.Out.Stat.DirectoryInformation), 0, SIZEOF(gFile_Ctrl.Out.Stat.DirectoryInformation));
				ELSIF (DirOpen_FileHandling.status = fiERR_DIR_NOT_EXIST) THEN
					//The directory is not found, create it
					MainState					:= C_MS_FILE_HAND_CREATE_DIR;
				ELSE
					//ERROR in FUB -> Save error information and go to Error State
					gFile_Ctrl.Out.Stat.Error.Number			:= UINT_TO_UDINT(DirOpen_FileHandling.status);
					gFile_Ctrl.Out.Stat.Error.Text.Line1		:= TaskName;
					gFile_Ctrl.Out.Stat.Error.Text.Line2		:= StateStrings[MainState];
					ErrorState									:= MainState;
					MainState									:= C_MS_FILE_HAND_ERROR;
				END_IF	
				//Reset enable FUB input
				DirOpen_FileHandling.enable	:= FALSE;
			END_IF	
	
		//============================================================================================	
		C_MS_FILE_HAND_CREATE_DIR:			//CREATE FILE
		//============================================================================================	
	
			//Enable FUB
			DirCreate_FileHandling.enable		:= TRUE;
		
			//Update FUB parameters
			DirCreate_FileHandling.pDevice		:=	ADR(gFile_Ctrl.Out.Stat.FileDeviceInfo.Name);
			DirCreate_FileHandling.pName		:= 	ADR(gFile_Ctrl.In.Par.DirectoryName);		
			
			//FUB execution
			DirCreate_FileHandling();
	
			//Wait for FUB execution
			IF (DirCreate_FileHandling.status = ERR_FUB_BUSY) THEN
				//FUB busy
			ELSE	
				//Check if the FUB execution is finished or there is an error
				IF (DirCreate_FileHandling.status = ERR_OK) THEN
					//FUB executed successfully -> Go to Wait command state
					MainState									:= C_MS_FILE_HAND_OPEN_DIR;
				ELSE
					//ERROR in FUB -> Save error information and go to Error State
					gFile_Ctrl.Out.Stat.Error.Number			:= UINT_TO_UDINT(DirCreate_FileHandling.status);
					gFile_Ctrl.Out.Stat.Error.Text.Line1		:= TaskName;
					gFile_Ctrl.Out.Stat.Error.Text.Line2		:= StateStrings[MainState];
					ErrorState									:= MainState;									
					MainState									:= C_MS_FILE_HAND_ERROR;
				END_IF	
				//Reset enable FUB input
				DirCreate_FileHandling.enable	:= FALSE;
			END_IF		
		
		//============================================================================================	
		C_MS_FILE_HAND_READ_DIR:			//READ DIRECTORY
		//============================================================================================	
	
			//Enable FUB
			DirReadEx_FileHandling.enable		:= TRUE;
		
			//FUB parameters
			DirReadEx_FileHandling.pData		:= ADR(gFile_Ctrl.Out.Stat.DirectoryInformation.ElementsInfo[jj]);
			DirReadEx_FileHandling.ident		:= DirOpen_FileHandling.ident;
			DirReadEx_FileHandling.data_len		:= SIZEOF(gFile_Ctrl.Out.Stat.DirectoryInformation.ElementsInfo[0]);
		
			//FUB execution
			DirReadEx_FileHandling();

            IF jj >= C_MAX_NR_ELEMENTS_IN_DIR_MINUS1 THEN
                gFile_Ctrl.Out.Stat.Error.Number		:= 99998;
	            gFile_Ctrl.Out.Stat.Error.Text.Line1	:= TaskName;
	            gFile_Ctrl.Out.Stat.Error.Text.Line2	:= 'Too many files in directory';	
	            ErrorState								:= MainState;
	            MainState								:= C_MS_FILE_HAND_ERROR ;
            END_IF

	
			//Wait for FUB execution
			IF (DirReadEx_FileHandling.status = ERR_FUB_BUSY) THEN
				//FUB busy
			ELSE	
				//Check if the FUB execution is finished or there is an error
				IF (DirReadEx_FileHandling.status = fiERR_NO_MORE_ENTRIES ) THEN
					//Save number of files and directories
					gFile_Ctrl.Out.Stat.DirectoryInformation.NrDirectories	:= 0;
					gFile_Ctrl.Out.Stat.DirectoryInformation.NrFiles			:= 0;
					//Save the information only when the directory is not empty
					IF (jj <> 0) THEN
						FOR kk := 0 TO (jj - 1) BY 1 DO
							IF (gFile_Ctrl.Out.Stat.DirectoryInformation.ElementsInfo[kk].Mode = fiFILE) THEN
								gFile_Ctrl.Out.Stat.DirectoryInformation.NrFiles 		:= gFile_Ctrl.Out.Stat.DirectoryInformation.NrFiles + 1;	
							ELSIF (gFile_Ctrl.Out.Stat.DirectoryInformation.ElementsInfo[kk].Mode = fiDIRECTORY) THEN
								gFile_Ctrl.Out.Stat.DirectoryInformation.NrDirectories 	:= gFile_Ctrl.Out.Stat.DirectoryInformation.NrDirectories + 1;
							END_IF	
						END_FOR	
					END_IF	
					//FUB executed successfully -> Go to Close Directory state
					MainState								:= C_MS_FILE_HAND_CLOSE_DIR;
				ELSIF (DirReadEx_FileHandling.status = ERR_OK) THEN	
					//Increment index to save the information
					jj 										:= jj + 1;
				ELSE
					//ERROR in FUB -> Save error information and go to Error State
					gFile_Ctrl.Out.Stat.Error.Number			:= UINT_TO_UDINT(DirReadEx_FileHandling.status);
					gFile_Ctrl.Out.Stat.Error.Text.Line1		:= TaskName;
					gFile_Ctrl.Out.Stat.Error.Text.Line2		:= StateStrings[MainState];	
					ErrorState								:= MainState;
					MainState								:= C_MS_FILE_HAND_ERROR;
				END_IF	
				//Reset enable FUB input
				DirReadEx_FileHandling.enable	:= FALSE;
			END_IF	
	
		//============================================================================================	
		C_MS_FILE_HAND_CLOSE_DIR:			//CLOSE DIRECTORY
		//============================================================================================	
	
			//Enable FUB
			DirClose_FileHandling.enable		:= TRUE;
		
			//Update FUB parameters
			DirClose_FileHandling.ident			:= DirOpen_FileHandling.ident;
			
			//FUB execution
			DirClose_FileHandling();
	
			//Wait for FUB execution
			IF (DirClose_FileHandling.status = ERR_FUB_BUSY) THEN
				//FUB busy
			ELSE	
				//Check if the FUB execution is finished or there is an error
				IF (DirClose_FileHandling.status = ERR_OK) THEN
					//FUB executed successfully -> Go to Wait command state
					MainState									:= C_MS_FILE_HAND_WAIT_CMD;
					//Set command done
					gFile_Ctrl.Out.Stat.CmdDone.ReadDirectory	:= TRUE;				
				ELSE
					//ERROR in FUB -> Save error information and go to Error State
					gFile_Ctrl.Out.Stat.Error.Number				:= UINT_TO_UDINT(DirClose_FileHandling.status);
					gFile_Ctrl.Out.Stat.Error.Text.Line1			:= TaskName;
					gFile_Ctrl.Out.Stat.Error.Text.Line2			:= StateStrings[MainState];
					ErrorState									:= MainState;
					MainState									:= C_MS_FILE_HAND_ERROR;
				END_IF	
				//Reset enable FUB input
				DirClose_FileHandling.enable					:= FALSE;
			END_IF		
	
		//============================================================================================	
		C_MS_FILE_HAND_ERROR:				//ERROR HANDLING
		//============================================================================================	
	
			//Wait for user acknowledge
			IF (gFile_Ctrl.In.Cmd.ErrorAcknowledge > OldInputs.Cmd.ErrorAcknowledge) THEN
				//The user wants to acknowledge the error -> Next step: Go to Acknowledge Error State
				MainState 			:= C_MS_FILE_HAND_ACK_ERROR;
			END_IF		
		
		//============================================================================================	
		C_MS_FILE_HAND_ACK_ERROR:			//ACKNOWLEDGE ERROR
		//============================================================================================				
		
			//Clear error information
			gFile_Ctrl.Out.Stat.Error.Number				:= 0;
			memset(ADR(gFile_Ctrl.Out.Stat.Error.Text), 0, SIZEOF(gFile_Ctrl.Out.Stat.Error.Text));
			ErrorState									:= C_MS_FILE_HAND_NOERROR;
			MainState									:= C_MS_FILE_HAND_WAIT_CMD;
			//Error acknowledged
			gFile_Ctrl.Out.Stat.CmdDone.ErrorAcknowledge	:= TRUE;
			//Acknowledge done -> Next step: Go to Init State 
			MainState 									:= C_MS_FILE_HAND_INIT;
	
		ELSE
					
			//============================================================================================		
					
			//The program sould not come here
			MainState 								:= C_MS_FILE_HAND_ERROR;
			gFile_Ctrl.Out.Stat.Error.Number			:= 0;
			gFile_Ctrl.Out.Stat.Error.Text.Line1		:= TaskName;
			gFile_Ctrl.Out.Stat.Error.Text.Line2		:= 'Not defined state in state machine';
			ErrorState								:= MainState;
			MainState								:= C_MS_FILE_HAND_ERROR;			
								
			//============================================================================================	
				
	END_CASE
		
	//Update old inputs variable
	OldInputs	:= gFile_Ctrl.In;
	
	//Update outputs
	Action_Output;
		
END_PROGRAM