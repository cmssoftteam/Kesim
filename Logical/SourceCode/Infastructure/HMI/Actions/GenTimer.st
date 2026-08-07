(*********************************************************************************
 * Copyright: B&R Industrial Automation GmbH 
 * Author:    kay3a 
 * Created:   June 24, 2025/9:29 PM 
 *********************************************************************************)
ACTION GenTimer:
			
	//======================================
	//			  Timer Genarate
	//======================================
	(* 50ms *)	
	Loc.FB.Timer.Pulse.ms50.PT := T#50ms;
	Loc.FB.Timer.Pulse.ms50.IN := NOT Loc.FB.Timer.Pulse.ms50.Q;
	Loc.FB.Timer.Pulse.ms50();
	IF Loc.FB.Timer.Pulse.ms50.Q THEN
		gHMI.Pulse.ms50 := NOT gHMI.Pulse.ms50; 	  
	END_IF;
	
	(* 100ms *)	
	Loc.FB.Timer.Pulse.ms100.PT := T#100ms;
	Loc.FB.Timer.Pulse.ms100.IN := NOT Loc.FB.Timer.Pulse.ms100.Q;
	Loc.FB.Timer.Pulse.ms100();
	IF Loc.FB.Timer.Pulse.ms100.Q THEN
		gHMI.Pulse.ms100 := NOT gHMI.Pulse.ms100; 	  
	END_IF;
	
	(* 200ms *)	
	Loc.FB.Timer.Pulse.ms200.PT := T#200ms;
	Loc.FB.Timer.Pulse.ms200.IN := NOT Loc.FB.Timer.Pulse.ms200.Q;
	Loc.FB.Timer.Pulse.ms200();
	IF Loc.FB.Timer.Pulse.ms200.Q THEN
		gHMI.Pulse.ms200 := NOT gHMI.Pulse.ms200; 	  
	END_IF;
	
	(* 300ms *)	
	Loc.FB.Timer.Pulse.ms300.PT := T#300ms;
	Loc.FB.Timer.Pulse.ms300.IN := NOT Loc.FB.Timer.Pulse.ms300.Q;
	Loc.FB.Timer.Pulse.ms300();
	IF Loc.FB.Timer.Pulse.ms300.Q THEN
		gHMI.Pulse.ms300 := NOT gHMI.Pulse.ms300; 	  
	END_IF;
	
	(* 500ms *)	
	Loc.FB.Timer.Pulse.ms500.PT := T#500ms;
	Loc.FB.Timer.Pulse.ms500.IN := NOT Loc.FB.Timer.Pulse.ms500.Q;
	Loc.FB.Timer.Pulse.ms500();
	IF Loc.FB.Timer.Pulse.ms500.Q THEN
		gHMI.Pulse.ms500 := NOT gHMI.Pulse.ms500; 	  
	END_IF;
	
	(* 1000ms *)	
	Loc.FB.Timer.Pulse.ms1000.PT := T#1000ms;
	Loc.FB.Timer.Pulse.ms1000.IN := NOT Loc.FB.Timer.Pulse.ms1000.Q;
	Loc.FB.Timer.Pulse.ms1000();
	IF Loc.FB.Timer.Pulse.ms1000.Q THEN
		gHMI.Pulse.ms1000 := NOT gHMI.Pulse.ms1000; 	  
	END_IF;
	//======================================

END_ACTION
