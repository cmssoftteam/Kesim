(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Package: CuttingTable
 * File: Parameter.typ
 * Author: blanca-gutim
 * Created: December 07, 2012
 ********************************************************************
 * Data types of package CuttingTable
 ********************************************************************)
(**)
(*========================================================================================================*)
(*Structure with machine parameters*)
(*========================================================================================================*)

TYPE
	gParameters_type : 	STRUCT 
		BridgeStraight : BOOL; (*Command is taken from the HMI when the bridge straightness is set by the user*)
		MachineType : USINT; (*Machine type*)
		Options : Parameters_Options_typ;
		LengthParametes : LengthParametes_type; (*Length parameters*)
		DriverParameters : ARRAY[0..5]OF DriverParameters_type; (*Drive parameters*)
		PressParameters : PressParameters_type; (*Pressure parameters*)
(*		LoaderParameters : LoaderCtrl_In_Par_typ; (*Loader parameters*)
		Network : Recipe_Ctrl_In_Par_Net_typ; (*Network parameters*)
	END_STRUCT;
END_TYPE

(**)
(*========================================================================================================*)
(*Options*)
(*========================================================================================================*)

TYPE
	Parameters_Options_typ : 	STRUCT 
		HW : Parameters_Options_HW_typ; (*Cutting table HW options*)
		SW : Parameters_Options_SW_typ; (*Cutting table SW options*)
	END_STRUCT;
	Parameters_Options_HW_Gantry_typ : 	STRUCT 
		Active : BOOL;
		HoldingBrakes : BOOL;
		MultiturnEnc : BOOL;
	END_STRUCT;
	Parameters_Options_HW_typ : 	STRUCT 
		LinearMotors_v1 : BOOL;
		LinearMotors_v2 : BOOL;
		NewLowE : BOOL; (*New version of the Low-E*)
		InkJet : {REDUND_UNREPLICABLE} BOOL; (*Inkjet printer exists in the machine instead of the old labeler system*)
		Labeler : BOOL;
		CAxisRev0 : BOOL; (*Revision xx-0 for the C axis [since it's a resolver, this should be known within the system so that the HW cfg is done accordingly]*)
		Gantry : Parameters_Options_HW_Gantry_typ;
		OCKMEnableTransferToBT : BOOL; (*Requested by the customer for one machine [14.05.2015].
The feature enables the glass transfer from the table to another machine in line. The process is the same with the YCKM_BREAKERs*)
	END_STRUCT;
	Parameters_Options_SW_typ : 	STRUCT 
		TorqueDiffTimeout : REAL;
		TorqueDiffLimit : REAL;
		GanTorqMonTimeoutError : USINT; (*Option to treat the torque difference monitoring timeout as an error; by default it is treated as a warning*)
		NewGCodeRecipe : BOOL;
		GantryTorqueMonActive : BOOL; (*Option to activate the torque difference monitoring *)
		KeepBridgeEnabled : BOOL; (*Option keep the bridge axes enabled all the time*)
		AutoHwCfg : BOOL;
		AutoUserLogout : BOOL; (*Option to de/activate the automatic user logout functionality*)
		ManualOptimization : BOOL; (*Option to de/activate the manual optimization feature (since version  A3.54.0)*)
		LanguageEnable : ARRAY[0..9]OF BOOL; (*Enable the corresponding language to make it selectible on the HMI when the translations are there*)
	END_STRUCT;
END_TYPE

(**)
(*========================================================================================================*)
(*Length parameters*)
(*========================================================================================================*)

TYPE
	LengthParametes_type : 	STRUCT 
		BAxisHomePos : REAL;
		BAxisMultiSetPos : REAL;
		YAxisMultiSetPos : REAL; (*Multiturn encoder home offset value for the Y axis [mm] / 0 when not applicable*)
		YAxisMultiHomeOffset : REAL; (*Set position for the multiturn encoder for the Y axis [mm] / 0 when not applicable*)
		MasterHomeOffset : REAL; (*Multiturn encder home offset value for master X axis [mm]*)
		MasterMultiSetPos : REAL; (*Set position of the multiturn encoder for the master*)
		SlaveHomeOffset : REAL; (*Multiturn encder home offset value for slave X2 axis [units]*)
		SlaveMultiSetPos : REAL; (*Set position of the multiturn encoder for the slave*)
		HeadUpTime : REAL; (*Time for the cutting head to move up [s]*)
		HeadDownTime : REAL; (*Time for the cutting head to move down [s]*)
		Low_eAboveTime : REAL; (*Time for the Low-E head to move up [s]*)
		Low_eBelowTime : REAL; (*Time for the Low-E head to move down [s]*)
		WaitPressureTime : REAL; (*Time to wait for the pressure reached [s]*)
		SquareForwardTime : REAL; (*Time to wait for the square forward movement [s]*)
		StretchingTime : REAL; (*Time to define how long the oil must be pumped when the machine starts operation [s] - NOT USED NOW*)
		X_GlassOriginPos : REAL; (*X distance between the Reference position and the Glass Origin position when the glass is placed without shift or rotation [mm]*)
		Y_GlassOriginPos : REAL; (*Y distance between the Reference position and the Glass Origin position when the glass is placed without shift or rotation [mm]*)
		C_GlassOriginPos : REAL; (*Offset between the cutting head and the glass (alignment) [°] - IT HAS TO BE MEASURED*)
		Y_GlassOriginPos_Right : REAL; (*Y distance between the Glass Origin position in the right side of the machine and the positive software limit in Y direction[mm] - ONLY IN FCL BIG SIZE MACHINES*)
		OffsetSpeed : REAL; (*Speed to move to Origin position [% prespect to maximum speed]*)
		X_AxisOffsetMachine : REAL; (*X offset between the cutting head and the laser sensor [mm]*)
		Y_AxisOffsetMachine : REAL; (*Y offset between the cutting head and the laser sensor [mm]*)
		Distance_Lowe_CuttingHead_X : REAL; (*X distance between cutting head and Low-E head [mm] *)
		Distance_Lowe_CuttingHead_Y : REAL; (*Y distance between cutting head and Low-E head [mm]*)
		X_HomeOffsetPos : REAL; (*X axis home offset [mm] - IT DEFINES THE REFERENCE POSITION, WHERE AXES ARE 0 units*)
		Y_HomeOffsetPos : REAL; (*Y axis home offset [mm] - IT DEFINES THE REFERENCE POSITION, WHERE AXES ARE 0 units*)
		C_HomeOffsetPos : REAL; (*C axis home offset [°] - IT DEFINES THE REFERENCE POSITION, WHERE AXES ARE 0 units*)
		ParkSpeed : REAL; (*Speed to move to Park position [% prespect to maximum speed]*)
		X3_Offset : REAL;
		X2_Offset : REAL;
		Y1_Offset : REAL;
		X_SafeLoadPosition : REAL; (*X axis position mandatory before loading*)
		MoveSafeLoadSpeed : REAL; (*Speed at which bridge will move to safe loading position*)
		Y_SafeLoadPosition : REAL; (*Y axis position mandatory before loading*)
		X_GlassTransferEndPosition : REAL; (*X axis, end position of transfer of the glass to breaking table*)
		Y_GlassTransferEndPosition : REAL; (*Y axis, end position of transfer of the glass to breaking table*)
		HomeSpeedTrigger : REAL;
		AutoSquaringSpeed : REAL; (*Auto squaring speed from the memory*)
		PushGlassSpeed : REAL; (*Speed at which glass should be transfered pushed after loading*)
		TransferSpeed : REAL; (*Speed at which glass should be transfered to breaking table*)
		StraightBridgeDelta : DINT; (*Defined by user, offset between ref pulses of X and X2 axes, having this parameter we can establish straigh position of bridge*)
		X_PushPositionEnd : REAL; (*Position when to finish glass pushing*)
		Y_PushPositionEnd : REAL; (*Position when to finish glass pushing*)
		Y_TransferPositionStart : REAL; (*Position when to start glass pushing/transfering*)
		X_TransferPositionStart : REAL; (*Position when to start glass pushing/transfering*)
		LabelApplyTime : REAL; (*Label application time*)
		InkJetPrintStroke : {REDUND_UNREPLICABLE} REAL; (*Stroke within which the inkjet should print*)
		InkJetPrintSpeed : {REDUND_UNREPLICABLE} REAL; (*Optimum speed at which the inkjet should perform the print (PLC will check the actual path speed of the CNC and trigger the print)*)
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*Drive parameters*)
(*========================================================================================================*)

TYPE
	DriverParameters_type : 	STRUCT 
		CntDir : USINT; (*Encoder counting direction*)
		DriveStep : REAL; (*Units needed for the motor to complete one turn [um] - THE SAME THAN units IN LOAD IN ACP INIT TABLE*)
		PositiveLimit : REAL; (*Positive software limit [mm] - THE SAME THAN IN LOAD IN ACP INIT TABLE*)
		NegativeLimit : REAL; (*Negative software limit [mm] - THE SAME THAN IN LOAD IN ACP INIT TABLE*)
		PID : DriverParameters_PID_type; (*PID parameters - THE SAME THAN IN CONTROLLER IN ACP INIT TABLE*)
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*Drive PID parameters*)
(*========================================================================================================*)

TYPE
	DriverParameters_PID_type : 	STRUCT 
		A0 : REAL;
		A1 : REAL;
		B0 : REAL;
		B1 : REAL;
		FilterType : UINT;
		Mode : USINT; (*Controller mode*)
		SpeedController : DriverParameters_PID_kv_tn_type; (*PID parameters for speed controller*)
		PositionController : DriverParameters_PID_kv_tn_type; (*PID parameters for position controller*)
		FeedForward : DriverParameters_FF_type; (*Feed forward related parameters*)
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*Drive PID parameters: kn and tv*)
(*========================================================================================================*)

