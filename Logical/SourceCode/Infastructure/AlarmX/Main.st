(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Task: AlarmX
 * Author: kay3a 
 * Created: October 2, 2024/3:55 PM 
 ********************************************************************
 * Description: Alarm mgr
 ********************************************************************)
PROGRAM _INIT 		
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               AlarmXHistory Klasörünü olustur	        	
	//|_________________________________________________________________________	
	Loc.FB.DirCreate.Parameters.DeviceName := 'DEV_ALARM';
	Loc.FB.DirCreate.Parameters.DirPath := '/DEVICE=USER_PATH/AlarmX';
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
	(* AlarmXCore *)
	Loc.FB.AlarmXCore.MpLink := ADR(gMpLink_AlarmXCore); 
	Loc.FB.AlarmXCore.Enable := TRUE;
	Loc.FB.AlarmXCore();
	
	(* AlarmXHistory *)
	Loc.FB.AlarmXHistory.Enable := TRUE; 
	Loc.FB.AlarmXHistory.MpLink := ADR(gMpLink_AlarmXHistory); 
	Loc.FB.AlarmXHistory.FileName := ADR('Alarms_%Y_%m_%d_%H_%M_%S'); 
	Loc.FB.AlarmXHistory.DeviceName := ADR('DEV_ALARM'); 	 
	Loc.FB.AlarmXHistory();	
	//|_________________________________________________________________________ 

	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               Ilk Açilis AlarmHist temizle		        	
	//|_________________________________________________________________________
//	Loc.FB.AlarmXHistory.Clear := TRUE; // bc25.10.15 
	//|_________________________________________________________________________ 
		
END_PROGRAM 
 
PROGRAM _CYCLIC 
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|                Command set/reset 		        	
	//|_________________________________________________________________________
	(* AlarmXHistory FB --- ErrorReset *)
	IF Loc.FB.AlarmXHistory.Error THEN
		Loc.FB.AlarmXHistory.ErrorReset := TRUE;
	ELSE
		Loc.FB.AlarmXHistory.ErrorReset := FALSE;
	END_IF;	
	
	(* AlarmXCore FB --- ErrorReset *)
	IF Loc.FB.AlarmXCore.Error THEN
		Loc.FB.AlarmXCore.ErrorReset := TRUE;
	ELSE
		Loc.FB.AlarmXCore.ErrorReset := FALSE;
	END_IF;	
	
	(* AlarmXCore --- AcknowledgeAll *)		
	IF Loc.FB.AlarmXCore.CommandDone THEN
		Loc.FB.AlarmXCore.AcknowledgeAll := FALSE;
	ELSE
		IF Loc.Cmd.AcknowledgeAll AND Loc.FB.AlarmXCore.UnacknowledgedAlarms <> 0 THEN
			Loc.FB.AlarmXCore.AcknowledgeAll := TRUE;	  
		END_IF;
	END_IF;	
	//|_________________________________________________________________________ 
	
	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               AlarmX Category check		        	
	//|_________________________________________________________________________
	// Category isimlerinin Category.Cfg tablosundaki ile ayni olmasi gerekmekte
	Loc.Status.ReactionCategory[LC_ALARM_Category0_Abort] := MpAlarmXCheckReaction(gMpLink_AlarmXCore, 'Category0_Abort');
	Loc.Status.ReactionCategory[LC_ALARM_Category1_Stop]  := MpAlarmXCheckReaction(gMpLink_AlarmXCore, 'Category1_Stop');
	Loc.Status.ReactionCategory[LC_ALARM_Category2_Pause] := MpAlarmXCheckReaction(gMpLink_AlarmXCore, 'Category2_Pause');
	Loc.Status.ReactionCategory[LC_ALARM_Category3_Info]  := MpAlarmXCheckReaction(gMpLink_AlarmXCore, 'Category3_Info');
	//|_________________________________________________________________________
	
	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|              Helper Actions		        	
	//|_________________________________________________________________________
	Interaction;
	AutoExport;
	AlarmHandle;
	//|_________________________________________________________________________
		


	
		 
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               FB Call 		        	
	//|_________________________________________________________________________
	Loc.FB.AlarmXCore(); 
	Loc.FB.AlarmXHistory(); 	
	//|_________________________________________________________________________ 

	gHMI.CommUnit.ActAlarms := Loc.FB.AlarmXCore.PendingAlarms;
END_PROGRAM

PROGRAM _EXIT
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               FB Kill 		        	
	//|_________________________________________________________________________
	Loc.FB.AlarmXCore(Enable := FALSE); 
	Loc.FB.AlarmXHistory(Enable := FALSE); 
	//|_________________________________________________________________________ 
	
END_PROGRAM