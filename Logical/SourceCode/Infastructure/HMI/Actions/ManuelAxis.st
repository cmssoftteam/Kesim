(*********************************************************************************
 * Copyright:   
 * Author:    baranc 
 * Created:   October 16, 2025/1:34 PM 
 *********************************************************************************)
	
ACTION ManuelAxis: 

	//==================================================
	//		eksenlerin hatalarýnýn sýfýrlanmasý.
	//==================================================
	IF gCommUnit.Main.In.MachineReset THEN
		FOR _i:=0 TO MAX_AX_NR_MIN1 DO
			IF gAxBasic[_i].Error THEN
				gAxBasic[_i].ErrorReset := TRUE;	
			END_IF;
			
		END_FOR
	ELSE
		FOR _i:=0 TO MAX_AX_NR_MIN1 DO
			IF EDGEPOS(gAxBasic[_i].Error = FALSE) THEN //mo25.11.29
				gAxBasic[_i].ErrorReset := FALSE;	
			END_IF;
		END_FOR
	END_IF;
	
	//==================================================
	//		Speed Override
	//==================================================
	
	gHMI.Diagnosis.SpeedOverride := LREAL_TO_REAL( fbDepthSpeedOverride_0.Out.VelocityOverride) ;
	
	//==================================================
	//		Aktuel Kenar Hizi
	//==================================================
	
	IF(gAxBasic[AX_VACUUM].Velocity <> 0 AND gAxBasic[AX_HEAD_Y].Velocity = 0) THEN // movement just in X direction
		gHMI.Diagnosis.ActSealingSpeed := gAxBasic[AX_VACUUM].Velocity;
		IF gAxBasic[AX_VACUUM].Velocity > 1 THEN
	  		gHMI.Widget.MoveHead.Image		:= 'Media/CMS/right.png' ;
		ELSIF gAxBasic[AX_VACUUM].Velocity < -1		THEN
			
			gHMI.Widget.MoveHead.Image		:= 'Media/CMS/left.png' ;
		END_IF;
	ELSIF (gAxBasic[AX_HEAD_Y].Velocity <> 0 AND gAxBasic[AX_VACUUM].Velocity = 0) THEN // movement just in Y direction
		gHMI.Diagnosis.ActSealingSpeed  := gAxBasic[AX_HEAD_Y].Velocity;
		IF gAxBasic[AX_HEAD_Y].Velocity > 1 THEN
			gHMI.Widget.MoveHead.Image		:= 'Media/CMS/up.png' ;
		ELSIF gAxBasic[AX_HEAD_Y].Velocity < -1		THEN
			gHMI.Widget.MoveHead.Image		:= 'Media/CMS/down.png' ;
		END_IF;
	ELSE	// any other situation - both axes are without motion or moving together - dyn. speed is 0
		gHMI.Diagnosis.ActSealingSpeed  := 0;
		gHMI.Widget.MoveHead.Image		:= 'Media/CMS/none2.png' ;
	END_IF // end of dynamic speed
	
	
	//==================================================
	//		Manual hiz ve pos için gerekli degskenlerin atanmasi.
	//==================================================
	IF gPML[0].ModeID = PML_MODE_MAN AND gPML[0].StateCurrent = mpPACKML_STATE_IDLE  THEN
		
		FOR _i:=0  TO MAX_AX_NR_MIN1 DO
			IF _i >= AX_ENTRY1 AND _i <= AX_EXIT8 THEN //bc25.10.15
				IF (Loc.SelectedStatus.Entrys OR Loc.SelectedStatus.Exits) AND gHMI.Selected.Ax[AX_VACUUM] THEN // Vacuum with conveyors speed
	  
					gAxBasicPar[_i].Velocity 	 		:= gRecData.Manual.Ax[AX_VACUUM].Speed;
					gAxBasicPar[_i].Jog.Velocity 		:= gRecData.Manual.Ax[AX_VACUUM].Speed;	  
					gAxBasicPar[_i].Jog.Acceleration	:= gRecData.Manual.Ax[AX_VACUUM].Speed * gACCFactor;
					gAxBasicPar[_i].Jog.Deceleration 	:= gRecData.Manual.Ax[AX_VACUUM].Speed * gACCFactor;
					gAxBasicPar[_i].Deceleration 		:= gRecData.Manual.Ax[AX_VACUUM].Speed * gACCFactor;
					gAxBasicPar[_i].Acceleration 		:= gRecData.Manual.Ax[AX_VACUUM].Speed * gACCFactor;
				ELSE
					gAxBasicPar[_i].Velocity 	 		:= gRecData.Manual.Ax[AX_ENTRY1].Speed;
					gAxBasicPar[_i].Jog.Velocity 		:= gRecData.Manual.Ax[AX_ENTRY1].Speed;	  
					gAxBasicPar[_i].Jog.Acceleration	:= gRecData.Manual.Ax[AX_ENTRY1].Speed * gACCFactor;
					gAxBasicPar[_i].Jog.Deceleration 	:= gRecData.Manual.Ax[AX_ENTRY1].Speed * gACCFactor;
					gAxBasicPar[_i].Deceleration 		:= gRecData.Manual.Ax[AX_ENTRY1].Speed * gACCFactor;
					gAxBasicPar[_i].Acceleration 		:= gRecData.Manual.Ax[AX_ENTRY1].Speed * gACCFactor;
				END_IF;
				
			ELSIF _i <> AX_HYD THEN
				IF NOT gCommUnit.Main.Status.HYD_MIXER_Y_C_AX AND ( _i = AX_HEAD_C OR _i = AX_HEAD_Y) THEN
					gAxBasicPar[_i].Velocity  			 := gRecData.Manual.Ax[_i].Speed;
					gAxBasicPar[_i].Jog.Velocity 		 := gRecData.Manual.Ax[_i].Speed;
					gAxBasicPar[_i].Jog.Acceleration 	 := gRecData.Manual.Ax[_i].Speed * gACCFactor ;
					gAxBasicPar[_i].Jog.Deceleration 	 := gRecData.Manual.Ax[_i].Speed * gACCFactor ;
					gAxBasicPar[_i].Position    		 := gRecData.Manual.Ax[_i].Pos ; 
					gAxBasicPar[_i].Deceleration		 := gRecData.Manual.Ax[_i].Speed * gACCFactor ;
					gAxBasicPar[_i].Acceleration		 := gRecData.Manual.Ax[_i].Speed * gACCFactor ;
				ELSIF ( _i <> AX_HEAD_C OR _i <> AX_HEAD_Y) THEN
					gAxBasicPar[_i].Velocity  			 := gRecData.Manual.Ax[_i].Speed;
					gAxBasicPar[_i].Jog.Velocity 		 := gRecData.Manual.Ax[_i].Speed;
					gAxBasicPar[_i].Jog.Acceleration 	 := gRecData.Manual.Ax[_i].Speed * gACCFactor ;
					gAxBasicPar[_i].Jog.Deceleration 	 := gRecData.Manual.Ax[_i].Speed * gACCFactor ;
					gAxBasicPar[_i].Position    		 := gRecData.Manual.Ax[_i].Pos ; 
					gAxBasicPar[_i].Deceleration		 := gRecData.Manual.Ax[_i].Speed * gACCFactor ;
					gAxBasicPar[_i].Acceleration		 := gRecData.Manual.Ax[_i].Speed * gACCFactor ;
				END_IF;
			
			END_IF;
			
		END_FOR;
		IF  gPML[0].ModeID = PML_MODE_MAN AND gPML[0].StateCurrent = mpPACKML_STATE_IDLE THEN
			IF gRecData.Manual.Ax[AX_EXIT1_BRIDGE_Y].Pos < gFixData.Ax[AX_EXIT1_BRIDGE_Y].Par.Homing.Position THEN
				gRecData.Manual.Ax[AX_EXIT1_BRIDGE_Y].Pos := LREAL_TO_REAL(gFixData.Ax[AX_EXIT1_BRIDGE_Y].Par.Homing.Position);
			END_IF;
		END_IF;
	
		fbExitBridgeCtrl_0[AS_BRIDGE_EXIT2].In.Parm.Position.Set 	:= gRecData.Manual.Bridge[AS_BRIDGE_EXIT2].Pos;
		fbExitBridgeCtrl_0[AS_BRIDGE_EXIT2].In.Parm.Speed.SpeedMan 	:= gRecData.Manual.Ax[AX_EXIT1_BRIDGE_Y].Speed * 0.25; // servo eksenin max hizi ile asenktron eksenin max hizi arasindaki oran
		
		fbExitBridgeCtrl_0[AS_BRIDGE_EXIT3].In.Parm.Position.Set 	:= gRecData.Manual.Bridge[AS_BRIDGE_EXIT3].Pos;
		fbExitBridgeCtrl_0[AS_BRIDGE_EXIT3].In.Parm.Speed.SpeedMan 	:= gRecData.Manual.Ax[AX_EXIT1_BRIDGE_Y].Speed * 0.25;
		
		fbExitBridgeCtrl_0[AS_BRIDGE_EXIT4].In.Parm.Position.Set 	:= gRecData.Manual.Bridge[AS_BRIDGE_EXIT4].Pos;
		fbExitBridgeCtrl_0[AS_BRIDGE_EXIT4].In.Parm.Speed.SpeedMan 	:= gRecData.Manual.Ax[AX_EXIT1_BRIDGE_Y].Speed * 0.25;

		
	END_IF
	
	//==================================================
	//		Y EKSEN GUVENLI POZISYONDA DEGIL. EXIT 1 IN YADA ENTRY 1 OUT SENSORU GORURSE VAKUM VE KONVEYOR HIZLARI DÜSSSÜN.
	//==================================================
	IF gAxBasic[AX_HEAD_Y].Position >10 AND gPML[0].ModeID = PML_MODE_MAN THEN
		IF gIO.In.Entry[ENTR1_UNIT].OutSens OR gIO.In.Exit[EXIT1_UNIT].Conv.InSens THEN
			IF gHMI.Selected.Ax[AX_VACUUM] AND gIO.In.Sealing.X2VacuumOK THEN
				gRecData.Manual.Ax[AX_VACUUM].Speed		:= 50 ;
				IF gAxBasic[AX_VACUUM].MoveActive AND gAxBasicPar[AX_VACUUM].Velocity <> gRecData.Manual.Ax[AX_VACUUM].Speed THEN
					
					gAxBasicPar[AX_VACUUM].Velocity 	 		:= gRecData.Manual.Ax[AX_VACUUM].Speed;
					gAxBasicPar[AX_VACUUM].Jog.Velocity 		:= gRecData.Manual.Ax[AX_VACUUM].Speed;	  
					gAxBasicPar[AX_VACUUM].Jog.Acceleration		:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					gAxBasicPar[AX_VACUUM].Jog.Deceleration 	:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					gAxBasicPar[AX_VACUUM].Deceleration 		:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					gAxBasicPar[AX_VACUUM].Acceleration 		:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					
					gAxBasicPar[AX_ENTRY1].Velocity 	 		:= gRecData.Manual.Ax[AX_VACUUM].Speed;
					gAxBasicPar[AX_ENTRY1].Jog.Velocity 		:= gRecData.Manual.Ax[AX_VACUUM].Speed;	  
					gAxBasicPar[AX_ENTRY1].Jog.Acceleration		:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					gAxBasicPar[AX_ENTRY1].Jog.Deceleration 	:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					gAxBasicPar[AX_ENTRY1].Deceleration 		:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					gAxBasicPar[AX_ENTRY1].Acceleration 		:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					
					gAxBasicPar[AX_EXIT1].Velocity 	 			:= gRecData.Manual.Ax[AX_VACUUM].Speed;
					gAxBasicPar[AX_EXIT1].Jog.Velocity 			:= gRecData.Manual.Ax[AX_VACUUM].Speed;	  
					gAxBasicPar[AX_EXIT1].Jog.Acceleration		:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					gAxBasicPar[AX_EXIT1].Jog.Deceleration 		:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					gAxBasicPar[AX_EXIT1].Deceleration 			:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					gAxBasicPar[AX_EXIT1].Acceleration 			:= gRecData.Manual.Ax[AX_VACUUM].Speed * 5;
					
					IF (gAxBasic[AX_VACUUM].MoveActive AND gAxBasicPar[AX_VACUUM].Velocity <> gAxBasic[AX_VACUUM].Velocity)  THEN
						gAxBasic[AX_VACUUM].Update 	:= TRUE ;
					END_IF;
				
					IF (gAxBasic[AX_ENTRY1].MoveActive AND gAxBasicPar[AX_ENTRY1].Velocity <> gAxBasic[AX_ENTRY1].Velocity)  THEN
						gAxBasic[AX_ENTRY1].Update 	:= TRUE ;
					END_IF;
			
					IF (gAxBasic[AX_EXIT1].MoveActive AND gAxBasicPar[AX_EXIT1].Velocity <> gAxBasic[AX_EXIT1].Velocity) THEN
						gAxBasic[AX_EXIT1].Update	:= TRUE ;
					END_IF;
				END_IF	
				IF gAxBasic[AX_VACUUM].UpdateDone THEN
					gAxBasic[AX_VACUUM].Update 	:= FALSE ;
				END_IF;
				IF gAxBasic[AX_ENTRY1].UpdateDone THEN
					gAxBasic[AX_ENTRY1].Update 	:= FALSE ;
				END_IF;
				IF gAxBasic[AX_EXIT1].UpdateDone THEN
					gAxBasic[AX_EXIT1].Update	:= FALSE ;
				END_IF;
				
			ELSIF gHMI.Selected.Ax[AX_ENTRY1] OR gHMI.Selected.Ax[AX_EXIT1] THEN
				gRecData.Manual.Ax[AX_ENTRY1].Speed		:= 50 ;
				
				gAxBasicPar[AX_ENTRY1].Velocity 	 		:= gRecData.Manual.Ax[AX_ENTRY1].Speed;
				gAxBasicPar[AX_ENTRY1].Jog.Velocity 		:= gRecData.Manual.Ax[AX_ENTRY1].Speed;	  
				gAxBasicPar[AX_ENTRY1].Jog.Acceleration		:= gRecData.Manual.Ax[AX_ENTRY1].Speed * 5;
				gAxBasicPar[AX_ENTRY1].Jog.Deceleration 	:= gRecData.Manual.Ax[AX_ENTRY1].Speed * 5;
				gAxBasicPar[AX_ENTRY1].Deceleration 		:= gRecData.Manual.Ax[AX_ENTRY1].Speed * 5;
				gAxBasicPar[AX_ENTRY1].Acceleration 		:= gRecData.Manual.Ax[AX_ENTRY1].Speed * 5;
					
				gAxBasicPar[AX_EXIT1].Velocity 	 			:= gRecData.Manual.Ax[AX_ENTRY1].Speed;
				gAxBasicPar[AX_EXIT1].Jog.Velocity 			:= gRecData.Manual.Ax[AX_ENTRY1].Speed;	  
				gAxBasicPar[AX_EXIT1].Jog.Acceleration		:= gRecData.Manual.Ax[AX_ENTRY1].Speed * 5;
				gAxBasicPar[AX_EXIT1].Jog.Deceleration 		:= gRecData.Manual.Ax[AX_ENTRY1].Speed * 5;
				gAxBasicPar[AX_EXIT1].Deceleration 			:= gRecData.Manual.Ax[AX_ENTRY1].Speed * 5;
				gAxBasicPar[AX_EXIT1].Acceleration 			:= gRecData.Manual.Ax[AX_ENTRY1].Speed * 5;
				
				
				
				IF (gAxBasic[AX_ENTRY1].MoveActive AND gAxBasicPar[AX_ENTRY1].Velocity <> gAxBasic[AX_ENTRY1].Velocity)  THEN
					gAxBasic[AX_ENTRY1].Update 	:= TRUE ;
				END_IF;
				
				IF (gAxBasic[AX_EXIT1].MoveActive AND gAxBasicPar[AX_EXIT1].Velocity <> gAxBasic[AX_EXIT1].Velocity) THEN
					gAxBasic[AX_EXIT1].Update	:= TRUE ;
				END_IF;
				IF gAxBasic[AX_ENTRY1].UpdateDone THEN
					gAxBasic[AX_ENTRY1].Update 	:= FALSE ;
				END_IF;
				IF gAxBasic[AX_EXIT1].UpdateDone THEN
					gAxBasic[AX_EXIT1].Update	:= FALSE ;
				END_IF;
			END_IF;
		
		END_IF;
	END_IF;
	//	gAxBasicPar[AX_EXIT1]();
	//	gAxBasic[AX_EXIT1]();
	
	//==================================================
	//		EXIT CONV SEÇILI MI ?
	//==================================================
	Loc.SelectedStatus.Exits := FALSE;
	FOR _i := AX_EXIT1 TO AX_EXIT8 DO
	  	
		IF gHMI.Selected.Ax[_i] THEN
			Loc.SelectedStatus.Exits := TRUE;
		END_IF;

	END_FOR;
	
	
	//==================================================
	//		ENTRY CONV SEÇILI MI ?
	//==================================================
	Loc.SelectedStatus.Entrys := FALSE;
	FOR _i:=AX_ENTRY1 TO AX_ENTRY4 DO
	  	
		IF gHMI.Selected.Ax[_i] THEN
			Loc.SelectedStatus.Entrys := TRUE;
		END_IF;

	END_FOR;
	
	
	//==================================================
	//	    AS KOPRULER SEÇILI MI ?
	//==================================================
	Loc.SelectedStatus.Bridges := FALSE;
	FOR _i:=AS_BRIDGE_EXIT2 TO AS_BRIDGE_EXIT8 DO
	  	
		IF gHMI.Selected.Bridge[_i] THEN
			Loc.SelectedStatus.Bridges := TRUE;
		END_IF;
	END_FOR;
	
	//==================================================
	//	     Konveyor Giris Z Eksenleri SEÇILI MI ?
	//==================================================
	Loc.SelectedStatus.EntryThicness := FALSE;
	FOR _i:=ENTR1_UNIT TO ENTR4_UNIT DO
	  	
		IF gHMI.Selected.Thick.Entry[_i] THEN
			Loc.SelectedStatus.EntryThicness := TRUE;
		END_IF;
	END_FOR;

	//==================================================
	//	     Konveyor Çikis Z Eksenleri SEÇILI MI ?
	//==================================================
	Loc.SelectedStatus.ExitThicness := FALSE;
	FOR _i:=EXIT1_UNIT TO EXIT8_UNIT DO
	  	
		IF gHMI.Selected.Thick.Exit[_i] THEN
			Loc.SelectedStatus.ExitThicness := TRUE;
		END_IF;
	END_FOR;

	//==================================================
	//		C EKSEN SEÇILEMEZ
	//==================================================
	gHMI.Diagnosis.Ax[AX_HEAD_C].Block := 

	NOT gAxBasic[AX_HEAD_C].PowerOn OR 
	NOT(Loc.SelectedStatus.Entrys OR		
	Loc.SelectedStatus.Exits OR		
	Loc.SelectedStatus.Bridges OR
	gHMI.Selected.Ax[AX_EXIT1_BRIDGE_Y	] OR
	gHMI.Selected.Ax[AX_HEAD_Z] OR
	gHMI.Selected.Ax[AX_VACUUM] OR
	gHMI.Selected.Ax[AX_HEAD_Y] OR
	gPML[0].ModeID = PML_MODE_AUTO OR
	Loc.SelectedStatus.ExitThicness ) ;
	
	
	//==================================================
	//		Y EKSEN SEÇILEMEZ
	//==================================================
	gHMI.Diagnosis.Ax[AX_HEAD_Y].Block :=
	NOT gAxBasic[AX_HEAD_Y].PowerOn OR
	NOT (Loc.SelectedStatus.Entrys OR		
	Loc.SelectedStatus.Exits OR		
	Loc.SelectedStatus.Bridges OR
	gHMI.Selected.Ax[AX_EXIT1_BRIDGE_Y	] OR
	gHMI.Selected.Ax[AX_HEAD_Z] OR
	gHMI.Selected.Ax[AX_VACUUM] OR
	gHMI.Selected.Ax[AX_HEAD_C] OR
	gPML[0].ModeID = PML_MODE_AUTO OR
	Loc.SelectedStatus.ExitThicness ) ;
	

	//==================================================
	//		Z EKSEN SEÇILEMEZ
	//==================================================
	gHMI.Diagnosis.Ax[AX_HEAD_Z].Block := 
	NOT gAxBasic[AX_HEAD_Z].PowerOn OR
	NOT (Loc.SelectedStatus.Entrys OR		
	Loc.SelectedStatus.Exits OR		
	Loc.SelectedStatus.Bridges OR
	gHMI.Selected.Ax[AX_EXIT1_BRIDGE_Y	] OR
	gHMI.Selected.Ax[AX_HEAD_Y] OR
	gHMI.Selected.Ax[AX_VACUUM] OR
	gHMI.Selected.Ax[AX_HEAD_C] OR
	gPML[0].ModeID = PML_MODE_AUTO OR
	Loc.SelectedStatus.ExitThicness ) ;
	
	//==================================================
	//		VAKUM EKSENI SEÇILEMEZ
	//==================================================
	gHMI.Diagnosis.Ax[AX_VACUUM].Block := 
	NOT gAxBasic[AX_VACUUM].PowerOn OR
	NOT (Loc.SelectedStatus.Bridges OR
	gHMI.Selected.Ax[AX_EXIT1_BRIDGE_Y	] OR
	gHMI.Selected.Ax[AX_HEAD_Y] OR
	gHMI.Selected.Ax[AX_HEAD_Z] OR
	gHMI.Selected.Ax[AX_HEAD_C] OR
	gPML[0].ModeID = PML_MODE_AUTO OR
	Loc.SelectedStatus.ExitThicness );
	
	
	//==================================================
	//		KOPRU 1(Servo Eksen) SEÇILEMEZ
	//==================================================
	gHMI.Diagnosis.Ax[AX_EXIT1_BRIDGE_Y].Block := 
	NOT gAxBasic[AX_EXIT1_BRIDGE_Y].PowerOn OR
	NOT( Loc.SelectedStatus.Entrys OR		
	Loc.SelectedStatus.Exits OR		
	gHMI.Selected.Ax[AX_VACUUM	] OR
	gHMI.Selected.Ax[AX_HEAD_Y] OR
	gHMI.Selected.Ax[AX_HEAD_Z] OR
	gHMI.Selected.Ax[AX_HEAD_C] OR
	gPML[0].ModeID = PML_MODE_AUTO OR
	Loc.SelectedStatus.ExitThicness ) ;
	
	//==================================================
	//		CONV SEÇILEMEZ
	//==================================================
	gHMI.Diagnosis.Ax[AX_ENTRY1].Block := 

	NOT (Loc.SelectedStatus.Bridges OR
	gHMI.Selected.Ax[AX_EXIT1_BRIDGE_Y	] OR
	gHMI.Selected.Ax[AX_HEAD_Y] OR
	gHMI.Selected.Ax[AX_HEAD_Z] OR
	gHMI.Selected.Ax[AX_HEAD_C] OR
	gPML[0].ModeID = PML_MODE_AUTO OR
	Loc.SelectedStatus.ExitThicness ) ;
	
	//==================================================
	//		KOPRULER(AS) SEÇILEMEZ
	//======================W============================
	gHMI.Diagnosis.Brdige[AS_BRIDGE_EXIT2].Block := 
	gPML[0].ModeID = PML_MODE_AUTO OR
	NOT( Loc.SelectedStatus.Entrys OR		
	Loc.SelectedStatus.Exits OR	
	gHMI.Selected.Ax[AX_VACUUM	] OR
	gHMI.Selected.Ax[AX_HEAD_Y] OR
	gHMI.Selected.Ax[AX_HEAD_Z] OR
	gHMI.Selected.Ax[AX_HEAD_C] OR
	gPML[0].ModeID = PML_MODE_AUTO OR
	Loc.SelectedStatus.ExitThicness ) ;
	
	//==================================================
	//		KALINLIK(AS) SEÇILEMEZ
	//======================W============================
	gHMI.Diagnosis.EntryThickness[ENTR1_UNIT].Block := 
	gPML[0].ModeID = PML_MODE_AUTO OR
	NOT( Loc.SelectedStatus.Entrys OR		
	Loc.SelectedStatus.Exits OR	
	gHMI.Selected.Ax[AX_VACUUM	] OR
	gHMI.Selected.Ax[AX_HEAD_Y] OR
	gHMI.Selected.Ax[AX_HEAD_Z] OR
	gHMI.Selected.Ax[AX_HEAD_C] OR
	gPML[0].ModeID = PML_MODE_AUTO OR
	Loc.SelectedStatus.Bridges ) ;
	
	
	//==================================================
	//		Vakum Seçili Degil. Vakum Sinyali var. Xler hareket etmesin.
	//==================================================
	
	Loc.SelectedStatus.VacuumWithConv := TRUE;
	
	IF gHMI.Selected.Conv.Entry[ENTR1_UNIT] AND NOT gHMI.Selected.Ax[AX_VACUUM] AND gIO.In.Sealing.X2VacuumOK THEN
		Loc.SelectedStatus.VacuumWithConv := FALSE;
	END_IF;
	
	IF gHMI.Selected.Conv.Entry[ENTR2_UNIT] AND NOT gHMI.Selected.Ax[AX_VACUUM] AND gIO.In.Sealing.X2VacuumOK AND gIO.In.Entry[ENTR2_UNIT].OutSens THEN
		Loc.SelectedStatus.VacuumWithConv := FALSE;
	END_IF;
	
	IF gHMI.Selected.Conv.Entry[EXIT1_UNIT] AND NOT gHMI.Selected.Ax[AX_VACUUM] AND gIO.In.Sealing.X2VacuumOK THEN
		Loc.SelectedStatus.VacuumWithConv := FALSE;
	END_IF;
	
	IF gHMI.Selected.Conv.Entry[EXIT2_UNIT] AND NOT gHMI.Selected.Ax[AX_VACUUM] AND gIO.In.Sealing.X2VacuumOK AND gIO.In.Exit[EXIT2_UNIT].Conv.InSens THEN
		Loc.SelectedStatus.VacuumWithConv := FALSE;
	END_IF;
	
	
	//	IF Loc.SelectedStatus.VacuumWithConv = FALSE AND (gHMI.Cmd.Jog.Neg OR gHMI.Cmd.Jog.Pos)  THEN
	//		gCommUnit.EntryMain.Out.ConvNotMoved      := TRUE;
	//		gAlert.Info.IDX[INFO_VACUUM_NOT_SELECTED] := TRUE;
	//	ELSE
	//		gCommUnit.EntryMain.Out.ConvNotMoved      := FALSE;
	//	END_IF;
	
	
	//==================================================
	//		Vakum var.Vakum Ekseni seçili. Kovveyorler seçili olmadan hareket verilmesin.
	//==================================================
	//	Loc.SelectedStatus.ConvWithVacuum				:= TRUE;
	
	IF gIO.In.Sealing.X2VacuumOK AND EDGEPOS(gHMI.Selected.Ax[AX_ENTRY1] OR gHMI.Selected.Ax[AX_EXIT1] OR gHMI.Selected.Ax[AX_VACUUM]) THEN
		gHMI.Selected.Ax[AX_ENTRY1]	:= TRUE;
		gHMI.Selected.Ax[AX_EXIT1]	:= TRUE;
		gHMI.Selected.Ax[AX_VACUUM]	:= TRUE;
	END_IF;
	
	//	IF gHMI.Selected.Ax[AX_VACUUM] AND NOT gHMI.Selected.Ax[AX_ENTRY2] AND gIO.In.Sealing.X2VacuumOK AND gIO.In.Entry[ENTR2_UNIT].OutSens THEN
	//	  	Loc.SelectedStatus.ConvWithVacuum				:= FALSE;
	//	END_IF;
	//	
	//	IF gHMI.Selected.Ax[AX_VACUUM] AND NOT gHMI.Selected.Ax[AX_ENTRY1] AND gIO.In.Sealing.X2VacuumOK THEN
	//		Loc.SelectedStatus.ConvWithVacuum				:= FALSE;
	//	END_IF;
	//	
	//	IF gHMI.Selected.Ax[AX_VACUUM] AND NOT gHMI.Selected.Ax[AX_EXIT1] AND gIO.In.Sealing.X2VacuumOK THEN
	//		Loc.SelectedStatus.ConvWithVacuum				:= FALSE;
	//	END_IF;
	//	
	//	IF gHMI.Selected.Ax[AX_VACUUM] AND NOT gHMI.Selected.Ax[AX_EXIT2] AND gIO.In.Sealing.X2VacuumOK AND gIO.In.Exit[EXIT2_UNIT].Conv.InSens THEN
	//		Loc.SelectedStatus.ConvWithVacuum				:= FALSE;
	//	END_IF;
	
	
	//	IF Loc.SelectedStatus.ConvWithVacuum  = FALSE THEN
	//		gCommUnit.EntryMain.Out.VacuumNotMoved      := TRUE;
	//		gAlert.Info.IDX[INFO_CONV_NOT_SELECTED] 	:= TRUE;
	//	ELSE
	//		gCommUnit.EntryMain.Out.VacuumNotMoved      := FALSE;
	//	END_IF

	


	//==================================================
	//		Vakumlu iken vakum ekseni - limite geldiyse konveyor hareket olmasin..
	//==================================================
	
	
	//==================================================
	//		RESETE BASILINCA TÜM SEÇIMLERI KALDIRSIN
	//==================================================
	
	TON_ResetAxis.IN	:= gCommUnit.Main.In.MachineReset;
	TON_ResetAxis.PT	:= T#0.3S;
	TON_ResetAxis();
	
	IF TON_ResetAxis.Q OR EDGEPOS(gPML[0].ModeID = PML_MODE_AUTO) THEN
		
		FOR _i := 0 TO MAX_AX_NR_MIN1 DO
			gHMI.Selected.Ax[_i ] := FALSE;
		END_FOR;
		
		FOR _i := AS_BRIDGE_EXIT2 TO AS_BRIDGE_EXIT8 DO
			gHMI.Selected.Bridge[_i ] := FALSE;
		END_FOR;
		
		FOR _i := EXIT1_UNIT TO EXIT8_UNIT DO
			gHMI.Selected.Thick.Exit[_i ] := FALSE;
		END_FOR;
		
		FOR _i := ENTR1_UNIT TO ENTR4_UNIT DO
			gHMI.Selected.Thick.Entry[_i ] := FALSE;
		END_FOR;
		
		
	END_IF
	
END_ACTION
