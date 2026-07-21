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
	gCSV_Ctrl.In.Cmd		:= gRecipe_Ctrl.Out.Cmd.CsvHandling;
	gCSV_Ctrl.In.Par		:= gRecipe_Ctrl.Out.Par.CsvHandling;
	
END_ACTION

(* Output actions *)
ACTION Action_Output: 
	
	//Update outputs, reset command done status
	gCSV_Ctrl.Out.Stat.CmdDone.ErrorAcknowledge		:= gCSV_Ctrl.Out.Stat.CmdDone.ErrorAcknowledge	AND gCSV_Ctrl.In.Cmd.ErrorAcknowledge;
	gCSV_Ctrl.Out.Stat.CmdDone.NotOverwriteFile		:= gCSV_Ctrl.Out.Stat.CmdDone.NotOverwriteFile	AND gCSV_Ctrl.In.Cmd.NotOverwriteFile;
	gCSV_Ctrl.Out.Stat.CmdDone.OverwriteFile		:= gCSV_Ctrl.Out.Stat.CmdDone.OverwriteFile		AND gCSV_Ctrl.In.Cmd.OverwriteFile;
	gCSV_Ctrl.Out.Stat.CmdDone.ReadFile				:= gCSV_Ctrl.Out.Stat.CmdDone.ReadFile			AND gCSV_Ctrl.In.Cmd.ReadFile;
	gCSV_Ctrl.Out.Stat.CmdDone.WriteFile			:= gCSV_Ctrl.Out.Stat.CmdDone.WriteFile			AND gCSV_Ctrl.In.Cmd.WriteFile;
	
	//Update output, get MainState and Error State in String and UDINT variables (for tracing and debuging)
	gCSV_Ctrl.Out.Stat.MainState					:= MainState;
	gCSV_Ctrl.Out.Stat.MainState_Text				:= StateStrings[MainState];
	
END_ACTION