TYPE
	DriverParameters_PID_kv_tn_type : 	STRUCT 
		kv : REAL; (*Proportional amplification*)
		tn : REAL; (*Integral action time [s]*)
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*Drive Feed forward parameters*)
(*========================================================================================================*)

TYPE
	DriverParameters_FF_type : 	STRUCT 
		Torque_Pos : REAL; (*Torque in positive direction [Nm]*)
		Torque_Neg : REAL; (*Torque in negative direction [Nm]*)
		Torque_Load : REAL; (*Load torque [Nm]*)
		Kv_Torque : REAL; (*Speed torque factor [Nms]*)
		Inertia : REAL; (*Mass moment of inertia [kgm²]*)
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*Pressure parameters*)
(*========================================================================================================*)

TYPE
	PressParameters_type : 	STRUCT 
		PressureCalibration : REAL; (*Coefficient to convert pressure value in Analog Output*)
		PressureCoefficent : REAL; (*Indicates the pressure value set in Automatic Mode page*)
		HeadDownPress : REAL; (*Pressure when the cutting head is moving down [bar]*)
		VinylCutPressure : REAL; (*Pressure when the vynil cutting is done*)
		LoweDownPressure : REAL; (*Low-e down pressure - used only for the new low-e system *)
		GlassType : Press_Params_Glass_type; (*Parameters dependent on the glass type*)
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*Pressure parameters that are dependent on the glass type*)
(*========================================================================================================*)

