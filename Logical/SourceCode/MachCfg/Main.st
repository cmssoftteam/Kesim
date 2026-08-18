
PROGRAM _INIT
	//===========================================
	//			AXES LINKAGE
	//===========================================
	
	(* AX_X *)
	gAxBasic[AX_X].MpLink	   := ADR(gMpLink_AxisQX);
	gAxBasic[AX_X].Parameters  := ADR(gAxBasicPar[AX_X]);
	gAxBasic[AX_X].Enable	   := TRUE;
	
	(* AX_Y *)
	gAxBasic[AX_Y].MpLink	    := ADR(gMpLink_AxisQY);
	gAxBasic[AX_Y].Parameters 	:= ADR(gAxBasicPar[AX_Y]);
	gAxBasic[AX_Y].Enable	    := TRUE;
	
	(* AX_c *)
	gAxBasic[AX_C].MpLink	    := ADR(gMpLink_AxisVQZ);
	gAxBasic[AX_C].Parameters 	:= ADR(gAxBasicPar[AX_C]);
	gAxBasic[AX_C].Enable	    := TRUE;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	gAxBasic[AX_X]();
	gAxBasic[AX_Y]();
	gAxBasic[AX_C](); 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

