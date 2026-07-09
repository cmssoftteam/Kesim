(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 *******************************************************************
 * Library: aLibFile
 * Function Block: FbFileRead
 * Author: kay3a 
 * Created: August 27, 2024/4:57 PM 
 ********************************************************************)
(**)
(**** FB Parameters Type*)

TYPE
	Par_FileRead_typ : 	STRUCT  (**** FB Parameters Type*)
		DeviceName : STRING[80]; (*- Istenilen essiz device name parametresi. ex: "Device_deneme"*)
		FileName : STRING[80]; (*- Folder içerisinde içerisine okunmak istenilen file ismi.*)
	END_STRUCT;
END_TYPE

(**)
(**)
(**)
(**)
(**** Internal Type*)

TYPE
	Int_FileRead_typ : 	STRUCT  (**** Internal Type*)
		Step : Int_FileRead_Step_enum; (*- Proses case steps.*)
		FB : Int_FileRead_FB_typ; (*- Internal usage FBs.*)
		CapturedExecute : BOOL; (*- Execute istegi yakalandi flagi.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal FB Type*)

TYPE
	Int_FileRead_FB_typ : 	STRUCT  (**** Internal FB Type*)
		_FileOpen : FileOpen; (*- File açmak için B&R fb.*)
		_FileReadEx : FileReadEx; (*- File okumak için B&R fb.*)
		_FileClose : FileClose; (*- File kapatmak için B&R fb.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal Step Enum Type*)

TYPE
	Int_FileRead_Step_enum : 
		( (**** Internal Step Enum Type*)
		stepFileRead_0_Idle := 0, (*- FB idle.*)
		stepFileRead_1_WaitCmd := 1, (*- Yeni komut için hazir step.*)
		stepFileRead_2_FileOpen := 2, (*- File açma step.*)
		stepFileRead_3_Read := 3, (*- File okuma step.*)
		stepFileRead_4_FileClose := 4, (*- File kapatma step.*)
		stepFileRead_10_Done := 10, (*- Islem basariyla tamamlandi step.*)
		stepFileRead_11_Error := 11 (*- Error step.*)
		);
END_TYPE
