(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 *******************************************************************
 * Library: aLibFile
 * Function Block: FbFileDelete
 * Author: kay3a 
 * Created: August 27, 2024/4:57 PM 
 ********************************************************************)
(**)
(**** FB Parameters Type*)

TYPE
	Par_FileDelete_typ : 	STRUCT  (**** FB Parameters Type*)
		DeviceName : STRING[80]; (*- Istenilen essiz device name parametresi. ex: "Device_deneme"*)
		FileName : STRING[80]; (*- Seçili folder içerisinden silinmek istenilen file.*)
	END_STRUCT;
END_TYPE

(**)
(**)
(**)
(**)
(**** Internal Type*)

TYPE
	Int_FileDelete_typ : 	STRUCT  (**** Internal Type*)
		Step : Int_FileDelete_Step_enum; (*- Proses case steps.*)
		FB : Int_FileDelete_FB_typ; (*- Internal usage FBs.*)
		CapturedExecute : BOOL; (*- Execute istegi yakalandi flagi.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal FB Type*)

TYPE
	Int_FileDelete_FB_typ : 	STRUCT  (**** Internal FB Type*)
		_FileDelete : FileDelete; (*- File silmek için B&R fb.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal Step Enum Type*)

TYPE
	Int_FileDelete_Step_enum : 
		( (**** Internal Step Enum Type*)
		stepFileDelete_0_Idle := 0, (*- FB idle.*)
		stepFileDelete_1_WaitCmd := 1, (*- Yeni komut için hazir step.*)
		stepFileDelete_2_Delete := 2, (*- File silme step.*)
		stepFileDelete_10_Done := 10, (*- Islem basariyla tamamlandi step.*)
		stepFileDelete_11_Error := 11 (*- Error step.*)
		);
END_TYPE
