
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
	
		
		
		IF gHMI.CommUnit.ActAlarms > 1 THEN
			gHMI.Widget.AlertImage.Visible := gHMI.Pulse.ms300;
		ELSIF gHMI.CommUnit.ActAlarms <> 0 THEN
			gHMI.Widget.AlertImage.Visible := TRUE;
		END_IF;
		IF gHMI.CommUnit.ActAlarms = 1 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/1.png';
		ELSIF gHMI.CommUnit.ActAlarms = 2 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/2.png';
		ELSIF gHMI.CommUnit.ActAlarms = 3 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/3.png';
		ELSIF gHMI.CommUnit.ActAlarms = 4 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/4.png';
		ELSIF gHMI.CommUnit.ActAlarms = 5 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/5.png';
		ELSIF gHMI.CommUnit.ActAlarms = 6 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/6.png';
		ELSIF gHMI.CommUnit.ActAlarms = 7 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/7.png';
		ELSIF gHMI.CommUnit.ActAlarms = 8 THEN
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
		IF gHMI.CommUnit.ActAlarms = 1 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/1.png';
		ELSIF gHMI.CommUnit.ActAlarms = 2 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/2.png';
		ELSIF gHMI.CommUnit.ActAlarms = 3 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/3.png';
		ELSIF gHMI.CommUnit.ActAlarms = 4 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/4.png';
		ELSIF gHMI.CommUnit.ActAlarms = 5 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/5.png';
		ELSIF gHMI.CommUnit.ActAlarms = 6 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/6.png';
		ELSIF gHMI.CommUnit.ActAlarms = 7 THEN
			gHMI.Widget.AlertImage.Image   := 'Media/AlarmX/7.png';
		ELSIF gHMI.CommUnit.ActAlarms = 8 THEN
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
END_ACTION
