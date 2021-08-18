// ----------------------------------------------------
// Database Method - On Host Database Event
// Database: 4DPop
// ID[D453BF9A8D4B40BCB95F778613DC853F]
// Created #16-7-2013 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// If the host database accepts
// We can launch the palette automatically
// ----------------------------------------------------
// Declarations
#DECLARE($eventCode : Integer)

// ----------------------------------------------------
Case of 
		
		//________________________________________
	: ($eventCode=On after host database startup:K74:4)
		
		// Launch the process of the palette
		EXECUTE METHOD:C1007("4DPop_Palette")  // (True)
		
		//________________________________________
	: ($eventCode=On before host database exit:K74:5)
		
		// Kill the process
		EXECUTE METHOD:C1007("4DPOP"; *; "deinit")
		
		//________________________________________
	: ($eventCode=On after host database exit:K74:6)
		
		// Cleanup the memory
		// CLEAR LIST(<>tools;*)
		
		//________________________________________
End case 