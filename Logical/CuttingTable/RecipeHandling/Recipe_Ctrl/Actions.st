(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: gRecipe_Ctrl
 * File: Actions.st
 * Author: blanca-gutim
 * Created: December 04, 2012
 ********************************************************************
 * Implementation of program gRecipe_Ctrl
 ********************************************************************) 

(* Input actions *)
ACTION Action_Input: 
	
	//Update inputs
	gRecipe_Ctrl.In.Stat.FileHandling	:= gFile_Ctrl.Out.Stat;
	gRecipe_Ctrl.In.Stat.CsvHandling	:= gCSV_Ctrl.Out.Stat;
	
	//Copy local loader parameters to gloabal parameters structure
	IF (MainState = C_MS_RECIPE_HAND_WAIT_CMD) THEN
		gParameters.LoaderParameters	:= gLoaderControl.In.Par;
	END_IF	
	
END_ACTION

(* Output actions *)
ACTION Action_Output: 
	
	//Reset input commands when they are done	
	IF (gRecipe_Ctrl.Out.Stat.CmdDone.DeleteRecipe = TRUE) THEN
		gRecipe_Ctrl.In.Cmd.DeleteRecipe			:= FALSE;
	END_IF
	IF (gRecipe_Ctrl.Out.Stat.CmdDone.ErrorAcknowledge = TRUE) THEN
		gRecipe_Ctrl.In.Cmd.ErrorAcknowledge		:= FALSE;
	END_IF
	IF (gRecipe_Ctrl.Out.Stat.CmdDone.LoadRecipe = TRUE) THEN
		gRecipe_Ctrl.In.Cmd.LoadRecipe				:= FALSE;
	END_IF
	IF (gRecipe_Ctrl.Out.Stat.CmdDone.SaveRecipe = TRUE) THEN
		gRecipe_Ctrl.In.Cmd.SaveRecipe				:= FALSE;
	END_IF
	IF (gRecipe_Ctrl.Out.Stat.CmdDone.Refresh = TRUE) THEN
		gRecipe_Ctrl.In.Cmd.Refresh					:= FALSE;
	END_IF
	IF (gRecipe_Ctrl.Out.Stat.CmdDone.OverwriteRecipe = TRUE) THEN
		gRecipe_Ctrl.In.Cmd.OverwriteRecipe			:= FALSE;
	END_IF
	IF (gRecipe_Ctrl.Out.Stat.CmdDone.NotOverwriteRecipe = TRUE) THEN
		gRecipe_Ctrl.In.Cmd.NotOverwriteRecipe		:= FALSE;
	END_IF		
	
	//Update outputs, reset command done status
	gRecipe_Ctrl.Out.Stat.CmdDone.DeleteRecipe			:= gRecipe_Ctrl.Out.Stat.CmdDone.DeleteRecipe		AND gRecipe_Ctrl.In.Cmd.DeleteRecipe;
	gRecipe_Ctrl.Out.Stat.CmdDone.ErrorAcknowledge		:= gRecipe_Ctrl.Out.Stat.CmdDone.ErrorAcknowledge	AND gRecipe_Ctrl.In.Cmd.ErrorAcknowledge;
	gRecipe_Ctrl.Out.Stat.CmdDone.LoadRecipe			:= gRecipe_Ctrl.Out.Stat.CmdDone.LoadRecipe			AND gRecipe_Ctrl.In.Cmd.LoadRecipe;
	gRecipe_Ctrl.Out.Stat.CmdDone.SaveRecipe			:= gRecipe_Ctrl.Out.Stat.CmdDone.SaveRecipe			AND gRecipe_Ctrl.In.Cmd.SaveRecipe;
	gRecipe_Ctrl.Out.Stat.CmdDone.Refresh				:= gRecipe_Ctrl.Out.Stat.CmdDone.Refresh			AND gRecipe_Ctrl.In.Cmd.Refresh;
	gRecipe_Ctrl.Out.Stat.CmdDone.OverwriteRecipe		:= gRecipe_Ctrl.Out.Stat.CmdDone.OverwriteRecipe	AND gRecipe_Ctrl.In.Cmd.OverwriteRecipe;
	gRecipe_Ctrl.Out.Stat.CmdDone.NotOverwriteRecipe	:= gRecipe_Ctrl.Out.Stat.CmdDone.NotOverwriteRecipe	AND gRecipe_Ctrl.In.Cmd.NotOverwriteRecipe;
	
	//Update output, get MainState and Error State in String and UDINT variables (for tracing and debuging)
	gRecipe_Ctrl.Out.Stat.MainState						:= MainState;
	gRecipe_Ctrl.Out.Stat.MainState_Text				:= StateStrings[MainState];
	
	//Update network parameters for file handling task
	gRecipe_Ctrl.In.Par.Network							:= gParameters.Network;	
	
	//Update the signal to know that the selected file already exists
	IF (MainState = C_MS_RECIPE_HAND_OVERWRITE) THEN
		//File already exists
		gRecipe_Ctrl.Out.Stat.OverwritePopUp		:= 0;
	ELSE
		//File doesn´t exists
		gRecipe_Ctrl.Out.Stat.OverwritePopUp		:= 1;	
	END_IF	
	
