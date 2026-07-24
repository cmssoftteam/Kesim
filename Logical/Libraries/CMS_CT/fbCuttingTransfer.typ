
TYPE
	fbCuttingTransferLoc_type : 	STRUCT 
		GlassGettingActive : BOOL;
		GlassTransferActive : BOOL;
		FirstInStep : BOOL;
		OldState : fbCuttingTransferState_type;
		TON_BeltDown : TON;
		LoaderGlassExitDelay : TOF;
		StepTimer : TON;
	END_STRUCT;
	fbCuttingTransferSens_type : 	STRUCT 
		LoaderGlassExit_SW : BOOL;
		BeltGlassExit_SW : BOOL;
		BeltStop_SW : BOOL;
		BeltUp_SW : BOOL;
		BeltDown_SW : BOOL;
		BT_DownSW : BOOL;
		YCarrBack_SW : BOOL;
		CT_BeltMotFault : BOOL;
	END_STRUCT;
	fbCuttingTransferState_type : 
		(
		CT_INIT := -1,
		CT_WAIT_CMD := 0,
		CT_BELT_UP := 1,
		CT_GET_OR_TRANSFER_GLASS := 2,
		CT_WAIT_FINISH_TRANS := 3,
		CT_BELT_DOWN := 4,
		CT_WAIT_BELT_DOWN := 5,
		CT_WAIT_CMD_DONE := 6,
		CT_TRANS_ERROR := 999
		);
	fbCuttingTransferDO_type : 	STRUCT 
		GlassTransToCuttingTable : BOOL;
		CT_TransportBeltUp : BOOL;
		CT_YCARRIERDOWNVALVE : BOOL;
		CT_GLASSTRANSPORTMOTORSTART : BOOL;
		L_GLASSTRANSPORTSTART : BOOL;
		BT_FanStart : BOOL; (*Breaker Table Fan Start*)
	END_STRUCT;
	fbCuttingTransfeErrorID_type : 
		(
		NO_ERROR := 0,
		CT_TRANS_BELT_MOT_FAULT,
		CT_BELT_IS_NOT_DOWN
		);
END_TYPE
