
ACTION WidgetVisible: 
	
	//======================================
	//			Header Alert Image/Line
	//======================================
	IF gAlert.Abort.Status THEN
		(* Line *)
		gHMI.Widget.AlertLine.Visible := TRUE;
	
		IF gHMI.Pulse.ms300 THEN
	  		gHMI.Widget.AlertLine.Style   := 'back_red';
		ELSE
			gHMI.Widget.AlertLine.Style   := 'back_none';
		END_IF;
		(* Image *)		
	
		
		
		IF gCommUnit.Main.Status.ActiveAlarmQty > 1 THEN
			gHMI.Widget.AlertImage.Visible := gHMI.Pulse.ms300;
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty <> 0 THEN
			gHMI.Widget.AlertImage.Visible := TRUE;
		END_IF;
		IF gCommUnit.Main.Status.ActiveAlarmQty = 1 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/1.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 2 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/2.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 3 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/3.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 4 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/4.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 5 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/5.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 6 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/6.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 7 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/7.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 8 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/8.png';
		ELSE
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/9.png';
		END_IF;
		
		
	ELSIF gAlert.Stop.Status THEN
		(* Line *)
		gHMI.Widget.AlertLine.Visible := TRUE;
		
		IF gHMI.Pulse.ms300 THEN
			gHMI.Widget.AlertLine.Style   := 'back_red';
		ELSE
			gHMI.Widget.AlertLine.Style   := 'back_none';
		END_IF;
		
		(* Image *)		
		(*	gHMI.Widget.AlertImage.Visible := gHMI.Pulse.ms300;	*)
		gHMI.Widget.AlertImage.Visible:= TRUE ;
		IF gCommUnit.Main.Status.ActiveAlarmQty = 1 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/1.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 2 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/2.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 3 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/3.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 4 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/4.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 5 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/5.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 6 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/6.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 7 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/7.png';
		ELSIF gCommUnit.Main.Status.ActiveAlarmQty = 8 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/8.png';
		ELSE
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/9.png';
		END_IF;
		
	ELSIF gAlert.Pause.Status THEN
		(* Line *)
		gHMI.Widget.AlertLine.Visible := TRUE;
		
		
		IF gHMI.Widget.AlertImage.Visible THEN
			gHMI.Widget.AlertLine.Style   := 'back_orange';
		ELSE
			gHMI.Widget.AlertLine.Style   := 'back_none';
		END_IF;
		(* Image *)
		gHMI.Widget.AlertImage.Visible := gHMI.Pulse.ms300;
		gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/Categories/Category2_Pause.svg';
		
	ELSIF gAlert.Info.Status THEN	
		(* Line *)
		gHMI.Widget.AlertLine.Visible := TRUE;	
		IF gHMI.Widget.AlertImage.Visible THEN
			gHMI.Widget.AlertLine.Style   := 'back_blue';
		ELSE
			gHMI.Widget.AlertLine.Style   := 'back_none';
		END_IF;
		(* Image *)	
		gHMI.Widget.AlertImage.Visible := TRUE;
		gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/Categories/Category3_Info.svg';	
		
	ELSE
		gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/Categories/Category3_Info.svg';	
		gHMI.Widget.AlertLine.Style   := 'back_blue';
		gHMI.Widget.AlertLine.Visible  := FALSE;	
		gHMI.Widget.AlertImage.Visible := FALSE;		
	END_IF;
	//======================================
	
	gHMI.Widget.Unit2Selected.Visible := gHMI.Pulse.ms500 AND gFixData.Config.ActiveUnit = 2 ;
	
	FOR _j:=0 TO gFixData.HwConfig.ExitUnitInstalled DO
		gHMI.Widget.ExitConv[_j].Visible := TRUE;
	END_FOR;
	FOR _j:=0 TO gFixData.HwConfig.EntryUnitInstalled DO
		gHMI.Widget.EntryConv[_j].Visible := TRUE;
	END_FOR;
	FOR _j:=gFixData.HwConfig.ExitUnitInstalled TO EXIT8_UNIT DO
			gHMI.Widget.ExitConv[_j].Visible := FALSE;
	END_FOR;
	
	FOR _j:=gFixData.HwConfig.EntryUnitInstalled TO ENTR4_UNIT DO
		gHMI.Widget.EntryConv[_j].Visible := FALSE;
	END_FOR;

	
	IF gRecData.Tech.Activated.DryRun (*AND gPML[0].ModeID = PML_MODE_AUTO*) THEN
		gHMI.Widget.MaterialActive.Visible := gHMI.Pulse.ms100 ;
	ELSE
		gHMI.Widget.MaterialActive.Visible := FALSE;
	END_IF;
	
	//Derinlik kapali
	
	IF gRecData.Tech.Activated.DisableFinger THEN
		gHMI.Widget.DisableFinger.Visible := gHMI.Pulse.ms100 ;
	ELSE
		gHMI.Widget.DisableFinger.Visible := FALSE;
	END_IF;
	
	
	IF gFixData.Config.SerialMode THEN
		gHMI.Widget.SerialProduction.Visible := FALSE;
	ELSE
		gHMI.Widget.SerialProduction.Visible := TRUE;
	END_IF;
	gHMI.Widget.Unit2.Visible := gFixData.HwConfig.HydUnit2Installed ;
	gHMI.Widget.Exit3.Visible := NOT gFixData.Ax[AX_EXIT3].Enabled ;
	gHMI.Widget.Exit4.Visible := NOT gFixData.Ax[AX_EXIT4].Enabled ;
	// Kenarlardan herhangi biri seçilmemis
	gHMI.Widget.Edge.Visible := (gRecData.Tech.Activated.EdgeDisb[0] OR gRecData.Tech.Activated.EdgeDisb[1]
	OR gRecData.Tech.Activated.EdgeDisb[2] OR gRecData.Tech.Activated.EdgeDisb[3]) 
	AND gHMI.Pulse.ms100 ;
END_ACTION
