(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 *******************************************************************
 * Library: aLibFile
 * Function Block: FbFileWrite
 * Author: kay3a 
 * Created: August 27, 2024/4:57 PM 
 ********************************************************************)
(**)
(**** FB Parameters Type*)

TYPE
	Par_FileWrite_typ : 	STRUCT  (**** FB Parameters Type*)
		DeviceName : STRING[80]; (*- Istenilen essiz device name parametresi. ex: "Device_deneme"*)
		FileName : STRING[80]; (*- Folder içerisinde içerisine yazilmak istenilen file ismi.*)
	END_STRUCT;
END_TYPE

(**)
(**)
(**)
(**)
(**** Internal Type*)

TYPE
	Int_FileWrite_typ : 	STRUCT  (**** Internal Type*)
		Step : Int_FileWrite_Step_enum; (*- Proses case steps.*)
		FB : Int_FileWrite_FB_typ; (*- Internal usage FBs.*)
		CapturedExecute : BOOL; (*- Execute istegi yakalandi flagi.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal FB Type*)

TYPE
	Int_FileWrite_FB_typ : 	STRUCT  (**** Internal FB Type*)
		_FileOpen : FileOpen; (*- File açmak için B&R fb.*)
		_FileWriteEx : FileWriteEx; (*- File yazmak için B&R fb.*)
		_FileClose : FileClose; (*- File kapatmak için B&R fb.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal Step Enum Type*)

TYPE
	Int_FileWrite_Step_enum : 
		( (**** Internal Step Enum Type*)
		stepFileWrite_0_Idle := 0, (*- FB idle.*)
		stepFileWrite_1_WaitCmd := 1, (*- Yeni komut için hazir step.*)
		stepFileWrite_2_FileOpen := 2, (*- File açma step.*)
		stepFileWrite_3_Write := 3, (*- File yazma step.*)
		stepFileWrite_4_FileClose := 4, (*- File kapatma step.*)
		stepFileWrite_10_Done := 10, (*- Islem basariyla tamamlandi step.*)
		stepFileWrite_11_Error := 11 (*- Error step.*)
		);
END_TYPE
