(********************************************************************
* COPYRIGHT --  B&R Industrial Automation GmbH 
********************************************************************
* Task: UserX
* Author: kay3a 
* Created: October 3, 2024/4:57 PM 
********************************************************************
* Description: UserX manager
********************************************************************)
PROGRAM _INIT	

//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
//|               UserX Klasörünü olustur	        	
//|_________________________________________________________________________
	Loc.FB.DirCreate.Parameters.DeviceName := 'DEV_USER';
	Loc.FB.DirCreate.Parameters.DirPath := '/DEVICE=USER_PATH/UserX';
	Loc.FB.DirCreate.Enable := TRUE;
	REPEAT	  
		Loc.FB.DirCreate.Execute := Loc.FB.DirCreate.Active AND NOT Loc.FB.DirCreate.CommandBusy AND NOT Loc.FB.DirCreate.CommandDone;
		Loc.FB.DirCreate();
		UNTIL Loc.FB.DirCreate.CommandDone 
	END_REPEAT;	
	//|_________________________________________________________________________



	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               FB linklemeleri	        	
	//|_________________________________________________________________________
	(* UserXLogin *)
	Loc.FB.UserXLogin.MpLink := ADR(gMpLink_UserXLogin);
	Loc.FB.UserXLogin.Enable := TRUE;
	Loc.FB.UserXLogin();

	(* UserXLoginUI *)
	Loc.FB.UserXLoginUI.MpLink := ADR(gMpLink_UserXLogin);
	Loc.FB.UserXLoginUI.UIConnect := ADR(Loc.Par.UserXLoginUIConnect);
	Loc.FB.UserXLoginUI.Enable := TRUE;
	Loc.FB.UserXLoginUI();

	(* UserXManagerUI *)
	Loc.Par.UserXMgrUIConnect.User.Create.Lock := FALSE;
	Loc.Par.UserXMgrUIConnect.User.Lock := FALSE;
	Loc.Par.UserXMgrUIConnect.User.Edit.Lock := FALSE;
	Loc.Par.UserXMgrUIConnect.User.Create.Dialog.UserName := "";
	Loc.Par.UserXMgrUIConnect.User.Create.Dialog.NewPassword := "";
	Loc.Par.UserXMgrUIConnect.User.Create.Dialog.ConfirmPassword := "";
	Loc.Par.UserXMgrUIConnect.User.List.MaxSelection := USER_LIST_MAX_SELECTION;
	Loc.Par.UserXMgrUIConnect.User.List.RangeStart := USER_LIST_RANGE_START;
	Loc.Par.UserXMgrUIConnect.User.List.RangeEnd := USER_LIST_RANGE_END;	
	Loc.FB.UserXManagerUI.MpLink := ADR(gMpLink_UserXLogin);
	Loc.FB.UserXManagerUI.UIConnect := ADR(Loc.Par.UserXMgrUIConnect);
	Loc.FB.UserXManagerUI.UISetup.FileDevice := 'DEV_USER';
	Loc.FB.UserXManagerUI.Enable := TRUE;
	Loc.FB.UserXManagerUI();	
	//|_________________________________________________________________________	

END_PROGRAM

PROGRAM _CYCLIC	

//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
//|               Helper Actions	        	
//|_________________________________________________________________________
	HMIAction;
	//|_________________________________________________________________________


	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               Assign	        	
	//|_________________________________________________________________________
	// Saving last status of UserXMgrUIconnect
	Loc.Status.LastMgrConnectStatus := Loc.Par.UserXMgrUIConnect.Status;
	//|_________________________________________________________________________
	
	
	

	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               FB Call	        	
	//|_________________________________________________________________________
	Loc.FB.UserXLogin();
	Loc.FB.UserXLoginUI();
	Loc.FB.UserXManagerUI();	
	//|_________________________________________________________________________	
	
END_PROGRAM

PROGRAM _EXIT	

//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
//|               FB Kill	        	
//|_________________________________________________________________________
	Loc.FB.UserXLogin(Enable := FALSE);
	Loc.FB.UserXLoginUI(Enable := FALSE);
	Loc.FB.UserXManagerUI(Enable := FALSE);	 
	//|_________________________________________________________________________
 
END_PROGRAM

