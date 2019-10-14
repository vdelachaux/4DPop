  // ----------------------------------------------------
  // Database Method - On Host Database Event
  // Database: 4DPop
  // ID[D453BF9A8D4B40BCB95F778613DC853F]
  // Created #16-7-2013 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // If the host database accepts
  // we can launch the palette automatically
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($1)

C_LONGINT:C283($Lon_hostDatabaseEvent)

  // ----------------------------------------------------
  // Initialisations
$Lon_hostDatabaseEvent:=$1

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_hostDatabaseEvent=On after host database startup:K74:4)
		
		  //Launch the process of the palette
		4DPop_Palette   // (True)
		
		  //______________________________________________________
	: ($Lon_hostDatabaseEvent=On before host database exit:K74:5)
		
		  //Kill the process
		4DPOP ("deinit")
		
		  //______________________________________________________
	: ($Lon_hostDatabaseEvent=On after host database exit:K74:6)
		
		  //Cleanup the memory
		  //CLEAR LIST(<>tools;*)
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // End