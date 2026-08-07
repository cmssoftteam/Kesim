(*********************************************************************************
 * Copyright:   
 * Author:    baranc 
 * Created:   November 3, 2025/4:10 PM 
 *********************************************************************************)
	
ACTION ManualDevice:
	
	IF fbVacuumCtrl_0.In.Cmd.VacuumOn = TRUE  AND  fbVacuumCtrl_0.Out.CommandDone THEN
		fbVacuumCtrl_0.In.Cmd.VacuumOn := FALSE;
	END_IF;
	IF gHMI.Cmd.Manual.VacuumGlass THEN
		fbVacuumCtrl_0.In.Cmd.VacuumOn := TRUE;
		(*fbVacuumCtrl_0.In.Cmd.VacuumOff := FALSE;*)
	END_IF;
	
	
	
		

	IF fbVacuumCtrl_0.In.Cmd.VacuumOff = TRUE  AND  fbVacuumCtrl_0.Out.CommandDone = TRUE THEN
		gHMI.Selected.Ax[AX_VACUUM] 	:= FALSE;
		fbVacuumCtrl_0.In.Cmd.VacuumOff := FALSE;
	END_IF;
	IF gHMI.Cmd.Manual.ReleaseGlass THEN
		(*fbVacuumCtrl_0.In.Cmd.VacuumOn := FALSE;*)
		fbVacuumCtrl_0.In.Cmd.VacuumOff := TRUE;
	END_IF;
	

	
	fbVacuumCtrl_0();
	
	
	FOR _k := 0 TO Max_Manual_Device DO
		fbManualDeviceCtrl[_k].In.bEnable := TRUE;
		fbManualDeviceCtrl[_k].In.bResettable := TRUE ;
		fbManualDeviceCtrl[_k].In.bEmergencyStop := TRUE;
		fbManualDeviceCtrl[_k].In.bManualMode := gPML[0].ModeID = PML_MODE_MAN;
	END_FOR;
	
	//==================================================
	//		Manual Device örnek kullaným.
	//==================================================
	//	fbManualDeviceCtrl[UNIT_LargeSpatulaPiston].In.bInput := Sinyali tetikleyecek deðiþken buraya yazýlýr;
	//	fbManualDeviceCtrl[UNIT_LargeSpatulaPiston].In.bSensor := Sensore baðlý ;
	//	Kontrol edilecek çýkýþ. := fbManualDeviceCtrl[UNIT_LargeSpatulaPiston].Out.bOutput ;
	//  fbManualDeviceCtrl[UNIT_LargeSpatulaPiston]();
	
	
	//==================================================
	//		Large Spatula Piston Manual
	//==================================================
	//	fbManualDeviceCtrl[UNIT_LargeSpatulaPiston].In.bInput := gHMI.Cmd.Manual.LargeSpatulaPiston;
	//	fbManualDeviceCtrl[UNIT_LargeSpatulaPiston].In.bSensor := FALSE; (*gIO.In.Sealing.SpatulaBigPistonBack*) ;
	//	gIO.Out.Sealing.SpatulaBigPistonFrw := fbManualDeviceCtrl[UNIT_LargeSpatulaPiston].Out.bOutput ;
	//	fbManualDeviceCtrl[UNIT_LargeSpatulaPiston]();
	
	IF EDGEPOS(gHMI.Cmd.Manual.LargeSpatulaPiston) THEN
		fbScrapperProcess_0.In.Cmd.Start:= TRUE;
	END_IF
	IF EDGEPOS(NOT gHMI.Cmd.Manual.LargeSpatulaPiston) THEN
		fbScrapperProcess_0.In.Cmd.Start:= FALSE;
	END_IF;
	
	//==================================================
	//		Small Spatula Piston Manual
	//==================================================
	//	fbManualDeviceCtrl[UNIT_SmallSpatulaPiston].In.bInput := gHMI.Cmd.Manual.SmallSpatulaPiston;
	//	fbManualDeviceCtrl[UNIT_SmallSpatulaPiston].In.bSensor := FALSE; (*gIO.In.Sealing.SpatulaSmallPistonBack*) ;
	//	gIO.Out.Sealing.SpatulaSmallPistonFrw := fbManualDeviceCtrl[UNIT_SmallSpatulaPiston].Out.bOutput ;
	//	fbManualDeviceCtrl[UNIT_SmallSpatulaPiston]();
	IF EDGEPOS(NOT gHMI.Cmd.Manual.SmallSpatulaPiston) THEN
		fbScrapperProcess_0.In.Cmd.EdgeLast:= FALSE;
		fbScrapperProcess_0.In.Cmd.Start:= FALSE;
	
	END_IF;
	IF EDGEPOS(gHMI.Cmd.Manual.SmallSpatulaPiston) THEN
		fbScrapperProcess_0.In.Cmd.EdgeLast:= TRUE;
		fbScrapperProcess_0.In.Cmd.Start:= TRUE;
	
	END_IF;
	
	
	
	//==================================================
	//		DepthForward
	//==================================================
	fbManualDeviceCtrl[UNIT_DepthValve].In.bInput := gHMI.Cmd.Manual.DepthForward;
	fbManualDeviceCtrl[UNIT_DepthValve].In.bSensor := FALSE ;
	gIO.Out.Sealing.DepthForward := fbManualDeviceCtrl[UNIT_DepthValve].Out.bOutput ;
	fbManualDeviceCtrl[UNIT_DepthValve]();
	
	//==================================================
	//		Material Out Valve
	//==================================================
	fbManualDeviceCtrl[UNIT_MaterialOutValve].In.bInput := gHMI.Cmd.Manual.MaterialOutValve;
	fbManualDeviceCtrl[UNIT_MaterialOutValve].In.bSensor := FALSE ;
	gIO.Out.Hydr.General.MaterialOpenValve := fbManualDeviceCtrl[UNIT_MaterialOutValve].Out.bOutput ;
	fbManualDeviceCtrl[UNIT_MaterialOutValve]();
	
	
	
END_ACTION
