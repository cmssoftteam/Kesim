
TYPE
	Timers_typ : 	STRUCT 
		TON_HomeState : TON;
		TON_ParkState : TON;
	END_STRUCT;
	Loc_typ : 	STRUCT 
		FirstInSubState : BOOL;
		FirstInMainState : BOOL;
		OldSubState : gMainSubState_Enum;
		OldMainState : gMainState_Enum;
		Timers : Timers_typ;
	END_STRUCT;
END_TYPE
