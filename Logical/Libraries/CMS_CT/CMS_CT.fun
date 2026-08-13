
{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK fbTONOF (*TON And TOF Timer*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Input : {REDUND_UNREPLICABLE} BOOL;
		TON_Time : {REDUND_UNREPLICABLE} TIME;
		TOF_Time : {REDUND_UNREPLICABLE} TIME;
	END_VAR
	VAR_OUTPUT
		Q : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR
		mode : {REDUND_UNREPLICABLE} BOOL;
		old : {REDUND_UNREPLICABLE} BOOL;
		TON_Timer : {REDUND_UNREPLICABLE} TON;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK fbToggle (*TODO: Toggle*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL;
		CLK : {REDUND_UNREPLICABLE} BOOL;
		Rst : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR_OUTPUT
		Q : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
	VAR
		_edge : {REDUND_UNREPLICABLE} BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK fbStateHistory (*State History LOgger*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		inEnable : {REDUND_UNREPLICABLE} BOOL;
		inReset : {REDUND_UNREPLICABLE} BOOL;
		inAlarm : BOOL;
		inActState : {REDUND_UNREPLICABLE} INT;
		N : {REDUND_UNREPLICABLE} INT;
	END_VAR
	VAR_OUTPUT
		outStateHistory : {REDUND_UNREPLICABLE} ARRAY[0..10] OF INT;
		outErrorHistory : ARRAY[0..2,0..10] OF INT;
	END_VAR
	VAR
		OldActState : {REDUND_UNREPLICABLE} INT;
		j : {REDUND_UNREPLICABLE} INT;
		i : {REDUND_UNREPLICABLE} INT;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK fbTableUpDown (*Table Up Down Movement for OCKM And Breaker*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL;
		In : {REDUND_UNREPLICABLE} fbTableUpDownIn_type;
	END_VAR
	VAR_OUTPUT
		Out : {REDUND_UNREPLICABLE} fbTableUpDownOut_type;
	END_VAR
	VAR
		Loc : fbTableUpDownLoc_type;
		Step : UINT;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK fbCuttingTransfer (*Transfer Glass To Cutting OR To Breaker*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		inEnable : BOOL;
		inSimulation : BOOL;
		inLoaderReadyToTransfer : {REDUND_UNREPLICABLE} BOOL;
		inCTReadyToTransfer : BOOL;
		inSensors : fbCuttingTransferSens_type;
		inReset : BOOL;
		inGlassTransfer : BOOL;
	END_VAR
	VAR_OUTPUT
		outActive : BOOL;
		outGlassTransferDone : BOOL;
		outGlassTransferActive : BOOL;
		outDO : fbCuttingTransferDO_type;
		outCommandDone : BOOL;
		outError : BOOL;
		outErrorID : fbCuttingTransfeErrorID_type;
		outState : fbCuttingTransferState_type;
	END_VAR
	VAR
		Loc : fbCuttingTransferLoc_type; (*Local Variables*)
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION fcFind_Origin : BOOL (*The equation of a line where 2 points are known and the 3rd point is perpendicular to it.*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : BOOL;
		X : REAL;
		X1 : REAL; (*The second X point read*)
		Y1 : REAL; (*The second Y point read*)
		X2 : REAL; (*The third X point read *)
		Y2 : REAL; (*The third Y  point read *)
		X3 : REAL; (*The first X point read*)
		SearchSensorXOffset : REAL;
		SearchSensorYOffset : REAL;
		Y3 : REAL; (*The first Y point read*)
	END_VAR
	VAR_IN_OUT
		F_LIN2 : REAL; (*The equation of a line whose two points are read.*)
		m2 : REAL; (*The tangent of a line read from two points.*)
		F_LIN1 : REAL; (*The equation of a line whose one  point are read.*)
		m1 : REAL; (*The equation of a line whose one  points are read.*)
		X0 : REAL; (*Calculated part X zero point*)
		Y0 : REAL; (*Calculated part Y zero point*)
		DEGREE : REAL;
		RADYAN : REAL;
	END_VAR
	VAR
		k : REAL;
	END_VAR
END_FUNCTION