END_ACTION

(*Sorting procedure for recipes*)
ACTION Action_SortRecipes:
	
	//Sorting procedure, when recipes are found
	IF (gRecipe_Ctrl.Out.Stat.RecipeList[0] <> '') THEN
		Changed	:= FALSE;
		kk		:= 0;
		REPEAT
			IF (strcmp(ADR(gRecipe_Ctrl.Out.Stat.RecipeList[kk]),ADR(gRecipe_Ctrl.Out.Stat.RecipeList[kk+1])) > 0) AND 
				(gRecipe_Ctrl.Out.Stat.RecipeList[kk] <> '') AND (gRecipe_Ctrl.Out.Stat.RecipeList[kk+1] <> '') THEN
				Changed := TRUE;
				strcpy(ADR(SaveFileName), ADR(gRecipe_Ctrl.Out.Stat.RecipeList[kk+1]));
				strcpy(ADR(gRecipe_Ctrl.Out.Stat.RecipeList[kk+1]), ADR(gRecipe_Ctrl.Out.Stat.RecipeList[kk]));
				strcpy(ADR(gRecipe_Ctrl.Out.Stat.RecipeList[kk]), ADR(SaveFileName));				
			END_IF
			kk := kk+1;
			IF (Changed) THEN
				Changed	:= FALSE;
				kk 		:= 0;
			END_IF			
			UNTIL (kk = (gRecipe_Ctrl.In.Stat.FileHandling.DirectoryInformation.NrFiles - 1))
		END_REPEAT
	END_IF	
	
END_ACTION

(*Check error actions*)
ACTION Action_CheckError:
	
	//Check if there are error from low level tasks
	IF (MainState <> C_MS_RECIPE_HAND_ACK_ERROR) THEN
		IF (gRecipe_Ctrl.In.Stat.FileHandling.Error.Number <> 0) THEN
			//Copy eeror information
			gRecipe_Ctrl.Out.Stat.Error	:= gRecipe_Ctrl.In.Stat.FileHandling.Error;
			//Go to error state
			MainState					:= C_MS_RECIPE_HAND_ERROR;
		END_IF	
		IF (gRecipe_Ctrl.In.Stat.CsvHandling.Error.Number <> 0) THEN
			//Copy eeror information
			gRecipe_Ctrl.Out.Stat.Error	:= gRecipe_Ctrl.In.Stat.CsvHandling.Error;
			//Go to error state
			MainState					:= C_MS_RECIPE_HAND_ERROR;
		END_IF	
	END_IF		
	
END_ACTION