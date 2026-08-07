(*********************************************************************************
 * Copyright:   
 * Author:    baranc 
 * Created:   October 6, 2025/1:24 PM 
 *********************************************************************************)	
ACTION IOcontrolPage:
	
	//---------------------------
	// Seçilen kart için dogru kanal sayisini ve adlarini göster
	FOR i := 0 TO 15 DO
		IF ((IO_START_INDEX_SELECTED_SLOT[gHMI.IO_Control.SelectedSlot] + i) <= 
			(IO_START_INDEX_SELECTED_SLOT[gHMI.IO_Control.SelectedSlot] + gHMI.IO_Control.MaxDpIndex) ) THEN  // check if the index corresponds to an empty IO channel
			gHMI.IO_Control.NameSelector[i]    := IO_START_INDEX_SELECTED_SLOT[gHMI.IO_Control.SelectedSlot] + i;
			gHMI.IO_Control.DatafieldStatus[i] := TRUE;
		ELSE
			gHMI.IO_Control.NameSelector[i]    := 32767;   // Nothing is mapped to the IO channel
			gHMI.IO_Control.DatafieldStatus[i] := FALSE; // buraya sayfayi gizlemek için erisicez
		END_IF		
	END_FOR

	//---------------------------
	// Kartlar dijital ise maximum 1 degeri girilsin, Analog ise 32767
	IF (gHMI.IO_Control.TypeOfIO = DI_IO OR gHMI.IO_Control.TypeOfIO = DO_IO) THEN	// Limits for DI, DO
		gHMI.IO_Control.MaxForceValueLimit 	:= 0;
		gHMI.IO_Control.MaxForceValueLimit	:= 1;
	ELSE	// Limits for AI, AO
		gHMI.IO_Control.MinForceValueLimit 	:= 0;
		gHMI.IO_Control.MaxForceValueLimit	:= 32767;
	END_IF;
	
	//----------------------------------------------
	// Seçili kartin degistigini anlamak için
	gHMI.IO_Control.SelectedSlotOld  := gHMI.IO_Control.SelectedSlot;
	

	
END_ACTION