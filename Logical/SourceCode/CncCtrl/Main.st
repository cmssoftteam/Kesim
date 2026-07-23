(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Task: SUB0
 * Author: kay3a 
 * Created: October 16, 2024/11:06 AM 
 ********************************************************************
 * Description: Machine CncCtrl task
 ********************************************************************)
PROGRAM _INIT
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               CNC Klasörünü olustur	        	
	//|_________________________________________________________________________	
	Loc.FB.DirCreate.Parameters.DeviceName := 'DEV_CNC';
	Loc.FB.DirCreate.Parameters.DirPath := '/DEVICE=USER_PATH/CNC';
	Loc.FB.DirCreate.Enable := TRUE;
	REPEAT	  
		Loc.FB.DirCreate.Execute := Loc.FB.DirCreate.Active AND NOT Loc.FB.DirCreate.CommandBusy AND NOT Loc.FB.DirCreate.CommandDone;
		Loc.FB.DirCreate();
		UNTIL Loc.FB.DirCreate.CommandDone 
	END_REPEAT;	
	//|_________________________________________________________________________ 
	
	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               CNC File olustur	        	
	//|_________________________________________________________________________	
	Loc.FB.FileCreate.Parameters.DeviceName := 'DEV_CNC';
	Loc.FB.FileCreate.Parameters.FileName := 'Program.cnc';
	Loc.FB.FileCreate.Enable := TRUE;
	REPEAT	  
		Loc.FB.FileCreate.Execute := Loc.FB.FileCreate.Active AND NOT Loc.FB.FileCreate.CommandBusy AND NOT Loc.FB.FileCreate.CommandDone;
		Loc.FB.FileCreate();
		UNTIL Loc.FB.FileCreate.CommandDone 
	END_REPEAT;	
	//|_________________________________________________________________________ 
	
	
	
		
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               L I V E    F B s       	
	//|_________________________________________________________________________	
//	(* PML *)
//	Loc.FB.PML.MpLink := ADR(gMpLink_PackMLSyncModule_CncCtrl);
//	Loc.FB.PML.Parameters := ADR(Loc.Par.PML);
//	Loc.FB.PML.Enable := TRUE;
	
	(* CNC *)
	Loc.FB.Cnc3Axis.MpLink := ADR(gMpLink_CncXYZ);
	Loc.FB.Cnc3Axis.Parameters := ADR(Loc.Par.Cnc3Axis);
	Loc.FB.Cnc3Axis.Enable := TRUE;
	Loc.FB.Cnc3Axis.Override := 100.0;	
	// Par
	Loc.Par.Cnc3Axis.ProgramName := 'Program.cnc';
	//|_________________________________________________________________________
	
END_PROGRAM

PROGRAM _CYCLIC
	
	(* Axis *)
	Loc.FB.Cnc3Axis();
	
	//|_________________________________________________________________________

	
	TestX := Loc.FB.Cnc3Axis.X / 1500;
	TestY := Loc.FB.Cnc3Axis.Z / 1500;
	
END_PROGRAM

PROGRAM _EXIT

	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|              K I L L   F B s      	
	//|_________________________________________________________________________
	(* PML *)
//	Loc.FB.PML(Enable := FALSE);
	
	(* CNC *)
	Loc.FB.Cnc3Axis(Enable := FALSE);
	//|_________________________________________________________________________
	
END_PROGRAM

