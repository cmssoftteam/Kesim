(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Task: AlarmX
 * Author: kay3a 
 * Created: October 3, 2024/10:48 AM 
 ********************************************************************
 * Description: Local/ global degiskenler arasinda okuma yazma yapar.
 ********************************************************************)
//==============================================================================
ACTION Interaction: 
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               Local / Global variables     ---   READ / WRITE		        	
	//|_________________________________________________________________________
	(* READ from Global *)
//	Loc.Cmd.AcknowledgeAll := gCommUnit.Main.In.MachineReset;
//
//	
	
	(* WRTIE to Global *)
	gAlert.Abort.Status := Loc.Status.ReactionCategory[LC_ALARM_Category0_Abort];
	gAlert.Stop.Status  := Loc.Status.ReactionCategory[LC_ALARM_Category1_Stop];
	gAlert.Pause.Status := Loc.Status.ReactionCategory[LC_ALARM_Category2_Pause];
	gAlert.Info.Status	:= Loc.Status.ReactionCategory[LC_ALARM_Category3_Info];
	//|_________________________________________________________________________
	
END_ACTION
//==============================================================================