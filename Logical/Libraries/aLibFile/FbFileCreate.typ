(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 *******************************************************************
 * Library: aLibFile
 * Function Block: FbFileCreate
 * Author: kay3a 
 * Created: August 27, 2024/4:57 PM 
 ********************************************************************)
(**)
(**** FB Parameters Type*)

TYPE
	Par_FileCreate_typ : 	STRUCT  (**** FB Parameters Type*)
		DeviceName : STRING[80]; (*- Istenilen essiz device name parametresi. ex: "Device_deneme"*)
		FileName : STRING[80]; (*- Istenilen folder içerisinde olusturulacak File ismi.*)
	END_STRUCT;
END_TYPE

(**)
(**)
(**)
(**)
(**** Internal Type*)

TYPE
	Int_FileCreate_typ : 	STRUCT  (**** Internal Type*)
		Step : Int_FileCreate_Step_enum; (*- Proses case steps.*)
		FB : Int_FileCreate_FB_typ; (*- Internal usage FBs.*)
		CapturedExecute : BOOL; (*- Execute istegi yakalandi flagi.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal FB Type*)

TYPE
	Int_FileCreate_FB_typ : 	STRUCT  (**** Internal FB Type*)
		_FileCreate : FileCreate; (*- File olusturmak için B&R fb.*)
		_FileClose : FileClose; (*- File kapatmak için B&R fb.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal Step Enum Type*)

TYPE
	Int_FileCreate_Step_enum : 
		( (**** Internal Step Enum Type*)
		stepFileCreate_0_Idle := 0, (*- FB idle.*)
		stepFileCreate_1_WaitCmd := 1, (*- Yeni komut için hazir step.*)
		stepFileCreate_2_Create := 2, (*- File olusturma step.*)
		stepFileCreate_3_Close := 3, (*- File kapatma step.*)
		stepFileCreate_10_Done := 10, (*- Islem basariyla tamamlandi step.*)
		stepFileCreate_11_Error := 11 (*- Error step.*)
		);
END_TYPE
