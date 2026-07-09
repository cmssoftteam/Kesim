(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 *******************************************************************
 * Library: aLibFile
 * Function Block: FbDirCreate
 * Author: kay3a 
 * Created: August 27, 2024/4:57 PM 
 ********************************************************************)
(**)
(**** FB Parameters Type*)

TYPE
	Par_DirCreate_typ : 	STRUCT  (**** FB Parameters Type*)
		DeviceName : STRING[80]; (*- Istenilen essiz device name parametresi. ex: "Device_deneme"*)
		DirPath : STRING[80]; (*- Folder olmasi istenilen direction. ex: "/DEVICE=USER_PATH/deneme/" yada "/DEVICE=C:\\deneme/"  gibi.*)
	END_STRUCT;
END_TYPE

(**)
(**)
(**)
(**)
(**** Internal Type*)

TYPE
	Int_DirCreate_typ : 	STRUCT  (**** Internal Type*)
		Step : Int_DirCreate_Step_enum; (*- Proses case steps.*)
		FB : Int_DirCreate_FB_typ; (*- Internal usage FBs.*)
		CapturedExecute : BOOL; (*- Execute istegi yakalandi flagi.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal FB Type*)

TYPE
	Int_DirCreate_FB_typ : 	STRUCT  (**** Internal FB Type*)
		_DirCreate : DirCreate; (*- Folder olusturmak için B&R fb.*)
		_DevLink : DevLink; (*- Device olusturmak için B&R fb.*)
	END_STRUCT;
END_TYPE

(**)
(**** Internal Step Enum Type*)

TYPE
	Int_DirCreate_Step_enum : 
		( (**** Internal Step Enum Type*)
		stepDirCreate_0_Idle := 0, (*- FB idle.*)
		stepDirCreate_1_WaitCmd := 1, (*- Yeni komut için hazir step.*)
		stepDirCreate_2_CrateDevLink := 2, (*- Device olusturma step.*)
		stepDirCreate_3_CreateDir := 3, (*- Folder olusturma step.*)
		stepDirCreate_10_Done := 10, (*- Islem basariyla tamamlandi step.*)
		stepDirCreate_11_Error := 11 (*- Error step.*)
		);
END_TYPE
