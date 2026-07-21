(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 *******************************************************************
 * Task: AlarmX
 * Author: kay3a 
 * Created: October 2, 2024/3:56 PM 
 ********************************************************************)
(**)
(**** Local Type*)

TYPE
	Loc_typ : 	STRUCT  (**** Local Type*)
		FB : Loc_FB_typ; (**** Local FB Type*)
		Cmd : Loc_Cmd_typ; (**** Local Command Type*)
		Status : Loc_Status_typ; (**** Local Status Type*)
	END_STRUCT;
END_TYPE

(**)
(**** Local FB Type*)

TYPE
	Loc_FB_typ : 	STRUCT  (**** Local FB Type*)
		DirCreate : FbDirCreate; (**** Alarm geçmisi export dosyalarini tutmak için*)
		AlarmXCore : MpAlarmXCore; (**** Local FB AlarmXCore Type*)
		AlarmXHistory : MpAlarmXHistory; (**** Local FB AlarmXHistory Type*)
	END_STRUCT;
END_TYPE

(**)
(**** Local Cmd Type*)

TYPE
	Loc_Cmd_typ : 	STRUCT  (**** Local Cmd Type*)
		AcknowledgeAll : BOOL; (**** Tüm alarmlari onayla*)
		AutoExport : BOOL; (**** Alarm geçmisini export et.*)
	END_STRUCT;
END_TYPE

(**)
(**** Local Status Type*)

TYPE
	Loc_Status_typ : 	STRUCT  (**** Local Status Type*)
		Alerts : Loc_Status_Alerts_typ; (**** Alarm durumlari*)
		ReactionCategory : ARRAY[0..LC_MAX_ALARM_CATEGORY_INDEX]OF BOOL; (**** Alarm reaction durumlari.*)
	END_STRUCT;
END_TYPE

(**)
(**** Local Status Alarm Type*)

TYPE
	Loc_Status_Alerts_typ : 	STRUCT  (**** Local Status Alarm Type*)
		Single : Loc_Status_Alerts_Single_typ; (**** Single alarm durumlari*)
		Snippet : ARRAY[0..LC_MAX_SNIPPET_ALARM_INDEX]OF Loc_Status_Alerts_Snippet_typ; (**** Snppet alarm durumlari ve index leri*)
	END_STRUCT;
END_TYPE

(**)
(**** Local Status Alarm Single Type*)

TYPE
	Loc_Status_Alerts_Single_typ : 	STRUCT  (**** Local Status Alarm Single Type*)
		Abort : ARRAY[0..MAX_SINGLE_ALARM_MIN1]OF BOOL;
		Stop : ARRAY[0..MAX_SINGLE_ALARM_MIN1]OF BOOL;
		Pause : ARRAY[0..MAX_SINGLE_ALARM_MIN1]OF BOOL;
		Info : ARRAY[0..MAX_SINGLE_ALARM_MIN1]OF BOOL;
	END_STRUCT;
END_TYPE

(**)
(**** Local Status Alarm Snippet Type*)

TYPE
	Loc_Status_Alerts_Snippet_typ : 	STRUCT  (**** Local Status Alarm Snippet Type*)
		Index : DINT; (**** Snippet alarm index degeri*)
		Val : BOOL; (**** Snippet alarm degeri*)
	END_STRUCT;
END_TYPE

(**)
