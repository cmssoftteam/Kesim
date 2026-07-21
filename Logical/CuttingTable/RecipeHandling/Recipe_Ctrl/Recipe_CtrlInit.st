(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * PROGRAM: gRecipe_Ctrl
 * File: gRecipe_CtrlInit.st
 * Author: blanca-gutim
 * Created: December 04, 2012
 ********************************************************************
 * Implementation OF PROGRAM gRecipe_Ctrl
 ********************************************************************)

PROGRAM _INIT

	//Init of task name
	TaskName	:= 'Recipe_Ctrl';
	
	//Init of variables used to control state machines
	MainState	:= C_MS_RECIPE_HAND_INIT;
	ErrorState	:= C_MS_RECIPE_HAND_NOERROR;
	
	//Init of other variables
	gRecipe_Ctrl.In.Par.Source		:= C_FILE_DEVICE_CF;		//CF used as default source device
	
	//Copy gloabal parameters structure to local loader parameters to 
	gLoaderControl.In.Par			:= gParameters.LoaderParameters;
	
	//Set the format to the Parameter string to Link the file device
	IF (gRecipe_Ctrl.In.Par.Source = C_FILE_DEVICE_CF) THEN
		//CF
		gRecipe_Ctrl.Out.Par.FileHandling.ParameterString			:= '/DEVICE=C:\\';
		gRecipe_Ctrl.Out.Par.FileHandling.DeviceName				:= 'CF';
	ELSIF (gRecipe_Ctrl.In.Par.Source = C_FILE_DEVICE_USB) THEN
		//USB
		gRecipe_Ctrl.Out.Par.FileHandling.DeviceName				:= 'USB';
		gRecipe_Ctrl.Out.Par.FileHandling.ParameterString			:= '/DEVICE=';
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gRecipe_Ctrl.In.Stat.FileHandling.UsbInformation[0].ifName));
	ELSIF (gRecipe_Ctrl.In.Par.Source = C_FILE_DEVICE_FTP) THEN
		//FTP			
		gRecipe_Ctrl.Out.Par.FileHandling.DeviceName				:= 'FTP';
		gRecipe_Ctrl.Out.Par.FileHandling.ParameterString			:= '/PROTOCOL=ftp /SIP=';
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.Server));
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(' /SNAME=FTP_SERV /PROTOCOL=ftp /USER=max /PASSWORD=passw'));				
	ELSIF (gRecipe_Ctrl.In.Par.Source = C_FILE_DEVICE_NETWORK) THEN
		//Network
		gRecipe_Ctrl.Out.Par.FileHandling.DeviceName				:= 'NET';
		gRecipe_Ctrl.Out.Par.FileHandling.ParameterString			:= '/PROTOCOL=cifs /SIP=';
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.Server));
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(' /SHARE='));
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.DirName));
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(' /USER='));
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.UserName));
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(' /PASSWORD='));
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.Password));
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(' /DOMAIN='));
		strcat(ADR(gRecipe_Ctrl.Out.Par.FileHandling.ParameterString), ADR(gParameters.Network.Workgroup));
	END_IF	
	
	//Init of variable to get state names in text format
	StateStrings[C_MS_RECIPE_HAND_INIT]				:= 'C_MS_RECIPE_HAND_INIT';
	StateStrings[C_MS_RECIPE_HAND_WAIT_CMD]			:= 'C_MS_RECIPE_HAND_WAIT_CMD';
	StateStrings[C_MS_RECIPE_HAND_PING]				:= 'C_MS_RECIPE_HAND_PING';
	StateStrings[C_MS_RECIPE_HAND_SET_DEVPAR]		:= 'C_MS_RECIPE_HAND_SET_DEVPAR';
	StateStrings[C_MS_RECIPE_HAND_LINK_DEV]			:= 'C_MS_RECIPE_HAND_LINK_DEV';
	StateStrings[C_MS_RECIPE_HAND_LIST]				:= 'C_MS_RECIPE_HAND_LIST';	
	StateStrings[C_MS_RECIPE_HAND_UNLINK_DEV]		:= 'C_MS_RECIPE_HAND_UNLINK_DEV';
	StateStrings[C_MS_RECIPE_HAND_LOAD]				:= 'C_MS_RECIPE_HAND_LOAD';
	StateStrings[C_MS_RECIPE_HAND_OVERWRITE]		:= 'C_MS_RECIPE_HAND_OVERWRITE';
	StateStrings[C_MS_RECIPE_HAND_SAVE]				:= 'C_MS_RECIPE_HAND_SAVE';
	StateStrings[C_MS_RECIPE_HAND_DELETE]			:= 'C_MS_RECIPE_HAND_DELETE';
	StateStrings[C_MS_RECIPE_HAND_ERROR]			:= 'C_MS_RECIPE_HAND_ERROR';
	StateStrings[C_MS_RECIPE_HAND_ACK_ERROR]		:= 'C_MS_RECIPE_HAND_ACK_ERROR';
	StateStrings[C_MS_RECIPE_HAND_NOERROR]			:= 'C_MS_RECIPE_HAND_NOERROR';

	// ----------------------------
	// Access to Program Interfaces
	// ----------------------------	
	// Access to Auto_Ctrl task interface
	uAdr := 0; uSize := 0;
	stat := PV_xgetadr(ADR('Auto_Ctrl:Auto_Ctrl'), ADR(uAdr), ADR(uSize));
	IF uAdr <> 0 AND stat = 0 THEN
		pAuto_Ctrl ACCESS uAdr;
	END_IF
END_PROGRAM

