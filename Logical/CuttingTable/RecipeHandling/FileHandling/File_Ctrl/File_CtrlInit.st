(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: gFile_Ctrl
 * File: gFile_CtrlInit.st
 * Author: blanca-gutim
 * Created: December 06, 2012
 ********************************************************************
 * Implementation of program gFile_Ctrl
 ********************************************************************)

PROGRAM _INIT

	//Init of task name
	TaskName	:= 'File_Ctrl';
	
	//Init of variables used to control state machines
	MainState	:= C_MS_FILE_HAND_INIT;
	ErrorState	:= C_MS_FILE_HAND_NOERROR;
	
	//Init of USB detection 
	USBDetectionIF.in.Enable		:= TRUE;
	USBDetectionIF.out.Step			:= USB_GETNODELIST;
	
	//Init of variable to get state names in text format
	StateStrings[C_MS_FILE_HAND_INIT]				:= 'C_MS_FILE_HAND_INIT';
	StateStrings[C_MS_FILE_HAND_WAIT_CMD]			:= 'C_MS_FILE_HAND_WAIT_CMD';
	StateStrings[C_MS_FILE_HAND_LINK_FILE_DEV]		:= 'C_MS_FILE_HAND_LINK_FILE_DEV';
	StateStrings[C_MS_FILE_HAND_GET_DEV_INFO]		:= 'C_MS_FILE_HAND_GET_DEV_INFO';
	StateStrings[C_MS_FILE_HAND_UNLINK_FILE_DEV]	:= 'C_MS_FILE_HAND_UNLINK_FILE_DEV';
	StateStrings[C_MS_FILE_HAND_DELETE_FILE]		:= 'C_MS_FILE_HAND_DELETE_FILE';
	StateStrings[C_MS_FILE_HAND_OPEN_DIR]			:= 'C_MS_FILE_HAND_OPEN_DIR';
	StateStrings[C_MS_FILE_HAND_CLOSE_DIR]			:= 'C_MS_FILE_HAND_CLOSE_DIR';
	StateStrings[C_MS_FILE_HAND_READ_DIR]			:= 'C_MS_FILE_HAND_READ_DIR';
	StateStrings[C_MS_FILE_HAND_CREATE_DIR]			:= 'C_MS_FILE_HAND_CREATE_DIR';	
	StateStrings[C_MS_FILE_HAND_ERROR]				:= 'C_MS_FILE_HAND_ERROR';
	StateStrings[C_MS_FILE_HAND_ACK_ERROR]			:= 'C_MS_FILE_HAND_ACK_ERROR';
	StateStrings[C_MS_FILE_HAND_NOERROR]			:= 'C_MS_FILE_HAND_NOERROR';

END_PROGRAM

