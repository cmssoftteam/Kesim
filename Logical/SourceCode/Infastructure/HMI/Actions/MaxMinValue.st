(*********************************************************************************
 * Copyright:   
 * Author:    baranc 
 * Created:   October 20, 2025/9:22 AM 
 *********************************************************************************)
	
ACTION MaxMinValue: 
	//==================================================
	//		Cam boyutu max deðerleri
	//==================================================
	gHMI.Widget.GlassXSize.Max := gFixData.HwConfig.EntryUnitInstalled* gFixData.HwConfig.ConvLength;
	gHMI.Widget.GlassXSize.Max := gFixData.HwConfig.EntryUnitInstalled* gFixData.HwConfig.ConvLength;
	gHMI.Widget.Pressure.Min   := gFixData.Material[gFixData.Config.Material].AFilling[gHydr.In.ActiveUnit-1] + 20 ;
	gHMI.Widget.ProductionDaily.Max	:= MAX(gFixData.Production.Daily.DoubleGlass,gFixData.Production.Daily.TripleGlass) + 50 ;
	gHMI.Widget.ProductionMonth.Max	:= MAX(gFixData.Production.Month.DoubleGlass,gFixData.Production.Month.TripleGlass) + 50 ;
	gHMI.Widget.ProductionTotal.Max	:= MAX(gFixData.Production.Total.DoubleGlass,gFixData.Production.Total.TripleGlass) + 50 ;
	
END_ACTION
