(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: File_Ctrl
 * File: File_Ctrl.typ
 * Author: blanca-gutim
 * Created: December 06, 2012
 ********************************************************************
 * Local data types of program File_Ctrl
 ********************************************************************)
(*======================================================================================================================================*)
(*USB DETECTION STEPS (CPU)*)
(*======================================================================================================================================*)

TYPE
	USB_STEP_type : 
		(
		USB_GETNODELIST := 0, (*Create list of actives USB devices*)
		USB_SEARCHDEVICE1, (*Get device data from the USB device*)
		USB_SEARCHDEVICE2 (*Get device data from the USB device*)
		);
END_TYPE

(*======================================================================================================================================*)
(*USB DATA INTERFACE (CPU)*)
(*======================================================================================================================================*)
(*Interface for the USB detection*)

TYPE
	usb_detec_typ : 	STRUCT  (*Interface for the USB detection*)
		in : usb_detec_in_typ; (*Input sub-interface*)
		out : usb_detec_out_typ; (*Output sub-interface*)
	END_STRUCT;
END_TYPE

(*======================================================================================================================================*)
(*USB DATA INTERFACE: INPUTS*)
(*======================================================================================================================================*)
(*Output sub-interface*)

TYPE
	usb_detec_in_typ : 	STRUCT 
		Enable : BOOL; (*Enable USB detection*)
	END_STRUCT;
END_TYPE

(*======================================================================================================================================*)
(*USB DATA INTERFACE: OUTPUTS*)
(*======================================================================================================================================*)
(*Output sub-interface*)

TYPE
	usb_detec_out_typ : 	STRUCT 
		Step : USB_STEP_type; (*Output sub-interface*)
		NrUSBDetectedDevices : USINT; (*Number of USB devices detected*)
		DeviceInfo : ARRAY[0..C_USB_DEVICES_MAX_MINUS1]OF usbNode_typ; (*Structure with the information of the detected USB device*)
	END_STRUCT;
END_TYPE
