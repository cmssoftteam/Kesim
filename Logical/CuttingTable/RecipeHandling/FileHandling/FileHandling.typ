(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: FileHandling
 * File: FileHandling.typ
 * Author: blanca-gutim
 * Created: December 04, 2012
 ********************************************************************
 * Data types of package FileHandling
 ********************************************************************)
(**)
(*Enumeration to manage the state machine states*)

TYPE
	emu_FileControl_State : 
		(
		C_MS_FILE_HAND_INIT := 0, (*Init state*)
		C_MS_FILE_HAND_WAIT_CMD, (*Wait commad state -Standstill state*)
		C_MS_FILE_HAND_LINK_FILE_DEV, (*Link file device state*)
		C_MS_FILE_HAND_GET_DEV_INFO, (*Get file device information*)
		C_MS_FILE_HAND_UNLINK_FILE_DEV, (*Unlink file device state*)
		C_MS_FILE_HAND_DELETE_FILE, (*Delete file satte*)
		C_MS_FILE_HAND_OPEN_DIR, (*Open directory state*)
		C_MS_FILE_HAND_CLOSE_DIR, (*Close directory state*)
		C_MS_FILE_HAND_READ_DIR, (*Read directory state*)
		C_MS_FILE_HAND_CREATE_DIR, (*Create directory state*)
		C_MS_FILE_HAND_ERROR, (*General error state*)
		C_MS_FILE_HAND_ACK_ERROR, (*Acknowledge error state*)
		C_MS_FILE_HAND_NOERROR (*Error State - No error*)
		);
END_TYPE

(**)
(*========================================================================================================*)
(*File control interface type*)
(*========================================================================================================*)

TYPE
	File_Ctrl_typ : 	STRUCT 
		In : File_Ctrl_In_typ; (*Inputs *)
		Out : File_Ctrl_Out_typ; (*Outputs*)
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*File control: input sub-interface type*)
(*========================================================================================================*)

TYPE
	File_Ctrl_In_typ : 	STRUCT 
		Cmd : File_Ctrl_In_Cmd_typ; (*Input commands *)
		Par : File_Ctrl_In_Par_typ; (*Input parameters *)
		Stat : File_Ctrl_In_Stat_typ; (*Input status*)
	END_STRUCT;
END_TYPE

(*File control: input commands sub-interface type*)

TYPE
	File_Ctrl_In_Cmd_typ : 	STRUCT 
		LinkFileDevice : BOOL; (*Links a file device*)
		GetFileDeviceInfo : BOOL; (*Get file device information*)
		UnlinkFileDevice : BOOL; (*Unlinks file device*)
		ReadDirectory : BOOL; (*Reads a directory*)
		DeleteFile : BOOL; (*Deletes a file*)
		ErrorAcknowledge : BOOL; (*Acknowledges an error*)
	END_STRUCT;
END_TYPE

(*File control: input parameters sub-interface type*)

TYPE
	File_Ctrl_In_Par_typ : 	STRUCT 
		DeviceName : STRING[50]; (*File device name*)
		ParameterString : STRING[255]; (*Device parameter string*)
		FileName : STRING[255]; (*File name*)
		DirectoryName : STRING[255]; (*Directory name*)
	END_STRUCT;
END_TYPE

(*File control: input status sub-interface type*)

TYPE
	File_Ctrl_In_Stat_typ : 	STRUCT 
		NOT_USED : BOOL;
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*File control: output sub-interface type*)
(*========================================================================================================*)

TYPE
	File_Ctrl_Out_typ : 	STRUCT 
		Cmd : File_Ctrl_Out_Cmd_typ; (*Output commands *)
		Par : File_Ctrl_Out_Par_typ; (*Output parameters *)
		Stat : File_Ctrl_Out_Stat_typ; (*Output status *)
	END_STRUCT;
END_TYPE

(*File control: output commands sub-interface type*)

TYPE
	File_Ctrl_Out_Cmd_typ : 	STRUCT 
		NOT_USED : BOOL;
	END_STRUCT;
END_TYPE

(*File control: output parameters sub-interface type*)

TYPE
	File_Ctrl_Out_Par_typ : 	STRUCT 
		NOT_USED : BOOL;
	END_STRUCT;
END_TYPE

(*File control: output status sub-interface type*)

TYPE
	File_Ctrl_Out_Stat_typ : 	STRUCT 
		MainState : DINT; (*Main state in numeric format*)
		MainState_Text : STRING[32]; (*Main state in text format*)
(*		UsbInformation : ARRAY[0..C_USB_DEVICES_MAX_MINUS1]OF usbNode_typ; (*Information about connected USB devices*)
		CmdDone : File_Ctrl_In_Cmd_typ; (*Command done*)
		FileDeviceInfo : File_Ctrl_Out_Stat_DevInfo_typ; (*Output device information*)
		DirectoryInformation : File_Ctrl_Out_Stat_DirInfo_typ; (*Output directory information*)
		ReadyForCmd : BOOL; (*Variable to show that the program is ready to get a new command*)
(*		Error : Error_Type; (*Error information*)
	END_STRUCT;
END_TYPE

(*File control: output status realted to the device info sub-interface type*)

TYPE
	File_Ctrl_Out_Stat_DevInfo_typ : 	STRUCT  (*Output device information*)
		FileDeviceLinked : BOOL; (*A file device is linked*)
		Name : STRING[50]; (*File device name*)
		FileDeviceHandle : UDINT; (*Device handle*)
		FreeMem : UDINT; (*Free memory*)
		TotalMem : UDINT; (*Total memory*)
	END_STRUCT;
END_TYPE

(*File control: output status realted to the read directory info sub-interface type*)

TYPE
	File_Ctrl_Out_Stat_DirInfo_typ : 	STRUCT  (*Output file information*)
		NrFiles : UDINT; (*Number of files in the directory*)
		NrDirectories : UDINT; (*Number os subdirectories in the directory*)
		ElementsInfo : ARRAY[0..C_MAX_NR_ELEMENTS_IN_DIR_MINUS1]OF fiDIR_READ_EX_DATA; (*Information about the elements inside the directory*)
	END_STRUCT;
END_TYPE
