
(* The equation of a line where 2 points are known and the 3rd point is perpendicular to it. *)
FUNCTION fcFind_Origin

	
IF Enable THEN	
	
	m2		:= (Y2 - Y1) / (X2 - X1);	// Iki noktasi okunan dogrunun egimi
	F_LIN2 	:= m2 * (X - X1) + Y1;  	// Iki noktasi okunan dogrunun denklemi
	m1     	:= -1/m2;			    	// Bir noktasi okunan dogrunun egimi
	F_LIN1 	:= m1 * (X - X3) + Y3;  	// Bir noktasi okunan ve egimi bilinen dogru denklemi
	
	k		:= ATAN(m2);					  // Hesaplama
	DEGREE	:= k * 180 / (3.14159265); 		  // Iki noktasi okunan dogrunun X eksenindeki dönüklügünün açi degeri
	RADYAN	:= (DEGREE * (3.14159265)) / 180; // Iki noktasi okunan dogrunun X eksenindeki dönüklügünün açi degeri

	IF m2<>0 THEN

		X0     := ( (Y3-Y1)+(m2*X1)-(m1*X3) ) / (m2-m1);    // Parca Sifiri X degeri
		Y0     := m2 *(X0 - X1)+Y1;							// Parca Sifiri Y degeri
	ELSIF m2=0 THEN // Cam Tam 90 derece konulmus
		X0     := X3 + SearchSensorXOffset;   // Gb_X3:= MC_TouchProbe_X.RecordedPosition + VarHmictrl_Sensor_X; // Ilk Okunan X Noktasinin Offsetli degeri
		Y0     := Y1 + SearchSensorYOffset;   // Gb_Y1:= MC_TouchProbe_Y.RecordedPosition + VarHmictrl_Sensor_Y; // Ikinci Okunan Degerin Y Offsetli degeri
	END_IF;
		
ELSE // No Enable
	;	
END_IF;		
	
	// Y eksen
	// 
	// 
	////  nokta 3
	// 
	// 
	// 
	//  	nokta 2			nokta 1						
	//		//				// 								
	/////////////////////////////////////// X eksen	
	
END_FUNCTION
