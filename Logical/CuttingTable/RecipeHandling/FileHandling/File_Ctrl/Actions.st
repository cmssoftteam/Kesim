(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Program: gRecipe_Ctrl
 * File: Actions.st
 * Author: blanca-gutim
 * Created: December 04, 2012
 ********************************************************************
 * Implementation of program gRecipe_Ctrl
 ********************************************************************) 

(* Input actions *)
ACTION Action_Input: 
	
	//Update inputs
	gFile_Ctrl.In.Cmd		:= gRecipe_Ctrl.Out.Cmd.FileHandling;
	gFile_Ctrl.In.Par		:= gRecipe_Ctrl.Out.Par.FileHandling;
	
	//USB detection
	Action_USB_Detection;
	
END_ACTION

(* Output actions *)
ACTION Action_Output: 
	
	//Update outputs, reset command done status
	gFile_Ctrl.Out.Stat.CmdDone.DeleteFile			:= gFile_Ctrl.Out.Stat.CmdDone.DeleteFile			AND gFile_Ctrl.In.Cmd.DeleteFile;
	gFile_Ctrl.Out.Stat.CmdDone.ErrorAcknowledge	:= gFile_Ctrl.Out.Stat.CmdDone.ErrorAcknowledge		AND gFile_Ctrl.In.Cmd.ErrorAcknowledge;
	gFile_Ctrl.Out.Stat.CmdDone.GetFileDeviceInfo	:= gFile_Ctrl.Out.Stat.CmdDone.GetFileDeviceInfo	AND gFile_Ctrl.In.Cmd.GetFileDeviceInfo;
	gFile_Ctrl.Out.Stat.CmdDone.LinkFileDevice		:= gFile_Ctrl.Out.Stat.CmdDone.LinkFileDevice		AND gFile_Ctrl.In.Cmd.LinkFileDevice;
	gFile_Ctrl.Out.Stat.CmdDone.ReadDirectory		:= gFile_Ctrl.Out.Stat.CmdDone.ReadDirectory		AND gFile_Ctrl.In.Cmd.ReadDirectory;
	gFile_Ctrl.Out.Stat.CmdDone.UnlinkFileDevice	:= gFile_Ctrl.Out.Stat.CmdDone.UnlinkFileDevice		AND gFile_Ctrl.In.Cmd.UnlinkFileDevice;
	
	//Update output, get MainState and Error State in String and UDINT variables (for tracing and debuging)
	gFile_Ctrl.Out.Stat.MainState					:= MainState;
	gFile_Ctrl.Out.Stat.MainState_Text				:= StateStrings[MainState];
	
	//Update output, USB devices information
	gFile_Ctrl.Out.Stat.UsbInformation[0]			:= USBDetectionIF.out.DeviceInfo[0];
	gFile_Ctrl.Out.Stat.UsbInformation[1]			:= USBDetectionIF.out.DeviceInfo[1];
	
END_ACTION

