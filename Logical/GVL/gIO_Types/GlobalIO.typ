
TYPE
	gIO_BreakerOut_typ : 	STRUCT 
		FanDoorControl : BOOL;
		FanStart : BOOL;
		WorkEnable : BOOL;
		TableValveUpSlow : BOOL;
		TableValveDownSlow : BOOL;
		TableDownValve : BOOL;
		TableUpValve : BOOL;
		HydraulicPumpStart : BOOL;
		PositionersUpValve : BOOL;
		PositionersDownValve : BOOL;
		LeftCarrierUp : BOOL;
	END_STRUCT;
	gIO_BreakerIn_typ : 	STRUCT 
		BT_EStop : BOOL; (* BT = Breaker Table *)
		BT_IsUpSW : BOOL; (* BT = Breaker Table *)
		BT_IsUpSlowSW : BOOL; (* BT = Breaker Table *)
		BT_IsDownSW : BOOL; (* BT = Breaker Table *)
		BT_IsDownSlowSW : BOOL; (* BT = Breaker Table *)
		BT_TransferBtn : BOOL; (* BT = Breaker Table *)
		BT_FanStartPedal : BOOL; (* BT = Breaker Table *)
		BT_FanMotorFault : BOOL; (* BT = Breaker Table *) (* Axis*)
		BT_CarrierIsUpSW : USINT; (* BT = Breaker Table *)
		BT_HydPumpMotorFault : USINT; (* BT = Breaker Table *)
	END_STRUCT;
	gIO_InCT_typ : 	STRUCT  (*Cutting Table Input Types*)
		EmergencyStop : BOOL; (*Emergency Stop Input to make an emergency stop*)
		PhaseRelayFault : BOOL; (*Phase Relay Fault detection*)
		ResetButton : BOOL; (*Reset Button to reset any faults*)
		StartButton : BOOL; (*Start button to start machine in automade*)
		PauseButton : BOOL; (*Pause button to pause the machine during cut*)
		FanMotorFault : BOOL; (*Fan Motor Fault detection for cutting table and breaker table*)
		SetPressureReached : BOOL; (*Cutting pressure reached set value, feedback signal*)
		FanPedal : BOOL; (*Manual Pedal control input for table fan start (toggle input)*)
		LowAirPressure : BOOL; (*Low air pressure sensor*) (* ockm*)
		TableDownSlowSwicth : BOOL; (*OCKM*)
		TableUpSlowSwicth : BOOL; (*OCKM*)
		TableUpStopSwicth : BOOL; (*OCKM*)
		TableDownStopSwicth : BOOL; (*OCKM*)
		HydraulicMotorTermic : BOOL; (*OCKM*)
		HydraulicMotorRun : BOOL; (*OCKM*)
		GlassSearchSensor : BOOL;
		HeadMaxDownSensor : BOOL;
		TableSquareBack : BOOL; (*FCL*)
		GlassTransBeltIsDown : BOOL; (*FCL*)
		GlassStopSW : BOOL; (*FCL*)
		GlassExitSW : BOOL; (*FCL*)
		AxisX_PositiveLimit : BOOL;
		AxisX_NeativeLimit : BOOL;
		AxisX_ReferenceLimit : BOOL; (*AX_X*)
		AxisY_ReferenceLimit : BOOL; (*AX_Y*)
		AxisC_ReferenceLimit : BOOL; (*AX_C*)
	END_STRUCT;
	gIO_In_typ : 	STRUCT 
		Breaker : gIO_BreakerIn_typ;
		CT : gIO_InCT_typ; (*CT = Cutting Table*)
		Loader : USINT;
	END_STRUCT;
	gIO_Out_CT_typ : 	STRUCT 
		RedLamp : BOOL; (*Red Lamp On if Error Occured*)
		YellowLamp : BOOL; (*Yellow Lamp On if manual activation *)
		GreenLamp : BOOL; (*Green Lamp On if machine cutting*)
		Reset : BOOL; (*Reset output signal*)
		CuttingHeadDown : BOOL; (*Send Cutting Head Down to glass surface*)
		DiamondOil : BOOL; (*Oil SupplyTANK Selection Tank-2*)
		LowEMotorStart : BOOL; (*Start LowE Motor  , Start and Stop conttroled by one output*)
		LowEMotorDown : BOOL; (*Low_e Motor UP and Down Controlled by one output*)
		FanDoorClose : BOOL; (*Close door in fan for blowers*)
		FanStart : BOOL; (*Table Fan Start Command*)
		SquareForward : BOOL; (*Move forward square system*) (* OCKM*)
		HydraulicMotorStart : BOOL;
		TableUpValve : BOOL; (*OCKM*)
		TableDownValve : BOOL; (*OCKM*)
		TableUpSlowValve : BOOL; (*OCKM*)
		TableDownSlowValve : BOOL; (*OCKM*)
		SquareUpValve : BOOL; (*OCKM*)
		SquareDownValve : BOOL; (*OCKM*)
		XYGlassBreakControl : BOOL; (*OCKM*)
		AO_CuttingPressure : USINT; (*Analog Output Cutting Pressure*)
	END_STRUCT;
	gIO_Out_Loader_typ : 	STRUCT 
		New_Member : USINT;
	END_STRUCT;
	gIO_Out_typ : 	STRUCT 
		CT : gIO_Out_CT_typ;
		Breaker : gIO_BreakerOut_typ;
		Loader : gIO_Out_Loader_typ;
	END_STRUCT;
	gIO_typ : 	STRUCT 
		In : gIO_In_typ;
		Out : gIO_Out_typ;
	END_STRUCT;
END_TYPE
