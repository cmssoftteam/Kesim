
TYPE
	gHMI_typ : 	STRUCT  (*Structure for handling visu*)
		IO_Control : gHMI_IO_Control_typ;
		UserName : STRING[80];
		Widget : gHMIWidgetType;
		MachineLock : gHMI_MachineLock_typ;
	END_STRUCT;
	gHMI_IO_Control_typ : 	STRUCT 
		MaxForceValueLimit : UDINT; (*Maximum force value limit for I/O control page*)
		MinForceValueLimit : UDINT; (*Minimum force value limit for I/O control page*)
		SelectedSlotOld : USINT;
		SelectedSlot : USINT; (*Selected IO card slot*)
		FoceValue : ARRAY[0..15]OF UDINT; (*Force value for the IO channel*)
		ForceStatus : ARRAY[0..15]OF BOOL; (*Force status of the active IO card*)
		PhysicalStatus : ARRAY[0..15]OF UDINT; (*Physical value of the datapoint*)
		DatafieldStatus : ARRAY[0..15]OF BOOL; (*Controls the visibility of the datafields on the HMI*)
		BitmapSelector : USINT; (*Datapoin to select the picture to be shown on IO control page*)
		NameSelector : ARRAY[0..15]OF INT; (*IO Datapoint name selector for the active IO card*)
		MaxDpIndex : USINT; (*Number of chanels in curently selected card*)
		TypeOfIO : IOTypeChannel_enm; (*Type of card, that is currently used. DI DO AI AO*)
	END_STRUCT;
	gHMI_MachineLock_typ : 	STRUCT 
		Logout : BOOL;
		Login : BOOL;
		Lock : BOOL;
		oldDay : USINT;
		EndTime : DATE_AND_TIME;
		Enable : BOOL;
		Password : STRING[80];
	END_STRUCT;
	gHMIWidgetType : 	STRUCT 
		MachineLock : gHMIWidgetBtnGenType;
	END_STRUCT;
	gHMIWidgetBtnGenType : 	STRUCT 
		Enable : BOOL;
		Visible : BOOL;
		Style : STRING[20] := 'default';
		Image : STRING[80];
	END_STRUCT;
END_TYPE
