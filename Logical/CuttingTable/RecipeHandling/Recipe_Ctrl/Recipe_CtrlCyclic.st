(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * PROGRAM: gRecipe_Ctrl
 * File: gRecipe_CtrlCyclic.st
 * Author: blanca-gutim
 * Created: December 04, 2012
 ********************************************************************
 * Implementation OF PROGRAM gRecipe_Ctrl
 ********************************************************************)

PROGRAM _CYCLIC

	IF uAdr <> 0 AND stat = 0 THEN
		//Update inputs
		Action_Input;
	
		//Control of the process if the USB is selected as File Device, but it is removed manually
		IF ( (gRecipe_Ctrl.In.Stat.FileHandling.UsbInformation[0].ifName = '') AND (gRecipe_Ctrl.In.Par.Source = C_FILE_DEVICE_USB) ) THEN
			//Change device index to CF and go to Unlink file device
			gRecipe_Ctrl.In.Par.Source 						:= C_FILE_DEVICE_CF;
		END_IF	
	
		//Check for errors
		Action_CheckError;
	
		//Pop up message informing user about file operation is being executed
		//    IF (MainState = C_MS_RECIPE_HAND_DELETE OR MainState = C_MS_RECIPE_HAND_LOAD OR
		//       MainState = C_MS_RECIPE_HAND_OVERWRITE OR MainState = C_MS_RECIPE_HAND_SAVE) AND gHMI.Others.PopUpRequest = 1  THEN
		//        gHMI.Others.PopUpRequest	        	:= 0;
		//        gHMI.Others.PopUpRequestIndex                       := 207;
		//  
		//    END_IF
		IF (gRecipe_Ctrl.In.Cmd.DeleteRecipe > OldInputs.Cmd.DeleteRecipe) OR (gRecipe_Ctrl.In.Cmd.LoadRecipe > OldInputs.Cmd.LoadRecipe) OR
			(gRecipe_Ctrl.In.Cmd.SaveRecipe > OldInputs.Cmd.SaveRecipe) OR (gRecipe_Ctrl.In.Cmd.Refresh > OldInputs.Cmd.Refresh)           OR 
			(gRecipe_Ctrl.In.Cmd.OverwriteRecipe > OldInputs.Cmd.OverwriteRecipe)                                                          THEN
			gHMI.Others.PopUpRequestIndex := 207;
			gHMI.Others.PopUpRequest	  := 0;
			gHMI.Others.PopUpBtnCancStat  := HIDE_OBJ;
			gHMI.Others.PopUpBtnOkStat    := HIDE_OBJ;            
		END_IF

		IF (gRecipe_Ctrl.Out.Stat.CmdDone.DeleteRecipe > OldOutputStatus.CmdDone.DeleteRecipe)       OR
			(gRecipe_Ctrl.Out.Stat.CmdDone.LoadRecipe > OldOutputStatus.CmdDone.LoadRecipe)           OR 
			(gRecipe_Ctrl.Out.Stat.CmdDone.SaveRecipe > OldOutputStatus.CmdDone.SaveRecipe)           OR
			(gRecipe_Ctrl.Out.Stat.CmdDone.Refresh > OldOutputStatus.CmdDone.Refresh)                 OR 
			(gRecipe_Ctrl.Out.Stat.CmdDone.OverwriteRecipe > OldOutputStatus.CmdDone.OverwriteRecipe) THEN
			gHMI.Others.PopUpRequestIndex := 0; 
			gHMI.Others.PopUpRequest	  := 1;
         
		END_IF 


		//====================================================================================================
		//	
		//									MAIN STATE MACHINE
		//	
		//====================================================================================================	
	
		CASE MainState OF
		
			//============================================================================================	
			C_MS_RECIPE_HAND_INIT:						//INITIALIZATION STATE
				//============================================================================================	

				//TWait for the low-level task to be ready
				IF ( (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE) AND (gRecipe_Ctrl.In.Stat.CsvHandling.ReadyForCmd = TRUE) ) THEN
					//Tasks ready, link the sourde file device if necessary. When there is a recover from an error is not necessary
					IF (gRecipe_Ctrl.In.Stat.FileHandling.FileDeviceInfo.FileDeviceLinked = FALSE) THEN
						//It is necessary to link the file device
						MainState 			:= C_MS_RECIPE_HAND_SET_DEVPAR;
					ELSE
						//It is not necessary to link the file device
						MainState 			:= C_MS_RECIPE_HAND_LIST;
					END_IF	
				END_IF	
		
			//============================================================================================	
			C_MS_RECIPE_HAND_SET_DEVPAR:				//PREPARE STRING PARAMETER FOR SOURCE DEVICE 
				//============================================================================================	
	
				//Set the format to the Parameter string to Link the file device
				IF (gRecipe_Ctrl.Out.Cmd.FileHandling.LinkFileDevice = FALSE) AND (gRecipe_Ctrl.In.Stat.FileHandling.FileDeviceInfo.FileDeviceLinked = FALSE) THEN
					IF (gRecipe_Ctrl.In.Par.Source = C_FILE_DEVICE_CF) THEN
						//CF
						gRecipe_Ctrl.Out.Par.FileHandling.ParameterString			:= '/DEVICE=C:\\';
						gRecipe_Ctrl.Out.Par.FileHandling.DeviceName				:= 'CF';
					ELSIF (gRecipe_Ctrl.In.Par.Source = C_FILE_DEVICE_USB) THEN
						//USB
						gRecipe_Ctrl.Out.Par.FileHandling.DeviceName				:= 'USB';
						gRecipe_Ctrl.Out.Par.FileHandling.ParameterString			:= '/DEVICE=';
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gRecipe_Ctrl.In.Stat.FileHandling.UsbInformation[0].ifName));
					ELSIF (gRecipe_Ctrl.In.Par.Source = C_FILE_DEVICE_FTP) THEN
						//FTP			
						gRecipe_Ctrl.Out.Par.FileHandling.DeviceName				:= 'FTP';
						gRecipe_Ctrl.Out.Par.FileHandling.ParameterString			:= '/PROTOCOL=ftp /SIP=';
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.Server));
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(' /SNAME=FTP_SERV /PROTOCOL=ftp /USER=max /PASSWORD=passw'));				
					ELSIF (gRecipe_Ctrl.In.Par.Source = C_FILE_DEVICE_NETWORK) THEN
						//Network
						gRecipe_Ctrl.Out.Par.FileHandling.DeviceName				:= 'NET';
						gRecipe_Ctrl.Out.Par.FileHandling.ParameterString			:= '/PROTOCOL=cifs /SIP=';
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.Server));
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(' /SHARE='));
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.DirName));
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(' /USER='));
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.UserName));
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(' /PASSWORD='));
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.Password));
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(' /DOMAIN='));
						strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.Workgroup));
					END_IF
				END_IF	
		
				//Set next state depending on the source device. For the FTP and NETWORK a PING command is sent
				IF ( (gRecipe_Ctrl.In.Par.Source = C_FILE_DEVICE_FTP) OR (gRecipe_Ctrl.In.Par.Source = C_FILE_DEVICE_NETWORK) ) THEN
					//Send PING command
					MainState		:= C_MS_RECIPE_HAND_PING;
				ELSE
					//Link source device
					MainState		:= C_MS_RECIPE_HAND_LINK_DEV;
				END_IF	
			
			//============================================================================================	
			C_MS_RECIPE_HAND_PING:				//Send PING command to the Source device
				//============================================================================================	
		
				//Send PING command to the network device
				IcmpPing_NetworkDevice(enable := TRUE, pHost := ADR(gRecipe_Ctrl.In.Par.Network.Server), timeout := C_PING_NETWORK_DEVICE_TIMEOUT);
				//Checking the state of the function
				IF (IcmpPing_NetworkDevice.status = ERR_OK) THEN	
					//The network device was found, continue. Link file device
					MainState										:= C_MS_RECIPE_HAND_LINK_DEV;
					IcmpPing_NetworkDevice.enable 					:= FALSE;
				ELSIF (IcmpPing_NetworkDevice.status = ERR_FUB_BUSY) THEN	
					//Busy, connecting to the network device	
				ELSE	
					//Error in function to send the PING command
					IcmpPing_NetworkDevice.enable 					:= FALSE;
					//Error, the network device is not found
					gRecipe_Ctrl.Out.Stat.Error.Number				:= UINT_TO_UDINT(IcmpPing_NetworkDevice.status);
					gRecipe_Ctrl.Out.Stat.Error.Text.Line1			:= TaskName;
					gRecipe_Ctrl.Out.Stat.Error.Text.Line2			:= StateStrings[MainState];
					ErrorState										:= MainState;					
					MainState										:= C_MS_RECIPE_HAND_ERROR;
				END_IF
		
			//============================================================================================	
			C_MS_RECIPE_HAND_LINK_DEV:			//LINK FILE DEVICE
				//============================================================================================				
			
				//Send command to execute the action when the File handling task is ready and a File Devcie has not been previously linked
				IF ( (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE) AND (gRecipe_Ctrl.In.Stat.FileHandling.FileDeviceInfo.FileDeviceLinked = FALSE) ) THEN
					//The parameter string is managed before coming to this state depending on the situation
					gRecipe_Ctrl.Out.Cmd.FileHandling.LinkFileDevice				:= TRUE;
				ELSIF (gRecipe_Ctrl.In.Stat.FileHandling.FileDeviceInfo.FileDeviceLinked = TRUE) AND (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE)
					AND (gRecipe_Ctrl.In.Stat.FileHandling.CmdDone.LinkFileDevice = TRUE) THEN
					//The file device has been linked, reset command
					gRecipe_Ctrl.Out.Cmd.FileHandling.LinkFileDevice				:= FALSE;
					//Make list of recipes
					MainState														:= C_MS_RECIPE_HAND_LIST;
				END_IF			
						
			//============================================================================================	
			C_MS_RECIPE_HAND_LIST:			//GET LIST OF RECIPES
				//============================================================================================				
			
				//Send command to execute the action when the File handling task is ready and a File Devcie has not been previously linked
				IF (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE) AND (gRecipe_Ctrl.Out.Cmd.FileHandling.ReadDirectory = FALSE) THEN
					//Set parameter to read directory
					gRecipe_Ctrl.Out.Par.FileHandling.DirectoryName				:= C_USER_DIRECTORY;
					//Set command to read the directory
					gRecipe_Ctrl.Out.Cmd.FileHandling.ReadDirectory				:= TRUE;
				ELSIF (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE) AND (gRecipe_Ctrl.In.Stat.FileHandling.CmdDone.ReadDirectory = TRUE) THEN
					//The directory has been read, reset command and save the information
					gRecipe_Ctrl.Out.Cmd.FileHandling.ReadDirectory				:= FALSE;
					//Save the information if there are files or directory found
					IF ( gRecipe_Ctrl.In.Stat.FileHandling.DirectoryInformation.NrFiles > 0 ) THEN
						ii	:= 0;
						memset(ADR(gRecipe_Ctrl.Out.Stat.RecipeList), 0, SIZEOF(gRecipe_Ctrl.Out.Stat.RecipeList));
						FOR kk := 0 TO (gRecipe_Ctrl.In.Stat.FileHandling.DirectoryInformation.NrFiles + gRecipe_Ctrl.In.Stat.FileHandling.DirectoryInformation.NrDirectories - 1) BY 1 DO
							//Save the recipe name indexed by kk
							memcpy(ADR(SaveFileName), ADR(gRecipe_Ctrl.In.Stat.FileHandling.DirectoryInformation.ElementsInfo[kk].Filename), SIZEOF(SaveFileName));
							//Search for the CSV extension and save only this type of files
							IF (FIND(SaveFileName, C_FILE_EXTENSION_LOW) <> 0) OR (FIND(SaveFileName, C_FILE_EXTENSION) <> 0) THEN
								//CSV file found, save name
								gRecipe_Ctrl.Out.Stat.RecipeList[ii] 			:= SaveFileName; 
								ii												:= ii + 1;
							END_IF	
						END_FOR		
						//Update number of recipes: it will be 0 when there are not recipes
						IF (ii <> 0) THEN
							gRecipe_Ctrl.Out.Stat.NrRecipes						:= ii - 1;		//-1 because the index of the recipes will start with 0
						ELSE
							gRecipe_Ctrl.Out.Stat.NrRecipes						:= 0;
						END_IF					
						//Sort the recipes by name when there are more than 1
						IF (gRecipe_Ctrl.Out.Stat.NrRecipes > 0) THEN
							Action_SortRecipes;					
						END_IF
					ELSE
						//No files in the list
						memset(ADR(gRecipe_Ctrl.Out.Stat.RecipeList), 0, SIZEOF(gRecipe_Ctrl.Out.Stat.RecipeList));
					END_IF	
					//Go to wait command state
					gHMI.Others.PopUpRequest := HIDE_OBJ;
					MainState				 := C_MS_RECIPE_HAND_WAIT_CMD;
					//Check if the Refresh command was used or not
					IF (gRecipe_Ctrl.In.Cmd.Refresh = TRUE) THEN
						//Set Refresh output command done
						gRecipe_Ctrl.Out.Stat.CmdDone.Refresh					:= TRUE;
					END_IF	
				END_IF		
		
			//============================================================================================						
			C_MS_RECIPE_HAND_WAIT_CMD:					//READY STATE
				//============================================================================================			
													
				//WAIT FOR COMMANDS
				IF (gRecipe_Ctrl.Out.Stat.ReadyForCmd = TRUE) THEN
					IF (gRecipe_Ctrl.In.Cmd.DeleteRecipe > OldInputs.Cmd.DeleteRecipe) THEN
						//Go to Delete recipe state
						MainState			:= C_MS_RECIPE_HAND_DELETE;
					ELSIF (gRecipe_Ctrl.In.Cmd.LoadRecipe > OldInputs.Cmd.LoadRecipe) THEN
						//Go to Load Recipe state
						MainState			:= C_MS_RECIPE_HAND_LOAD;				
					ELSIF (gRecipe_Ctrl.In.Cmd.SaveRecipe > OldInputs.Cmd.SaveRecipe) THEN
						IF (gRecipe_Ctrl.In.Par.RecipeName = '') THEN
							gRecipe_Ctrl.In.Par.RecipeName := gRecipe_Ctrl.Out.Stat.RecipeList[gRecipe_Ctrl.In.Par.RecipeIndex];
						END_IF;
						//Go to Save Recipe state
						MainState			:= C_MS_RECIPE_HAND_SAVE;
					ELSIF (gRecipe_Ctrl.In.Cmd.Refresh > OldInputs.Cmd.Refresh) THEN
						//Go to Refresh Recipe list state
						MainState			:= C_MS_RECIPE_HAND_LIST;		
					ELSE
						//Stay in Wait Command state
						MainState 			:= C_MS_RECIPE_HAND_WAIT_CMD;
						//Reset input commands
						memset(ADR(gRecipe_Ctrl.In.Cmd), 0, SIZEOF(gRecipe_Ctrl.In.Cmd));
					END_IF	
				END_IF	
			
				//CHECK IF THE SOURCE FILE DEVICE CHANGED
				IF (gRecipe_Ctrl.In.Par.Source <> OldInputs.Par.Source) THEN
					//The selected source device changed, unlnk the actual file device and link the new one
					MainState 				:= C_MS_RECIPE_HAND_UNLINK_DEV;
				END_IF	
		
				//Update the output ReadyForCmd
				IF (MainState = C_MS_RECIPE_HAND_WAIT_CMD) AND (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE) AND (gRecipe_Ctrl.In.Stat.CsvHandling.ReadyForCmd = TRUE) THEN
					gRecipe_Ctrl.Out.Stat.ReadyForCmd	:= TRUE;
				ELSE
					gRecipe_Ctrl.Out.Stat.ReadyForCmd	:= FALSE;
				END_IF		
	
		
			//============================================================================================	
			C_MS_RECIPE_HAND_UNLINK_DEV:			//UNLINK FILE DEVICE
				//============================================================================================				
			
				//Send command to execute the action when the File handling task is ready and a File Devcie has been previously linked
				IF ( (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE) AND (gRecipe_Ctrl.In.Stat.FileHandling.FileDeviceInfo.FileDeviceLinked = TRUE) ) THEN
					//The parameter string is managed before coming to this state depending on the situation
					gRecipe_Ctrl.Out.Cmd.FileHandling.UnlinkFileDevice			:= TRUE;
				ELSIF (gRecipe_Ctrl.In.Stat.FileHandling.FileDeviceInfo.FileDeviceLinked = FALSE) AND (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE)
					AND (gRecipe_Ctrl.In.Stat.FileHandling.CmdDone.UnlinkFileDevice = TRUE) THEN
					//The file device has been unlinked, reset command
					gRecipe_Ctrl.Out.Cmd.FileHandling.UnlinkFileDevice			:= FALSE;
					//Link the new file device
					MainState													:= C_MS_RECIPE_HAND_SET_DEVPAR;
				END_IF
		
			//============================================================================================	
			C_MS_RECIPE_HAND_DELETE:			//DELETE RECIPE
				//============================================================================================				
			
				//Send command to execute the action when the File handling task is ready and a recipe is selected
				IF ( (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE) AND (gRecipe_Ctrl.Out.Stat.RecipeList[gRecipe_Ctrl.In.Par.RecipeIndex] <> '') AND 
					(gRecipe_Ctrl.Out.Cmd.FileHandling.DeleteFile = FALSE) ) THEN
					//Set command and parameters to delete file
					gRecipe_Ctrl.Out.Par.FileHandling.FileName					:= C_USER_DIRECTORY;
					strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.FileName), ADR('/'));
					strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.FileName), ADR(gRecipe_Ctrl.Out.Stat.RecipeList[gRecipe_Ctrl.In.Par.RecipeIndex]));
					gRecipe_Ctrl.Out.Cmd.FileHandling.DeleteFile				:= TRUE;
				ELSIF (gRecipe_Ctrl.In.Stat.FileHandling.CmdDone.DeleteFile = TRUE) AND (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE)
					AND (gRecipe_Ctrl.Out.Cmd.FileHandling.DeleteFile = TRUE) THEN
					//The recipe has been deleted, reset command
					gRecipe_Ctrl.Out.Cmd.FileHandling.DeleteFile				:= FALSE;
					//Set output command done
					gRecipe_Ctrl.Out.Stat.CmdDone.DeleteRecipe					:= TRUE;
					//Make again the list of files
					MainState													:= C_MS_RECIPE_HAND_LIST;
				ELSIF (gRecipe_Ctrl.Out.Stat.RecipeList[gRecipe_Ctrl.In.Par.RecipeIndex] = '') THEN
					//No file selected, go back to wait command
					gHMI.Others.PopUpRequest	        	                        := 1;
					MainState													:= C_MS_RECIPE_HAND_WAIT_CMD;
				END_IF		
		
			//============================================================================================	
			C_MS_RECIPE_HAND_SAVE:			//SAVE RECIPE
				//============================================================================================				
			
				//Send command to execute the action when the File handling task is ready and a recipe is selected
				IF ( (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE) AND (gRecipe_Ctrl.In.Par.RecipeName <> '') AND 
					(gRecipe_Ctrl.Out.Cmd.CsvHandling.WriteFile = FALSE) ) THEN
					//Set command and parameters to save file
					gRecipe_Ctrl.Out.Par.CsvHandling.FileDeviceName	:= gRecipe_Ctrl.In.Stat.FileHandling.FileDeviceInfo.Name;
					gRecipe_Ctrl.Out.Par.CsvHandling.FileName		:= gRecipe_Ctrl.In.Par.RecipeName;
					gRecipe_Ctrl.Out.Par.CsvHandling.Path			:= C_USER_DIRECTORY;
					strcat(ADR(gRecipe_Ctrl.Out.Par.CsvHandling.Path), ADR('\'));				
					gRecipe_Ctrl.Out.Cmd.CsvHandling.WriteFile		:= TRUE;
				ELSIF (gRecipe_Ctrl.In.Stat.CsvHandling.CmdDone.WriteFile = TRUE) AND (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE)
					AND (gRecipe_Ctrl.Out.Cmd.CsvHandling.WriteFile = TRUE) THEN
					//The recipe has been saved, reset command
					gRecipe_Ctrl.Out.Cmd.CsvHandling.WriteFile		:= FALSE;
					//Set output command done
					gRecipe_Ctrl.Out.Stat.CmdDone.SaveRecipe		:= TRUE;				
					//Make again the list of files
					MainState										:= C_MS_RECIPE_HAND_LIST;
				ELSIF (gRecipe_Ctrl.Out.Cmd.CsvHandling.WriteFile = TRUE) AND (gRecipe_Ctrl.In.Stat.CsvHandling.FileAlreadyExists = TRUE) THEN
					//There is already a file with the same name, overwrite or not
					//Reset pop up      
					gHMI.Others.PopUpRequest	        	:= 0;
					gHMI.Others.PopUpRequestIndex           := 217;
					gHMI.Others.PopUpBtnCancStat            := SHOW_OBJ;
					gHMI.Others.PopUpBtnOkStat              := SHOW_OBJ;
					MainState								:= C_MS_RECIPE_HAND_OVERWRITE;
				ELSIF (gRecipe_Ctrl.In.Par.RecipeName = '') THEN
					//No recipe name entered, go back to wait command
					gRecipe_Ctrl.In.Par.RecipeName := gRecipe_Ctrl.Out.Stat.RecipeList[gRecipe_Ctrl.In.Par.RecipeIndex];
				END_IF		
		
			//============================================================================================	
			C_MS_RECIPE_HAND_OVERWRITE:			//OVERWRITE RECIPE OR NOT
				//============================================================================================				
				IF gHMI.Others.PopUpRequest = SHOW_OBJ THEN
					IF gHMI.Others.CmdOk THEN
						gHMI.Others.CmdOk             := FALSE;
						gHMI.Others.PopUpRequest      := SHOW_OBJ;
						gHMI.Others.PopUpBtnCancStat  := HIDE_OBJ;
						gHMI.Others.PopUpBtnOkStat    := HIDE_OBJ;
						gHMI.Others.PopUpRequestIndex := 207;
						gRecipe_Ctrl.In.Cmd.OverwriteRecipe := TRUE;
					ELSIF gHMI.Others.CmdCancel THEN
						gHMI.Others.CmdCancel := FALSE;
						gHMI.Others.CmdOk             := FALSE;
						gHMI.Others.PopUpRequest      := SHOW_OBJ;
						gRecipe_Ctrl.In.Cmd.NotOverwriteRecipe := TRUE;
					END_IF;
				END_IF;			

				//Wait for user command to select if the recipe is going to be overwritten or not
				IF (gRecipe_Ctrl.Out.Cmd.CsvHandling.OverwriteFile = FALSE) AND (gRecipe_Ctrl.Out.Cmd.CsvHandling.NotOverwriteFile = FALSE) THEN
					IF (gRecipe_Ctrl.In.Cmd.OverwriteRecipe > OldInputs.Cmd.OverwriteRecipe) THEN
						//Overwrite recipe, send command to CSV handling task
						gRecipe_Ctrl.Out.Cmd.CsvHandling.OverwriteFile		:= TRUE;
					ELSIF (gRecipe_Ctrl.In.Cmd.NotOverwriteRecipe > OldInputs.Cmd.NotOverwriteRecipe) THEN
						//Not overwrite recipe, send command to CSV handling task
						gRecipe_Ctrl.Out.Cmd.CsvHandling.NotOverwriteFile	:= TRUE;
					END_IF	
				END_IF
				//Wait for the process to be finished
				IF ( (gRecipe_Ctrl.Out.Cmd.CsvHandling.OverwriteFile = TRUE) OR (gRecipe_Ctrl.Out.Cmd.CsvHandling.NotOverwriteFile = TRUE) ) AND
					(gRecipe_Ctrl.In.Stat.CsvHandling.ReadyForCmd = TRUE) THEN
					IF (gRecipe_Ctrl.In.Stat.CsvHandling.CmdDone.OverwriteFile = TRUE) AND (gRecipe_Ctrl.In.Stat.CsvHandling.CmdDone.WriteFile = TRUE) THEN
						//Reset command
						gRecipe_Ctrl.Out.Cmd.CsvHandling.OverwriteFile		:= FALSE;
						//Set output command done
						gRecipe_Ctrl.Out.Stat.CmdDone.OverwriteRecipe		:= TRUE;					
					ELSIF (gRecipe_Ctrl.In.Stat.CsvHandling.CmdDone.NotOverwriteFile = TRUE) AND (gRecipe_Ctrl.In.Stat.CsvHandling.CmdDone.WriteFile = TRUE) THEN
						//Reset command
						gRecipe_Ctrl.Out.Cmd.CsvHandling.NotOverwriteFile	:= FALSE;
						//Set output command done
						gRecipe_Ctrl.Out.Stat.CmdDone.NotOverwriteRecipe	:= TRUE;
					END_IF	
					//Reset write file command
					gRecipe_Ctrl.Out.Cmd.CsvHandling.WriteFile				:= FALSE;
					//Set output command done
					gRecipe_Ctrl.Out.Stat.CmdDone.SaveRecipe				:= TRUE;
					//Go to wait command state
					gHMI.Others.PopUpRequest	        	                := 1;
					gHMI.Others.PopUpRequestIndex                           := 0;
					MainState												:= C_MS_RECIPE_HAND_WAIT_CMD;
				END_IF				
		
			//============================================================================================	
			C_MS_RECIPE_HAND_LOAD:			//LOAD RECIPE
				//============================================================================================				
			
				//Send command to execute the action when the File handling task is ready and a recipe is selected
				IF ( (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE) AND (gRecipe_Ctrl.Out.Stat.RecipeList[gRecipe_Ctrl.In.Par.RecipeIndex] <> '') AND 
					(gRecipe_Ctrl.Out.Cmd.CsvHandling.ReadFile = FALSE) ) THEN
					//Set command and parameters to load file
					gRecipe_Ctrl.Out.Par.CsvHandling.FileDeviceName				:= gRecipe_Ctrl.In.Stat.FileHandling.FileDeviceInfo.Name;
					gRecipe_Ctrl.Out.Par.CsvHandling.FileName					:= gRecipe_Ctrl.Out.Stat.RecipeList[gRecipe_Ctrl.In.Par.RecipeIndex];
					gRecipe_Ctrl.Out.Par.CsvHandling.Path						:= C_USER_DIRECTORY;
					strcat(ADR(gRecipe_Ctrl.Out.Par.CsvHandling.Path), ADR('\'));				
					gRecipe_Ctrl.Out.Cmd.CsvHandling.ReadFile					:= TRUE;
				ELSIF (gRecipe_Ctrl.In.Stat.CsvHandling.CmdDone.ReadFile = TRUE) AND (gRecipe_Ctrl.In.Stat.FileHandling.ReadyForCmd = TRUE)
					AND (gRecipe_Ctrl.Out.Cmd.CsvHandling.ReadFile = TRUE) THEN
					//The recipe has been loaded, reset command
					gRecipe_Ctrl.Out.Cmd.CsvHandling.ReadFile					:= FALSE;
					//Set output command done
					gRecipe_Ctrl.Out.Stat.CmdDone.LoadRecipe					:= TRUE;
					pAuto_Ctrl.In.Stat.RecipeLoaded                             := TRUE;
					//Go to wait command state
					gHMI.Others.PopUpRequest	        	                    := 1;
					gRecipe_Ctrl.In.Par.RecipeName                              := ''; 
					MainState													:= C_MS_RECIPE_HAND_WAIT_CMD;
					//Copy gloabal parameters structure to local loader parameters to 
					gLoaderControl.In.Par										:= gParameters.LoaderParameters;
				ELSIF (gRecipe_Ctrl.Out.Stat.RecipeList[gRecipe_Ctrl.In.Par.RecipeIndex] = '') THEN
					//No recipe selected, go back to wait command
					gHMI.Others.PopUpRequest	        	                    := 1;
					MainState													:= C_MS_RECIPE_HAND_WAIT_CMD;
				END_IF			
		
			//============================================================================================	
			C_MS_RECIPE_HAND_ERROR:				//ERROR HANDLING
				//============================================================================================	
	
				gHMI.Others.PopUpRequest	        	                        := 1;
				//Wait for user acknowledge
				IF (gRecipe_Ctrl.In.Cmd.ErrorAcknowledge > OldInputs.Cmd.ErrorAcknowledge) THEN
					//The user wants to acknowledge the error -> Next step: Go to Acknowledge Error State
					MainState 			:= C_MS_RECIPE_HAND_ACK_ERROR;
					//Reset output commands
					memset(ADR(gRecipe_Ctrl.Out.Cmd), 0, SIZEOF(gRecipe_Ctrl.Out.Cmd));		
					//Reset input commands
					memset(ADR(gRecipe_Ctrl.In.Cmd), 0, SIZEOF(gRecipe_Ctrl.In.Cmd));	
				END_IF		
		
			//============================================================================================	
			C_MS_RECIPE_HAND_ACK_ERROR:			//ACKNOWLEDGE ERROR
				//============================================================================================				
		
				//Clear error information
				gRecipe_Ctrl.Out.Stat.Error.Number							:= 0;
				memset(ADR(gRecipe_Ctrl.Out.Stat.Error.Text), 0, SIZEOF(gRecipe_Ctrl.Out.Stat.Error.Text));
				//Send acknowledge error command to the low level tasks in case that they are in error
				IF (gRecipe_Ctrl.In.Stat.FileHandling.Error.Number <> 0) THEN
					//Error in low level task, acknowledge error
					gRecipe_Ctrl.Out.Cmd.FileHandling.ErrorAcknowledge		:= TRUE;
				ELSIF ( (gRecipe_Ctrl.In.Stat.FileHandling.Error.Number = 0) AND (gRecipe_Ctrl.In.Stat.FileHandling.CmdDone.ErrorAcknowledge = TRUE) ) THEN
					//Reset output command to acknowledge
					gRecipe_Ctrl.Out.Cmd.FileHandling.ErrorAcknowledge		:= FALSE;				
				END_IF	
				IF (gRecipe_Ctrl.In.Stat.CsvHandling.Error.Number <> 0) THEN
					//Error in low level task, acknowledge error
					gRecipe_Ctrl.Out.Cmd.CsvHandling.ErrorAcknowledge		:= TRUE;
				ELSIF ( (gRecipe_Ctrl.In.Stat.CsvHandling.Error.Number = 0) AND (gRecipe_Ctrl.In.Stat.CsvHandling.CmdDone.ErrorAcknowledge = TRUE) ) THEN
					//Reset output command to acknowledge
					gRecipe_Ctrl.Out.Cmd.CsvHandling.ErrorAcknowledge		:= FALSE;
				END_IF			
				//Check if all error numbers are 0 to set command done output status
				IF ( (gRecipe_Ctrl.In.Stat.CsvHandling.Error.Number = 0) AND (gRecipe_Ctrl.In.Stat.FileHandling.Error.Number = 0) AND (gRecipe_Ctrl.Out.Stat.Error.Number = 0) ) THEN
					//Error acknowledged
					gRecipe_Ctrl.Out.Stat.CmdDone.ErrorAcknowledge			:= TRUE;
					//Acknowledge done -> Next step: Go to Init State 
					MainState 												:= C_MS_RECIPE_HAND_INIT;
					ErrorState												:= C_MS_RECIPE_HAND_NOERROR;			
				END_IF	
	
			ELSE
					
				//============================================================================================		
					
				//The program sould not come here
				MainState 									:= C_MS_RECIPE_HAND_ERROR;
				gRecipe_Ctrl.Out.Stat.Error.Number			:= 0;
				gRecipe_Ctrl.Out.Stat.Error.Text.Line1		:= TaskName;
				gRecipe_Ctrl.Out.Stat.Error.Text.Line2		:= 'Not defined state in state machine';
				ErrorState									:= MainState;
				MainState									:= C_MS_RECIPE_HAND_ERROR;			
								
			//============================================================================================	
				
		END_CASE	    

		//Update variables used to detect edges
		OldInputs		:= gRecipe_Ctrl.In;	
		OldOutputStatus	:= gRecipe_Ctrl.Out.Stat;
		//Update outputs
		Action_Output;

	END_IF;	

END_PROGRAM
