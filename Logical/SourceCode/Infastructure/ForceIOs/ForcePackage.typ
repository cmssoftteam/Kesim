(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: ForceIOs
 * File: ForcePackage.typ
 * Author: abdullahoglf
 * Created: February 12, 2014
 ********************************************************************
 * Data types of package ForceIOs
 ********************************************************************)
(**)
(**************************************************************************************)
(*IO Handling Package Datatypes*)
(**************************************************************************************)

TYPE
	DisposeInfoCommands_typ : 	STRUCT 
		disponseInfo : BOOL; (*Cmd to dispose info*)
	END_STRUCT;
END_TYPE

(*I/O's for DiagGetStrInfo()*)

TYPE
	GetStrInfoCommands_typ : 	STRUCT 
		infoCode : UDINT; (*Information code configured for the FB*)
		desiredStr : STRING[80]; (*Returned information from the FB*)
		index : UDINT; (*Index of the HW module -- corresponds to an internal order; does not have to be the same with the physical order*)
		getStrInfo : BOOL; (*Cmd to get the information*)
	END_STRUCT;
END_TYPE

(*I/O's for DiagGetStrInfo()*)

TYPE
	GetNumInfoCommands_typ : 	STRUCT 
		infoCode : UDINT; (*Information code configured for the FB*)
		index : UDINT; (*Index of the HW module -- corresponds to an internal order; does not have to be the same with the physical order*)
		getNumInfo : BOOL; (*Cmd to get the numeric information*)
		desiredNum : UDINT; (*Returned numric info from the FB*)
	END_STRUCT;
END_TYPE

(*I/O's for DiagCreateInfo()*)

TYPE
	CreateInfoCommands_typ : 	STRUCT 
		plugged : BOOL; (*Cmd to get information about the plugged HW modules*)
		createInfo : BOOL; (*Cmd to get the information*)
		configured : BOOL; (*Cmd to get information about the configured HW modules*)
		all : BOOL; (*Cmd to get information about all the HW modules*)
	END_STRUCT;
	Info_typ : 	STRUCT 
		NumbersEntries : UDINT; (*Number of entries*)
		Ident : UDINT; (*ID of the information *)
		errorAck : BOOL; (*Error acknowledgement button*)
		errorFlag : BOOL; (*Error flag*)
		errorStatement : STRING[80]; (*Error statement*)
		Index : UDINT; (*Index for the list*)
	END_STRUCT;
END_TYPE

(*Default values for the list*)

TYPE
	List_typ : 	STRUCT 
		moduleState : UDINT; (*Module state --- 1 = configured but not plugged; 2 = inserted but not configured; 3 = configured & plugged; 4 = inserted module is different than the configured module*)
		name : STRING[80]; (*Returned HW module name*)
		index : UDINT; (*Index of the HW module -- corresponds to an internal order; does not have to be the same with the physical order*)
	END_STRUCT;
END_TYPE

(*I/O's for GET_LIST*)

TYPE
	GetList_typ : 	STRUCT 
		List : ARRAY[0..100]OF List_typ; (*The HW module information list*)
		GetList : BOOL; (*Cmd to create the list*)
	END_STRUCT;
END_TYPE
