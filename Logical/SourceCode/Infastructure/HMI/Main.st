(*********************************************************************************
 * Copyright:   
 * Author:    baranc 
 * Created:   September 19, 2025/1:33 PM 
 *********************************************************************************)

PROGRAM _INIT

	//Loc.OldMaterialNumber	:=	4; //Program ilk açildiginda Ekrana mecvut seçili ilaçin Degerlerini getirmek için.

END_PROGRAM

PROGRAM _CYCLIC
//	//==================================================
//	//	 Ekrana gönderilecek PML,Pos vb degiskenlerin atanmasi
//	//==================================================
//	Status;
//	
//	
//	//==================================================
//	//		Ekranda kullanilacak Timerlari çagirma ve atama
//	//==================================================
	GenTimer;
	
//	//==================================================
//	//		Ekranda bulunan widgetlari gizleme
//	//==================================================
	WidgetVisible;

	//==================================================
	//		IO Force kisminin kontrolleri
	//==================================================
	IOcontrolPage;
//
//	//==================================================
//	//		Manuel Eksen Atamalari
//	//==================================================
//	ManuelAxis;
//	
	//==================================================
	//		Makine kilitleme sayfasi kontrolleri
	//==================================================
	MachineLockPage;

	
	
	
//	//==================================================
//	//		Manuel Device
//	//==================================================
//
//		ManualDevice;
//
//	
//	
//	
//	//==================================================
//	//		Maximum ve Minimum deðerlerin atanmasý
//	//==================================================
//	MaxMinValue;
//	
//	
//	//==================================================
//	//		Home Ýþlemleri
//	//==================================================
//
//		Home;
//
//	Hyd;
//	
//	SpacerType;
//	
//	Distance;
//	
//	

END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

