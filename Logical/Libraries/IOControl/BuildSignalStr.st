(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Library: IOControl
 * File: BuildSignalStr.st
 * Author: abdullahoglf
 * Created: February 12, 2014
 ********************************************************************
 * Implementation of library IOControl
 ********************************************************************) 

(* Builds the necessary datapoint for a specific channel *)
FUNCTION_BLOCK BuildSignalStr
		
		// build string: step 1 : direction prefix and size prefix
		CASE eTypeSignal OF
			(* --- *)
			DI_IO: 
				sStrSignal := '%IX';
		
				(* --- *)
			DO_IO: 
				sStrSignal := '%QX'; 

				(* --- *)
			AI_IO: 
				sStrSignal := '%IW'; 
			
				(* --- *)
			AO_IO: 
				sStrSignal := '%QW'; 

		END_CASE;

		(* --- *)
		// build string: step 2 : add powerlink interface name
		brsstrcat(ADR(sStrSignal),ADR(sEPL));	
	
		// num slot
		brsstrcat(ADR(sStrSignal),ADR('.IF6'));
	

		(* --- *)
		// build string: step 3 : num station and num slot
		// num station
		brsitoa(USINT_TO_DINT(uNumStation), ADR(str));
		
	
		brsstrcat(ADR(sStrSignal),ADR('.ST'));	
		brsstrcat(ADR(sStrSignal),ADR(str));
	
		//	itoa(USINT_TO_DINT(uNumSlot), ADR(str));
		//	strcat(ADR(sStrSignal),ADR(str));	


		(* --- *)
		// build string: step 4 : channel name
		CASE eTypeSignal OF
			(* --- *)
			DI_IO: 
				str := '.DigitalInput';

				(* --- *)
			DO_IO: 
				str := '.DigitalOutput';

				(* --- *)
			AI_IO: 
				str := '.AnalogInput';
			
				(* --- *)
			AO_IO: 
				str := '.AnalogOutput';
		END_CASE;

		CASE uNumSignal OF

			0: (* this Channel is not configured *);												
				str := 'NOT CONFIGURED';										

			1:	(* ChannelName01 *)
				brsstrcat(ADR(str),ADR('01'));

			2:	(* ChannelName02 *)
				brsstrcat(ADR(str),ADR('02'));

			3:	(* ChannelName03 *)
				brsstrcat(ADR(str),ADR('03'));

			4: (* ChannelName04 *)
				brsstrcat(ADR(str),ADR('04'));

			5: (* ChannelName05 *)
				brsstrcat(ADR(str),ADR('05'));

			6:	(* ChannelName06 *)
				brsstrcat(ADR(str),ADR('06'));

			7:	(* ChannelName07 *)
				brsstrcat(ADR(str),ADR('07'));

			8:	(* ChannelName08 *)
				brsstrcat(ADR(str),ADR('08'));

			9: (* ChannelName09 *)
				brsstrcat(ADR(str),ADR('09'));

			10:(* ChannelName10 *)
				brsstrcat(ADR(str),ADR('10'));

			11:(* ChannelName11 *)
				brsstrcat(ADR(str),ADR('11'));

			12:(* ChannelName12 *)
				brsstrcat(ADR(str),ADR('12'));	
			
			13:(* ChannelName13 *)
				brsstrcat(ADR(str),ADR('13'));	
			
			14:(* ChannelName14 *)
				brsstrcat(ADR(str),ADR('14'));	
			
			15:(* ChannelName15 *)
				brsstrcat(ADR(str),ADR('15'));	
			
			16:(* ChannelName16 *)
				brsstrcat(ADR(str),ADR('16'));	

		END_CASE

		brsstrcat(ADR(sStrSignal),ADR(str));
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
END_FUNCTION_BLOCK