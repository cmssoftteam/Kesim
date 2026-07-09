(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 *******************************************************************
 * Task: MAIN
 * Author: kay3a 
 * Created: October 16, 2024/11:08 AM 
 ********************************************************************)

TYPE
	Loc_typ : 	STRUCT  (**** Local Type*)
		FB : Loc_FB_typ; (**** Local FB Type*)
		Par : Loc_Par_typ;
		Cmd : Loc_Cmd_typ; (**** Local Command Type*)
		Status : Loc_Status_typ; (**** Local Status Type*)
	END_STRUCT;
END_TYPE

(**)
(**** Local FB Type*)

TYPE
	Loc_FB_typ : 	STRUCT  (**** Local FB Type*)
		Cnc3Axis : MpCnc3Axis; (**** CNC FB*)
		DirCreate : FbDirCreate; (**** CNC Direction create*)
		FileCreate : FbFileCreate; (**** CNC File create*)
	END_STRUCT;
END_TYPE

(**)
(**** Local Par Type*)

TYPE
	Loc_Par_typ : 	STRUCT  (**** Local Par Type*)
		Cnc3Axis : MpCnc3AxisParType;
	END_STRUCT;
END_TYPE

(**)
(**** Local Cmd Type*)

TYPE
	Loc_Cmd_typ : 	STRUCT  (**** Local Cmd Type*)
		New_Member : USINT;
	END_STRUCT;
END_TYPE

(**)
(**** Local Status Type*)

TYPE
	Loc_Status_typ : 	STRUCT  (**** Local Status Type*)
		New_Member : USINT;
	END_STRUCT;
END_TYPE

(**)
