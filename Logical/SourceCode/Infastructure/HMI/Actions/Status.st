(*********************************************************************************
 * Copyright: B&R Industrial Automation GmbH 
 * Author:    kay3a 
 * Created:   June 24, 2025/9:29 PM 
 *********************************************************************************)
ACTION Status:

	//======================================
	//		   Cam bekletme istegi.
	//======================================
	IF gFixData.Config.PressTransferPause THEN
		IF gHMI.Pulse.ms300 THEN
			gHMI.Widget.PressGlassPause.Style  := 'Operate';
		ELSE
			gHMI.Widget.PressGlassPause.Style  := 'Operate1';
		END_IF;
	
	ELSE
		gHMI.Widget.PressGlassPause.Style  := 'Operate1';
	END_IF;


	//======================================
	//		   Reset Butonu istegi gelirse.
	//======================================
	IF (gPML[0].StateCurrent = mpPACKML_STATE_ABORTED OR gPML[0].StateCurrent = mpPACKML_STATE_STOPPED 
		OR gAlert.Abort.Status OR gAlert.Stop.Status ) AND gHMI.Pulse.ms100
		THEN
		gHMI.Widget.ResetButton.Style  := 'Operate';
	ELSE
		gHMI.Widget.ResetButton.Style  := 'Operate1';
	END_IF;

	//======================================
	//		   Hareketli eksenleri görelim.
	//======================================
	FOR _k:=0 TO MAX_AX_NR_MIN1 DO
	(*	IF ABS(gAxBasic[_k].Velocity) > 1 THEN*)
	  		gHMI.Diagnosis.Ax[_k].MoveActive := gAxBasic[_k].MoveActive;
