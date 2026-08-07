(*********************************************************************************
 * Copyright:   
 * Author:    baranc 
 * Created:   October 27, 2025/7:52 AM 
 *********************************************************************************)

ACTION Home: 

	//========================================================================================	
	// AX_HEAD_C Servo Axis  Home Offset ini Hesaplama
	//========================================================================================	
	CASE StateAbsCHomeOffset OF
		0: //WAIT_ABS_HOME_CMD
			IF gHMI.Cmd.bHome.Ax[AX_HEAD_C] AND NOT gAxBasic[ AX_HEAD_C].Error THEN
				gAxBasic[ AX_HEAD_C].Home 		:= FALSE;
				StateAbsCHomeOffset := 10; 
			ELSE
				gHMI.Cmd.bHome.Ax[AX_HEAD_C] := FALSE;
			END_IF	

		10: // POWER_ON_CHK
			IF (gAxBasic[ AX_HEAD_C].PowerOn = FALSE) THEN
				gAxBasic[ AX_HEAD_C].Power := TRUE;
			ELSIF gAxBasic[ AX_HEAD_C].PowerOn THEN
				StateAbsCHomeOffset := 20; 
			END_IF	
		
		20:// DIRECT HOME    
			// Once Eksen Homelanir
			gAxBasicPar[AX_HEAD_C].Homing.Mode 		:= mcHOMING_DIRECT;   
			gAxBasicPar[ AX_HEAD_C].Homing.Position	:= 0;
			IF gFixData.Ax[ AX_HEAD_C].Enabled AND NOT gAxBasic[ AX_HEAD_C].CommandBusy THEN
				gAxBasic[ AX_HEAD_C].Home := TRUE;
				StateAbsCHomeOffset := 25; 
			END_IF;	  		
			
		25: (* Wait Home *)
			IF (gAxBasic[ AX_HEAD_C].IsHomed) THEN
				gAxBasic[ AX_HEAD_C].Home 		:= FALSE;
				gFixData.MultiturnEncOffsets.AX_C_EncOffset := ( gAxBasic[ AX_HEAD_C].Position );
				StateAbsCHomeOffset := 30; 					
			END_IF
			
		30: // MC_ReadParameter
			// Ham Enkoder Degeri Okunur
			MC_ReadParameterC_FB.Axis 			:= ADR(gAxis_HeadC);
			MC_ReadParameterC_FB.ParameterNumber := mcPAR_HOMING_OFFSET;
			MC_ReadParameterC_FB.Enable 			:= TRUE;
			MC_ReadParameterC_FB();	
		
			// Ham Degere HMI dan Set edilen istenen degere offsetlenir
			IF MC_ReadParameterC_FB.Valid THEN
				MC_ReadParameterC_FB.Enable := FALSE;	
				gFixData.MultiturnEncOffsets.AX_C_EncOffset := ( MC_ReadParameterC_FB.Value ) + gFixData.Ax[AX_HEAD_C].Par.Homing.Position;(* HMI Set Deger*)
				StateAbsCHomeOffset 		:= 40; 				
			END_IF	
		
		40: // mcHOMING_ABSOLUTE
			// Absolute Home Position degeri olarak Homing yapilir
			gAxBasicPar[AX_HEAD_C].Homing.Mode 		:= mcHOMING_ABSOLUTE; 
			gAxBasicPar[ AX_HEAD_C].Homing.Position	:= gFixData.MultiturnEncOffsets.AX_C_EncOffset;
			IF gFixData.Ax[ AX_HEAD_C].Enabled AND NOT gAxBasic[ AX_HEAD_C].CommandBusy THEN
				gAxBasic[ AX_HEAD_C].Home := TRUE;
				StateAbsCHomeOffset := 45; 
			END_IF;	
		
		45: (* Wait Home *)
			IF (gAxBasic[ AX_HEAD_C].IsHomed) THEN	
				gAxBasic[ AX_HEAD_C].Home 		:= FALSE;	
				gHMI.Cmd.bHome.Ax[AX_HEAD_C] := FALSE;
				gAxBasic[ AX_HEAD_C].Home  := FALSE;
				StateAbsCHomeOffset 			:= 0; 					
			END_IF	

	END_CASE;
	

	MC_ReadParameterC_FB();	
	
	//========================================================================================	
	// AX_HEAD_Z Servo Axis  Home Offset ini Hesaplama
	//========================================================================================	

	CASE StateAbsZHomeOffset OF
		0: //WAIT_ABS_HOME_CMD
			IF gHMI.Cmd.bHome.Ax[AX_HEAD_Z] AND NOT gAxBasic[ AX_HEAD_Z].Error THEN
				gAxBasic[ AX_HEAD_Z].Home 		:= FALSE;
				StateAbsZHomeOffset := 10; 
			ELSE
				gHMI.Cmd.bHome.Ax[AX_HEAD_Z] := FALSE;
			END_IF	

		10: // POWER_ON_CHK
			IF (gAxBasic[ AX_HEAD_Z].PowerOn = FALSE) THEN
				gAxBasic[ AX_HEAD_Z].Power := TRUE;
			ELSIF gAxBasic[ AX_HEAD_Z].PowerOn THEN
				StateAbsZHomeOffset := 20; 
			END_IF	
		
		20:// DIRECT HOME    
			// Once Eksen Homelanir
			gAxBasicPar[AX_HEAD_Z].Homing.Mode 		:= mcHOMING_DIRECT;   
			gAxBasicPar[ AX_HEAD_Z].Homing.Position	:= 0;
			IF gFixData.Ax[ AX_HEAD_Z].Enabled AND NOT gAxBasic[ AX_HEAD_Z].CommandBusy THEN
				gAxBasic[ AX_HEAD_Z].Home := TRUE;
				StateAbsZHomeOffset := 25; 
			END_IF;	  		
			
		25: (* Wait Home *)
			IF (gAxBasic[ AX_HEAD_Z].IsHomed) THEN
				gAxBasic[ AX_HEAD_Z].Home 		:= FALSE;
				gFixData.MultiturnEncOffsets.AX_Z_EncOffset := ( gAxBasic[ AX_HEAD_Z].Position );
				StateAbsZHomeOffset := 30; 					
			END_IF
			
		30: // MC_ReadParameter
			// Ham Enkoder Degeri Okunur
			MC_ReadParameterZ_FB.Axis 			:= ADR(gAxis_HeadZ);
			MC_ReadParameterZ_FB.ParameterNumber := mcPAR_HOMING_OFFSET;
			MC_ReadParameterZ_FB.Enable 			:= TRUE;
			MC_ReadParameterZ_FB();	
		
			// Ham Degere HMI dan Set edilen istenen degere offsetlenir
			IF MC_ReadParameterZ_FB.Valid THEN
				MC_ReadParameterZ_FB.Enable := FALSE;	
				gFixData.MultiturnEncOffsets.AX_Z_EncOffset := ( MC_ReadParameterZ_FB.Value ) + gFixData.Ax[AX_HEAD_Z].Par.Homing.Position;(* HMI Set Deger*)
				StateAbsZHomeOffset 		:= 40; 				
			END_IF	
		
		40: // mcHOMING_ABSOLUTE
			// Absolute Home Position degeri olarak Homing yapilir
			gAxBasicPar[AX_HEAD_Z].Homing.Mode 		:= mcHOMING_ABSOLUTE; 
			gAxBasicPar[ AX_HEAD_Z].Homing.Position	:= gFixData.MultiturnEncOffsets.AX_Z_EncOffset;
			IF gFixData.Ax[ AX_HEAD_Z].Enabled AND NOT gAxBasic[ AX_HEAD_Z].CommandBusy THEN
				gAxBasic[ AX_HEAD_Z].Home := TRUE;
				StateAbsZHomeOffset := 45; 
			END_IF;	
		
		45: (* Wait Home *)
			IF (gAxBasic[ AX_HEAD_Z].IsHomed) THEN	
				gAxBasic[ AX_HEAD_Z].Home 		:= FALSE;	
				gHMI.Cmd.bHome.Ax[AX_HEAD_Z] := FALSE;
				gAxBasic[ AX_HEAD_Z].Home  := FALSE;
				StateAbsZHomeOffset 			:= 0; 					
			END_IF	

	END_CASE;
	

	MC_ReadParameterZ_FB();	
	
	//	//Execture manual
	//	gAxBasicPar[12].Homing.Mode	    := mcHOMING_ABSOLUTE;
	//	gAxBasicPar[12].Homing.Position := gParDataEksen12.Offset;
	//	
	//	// power ver
	//	// direct home ver
	//	// mc_readparam cagir.
	//	// gParDataEksen12.Offset  0 olamaz
	//	//motor sökülmedigi sürece çalistirmaya gerek yok
	//	IF MakineAyarlandiHomePozisyonBurasi THEN
	//		MC_ReadParameter_FB.Axis := ADR(gAxis_HeadZ);
	//		MC_ReadParameter_FB.ParameterNumber := mcPAR_HOMING_OFFSET;
	//		MC_ReadParameter_FB.Enable := TRUE;
	//		MC_ReadParameter_FB();
	//	END_IF;
	//	IF MC_ReadParameter_FB.Valid THEN
	//		MC_ReadParameter_FB.Enable := FALSE;
	//		gParDataEksen12.Offset := MC_ReadParameter_FB.Value + EksenBuradaykenGormekIstedigimPozisyonDegeri;	  
	//	END_IF;	
	
	//==================================================
	//		Y Eksenine home gönderelim
	//==================================================
	//isHomed geldiyse Home komutunu keselim
	IF EDGEPOS(gAxBasic[AX_HEAD_Y].IsHomed) THEN
		gAxBasic[ AX_HEAD_Y ].Home 			:= FALSE;
	END_IF;
	IF gHMI.Cmd.bHome.Ax[AX_HEAD_Y] THEN
		IF gSimulation THEN
			gAxBasicPar[AX_HEAD_Y].Homing.Mode 	:= mcHOMING_DIRECT;   
			gAxBasicPar[ AX_HEAD_Y].Homing.Position	:= gFixData.Ax[AX_HEAD_Y].Par.Homing.Position;
			gAxBasic[ AX_HEAD_Y].Home 			:= gFixData.Ax[ AX_HEAD_Y].Enabled;
		ELSE
			gAxBasicPar[AX_HEAD_Y].Homing.Mode					  	:= mcHOMING_ABSOLUTE_SWITCH; 
			gAxBasicPar[AX_HEAD_Y].Homing.Options.SensorOffset   	:= gFixData.Ax[AX_HEAD_Y].Config.MultiturnEncOffset; //Home yaptiktan sonra kaçinci pozisyona kadar gitsin
			gAxBasicPar[AX_HEAD_Y].Homing.Position 			  		:= gFixData.Ax[AX_HEAD_Y].Par.Homing.Position; //Home yapip Sensor offset kadar gidip bunuda üstüne ekliyor
			gAxBasicPar[AX_HEAD_Y].Homing.Options.SwitchEdge     	:= mcDIR_NEGATIVE; //Switch nerede aranacak
			gAxBasicPar[AX_HEAD_Y].Homing.Options.HomingDirection	:= mcDIR_POSITIVE; //switch ten kurtulduktan sonra offset için hangi yöne gidecek
			gAxBasicPar[AX_HEAD_Y].Homing.Options.StartDirection 	:= mcDIR_NEGATIVE;
			gAxBasicPar[AX_HEAD_Y].Homing.Options.StartVelocity  	:= 60;
			gAxBasicPar[AX_HEAD_Y].Homing.Options.HomingVelocity 	:= 30;
			gAxBasicPar[AX_HEAD_Y].Homing.Options.Acceleration   	:= 150;	
			gAxBasic[AX_HEAD_Y].Home 								:= TRUE;
		END_IF;

	END_IF;

	//==================================================
	//		Vacuum Eksenine home gönderelim
	//==================================================
	//isHomed geldiyse Home komutunu keselim
	IF EDGEPOS(gAxBasic[AX_VACUUM].IsHomed) THEN
		gAxBasic[ AX_VACUUM].Home 			:= FALSE;
	END_IF;
	IF gHMI.Cmd.bHome.Ax[AX_VACUUM] THEN
		IF gSimulation THEN
			gAxBasicPar[AX_VACUUM].Homing.Mode 	:= mcHOMING_DIRECT;   
			gAxBasicPar[ AX_VACUUM].Homing.Position	:= gFixData.Ax[AX_VACUUM].Par.Homing.Position;
			gAxBasic[ AX_VACUUM].Home 			:= gFixData.Ax[ AX_VACUUM].Enabled;
		ELSE
			gAxBasicPar[AX_VACUUM].Homing.Mode					  := mcHOMING_ABSOLUTE_SWITCH; 
			gAxBasicPar[AX_VACUUM].Homing.Options.SensorOffset   := gFixData.Ax[AX_VACUUM].Config.MultiturnEncOffset; //Home yaptiktan sonra kaçinci pozisyona kadar gitsin
			gAxBasicPar[AX_VACUUM].Homing.Position 			  	:= gFixData.Ax[AX_VACUUM].Par.Homing.Position; //Home yapip Sensor offset kadar gidip bunuda üstüne ekliyor
			gAxBasicPar[AX_VACUUM].Homing.Options.SwitchEdge     := mcDIR_NEGATIVE; //Switch nerede aranacak
			gAxBasicPar[AX_VACUUM].Homing.Options.HomingDirection:= mcDIR_POSITIVE; //switch ten kurtulduktan sonra offset için hangi yöne gidecek
			gAxBasicPar[AX_VACUUM].Homing.Options.StartDirection := mcDIR_NEGATIVE;
			gAxBasicPar[AX_VACUUM].Homing.Options.StartVelocity  := 60;
			gAxBasicPar[AX_VACUUM].Homing.Options.HomingVelocity := 30;
			gAxBasicPar[AX_VACUUM].Homing.Options.Acceleration   := 150;	
			gAxBasic[ AX_VACUUM].Home 							:= TRUE;
		END_IF;
	
	END_IF;
	
	
	//==================================================
	//		Köprü 1 Eksenine home gönderelim
	//==================================================
	//isHomed geldiyse Home komutunu keselim
	IF EDGEPOS(gAxBasic[AX_EXIT1_BRIDGE_Y].IsHomed) THEN
		gAxBasic[ AX_EXIT1_BRIDGE_Y].Home 			:= FALSE;
	END_IF;
	IF gHMI.Cmd.bHome.Ax[AX_EXIT1_BRIDGE_Y] THEN
		IF gSimulation THEN
			gAxBasicPar[AX_EXIT1_BRIDGE_Y].Homing.Mode 	:= mcHOMING_DIRECT;   
			gAxBasicPar[ AX_EXIT1_BRIDGE_Y].Homing.Position	:= gFixData.Ax[AX_EXIT1_BRIDGE_Y].Par.Homing.Position;
			gAxBasic[ AX_EXIT1_BRIDGE_Y].Home 			:= gFixData.Ax[ AX_EXIT1_BRIDGE_Y].Enabled;
		ELSE
			gAxBasicPar[AX_EXIT1_BRIDGE_Y].Homing.Mode					  := mcHOMING_ABSOLUTE_SWITCH; 
			gAxBasicPar[AX_EXIT1_BRIDGE_Y].Homing.Options.SensorOffset   := gFixData.Ax[AX_EXIT1_BRIDGE_Y].Config.MultiturnEncOffset; //Home yaptiktan sonra kaçinci pozisyona kadar gitsin
			gAxBasicPar[AX_EXIT1_BRIDGE_Y].Homing.Position 			  	:= gFixData.Ax[AX_EXIT1_BRIDGE_Y].Par.Homing.Position; //Home yapip Sensor offset kadar gidip bunuda üstüne ekliyor
			gAxBasicPar[AX_EXIT1_BRIDGE_Y].Homing.Options.SwitchEdge     := mcDIR_NEGATIVE; //Switch nerede aranacak
			gAxBasicPar[AX_EXIT1_BRIDGE_Y].Homing.Options.HomingDirection:= mcDIR_POSITIVE; //switch ten kurtulduktan sonra offset için hangi yöne gidecek
			gAxBasicPar[AX_EXIT1_BRIDGE_Y].Homing.Options.StartDirection := mcDIR_NEGATIVE;
			gAxBasicPar[AX_EXIT1_BRIDGE_Y].Homing.Options.StartVelocity  := 60;
			gAxBasicPar[AX_EXIT1_BRIDGE_Y].Homing.Options.HomingVelocity := 30;
			gAxBasicPar[AX_EXIT1_BRIDGE_Y].Homing.Options.Acceleration   := 150;	
			gAxBasic[ AX_EXIT1_BRIDGE_Y].Home 							:= TRUE;
		END_IF;
		
	END_IF;
	
	
	//==================================================
	//		Köprü 2 Eksenine home gönderelim
	//==================================================
	IF EDGEPOS(gHMI.Cmd.bHome.Bridge[EXIT2_UNIT]) THEN
		fbExitBridgeCtrl_0[EXIT2_UNIT].In.Cmd.Home := TRUE;
		gHMI.Cmd.bHome.Bridge[EXIT2_UNIT] := FALSE;
	END_IF;
	
	IF EDGEPOS(gHMI.Cmd.bCalculate.Bridge[AS_BRIDGE_EXIT2]) THEN
		fbScaleBridgeExit[AS_BRIDGE_EXIT2].In.Cmd.Calculate := TRUE;
	END_IF
	
	fbExitBridgeCtrl_0[AS_BRIDGE_EXIT2]();
	fbScaleBridgeExit[AS_BRIDGE_EXIT2]();
	
	
	//==================================================
	//		Köprü 3 Eksenine home gönderelim
	//==================================================
	IF EDGEPOS(gHMI.Cmd.bHome.Bridge[EXIT3_UNIT]) THEN
		fbExitBridgeCtrl_0[EXIT3_UNIT].In.Cmd.Home := TRUE;
		gHMI.Cmd.bHome.Bridge[EXIT3_UNIT] := FALSE;
	END_IF;
	
	IF EDGEPOS(gHMI.Cmd.bCalculate.Bridge[EXIT3_UNIT]) THEN
		fbScaleBridgeExit[EXIT3_UNIT].In.Cmd.Calculate := TRUE;
	END_IF
	
	fbExitBridgeCtrl_0[AS_BRIDGE_EXIT3]();
	fbScaleBridgeExit[AS_BRIDGE_EXIT3]();
	
	//==================================================
	//		Köprü 4 Eksenine home gönderelim
	//==================================================
	IF EDGEPOS(gHMI.Cmd.bHome.Bridge[EXIT4_UNIT]) THEN
		fbExitBridgeCtrl_0[EXIT4_UNIT].In.Cmd.Home := TRUE;
		gHMI.Cmd.bHome.Bridge[EXIT4_UNIT] := FALSE;
	END_IF;
	
	IF EDGEPOS(gHMI.Cmd.bCalculate.Bridge[EXIT4_UNIT]) THEN
		fbScaleBridgeExit[EXIT4_UNIT].In.Cmd.Calculate := TRUE;
	END_IF
	
	
	fbExitBridgeCtrl_0[AS_BRIDGE_EXIT4]();
	fbScaleBridgeExit[AS_BRIDGE_EXIT4]();
	
	//==================================================
	//		Entry 1 Thickness home gönderelim
	//==================================================
	IF EDGEPOS(gHMI.Cmd.bHome.EntryThickness[ENTR1_UNIT]) THEN
		fbEntryZAscMotorCtrl[ENTR1_UNIT].In.Cmd.Home := TRUE;
		gHMI.Cmd.bHome.EntryThickness[ENTR1_UNIT] := FALSE;
	END_IF;
	
	IF EDGEPOS(gHMI.Cmd.bCalculate.EntryThickness[ENTR1_UNIT]) THEN
		fbScaleZAxesEntry[ENTR1_UNIT].In.Cmd.Calculate := TRUE;
	END_IF
	
	
	fbEntryZAscMotorCtrl[ENTR1_UNIT]();
	fbScaleZAxesEntry[ENTR1_UNIT]();

	//==================================================
	//		Entry 1 Thickness home gönderelim
	//==================================================
	IF EDGEPOS(gHMI.Cmd.bHome.EntryThickness[ENTR1_UNIT]) THEN
		fbEntryZAscMotorCtrl[ENTR1_UNIT].In.Cmd.Home := TRUE;
		gHMI.Cmd.bHome.EntryThickness[ENTR1_UNIT] := FALSE;
	END_IF;
	
	IF EDGEPOS(gHMI.Cmd.bCalculate.EntryThickness[ENTR1_UNIT]) THEN
		fbScaleZAxesEntry[ENTR1_UNIT].In.Cmd.Calculate := TRUE;
	END_IF
	
	
	fbEntryZAscMotorCtrl[ENTR1_UNIT]();
	fbScaleZAxesEntry[ENTR1_UNIT]();
	
	//==================================================
	//		Entry 2 Thickness home gönderelim
	//==================================================
	IF EDGEPOS(gHMI.Cmd.bHome.EntryThickness[ENTR2_UNIT]) THEN
		fbEntryZAscMotorCtrl[ENTR2_UNIT].In.Cmd.Home := TRUE;
		gHMI.Cmd.bHome.EntryThickness[ENTR2_UNIT] := FALSE;
	END_IF;
	
	IF EDGEPOS(gHMI.Cmd.bCalculate.EntryThickness[ENTR2_UNIT]) THEN
		fbScaleZAxesEntry[ENTR2_UNIT].In.Cmd.Calculate := TRUE;
	END_IF
	
	
	fbEntryZAscMotorCtrl[ENTR2_UNIT]();
	fbScaleZAxesEntry[ENTR2_UNIT]();
	
	//==================================================
	//		Exit 1 Thickness home gönderelim
	//==================================================
	IF EDGEPOS(gHMI.Cmd.bHome.ExitThickness[EXIT1_UNIT]) THEN
		fbScaleZAxesExit[EXIT1_UNIT].In.SetValue  := gHMI.Diagnosis.ExitThickness[EXIT1_UNIT].HomePos;
		fbExitZAscMotorCtrl[EXIT1_UNIT].In.Cmd.Home := TRUE;
		gHMI.Cmd.bHome.ExitThickness[EXIT1_UNIT] := FALSE;
	END_IF;
	
	IF EDGEPOS(gHMI.Cmd.bCalculate.ExitThickness[EXIT1_UNIT]) THEN
		fbScaleZAxesExit[EXIT1_UNIT].In.Cmd.Calculate := TRUE;
	END_IF
	
	
	fbExitZAscMotorCtrl[EXIT1_UNIT]();
	fbScaleZAxesExit[EXIT1_UNIT]();
	
	//==================================================
	//		Exit 2 Thickness home gönderelim
	//==================================================
	IF EDGEPOS(gHMI.Cmd.bHome.ExitThickness[EXIT2_UNIT]) THEN
		fbExitZAscMotorCtrl[EXIT2_UNIT].In.Cmd.Home := TRUE;
		gHMI.Cmd.bHome.ExitThickness[EXIT2_UNIT] := FALSE;
	END_IF;
	
	IF EDGEPOS(gHMI.Cmd.bCalculate.ExitThickness[EXIT2_UNIT]) THEN
		fbScaleZAxesExit[EXIT2_UNIT].In.Cmd.Calculate := TRUE;
	END_IF
	
	
	fbExitZAscMotorCtrl[EXIT2_UNIT]();
	fbScaleZAxesExit[EXIT2_UNIT]();
	
	//==================================================
	//		Exit 3 Thickness home gönderelim
	//==================================================
	IF EDGEPOS(gHMI.Cmd.bHome.ExitThickness[EXIT3_UNIT]) THEN
		fbExitZAscMotorCtrl[EXIT3_UNIT].In.Cmd.Home := TRUE;
		gHMI.Cmd.bHome.ExitThickness[EXIT3_UNIT] := FALSE;
	END_IF;
	
	IF EDGEPOS(gHMI.Cmd.bCalculate.ExitThickness[EXIT3_UNIT]) THEN
		fbScaleZAxesExit[EXIT3_UNIT].In.Cmd.Calculate := TRUE;
	END_IF
	
	
	fbExitZAscMotorCtrl[EXIT3_UNIT]();
	fbScaleZAxesExit[EXIT3_UNIT]();
	
	//==================================================
	//		Exit 4 Thickness home gönderelim
	//==================================================
	IF EDGEPOS(gHMI.Cmd.bHome.ExitThickness[EXIT4_UNIT]) THEN
		fbExitZAscMotorCtrl[EXIT4_UNIT].In.Cmd.Home := TRUE;
		gHMI.Cmd.bHome.ExitThickness[EXIT4_UNIT] := FALSE;
	END_IF;
	
	IF EDGEPOS(gHMI.Cmd.bCalculate.ExitThickness[EXIT4_UNIT]) THEN
		fbScaleZAxesExit[EXIT4_UNIT].In.Cmd.Calculate := TRUE;
	END_IF
	
	
	fbExitZAscMotorCtrl[EXIT4_UNIT]();
	fbScaleZAxesExit[EXIT4_UNIT]();
	
	//==================================================
	//		Edge Capture ile Y ekseni ayarlama.
	//==================================================
	CASE Loc.EdgeCaptureStep OF
		
		EC_WAIT_CMD:
			IF gHMI.EdgeCapture.Go THEN
				
				Loc.EdgeCaptureStep						 := EC_START;
				gHMI.EdgeCapture.Go					 := FALSE;
			END_IF;
		EC_START:
			IF Loc.FirstInStepEC THEN
				fbExit1BridgeEdgeCapture_0.In.Cmd.GlassEdgeCapture	 := TRUE;
			ELSE
				IF fbExit1BridgeEdgeCapture_0.Out.Status.CommandDone THEN
					fbExit1BridgeEdgeCapture_0.In.Cmd.GlassEdgeCapture		 := FALSE;
					Loc.EdgeCaptureStep										 := EC_OFSET;
				END_IF;
				
			END_IF;
			
		EC_OFSET:
			IF gHMI.EdgeCapture.Calculate THEN
				gFixData.Ax[AX_EXIT1_BRIDGE_Y].Par.Homing.Position := gFixData.Ax[AX_EXIT1_BRIDGE_Y].Par.Homing.Position - (fbExit1BridgeEdgeCapture_0.Out.GlassHeight.CapturedPos - gHMI.EdgeCapture.GlassSize);
				gHMI.EdgeCapture.Calculate 					 := FALSE; 
				Loc.EdgeCaptureStep							 := EC_WAIT_CMD;
			END_IF;
			IF gCommUnit.Main.In.MachineReset THEN
				Loc.EdgeCaptureStep							 := EC_WAIT_CMD;	
			END_IF;
		EC_FINISH: 
	END_CASE;
	gHMI.EdgeCapture.CapturePos		 := LREAL_TO_REAL(fbExit1BridgeEdgeCapture_0.Out.GlassHeight.CapturedPos);
	IF gAxBasic[AX_HEAD_Y].MoveActive = FALSE AND gCommUnit.Main.In.MachineReset AND Loc.EdgeCaptureStep <> EC_WAIT_CMD THEN
	  Loc.EdgeCaptureStep	:= EC_WAIT_CMD;
	END_IF;
	Loc.FirstInStepEC := Loc.EdgeCaptureStep <> Loc.oldEdgeCaptureStep ;
	Loc.oldEdgeCaptureStep := Loc.EdgeCaptureStep; 
END_ACTION