TYPE
	Press_Params_Glass_type : 	STRUCT 
		T2 : Glass_PressureType; (*Glass thickness equal to 2 mm*)
		T3 : Glass_PressureType; (*Glass thickness equal to 3 mm*)
		T4 : Glass_PressureType; (*Glass thickness equal to 4 mm*)
		T5 : Glass_PressureType; (*Glass thickness equal to 5 mm*)
		T6 : Glass_PressureType; (*Glass thickness equal to 6 mm*)
		T8 : Glass_PressureType; (*Glass thickness equal to 8 mm*)
		T10 : Glass_PressureType; (*Glass thickness equal to 10 mm*)
		T12 : Glass_PressureType; (*Glass thickness equal to 12 mm*)
		T15 : Glass_PressureType; (*Glass thickness equal to 15 mm*)
		T19 : Glass_PressureType; (*Glass thickness equal to 19 mm*)
	END_STRUCT;
END_TYPE

(*========================================================================================================*)
(*Pressure parameters that are dependent on the glass type*)
(*========================================================================================================*)

TYPE
	Glass_PressureType : 	STRUCT 
		MFunctionStart : UINT; (*Value of the fist M-Function used for this pressure values*)
		Pressure : ARRAY[0..5]OF REAL; (*Set pressure for different kinds of cut [bar]*)
	END_STRUCT;
END_TYPE