//		END_IF;

		
	END_FOR;
	//======================================
	//		   Tüm PMLleri ekrana gönderelim.
	//======================================
	gIO;
	FOR _k:=0  TO MAX_AX_NR_MIN1 DO
		gHMI.Diagnosis.Ax[_k].Speed := gAxBasic[_k].Velocity;
		gHMI.Diagnosis.Ax[_k].Pos := gAxBasic[_k].Position;
		gHMI.Diagnosis.Ax[_k].HomeStatus := gAxBasic[_k].IsHomed;
		gHMI.Diagnosis.Ax[_k].PowerOn    := gAxBasic[_k].PowerOn;
	END_FOR;
	FOR _k:=0 TO MAX_PML_TASK_NR_MIN1 DO
		
		gHMI.Status.PML[_k].Name		 := _k;
		gHMI.Status.PML[_k].ModeID 		 := gPML[_k].ModeID;
		gHMI.Status.PML[_k].State 		 := gPML[_k].StateCurrent;
		gHMI.Status.PML[_k].SubState  	 := gPML[_k].SubStateCurrent;
	END_FOR;
	
	//======================================
	//			REFERANS VE PARK ISLEMLERININ YAPILMA IZNI
	//======================================
	IF gPML[0].StateCurrent <> mpPACKML_STATE_IDLE THEN
		gHMI.Widget.ParkAndRefRequest.Enable := FALSE;
	ELSE
		gHMI.Widget.ParkAndRefRequest.Enable := TRUE;
	END_IF;
	
	
	//======================================
	//		   ACT DEPTH VIEW
	//======================================
	
	gHMI.Diagnosis.Depth.Pos			:= gActDepth;
	
	//======================================
	//		   Seçili Üniteyi Gösterelim.
	//======================================
	IF gFixData.Config.ActiveUnit = 1 THEN
		gHMI.Widget.Unit1.Style 		 := 'Command';
		gHMI.Widget.Unit2.Style 		 := 'default';
	ELSIF gFixData.Config.ActiveUnit = 2  THEN
		gHMI.Widget.Unit1.Style 		 := 'default';
		gHMI.Widget.Unit2.Style 		 := 'Command';
	END_IF;
	

	//======================================
	//		  Homing Durumlarýný Görelim 
	//======================================
	Loc.ReferenceStatus := TRUE;
	FOR _k :=0 TO MAX_AX_NR_MIN1 DO
		IF gFixData.Ax[_k].Enabled AND gAxBasic[_k].IsHomed THEN
			gHMI.Widget.Ax[_k].Style := 'Command';
		ELSE	
			gHMI.Widget.Ax[_k].Style := 'default';
		END_IF;
		IF gFixData.Ax[_k].Enabled AND gAxBasic[_k].IsHomed =FALSE THEN
			Loc.ReferenceStatus:= FALSE;
		END_IF	
	END_FOR;
	
	FOR  _k := EXIT2_UNIT  TO EXIT8_UNIT DO
		gHMI.Diagnosis.Brdige[_k].HomeStatus := fbExitBridgeCtrl_0[_k].Out.Status.Homed;
		IF fbExitBridgeCtrl_0[_k].Out.Status.Homed  AND _k <= gFixData.HwConfig.ExitUnitInstalled THEN
			gHMI.Widget.Bridge[_k].Style := 'Command';
			
		ELSE
			gHMI.Widget.Bridge[_k].Style := 'default';
		END_IF;
		IF fbExitBridgeCtrl_0[_k].Out.Status.Homed = FALSE  AND _k <= gFixData.HwConfig.ExitUnitInstalled THEN
			Loc.ReferenceStatus:= FALSE;
		END_IF
		
	END_FOR;
	// giriþ kalýnlýk eksenler home yaptý mý?
	FOR  _k := ENTR1_UNIT  TO ENTR4_UNIT DO
		gHMI.Diagnosis.EntryThickness[_k].HomeStatus := fbEntryZAscMotorCtrl[_k].Out.Status.Homed;
		IF fbEntryZAscMotorCtrl[_k].Out.Status.Homed  AND _k <= gFixData.HwConfig.EntryUnitInstalled THEN
			gHMI.Widget.EntryThickness[_k].Style := 'Command';
		ELSE
			gHMI.Widget.EntryThickness[_k].Style := 'default';
		END_IF;
		IF fbEntryZAscMotorCtrl[_k].Out.Status.Homed = FALSE  AND _k <= gFixData.HwConfig.EntryUnitInstalled THEN
			Loc.ReferenceStatus:= FALSE;
		END_IF
		
	END_FOR;
	// çýkýþ kalýnlýk eksenler home yaptý mý?
	FOR  _k := EXIT1_UNIT  TO EXIT8_UNIT DO
		gHMI.Diagnosis.ExitThickness[_k].HomeStatus := fbExitZAscMotorCtrl[_k].Out.Status.Homed;
		IF fbExitZAscMotorCtrl[_k].Out.Status.Homed  AND _k <= gFixData.HwConfig.ExitUnitInstalled THEN
			gHMI.Widget.ExitThickness[_k].Style := 'Command';
		ELSE
			gHMI.Widget.ExitThickness[_k].Style := 'default';
		END_IF;
		IF fbExitZAscMotorCtrl[_k].Out.Status.Homed = FALSE  AND _k <= gFixData.HwConfig.ExitUnitInstalled THEN
			Loc.ReferenceStatus:= FALSE;
		END_IF
		
	END_FOR;
	
	IF gCommUnit.Main.In.Referance THEN
		IF gHMI.Pulse.ms500 THEN
			gHMI.Widget.PowerGroup.Reference.Style := 'Command';
		ELSE
			gHMI.Widget.PowerGroup.Reference.Style := 'default';
		END_IF
		
	ELSIF Loc.ReferenceStatus THEN
		gHMI.Widget.PowerGroup.Reference.Style := 'Command';
		gCommUnit.Main.Status.Referenced := TRUE;
	ELSE	
		
		gCommUnit.Main.Status.Referenced := FALSE;
	END_IF;
	//======================================
	//Eksenler Park Pozisyonunda mý ?
	//======================================
	IF gCommUnit.Main.In.Park THEN
		IF gHMI.Pulse.ms300 THEN
			gHMI.Widget.PowerGroup.Park.Style := 'Command';
		ELSE
			gHMI.Widget.PowerGroup.Park.Style := 'default';
		END_IF
	ELSIF gCommUnit.Main.Status.MachineParked THEN
		gHMI.Widget.PowerGroup.Park.Style := 'Command';
	ELSE
		gHMI.Widget.PowerGroup.Park.Style := 'default';
	END_IF;
	
	//======================================
	//		  Auto Man Durumunu Görelim 
	//======================================
	
	IF gPML[0].ModeID = PML_MODE_MAN THEN
		gHMI.Widget.PowerGroup.Automatic.Style := 'default';
		gHMI.Widget.PowerGroup.Automatic.Enable := TRUE;// manual iken enable olabilsin
		gHMI.Widget.PowerGroup.Manual.Style := 'Command';
	ELSIF gPML[0].ModeID = PML_MODE_AUTO THEN
		gHMI.Widget.PowerGroup.Automatic.Style := 'Command';
		gHMI.Widget.PowerGroup.Manual.Style := 'default';
		gHMI.Widget.PowerGroup.Automatic.Enable := FALSE;
	END_IF;

	
	//======================================
	//		  Power Durumuu görelim 
	//======================================
	Loc.PowerStatus := TRUE;
	FOR _k:=0 TO MAX_AX_NR_MIN1 DO
		IF gFixData.Ax[_k].Enabled  AND gAxBasic[_k].PowerOn =FALSE THEN
			Loc.PowerStatus := FALSE;
			EXIT;
		END_IF;  
	
	END_FOR;
	
	IF Loc.PowerStatus THEN
		gHMI.Widget.PowerGroup.Power.Style := 'Command';
	ELSE	
		gHMI.Widget.PowerGroup.Power.Style := 'default';
	END_IF;
	
	
	//======================================
	//		  Vacuum Grubu Butonlarý
	//======================================
	
	IF gIO.In.Sealing.X2VacuumOK THEN
		gHMI.Widget.Button.HoldGlass.Style:= 'Command';
	ELSE
		gHMI.Widget.Button.HoldGlass.Style := 'default';
	END_IF;
	
	//======================================
	//		  Otomatikten manuel moda geçis
	//======================================
	IF ((gPML[PML_TASK_SEALING].SubStateCurrent = SUBS_WAIT_CMD OR gPML[PML_TASK_SEALING].StateCurrent = mpPACKML_STATE_IDLE) AND gPML[0].ModeID = PML_MODE_AUTO) OR ( gPML[0].ModeID = PML_MODE_MAN )THEN
		gHMI.Widget.PowerGroup.Manual.Enable := TRUE ;
	ELSE
		gHMI.Widget.PowerGroup.Manual.Enable := FALSE ;
	END_IF;
	
	
	//======================================
	//		  Ekran hareketleri
	//======================================
	IF gHMI.Status.EdgeBaseChange THEN
		gRecData.Speed.EdgeBase[1] := gRecData.Speed.EdgeBase[0];
		gRecData.Speed.EdgeBase[2] := gRecData.Speed.EdgeBase[0];
		gRecData.Speed.EdgeBase[3] := gRecData.Speed.EdgeBase[0];
		gHMI.Status.EdgeBaseChange := FALSE;
	END_IF;
	
	
	IF gHMI.Status.CompCloseChange THEN
		gRecData.Distance[gFixData.Config.SpacerType].CompClose[1] := 	gRecData.Distance[gFixData.Config.SpacerType].CompClose[0];
		gRecData.Distance[gFixData.Config.SpacerType].CompClose[2] := 	gRecData.Distance[gFixData.Config.SpacerType].CompClose[0];
		gRecData.Distance[gFixData.Config.SpacerType].CompClose[3] := 	gRecData.Distance[gFixData.Config.SpacerType].CompClose[0];
		gHMI.Status.CompCloseChange := FALSE;
	END_IF;
	
	
	IF gHMI.Status.CornerFillingChange THEN
		gRecData.Time[gFixData.Config.SpacerType].CornerFilling[1]	:= gRecData.Time[gFixData.Config.SpacerType].CornerFilling[0];
		gRecData.Time[gFixData.Config.SpacerType].CornerFilling[2]	:= gRecData.Time[gFixData.Config.SpacerType].CornerFilling[0];
		gRecData.Time[gFixData.Config.SpacerType].CornerFilling[3]	:= gRecData.Time[gFixData.Config.SpacerType].CornerFilling[0];
		gHMI.Status.CornerFillingChange	:= FALSE;
	END_IF;
	
	
	IF gHMI.Status.PreOpenChange THEN
		gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[1]		:= gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[0];
		gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[2]		:= gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[0];
		gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[3]		:= gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[0];
		gHMI.Status.PreOpenChange			:=FALSE;
	END_IF;
	
	IF gHMI.Status.StartPosChange THEN
		gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[1]	:=gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[0];
		gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[2]	:=gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[0];
		gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[3]	:=gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[0];
		gHMI.Status.StartPosChange			:=FALSE;
	END_IF;
	
	IF EDGEPOS(gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[0] <> 0) THEN
		gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[0] := 0;
	END_IF;
	
	IF EDGEPOS(gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[1] <> 0) THEN
		gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[1] := 0;
	END_IF;
	
	IF EDGEPOS(gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[2] <> 0) THEN
		gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[2] := 0;
	END_IF;
	
	IF EDGEPOS(gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[3] <> 0) THEN
		gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[3] := 0;
	END_IF;
	
	IF EDGEPOS(gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[0] <> 0) THEN
		gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[0] := 0;
	END_IF;
	
	IF EDGEPOS(gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[1] <> 0) THEN
		gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[1] := 0;
	END_IF;
	
	IF EDGEPOS(gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[2] <> 0) THEN
		gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[2] := 0;
	END_IF;
	
	IF EDGEPOS(gRecData.Distance[gFixData.Config.SpacerType].StartUpComponent[3] <> 0) THEN
		gRecData.Time[gFixData.Config.SpacerType].CompPreOpen[3] := 0;
	END_IF;
	
	
	//======================================
	//		  Üretim Sayilarini resetleme.
	//======================================
	IF gHMI.Cmd.ProductionReset THEN
		gFixData.Production.Daily.DoubleGlass 	:= 0;
		gFixData.Production.Daily.TripleGlass 	:= 0;
		gFixData.Production.DailyMeterSqr		:= 0;
		gHMI.Cmd.ProductionReset := FALSE ;
	END_IF;
	IF gFixData.Production.oldDay <> DTStructure_0.day AND DTStructure_0.day <> 0 THEN
		gFixData.Production.Daily.DoubleGlass 	:= 0;
		gFixData.Production.Daily.TripleGlass 	:= 0;
		gFixData.Production.DailyMeterSqr		:= 0;
		gFixData.Production.oldDay				:= DTStructure_0.day;
	END_IF;
	
	IF gFixData.Production.oldMonth <> DTStructure_0.month  AND DTStructure_0.month <> 0 THEN
		gFixData.Production.Month.DoubleGlass 	:= 0;
		gFixData.Production.Month.TripleGlass 	:= 0;
		gFixData.Production.oldMonth 			:= DTStructure_0.month;
	END_IF;
	
	
	//======================================
	//		  Derinlik Tanimlama
	//======================================
	
	IF gHMI.Cmd.SetMaxDepthDigit THEN
		gHMI.Cmd.SetMaxDepthDigit := FALSE;
		gFixData.Depth.MasterDepthDigit := gIO.In.Sealing.aiDeepnesSignal ;
	END_IF;
	
	IF gHMI.Cmd.SetGlassSurfaceDepthDigit THEN
		gHMI.Cmd.SetGlassSurfaceDepthDigit := FALSE;
		gFixData.Depth.GlassSurfaceDigit := gIO.In.Sealing.aiDeepnesSignal ;
	END_IF;
END_ACTION
