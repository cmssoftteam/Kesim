(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: RecipeHandling
 * File: RecipeHandling.typ
 * Author: blanca-gutim
 * Created: December 04, 2012
 ********************************************************************
 * Data types of package RecipeHandling
 ********************************************************************)
(**)
(*Enumeration to manage the state machine states*)

TYPE
	emu_RecipeControl_State : 
		(
		C_MS_RECIPE_HAND_INIT := 0, (*Init state*)
		C_MS_RECIPE_HAND_PING, (*Send a ping command to the NETWORK device*)
		C_MS_RECIPE_HAND_SET_DEVPAR, (*Set device patrameters for linking teh device*)
		C_MS_RECIPE_HAND_LINK_DEV, (*Link file device (set the format for the String Parameter)*)
		C_MS_RECIPE_HAND_LIST, (*List of all recipes*)
		C_MS_RECIPE_HAND_WAIT_CMD, (*Wait commad state -Standstill state*)
		C_MS_RECIPE_HAND_UNLINK_DEV, (*Unlink file device*)
		C_MS_RECIPE_HAND_LOAD, (*Load recipe*)
		C_MS_RECIPE_HAND_SAVE, (*Save recipe*)
		C_MS_RECIPE_HAND_OVERWRITE, (*Overwrite recipe or not?*)
		C_MS_RECIPE_HAND_DELETE, (*Delete recipe*)
		C_MS_RECIPE_HAND_ERROR, (*General error state*)
		C_MS_RECIPE_HAND_ACK_ERROR, (*Acknowledge error state*)
		C_MS_RECIPE_HAND_NOERROR (*Error State - No error*)
		);
END_TYPE

(**)
(*========================================================================================================*)
(*Recipe handling interface type*)
(*========================================================================================================*)

TYPE
	Recipe_Ctrl_typ : 	STRUCT 
		In : Recipe_Ctrl_In_typ; (*Input*)
		Out : Recipe_Ctrl_Out_typ; (*Output*)
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*Recipe control: input sub-interface type*)
(*========================================================================================================*)

TYPE
	Recipe_Ctrl_In_typ : 	STRUCT 
		Cmd : Recipe_Ctrl_In_Cmd_typ; (*Commands*)
		Par : Recipe_Ctrl_In_Par_typ; (*Parameters*)
		Stat : Recipe_Ctrl_In_Stat_typ; (*Status*)
	END_STRUCT;
END_TYPE

(*Recipe control: input commands sub-interface type*)

TYPE
	Recipe_Ctrl_In_Cmd_typ : 	STRUCT 
		LoadRecipe : BOOL; (*Load recipe*)
		SaveRecipe : BOOL; (*Save recipe*)
		DeleteRecipe : BOOL; (*Delete recipe*)
		Refresh : BOOL; (*Refresh list of recipes*)
		OverwriteRecipe : BOOL; (*Overwrite recipe*)
		NotOverwriteRecipe : BOOL; (*Not overwrite recipe*)
		ErrorAcknowledge : BOOL; (*Acknowledges an error*)
	END_STRUCT;
END_TYPE

(*Recipe control: input parameters sub-interface type*)

TYPE
	Recipe_Ctrl_In_Par_typ : 	STRUCT 
		RecipeName : STRING[32]; (*Recipe name*)
		RecipeIndex : UDINT; (*Index of the selected recipe into the recipe list*)
		Source : USINT; (*Sourde index for recipes*)
		Network : Recipe_Ctrl_In_Par_Net_typ; (*Network parameters when the file device is the NETWORK*)
	END_STRUCT;
END_TYPE

(*Recipe control: input network parameters sub-interface type*)

TYPE
	Recipe_Ctrl_In_Par_Net_typ : 	STRUCT 
		Server : STRING[50]; (*Server where the shared directory is located*)
		Workgroup : STRING[50]; (*Workgroup*)
		DirName : STRING[50]; (*Name of the shared directory*)
		UserName : STRING[50]; (*User name*)
		Password : STRING[50]; (*Password*)
	END_STRUCT;
END_TYPE

(*Recipe control: input status sub-interface type*)

TYPE
	Recipe_Ctrl_In_Stat_typ : 	STRUCT 
		FileHandling : File_Ctrl_Out_Stat_typ; (*File handling status*)
		CsvHandling : CSV_Ctrl_Out_Stat_typ; (*CSV handling status*)
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*Recipe control: output sub-interface type*)
(*========================================================================================================*)

TYPE
	Recipe_Ctrl_Out_typ : 	STRUCT 
		Cmd : Recipe_Ctrl_Out_Cmd_typ; (*Commands*)
		Par : Recipe_Ctrl_Out_Par_typ; (*Parameters*)
		Stat : Recipe_Ctrl_Out_Stat_typ; (*Status*)
	END_STRUCT;
END_TYPE

(*Recipe control: output commands sub-interface type*)

TYPE
	Recipe_Ctrl_Out_Cmd_typ : 	STRUCT 
		FileHandling : File_Ctrl_In_Cmd_typ; (*File handling output commands*)
		CsvHandling : CSV_Ctrl_In_Cmd_typ; (*CSV handling output commands*)
	END_STRUCT;
END_TYPE

(*Recipe control: output commands sub-interface type*)

TYPE
	Recipe_Ctrl_Out_Par_typ : 	STRUCT 
		FileHandling : File_Ctrl_In_Par_typ; (*File handling output parameters*)
		CsvHandling : CSV_Ctrl_In_Par_typ; (*CSV handling output parameters*)
	END_STRUCT;
END_TYPE

(*Recipe control: output status sub-interface type*)

TYPE
	Recipe_Ctrl_Out_Stat_typ : 	STRUCT 
		MainState : DINT; (*Main state in numeric format*)
		MainState_Text : STRING[32]; (*Main state in text format*)
		NrRecipes : UDINT; (*Number of listed recipes*)
		RecipeList : ARRAY[0..C_MAX_NR_ELEMENTS_IN_DIR_MINUS1]OF STRING[260]; (*List of recipes*)
		OverwritePopUp : USINT; (*Variable to control the overwrite PopUp*)
		CmdDone : Recipe_Ctrl_In_Cmd_typ; (*Command done*)
		ReadyForCmd : BOOL; (*Variable to show that the program is ready to get a new command*)
(*		Error : Error_Type; (*Error information*)
	END_STRUCT;
END_TYPE
