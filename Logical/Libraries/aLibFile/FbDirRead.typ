(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 *******************************************************************
 * Library: aLibFile
 * Function Block: FbDirRead
 * Author: kay3a 
 * Created: August 27, 2024/4:57 PM 
 ********************************************************************)
(**)
(**** FB Parameters Type*)

TYPE
	Par_DirRead_typ : 	STRUCT  (**** FB Parameters Type*)
		DeviceName : STRING[80]; (*- Istenilen essiz device name parametresi. ex: "Device_deneme"*)
	END_STRUCT;
END_TYPE

(**)
(**)
(**)
(**)
(**** Internal Type*)

TYPE
	Int_DirRead_typ : 	STRUCT  (**** Internal Type*)
		Step : Int_DirRead_Step_enum; (*- Proses case steps.*)
		CountFile : UDINT; (*- Okuma esnasinda sayma degiskeni.*)
		ReadFile : fiDIR_READ_EX_DATA; (*- Okuma tipi.*)
		FB : Int_DirRead_FB_typ; (*- Internal usage FBs.*)
		CapturedExecute : BOOL; (*- Execute istegi yakalandi flagi.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal FB Type*)

TYPE
	Int_DirRead_FB_typ : 	STRUCT  (**** Internal FB Type*)
		_DirInfo : DirInfo; (*- Folder bilgisi almak için B&R fb.*)
		_DirRead : DirRead; (*- Folder içindekileri okuyup siralamak için B&R fb.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal Step Enum Type*)

TYPE
	Int_DirRead_Step_enum : 
		( (**** Internal Step Enum Type*)
		stepDirRead_0_Idle := 0, (*- FB idle.*)
		stepDirRead_1_WaitCmd := 1, (*- Yeni komut için hazir step.*)
		stepDirRead_2_GetInfo := 2, (*- Folder info alma step.*)
		stepDirRead_3_Read := 3, (*- Folder içini okuma step.*)
		stepDirRead_10_Done := 10, (*- Islem basariyla tamamlandi step.*)
		stepDirRead_11_Error := 11 (*- Error step.*)
		);
END_TYPE
