(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 *******************************************************************
 * Task: UserX
 * Author: kay3a 
 * Created: October 3, 2024/4:58 PM 
 ********************************************************************)
(**)
(**** Local Type*)

TYPE
	Loc_typ : 	STRUCT 
		FB : Loc_FB_typ; (**** Local FB ler*)
		Cmd : Loc_Cmd_typ; (**** Komutlar*)
		Status : Loc_Status_typ; (**** Durumlar*)
		Par : Loc_Par_typ;
	END_STRUCT;
END_TYPE

(**)
(**** Local FB Type*)

TYPE
	Loc_FB_typ : 	STRUCT  (**** Local FB Type*)
		DirRead : FbDirRead;
		DirCreate : FbDirCreate; (**** UserX export/import file dosyalarini tuttmak için.*)
		UserXLogin : MpUserXLogin;
		UserXManagerUI : MpUserXManagerUI;
		UserXLoginUI : MpUserXLoginUI;
	END_STRUCT;
END_TYPE

(**)
(**** Local Cmd Type*)

TYPE
	Loc_Cmd_typ : 	STRUCT  (**** Local Cmd Type*)
		Export : BOOL;
		ConfirmOverwrite : BOOL;
	END_STRUCT;
END_TYPE

(**)
(**** Local Status Type*)

TYPE
	Loc_Status_typ : 	STRUCT  (**** Local Status Type*)
		FileDuplicate : BOOL;
		ExportComplete : BOOL;
		UserExportDisplayed : BOOL;
		UserXHmiState : HmiStateEnum;
		LastMgrConnectStatus : MpUserXUIStatusEnum;
	END_STRUCT;
END_TYPE

(**)
(**** Local Parmaeter Type*)

TYPE
	Loc_Par_typ : 	STRUCT  (**** Local Parmaeter Type*)
		UserXLoginUIConnect : MpUserXLoginUIConnectType;
		UserXMgrUIConnect : MpUserXMgrUIConnectType;
	END_STRUCT;
END_TYPE

(**)
(**)
(**)
(**)
(*Enumerations*)

TYPE
	HmiStateEnum : 
		( (*State enumeration for HMI interaction*)
		USERX_START := 0,
		USERX_WAIT_FOR_DIALOG := 1,
		USERX_SET_RESPONSE := 2,
		USERX_CONFIRM_RESPONSE := 3,
		USERX_NEW_EXPORT := 4,
		USERX_FINISH := 5
		);
END_TYPE
