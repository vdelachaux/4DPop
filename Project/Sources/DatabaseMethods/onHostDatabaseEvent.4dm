// ----------------------------------------------------
// Database Method - On Host Database Event
// Database: 4DPop
// ID[D453BF9A8D4B40BCB95F778613DC853F]
// Created 16-7-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Automatic management of the 4DPop palette
// ----------------------------------------------------
#DECLARE($eventCode : Integer)

Case of 
		
		//________________________________________
	: ($eventCode=On before host database startup:K74:3)
		
		If (Is compiled mode:C492)
			
			// Define the global error handler
			ON ERR CALL:C155(Formula:C1597(noError).source; ek global:K92:2)
			
		End if 
		
		//________________________________________
	: ($eventCode=On after host database startup:K74:4)
		
		If (Not:C34(Is compiled mode:C492))
			
			ARRAY TEXT:C222($componentsArray; 0)
			COMPONENT LIST:C1001($componentsArray)
			
			If (Find in array:C230($componentsArray; "4DPop QuickOpen")>0)
				
				INSTALL ACTIONS
				
			End if 
		End if 
		
		DISPLAY 4DPOP STRIP
		
		//________________________________________
	: ($eventCode=On before host database exit:K74:5)
		
		If (Not:C34(Undefined:C82(strip)))
			
			strip.abort()
			
		End if 
		
		//________________________________________
	: ($eventCode=On after host database exit:K74:6)
		
		//
		
		//________________________________________
End case 