(* USB detection *)
ACTION Action_USB_Detection: 
	
	//==================================================================================================================
	//STATE MACHINE FOR THE DETECTION OF THE USB DEVICES IN THE CPU
	//==================================================================================================================	
	
	IF (USBDetectionIF.in.Enable = TRUE) THEN
	
		CASE (USBDetectionIF.out.Step) OF
			
			//==================================================================================================================
			USB_GETNODELIST:
			//==================================================================================================================	
				
				UsbNodeListGet_USBDetec.enable					:= TRUE;
				UsbNodeListGet_USBDetec.pBuffer					:= ADR(usbNodeList[0]);
				UsbNodeListGet_USBDetec.bufferSize				:= SIZEOF(usbNodeList);
				UsbNodeListGet_USBDetec.filterInterfaceClass	:= asusb_CLASS_MASS_STORAGE;
				UsbNodeListGet_USBDetec.filterInterfaceSubClass	:= asusb_SUBCLASS_SCSI_COMMAND_SET;
				UsbNodeListGet_USBDetec();
				IF (UsbNodeListGet_USBDetec.status = ERR_OK) THEN
					//USB device found, get information from the device and get the number of detected USB devices
					USBDetectionIF.out.NrUSBDetectedDevices := 0;
					FOR ii := 1 TO C_USB_DEVICES_MAX_MINUS1 BY 1 DO
						IF (usbNodeList[ii] <> 0) THEN
							USBDetectionIF.out.NrUSBDetectedDevices := USBDetectionIF.out.NrUSBDetectedDevices + 1;
						END_IF	
					END_FOR	
					USBDetectionIF.out.Step:= DINT_TO_UINT(USB_SEARCHDEVICE1);
				ELSIF (UsbNodeListGet_USBDetec.status = asusbERR_USB_NOTFOUND) THEN
					//The USB is not found -> Clear structure with information 
					memset(ADR(USBDetectionIF.out.DeviceInfo), 0, SIZEOF(USBDetectionIF.out.DeviceInfo));	
					USBDetectionIF.out.NrUSBDetectedDevices := 0;		
				ELSE
					IF ((UsbNodeListGet_USBDetec.status = asusbERR_BUFSIZE) OR (UsbNodeListGet_USBDetec.status = asusbERR_NULLPOINTER)) THEN
						//* Error Handling */
						gFile_Ctrl.Out.Stat.Error.Number		:= UINT_TO_UDINT(UsbNodeListGet_USBDetec.status);
						gFile_Ctrl.Out.Stat.Error.Text.Line1	:= TaskName;
						gFile_Ctrl.Out.Stat.Error.Text.Line2	:= 'USB_GETNODELIST';
						ErrorState							:= MainState;					
						MainState							:= C_MS_FILE_HAND_ERROR;
					END_IF
				END_IF
					
			//==================================================================================================================		
			USB_SEARCHDEVICE1:
			//==================================================================================================================			
			
				UsbNodeGet_USBDetec1.enable		:= TRUE;
				UsbNodeGet_USBDetec1.nodeId		:= usbNodeList[0];
				UsbNodeGet_USBDetec1.pBuffer	:= ADR(USBDetectionIF.out.DeviceInfo[0]);
				UsbNodeGet_USBDetec1.bufferSize	:= SIZEOF(USBDetectionIF.out.DeviceInfo[0]);
				UsbNodeGet_USBDetec1();
				IF (UsbNodeGet_USBDetec1.status = ERR_OK) THEN
					//No errors -> Check for the other USB or get the list of USB again
					IF (USBDetectionIF.out.NrUSBDetectedDevices = 0) THEN
						USBDetectionIF.out.Step:= DINT_TO_UINT(USB_GETNODELIST);
						//Clear the information abot the second USB device
						memset(ADR(USBDetectionIF.out.DeviceInfo[1]), 0, SIZEOF(USBDetectionIF.out.DeviceInfo[1]));
					ELSE
						USBDetectionIF.out.Step:= DINT_TO_UINT(USB_SEARCHDEVICE2);
					END_IF	
				ELSIF (UsbNodeGet_USBDetec1.status = asusbERR_USB_NOTFOUND) THEN
					//The USB is not found -> Clear structure with information and go to the previous step
					memset(ADR(USBDetectionIF.out.DeviceInfo[0]), 0, SIZEOF(USBDetectionIF.out.DeviceInfo[0]));
					USBDetectionIF.out.Step:= DINT_TO_UINT(USB_GETNODELIST);
				ELSE
					IF ((UsbNodeGet_USBDetec1.status = asusbERR_BUFSIZE) OR (UsbNodeGet_USBDetec1.status = asusbERR_NULLPOINTER)) THEN
						//* Error Handling */
						gFile_Ctrl.Out.Stat.Error.Number		:= UINT_TO_UDINT(UsbNodeGet_USBDetec1.status);
						gFile_Ctrl.Out.Stat.Error.Text.Line1	:= TaskName;
						gFile_Ctrl.Out.Stat.Error.Text.Line2	:= 'USB_SEARCHDEVICE1';
						ErrorState							:= MainState;					
						MainState							:= C_MS_FILE_HAND_ERROR;						
					END_IF
				END_IF
			
			//==================================================================================================================		
			USB_SEARCHDEVICE2:
				//==================================================================================================================			
			
				UsbNodeGet_USBDetec2.enable		:= TRUE;
				UsbNodeGet_USBDetec2.nodeId		:= usbNodeList[1];
				UsbNodeGet_USBDetec2.pBuffer	:= ADR(USBDetectionIF.out.DeviceInfo[1]);
				UsbNodeGet_USBDetec2.bufferSize	:= SIZEOF(USBDetectionIF.out.DeviceInfo[1]);
				UsbNodeGet_USBDetec2();
				IF (UsbNodeGet_USBDetec2.status = ERR_OK) THEN
					//No errors -> Get the list of USB again
					USBDetectionIF.out.Step:= DINT_TO_UINT(USB_GETNODELIST);	
				ELSIF (UsbNodeGet_USBDetec2.status = asusbERR_USB_NOTFOUND) THEN
					//The USB is not found -> Clear structure with information and go to the previous step
					memset(ADR(USBDetectionIF.out.DeviceInfo[1]), 0, SIZEOF(USBDetectionIF.out.DeviceInfo[1]));
					USBDetectionIF.out.Step:= DINT_TO_UINT(USB_GETNODELIST);
				ELSE
					IF ((UsbNodeGet_USBDetec2.status = asusbERR_BUFSIZE) OR (UsbNodeGet_USBDetec2.status = asusbERR_NULLPOINTER)) THEN
						//* Error Handling */
						gFile_Ctrl.Out.Stat.Error.Number		:= UINT_TO_UDINT(UsbNodeGet_USBDetec2.status);
						gFile_Ctrl.Out.Stat.Error.Text.Line1	:= TaskName;
						gFile_Ctrl.Out.Stat.Error.Text.Line2	:= 'USB_SEARCHDEVICE2';
						ErrorState							:= MainState;					
						MainState							:= C_MS_FILE_HAND_ERROR;						
					END_IF
				END_IF			

		END_CASE
	
	ELSE
		//Reset output information
		memset(ADR(USBDetectionIF.out), 0, SIZEOF(USBDetectionIF.out));
		
	END_IF	
	
END_ACTION