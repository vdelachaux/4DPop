// ----------------------------------------------------
// Database Method - On Host Database Event
// Database: 4DPop
// ID[D453BF9A8D4B40BCB95F778613DC853F]
// Created #16-7-2013 by Vincent de Lachaux
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
			ON ERR CALL:C155("noError"; ek global:K92:2)
			
		End if 
		
		//________________________________________
	: ($eventCode=On after host database startup:K74:4)
		
		// Launch
		displayStrip
		
		//________________________________________
	: ($eventCode=On before host database exit:K74:5)
		
		If (Not:C34(Undefined:C82(component)))
			
			// Kill the process
			component.abort()
			
		End if 
		
		//________________________________________
	: ($eventCode=On after host database exit:K74:6)
		
		//
		
		//________________________________________
End case 

