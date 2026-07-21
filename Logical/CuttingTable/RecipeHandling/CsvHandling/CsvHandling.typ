(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: CSVHandling
 * File: CSVHandling.typ
 * Author: blanca-gutim
 * Created: December 04, 2012
 ********************************************************************
 * Data types of package CSVHandling
 ********************************************************************)
(**)
(*Enumeration to manage the state machine states*)

TYPE
	emu_CSVControl_State : 
		(
		C_MS_CSV_FILE_HAND_INIT := 0, (*Init state*)
		C_MS_CSV_FILE_HAND_WAIT_CMD, (*Wait commad state -Standstill state*)
		C_MS_CSV_FILE_HAND_READ, (*Read CSV file state*)
		C_MS_CSV_FILE_HAND_GEN_FILE_NAME, (*Generate file name state*)
		C_MS_CSV_FILE_HAND_SEARCH_FILE, (*Search for the specified file name*)
		C_MS_CSV_FILE_HAND_WAIT_OVRW_OK, (*Wait overwrite confirmation state*)
		C_MS_CSV_FILE_HAND_SEARCH_VAR, (*Search the variables that are part of the CSV file state*)
		C_MS_CSV_FILE_HAND_WRITE, (*Write CSV file state*)
		C_MS_CSV_FILE_HAND_ERROR, (*General error state*)
		C_MS_CSV_FILE_HAND_ACK_ERROR, (*Acknowledge error state*)
		C_MS_CSV_FILE_HAND_NOERROR (*Error State - No error*)
		);
END_TYPE

(**)
(*========================================================================================================*)
(*CSV control interface type*)
(*========================================================================================================*)

TYPE
	CSV_Ctrl_typ : 	STRUCT 
		In : CSV_Ctrl_In_typ; (*Inputs*)
		Out : CSV_Ctrl_Out_typ; (*Outputs*)
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*CSV control: input sub-interface type*)
(*========================================================================================================*)

TYPE
	CSV_Ctrl_In_typ : 	STRUCT 
		Cmd : CSV_Ctrl_In_Cmd_typ; (*Input commands*)
		Par : CSV_Ctrl_In_Par_typ; (*Input parameters *)
		Stat : CSV_Ctrl_In_Stat_typ; (*Input status*)
	END_STRUCT;
END_TYPE

(*CSV control: input commands sub-interface type*)

TYPE
	CSV_Ctrl_In_Cmd_typ : 	STRUCT 
		ReadFile : BOOL; (*Read file command*)
		WriteFile : BOOL; (*Write file command*)
		OverwriteFile : BOOL; (*Overwrite file command*)
		NotOverwriteFile : BOOL; (*Do not overwrite file command*)
		ErrorAcknowledge : BOOL; (*Acknowledge error command*)
	END_STRUCT;
END_TYPE

(*CSV control: input parameters sub-interface type*)

TYPE
	CSV_Ctrl_In_Par_typ : 	STRUCT 
		FileDeviceName : STRING[50]; (*File Device name*)
		FileName : STRING[255]; (*File name*)
		Path : STRING[255]; (*Path to the file*)
		Header : CSV_Ctrl_In_Par_Header_typ; (*Header input parameters substructure*)
	END_STRUCT;
END_TYPE

(*Header input parameters substructure*)

TYPE
	CSV_Ctrl_In_Par_Header_typ : 	STRUCT 
		Enable : BOOL; (*Enable header in CSV file*)
		MachineNr : STRING[80]; (*Machine number*)
		Comment : STRING[80]; (*Header comment*)
		Version : STRING[80]; (*Version*)
	END_STRUCT;
END_TYPE

(*CSV control: input status sub-interface type*)

TYPE
	CSV_Ctrl_In_Stat_typ : 	STRUCT 
		NOT_USED : BOOL;
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*CSV control: output sub-interface type*)
(*========================================================================================================*)

TYPE
	CSV_Ctrl_Out_typ : 	STRUCT 
		Cmd : CSV_Ctrl_Out_Cmd_typ; (*Output commands*)
		Par : CSV_Ctrl_Out_Par_typ; (*Output parameters *)
		Stat : CSV_Ctrl_Out_Stat_typ; (*Output status*)
	END_STRUCT;
END_TYPE

(*CSV control: output commands sub-interface type*)

TYPE
	CSV_Ctrl_Out_Cmd_typ : 	STRUCT 
		NOT_USED : BOOL;
	END_STRUCT;
END_TYPE

(*CSV control: output parameters sub-interface type*)

TYPE
	CSV_Ctrl_Out_Par_typ : 	STRUCT 
		NOT_USED : BOOL;
	END_STRUCT;
END_TYPE

(*CSV control: output status sub-interface type*)

TYPE
	CSV_Ctrl_Out_Stat_typ : 	STRUCT 
		MainState : DINT; (*Main state in numeric format*)
		MainState_Text : STRING[32]; (*Main state in text format*)
		VariableNames : ARRAY[0..C_NR_VARIABLES_CSVFILE_MINUS1]OF STRING[30]; (*Names of the variables that are part of the CSV file*)
		CmdDone : CSV_Ctrl_In_Cmd_typ; (*Command done*)
		FileAlreadyExists : BOOL; (*Flag to show that the CSV file already exists (in write process)*)
		ReadyForCmd : BOOL; (*Variable to show that the program is ready to get a new command*)
(*		Error : Error_Type; (*Error information*)
	END_STRUCT;
END_TYPE
