(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 *******************************************************************
 * Library: aLibFile
 * Function Block: FbDirDelete
 * Author: kay3a 
 * Created: August 27, 2024/4:57 PM 
 ********************************************************************)
(**)
(**** FB Parameters Type*)

TYPE
	Par_DirDelete_typ : 	STRUCT  (**** FB Parameters Type*)
		DeviceName : STRING[80]; (*- Istenilen essiz device name parametresi. ex: "Device_deneme"*)
	END_STRUCT;
END_TYPE

(**)
(**)
(**)
(**)
(**** Internal Type*)

TYPE
	Int_DirDelete_typ : 	STRUCT  (**** Internal Type*)
		Step : Int_DirDelete_Step_enum; (*- Proses case steps.*)
		FB : Int_DirDelete_FB_typ; (*- Internal usage FBs.*)
		CapturedExecute : BOOL; (*- Execute istegi yakalandi flagi.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal FB Type*)

TYPE
	Int_DirDelete_FB_typ : 	STRUCT  (**** Internal FB Type*)
		_DirDelete : DirDeleteEx; (*- Folder silmek için B&R fb.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal Step Enum Type*)

TYPE
	Int_DirDelete_Step_enum : 
		( (**** Internal Step Enum Type*)
		stepDirDelete_0_Idle := 0, (*- FB idle.*)
		stepDirDelete_1_WaitCmd := 1, (*- Yeni komut için hazir step.*)
		stepDirDelete_2_Delete := 2, (*- Folder silme step.*)
		stepDirDelete_10_Done := 10, (*- Islem basariyla tamamlandi step.*)
		stepDirDelete_11_Error := 11 (*- Error step.*)
		);
END_TYPE
