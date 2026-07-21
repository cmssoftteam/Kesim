(********************************************************************
 * COPYRIGHT --  B&R Industrial Automation GmbH 
 ********************************************************************
 * Task: AlarmX
 * Author: kay3a 
 * Created: October 2, 2024/11:08 PM 
 ********************************************************************
 * Description: Alarms Handle action.
 ********************************************************************)
//==============================================================================
ACTION AlarmHandle:
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               Read Global Alerts 		        	
	//|_________________________________________________________________________	
	brsmemcpy(ADR(Loc.Status.Alerts.Single.Abort), ADR(gAlert.Abort.IDX), SIZEOF(Loc.Status.Alerts.Single.Abort));	
	brsmemcpy(ADR(Loc.Status.Alerts.Single.Stop),  ADR(gAlert.Stop.IDX),  SIZEOF(Loc.Status.Alerts.Single.Stop));	
	brsmemcpy(ADR(Loc.Status.Alerts.Single.Pause), ADR(gAlert.Pause.IDX), SIZEOF(Loc.Status.Alerts.Single.Pause));	
	brsmemcpy(ADR(Loc.Status.Alerts.Single.Info),  ADR(gAlert.Info.IDX),  SIZEOF(Loc.Status.Alerts.Single.Info));
	//|_________________________________________________________________________
	
	
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               	Clear Global Alarm ID 		        	
	//|_________________________________________________________________________
	brsmemset(ADR(gAlert.Abort.IDX), 0, SIZEOF(gAlert.Abort.IDX));
	brsmemset(ADR(gAlert.Stop.IDX),  0, SIZEOF(gAlert.Stop.IDX));
	brsmemset(ADR(gAlert.Pause.IDX), 0, SIZEOF(gAlert.Pause.IDX));
	brsmemset(ADR(gAlert.Info.IDX),  0, SIZEOF(gAlert.Info.IDX));
	//|_________________________________________________________________________
	
END_ACTION
//==============================================================================




//==============================================================================
ACTION SnippetAlerts: 
	
	//|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯		
	//|               Snippet alarms genarate 		    		        	
	//|_________________________________________________________________________
	Loc.Status.Alerts.Snippet[0].Index;
	Loc.Status.Alerts.Snippet[0].Val;
	
	Loc.Status.Alerts.Snippet[1].Index;
	Loc.Status.Alerts.Snippet[1].Val;
	
	Loc.Status.Alerts.Snippet[2].Index;
	Loc.Status.Alerts.Snippet[2].Val;
	
	Loc.Status.Alerts.Snippet[3].Index;
	Loc.Status.Alerts.Snippet[3].Val;
	
	Loc.Status.Alerts.Snippet[4].Index;
	Loc.Status.Alerts.Snippet[4].Val;
	
	Loc.Status.Alerts.Snippet[5].Index;
	Loc.Status.Alerts.Snippet[5].Val;
	
	Loc.Status.Alerts.Snippet[6].Index;
	Loc.Status.Alerts.Snippet[6].Val;
	
	Loc.Status.Alerts.Snippet[7].Index;
	Loc.Status.Alerts.Snippet[7].Val;
	
	Loc.Status.Alerts.Snippet[8].Index;
	Loc.Status.Alerts.Snippet[8].Val;
	
	Loc.Status.Alerts.Snippet[9].Index;
	Loc.Status.Alerts.Snippet[9].Val;
	
	Loc.Status.Alerts.Snippet[10].Index;
	Loc.Status.Alerts.Snippet[10].Val;	
	//|_________________________________________________________________________

END_ACTION
//==============================================================================