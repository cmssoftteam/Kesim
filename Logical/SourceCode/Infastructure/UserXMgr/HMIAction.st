(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Task: UserX
 * Author: kay3a 
 * Created: October 3, 2024/4:59 PM 
 ********************************************************************
 * Description: 
 ********************************************************************)
//==============================================================================
ACTION HMIAction: 

	CASE Loc.Status.UserXHmiState OF
		USERX_START:
			IF NOT Loc.Par.UserXMgrUIConnect.Import.ShowDialog THEN
				Loc.Par.UserXMgrUIConnect.Import.ShowDialog := TRUE;
			ELSE
				Loc.Status.UserXHmiState := USERX_WAIT_FOR_DIALOG;
			END_IF
		USERX_WAIT_FOR_DIALOG:
			Loc.Par.UserXMgrUIConnect.Import.ShowDialog := FALSE;
			Loc.Status.UserXHmiState := USERX_SET_RESPONSE;
		USERX_SET_RESPONSE:
			IF NOT(Loc.Par.UserXMgrUIConnect.Status = mpUSERX_UI_STATUS_IDLE) THEN
				Loc.Par.UserXMgrUIConnect.Import.Dialog.Cancel := TRUE;
			ELSE
				Loc.Par.UserXMgrUIConnect.Import.Dialog.Cancel := FALSE;
				Loc.Status.UserXHmiState := USERX_CONFIRM_RESPONSE;
			END_IF
		USERX_CONFIRM_RESPONSE:
			IF Loc.Par.UserXMgrUIConnect.Status = mpUSERX_UI_STATUS_WAIT_DLG THEN
				Loc.Status.UserXHmiState := USERX_START;
			ELSE
				Loc.Status.UserXHmiState := USERX_FINISH;
			END_IF
		USERX_NEW_EXPORT:
			IF NOT Loc.Par.UserXMgrUIConnect.Export.ShowDialog AND Loc.Par.UserXMgrUIConnect.Status = mpUSERX_UI_STATUS_IDLE THEN
				Loc.Status.UserXHmiState := USERX_START;
			END_IF
		USERX_FINISH:

	END_CASE
	// If new updates are made via export execute a check
	IF Loc.Par.UserXMgrUIConnect.Export.ShowDialog THEN
		Loc.Status.UserXHmiState := USERX_NEW_EXPORT;
	END_IF

	//Duplicate file checks	
	IF EDGEPOS(Loc.Par.UserXMgrUIConnect.Status = mpUSERX_UI_STATUS_WAIT_DLG AND Loc.Par.UserXMgrUIConnect.Export.Dialog.LayerStatus = 0) OR
		EDGEPOS(Loc.Par.UserXMgrUIConnect.Status = mpUSERX_UI_STATUS_WAIT_DLG AND Loc.Par.UserXMgrUIConnect.Import.Dialog.LayerStatus = 0) THEN
		Loc.FB.DirRead.Execute := TRUE;
	END_IF;
	Loc.FB.DirRead.Parameters.DeviceName := Loc.FB.UserXManagerUI.UISetup.FileDevice;
	Loc.FB.DirRead.Enable := TRUE;
	IF Loc.FB.DirRead.CommandDone THEN
		Loc.FB.DirRead.Execute := FALSE;
	END_IF;
	Loc.FB.DirRead();	
	Loc.Status.FileDuplicate := FALSE;		
	FOR i := 0 TO 19 (*((SIZEOF(Loc.FB.DirRead.ListedFile)/SIZEOF(Loc.FB.DirRead.ListedFile[0])) - 1)*) DO		
		temp := Loc.Par.UserXMgrUIConnect.Export.Dialog.FileName;
		brsstrcat(ADR(temp),ADR('.usr'));
		IF (temp = Loc.FB.DirRead.ListedFile[i]) THEN
			Loc.Status.FileDuplicate := Loc.Cmd.Export;
		END_IF;
	END_FOR;

	
	IF Loc.Status.FileDuplicate AND (Loc.Cmd.ConfirmOverwrite) THEN
		Loc.Par.UserXMgrUIConnect.Export.Dialog.Confirm := TRUE;
		Loc.Cmd.Export := FALSE;
		Loc.Cmd.ConfirmOverwrite := FALSE;
	ELSIF NOT Loc.Status.FileDuplicate AND Loc.Cmd.Export THEN
		Loc.Par.UserXMgrUIConnect.Export.Dialog.Confirm := TRUE;
		Loc.Cmd.Export := FALSE;
	END_IF
	
	// Export confirmation pop-up handling
	IF EDGENEG(Loc.Status.UserXHmiState = USERX_NEW_EXPORT) THEN
		IF (Loc.Status.LastMgrConnectStatus = mpUSERX_UI_STATUS_EXECUTE) AND (Loc.Par.UserXMgrUIConnect.Status = mpUSERX_UI_STATUS_IDLE) THEN
			Loc.Status.ExportComplete := TRUE;
		END_IF;
	END_IF;
	IF Loc.Status.UserExportDisplayed THEN
		Loc.Status.ExportComplete := FALSE;
		Loc.Status.UserExportDisplayed := FALSE;
		Loc.Par.UserXMgrUIConnect.Export.Dialog.Confirm := FALSE;
	END_IF
	
END_ACTION
//==============================================================================
