(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: gCSV_Ctrl
 * File: gCSV_CtrlInit.st
 * Author: blanca-gutim
 * Created: December 06, 2012
 ********************************************************************
 * Implementation of program gCSV_Ctrl
 ********************************************************************)

PROGRAM _INIT

	//Init of task name
	TaskName	:= 'CSV_Ctrl';

	//Init of variable to get state names in text format
	StateStrings[C_MS_CSV_FILE_HAND_INIT]			:= 'C_MS_CSV_FILE_HAND_INIT';
	StateStrings[C_MS_CSV_FILE_HAND_WAIT_CMD]		:= 'C_MS_CSV_FILE_HAND_WAIT_CMD';
	StateStrings[C_MS_CSV_FILE_HAND_READ]			:= 'C_MS_CSV_FILE_HAND_READ';
	StateStrings[C_MS_CSV_FILE_HAND_GEN_FILE_NAME]	:= 'C_MS_CSV_FILE_HAND_GEN_FILE_NAME';
	StateStrings[C_MS_CSV_FILE_HAND_SEARCH_FILE]	:= 'C_MS_CSV_FILE_HAND_SEARCH_FILE';
	StateStrings[C_MS_CSV_FILE_HAND_WAIT_OVRW_OK]	:= 'C_MS_CSV_FILE_HAND_WAIT_OVRW_OK';
	StateStrings[C_MS_CSV_FILE_HAND_SEARCH_VAR]		:= 'C_MS_CSV_FILE_HAND_SEARCH_VAR';
	StateStrings[C_MS_CSV_FILE_HAND_WRITE]			:= 'C_MS_CSV_FILE_HAND_WRITE';
	StateStrings[C_MS_CSV_FILE_HAND_ERROR]			:= 'C_MS_CSV_FILE_HAND_ERROR';
	StateStrings[C_MS_CSV_FILE_HAND_ACK_ERROR]		:= 'C_MS_CSV_FILE_HAND_ACK_ERROR';
	StateStrings[C_MS_CSV_FILE_HAND_NOERROR]		:= 'C_MS_CSV_FILE_HAND_NOERROR';
	
	//****************************************************************************************************************
	//****************************************************************************************************************
	//THIS PART OF THE CODE MUST BE CONFIGURED FOR EACH APPLICATION
	//CHECK THE VALUE OF THE CONSTANT: C_NR_VARIABLES_CSVFILE_MINUS_1
	//DELETE THE VARIABLES AND STRUCTURES FOR TESTING: TestVar1 AND TestVar2
	//****************************************************************************************************************
	//****************************************************************************************************************
	//Init of the variables that are going to take part in the CSV file
	//Addresses of the names of the variables
	pVarNames[0] 	:= ADR('gParameters');
	//Sizes of the variables
	VarSizes[0]		:= SIZEOF(gParameters);
	//Show output information about the involved variables
	gCSV_Ctrl.Out.Stat.VariableNames[0] := 'gParameters';
	//****************************************************************************************************************
	//****************************************************************************************************************
	
	//Init of machine state and error information
	MainState 	:= C_MS_CSV_FILE_HAND_INIT;
	ErrorState	:= C_MS_CSV_FILE_HAND_NOERROR;	
	
	//================================================================================================================
	//Calculate the necessary size of the memory to save the CSV-file on the compact flash and allocate the memory	
	//================================================================================================================
	
	//FUB parameters
	Init_CSVHandling.pStructName	:= ADR(pVarNames);
	Init_CSVHandling.NumOfStructs	:= C_NR_VARIABLES_CSVFILE_MINUS1 + 1;
	Init_CSVHandling.FullNameLenght	:= C_SHOW_VAR_NAME_OPTION;
	Init_CSVHandling.Options		:= 0;
	
	TON_Init.PT := T#5S;
	TON_Init.IN := TRUE;
	
END_PROGRAM

