(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: ForceIO
 * File: ForceIO.typ
 * Author: abdullahoglf
 * Created: December 18, 2013
 ********************************************************************
 * Local data types of program ForceIO
 ********************************************************************)

TYPE
	Status_typ : 	STRUCT 
		ModuleForceStatus : ARRAY[0..NUMBER_OF_MODULES_MINUS_ONE]OF ForceStatus_typ;
		ErrorActive : USINT; (*Flag that error is active*)
	END_STRUCT;
	ForceStatus_typ : 	STRUCT 
		ForceValueOld : ARRAY[0..15]OF UDINT; (*Force value from the HMI from the previous cycle*)
		ForceValue : ARRAY[0..15]OF UDINT; (*Force value from the HMI*)
		ForceStatusOld : ARRAY[0..15]OF BOOL; (*Represents the force status request from the HMI of the related I/O channel from previous cycles*)
		ForceStatus : ARRAY[0..15]OF BOOL; (*Represents the current force status request from the HMI of the related I/O channel*)
		IsForced : ARRAY[0..15]OF BOOL; (*Represents the current force status of the channel*)
	END_STRUCT;
	ForceModuleParameter_typ : 	STRUCT 
		DatapointToControl : ARRAY[0..15]OF UDINT;
	END_STRUCT;
	ForceParameters_typ : 	STRUCT 
		ModuleForceParameter : ARRAY[0..NUMBER_OF_MODULES_MINUS_ONE]OF ForceModuleParameter_typ;
	END_STRUCT;
	ForceCmd_typ : 	STRUCT 
		ErrAck : BOOL; (*Error Acknowledge*)
		GetStatus : BOOL; (*Cmd to get the status*)
		DisableForceGlobal : BOOL; (*Disables forcing for all channels*)
		WriteForceValue : BOOL; (*Cmd to write the force value to the channel*)
		DisableForce : BOOL; (*Disables forcing for a specific channel*)
		Force : BOOL; (*Enables forcing for a specific channel*)
	END_STRUCT;
	ForceHandle_typ : 	STRUCT 
		Cmd : ForceCmd_typ;
		Status : Status_typ;
		Parameters : ForceParameters_typ;
	END_STRUCT;
	GetStatus_enm : 
		(
		STATUS_ERROR,
		STATUS_GET_STATUS,
		STATUS_WAIT
		);
	ForceStep_enm : 
		(
		FORCE_WAIT := 0,
		FORCE_ENABLE_FORCE := 10,
		FORCE_WRITE := 20,
		FORCE_DISABLE_SPECIFIC_FORCE := 30,
		FORCE_DISABLE_ALL := 40,
		FORCE_ERROR := 99
		);
END_TYPE
