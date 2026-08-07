(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Library: IOControl
 * File: IOControl.fun
 * Author: abdullahoglf
 * Created: February 12, 2014
 ********************************************************************
 * Functions and function blocks of library IOControl
 ********************************************************************)

FUNCTION_BLOCK BuildSignalStr (*Builds the necessary datapoint for a specific channel*)
	VAR_INPUT
		uNumStation : USINT;
		uNumSignal : USINT; (*Channel number*)
		eTypeSignal : IOTypeChannel_enm; (*Channel type*)
		sStrSignal : STRING[255];
		selectedWashingModule : BOOL;
	END_VAR
	VAR
		str : STRING[255];
		sEPL : STRING[32];
	END_VAR
END_FUNCTION_BLOCK
