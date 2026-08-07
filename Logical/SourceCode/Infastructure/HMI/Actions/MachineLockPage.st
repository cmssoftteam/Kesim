(*********************************************************************************
 * Copyright:   
 * Author:    baranc 
 * Created:   October 8, 2025/9:10 AM 
 *********************************************************************************)

ACTION MachineLockPage: 
	//======================================
	//		Get Time 
	//======================================
	
	DTStructureGetTime_0.enable := TRUE;
	DTStructureGetTime_0.pDTStructure := ADR(DTStructure_0);
	DTStructureGetTime_0();
	//Sistem zamanini çekelim.
	DTGetTime_0.enable 	:= TRUE;
	SystemTime			:= DTGetTime_0.DT1 ;
	DTGetTime_0();
	//SuperPassword hesaplama
	SuperPassword:= '';
	tempMonth	:= USINT_TO_STRING(DTStructure_0.month * 2);
	tempDay	:= USINT_TO_STRING(DTStructure_0.day * 2);
	brsstrcat(ADR(SuperPassword),ADR(tempDay));
	brsstrcat(ADR(SuperPassword),ADR(tempMonth));

	//Normal Password Hesaplama
	NormalPassword:= '';
	tempMonth	:= USINT_TO_STRING(DTStructure_0.month + 1);
	tempDay		:= USINT_TO_STRING(DTStructure_0.day + 1) ;
	brsstrcat(ADR(NormalPassword),ADR(tempDay));
	brsstrcat(ADR(NormalPassword),ADR(tempMonth));

	//Süper Sifre ile giris yapilirsa tamamen kapatilsin.
	IF gHMI.MachineLock.Login AND gHMI.MachineLock.Password = SuperPassword AND gHMI.UserName <> 'admin'  THEN
		gFixData.MachineLock.Enable		:= FALSE;
		gHMI.MachineLock.Password		:= '' ;
	END_IF;
	
	//Süper Sifre ile giris yapilirsa ve admin modundaysan tarih ayarlanabilir olacak.
	IF gHMI.MachineLock.Login AND gHMI.MachineLock.Password = SuperPassword AND gHMI.UserName = 'admin' THEN
		gHMI.Widget.MachineLock.Visible := TRUE;
		gHMI.MachineLock.Password		:= '' ;
	END_IF;
	
	
	//Sifre 2 ile giris yapilirsa mevcut süre 1 ay uzatilsin.
	IF gHMI.MachineLock.Login AND gHMI.MachineLock.Password = NormalPassword AND gFixData.MachineLock.oldDay <> DTStructure_0.day AND DTStructure_0.day <> 0 THEN
		gFixData.MachineLock.EndTime :=  gFixData.MachineLock.EndTime + t#14d + t#14d + t#2d;
		gHMI.MachineLock.Login		 := FALSE;
		gHMI.MachineLock.Password		:= '' ;
		gFixData.MachineLock.oldDay := DTStructure_0.day;
	END_IF;
	

	// eger kilitleme zamani geçmis ve makine kilitleme opsiyonu açiksa .	
	IF (gFixData.MachineLock.EndTime < SystemTime) AND gFixData.MachineLock.Enable THEN
		gHMI.MachineLock.Lock := TRUE;
	ELSE
		gHMI.MachineLock.Lock := FALSE;
	END_IF;
	
	TON_Logout.IN := gHMI.Widget.MachineLock.Visible ;
	TON_Logout.PT := T#1m;
	
	
	IF TON_Logout.Q THEN
	  gHMI.Widget.MachineLock.Visible := FALSE;
	END_IF;
	
	TON_Logout();

	
	
	
END_ACTION
