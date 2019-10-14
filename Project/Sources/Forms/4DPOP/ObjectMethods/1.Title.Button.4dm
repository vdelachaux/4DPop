  // ----------------------------------------------------
  // Object method: 4DPop_ButtonPalette.1.Title.Button
  // Created 05/06/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (12/12/13)
  // v14 refactoring
  // ----------------------------------------------------
C_LONGINT:C283($0)

C_LONGINT:C283($Lon_formEvent)

$Lon_formEvent:=Form event code:C388

Case of 
		
		  //________________________________________
	: ($Lon_formEvent=On Drag Over:K2:13)
		
		  // Added by Vincent de Lachaux (18/05/09)
		  // Automatic collapse/Expand
		If (Form:C1466.autoClose)
			
			COLLAPSE_EXPAND (Form:C1466.widgets.length)
			
			Form:C1466.event:=999
			SET TIMER:C645(-1)
			
		End if 
		
		IDLE:C311
		
		  //________________________________________
	: (Form event code:C388=On Mouse Move:K2:35)
		
		SET CURSOR:C469(Choose:C955(Macintosh control down:C544;9015;555))
		
		  //________________________________________
	: ($Lon_formEvent=On Mouse Leave:K2:34)
		
		SET CURSOR:C469
		
		  //________________________________________
	: (Contextual click:C713)
		
		CONTEXTUAL_MENU 
		
		  //________________________________________
	Else 
		
		SET TIMER:C645(0)
		SET CURSOR:C469(556)
		
		DRAG WINDOW:C452
		
		  // #12-12-2013 - delegate to the timer is more efficient
		Form:C1466.event:=8858
		SET TIMER:C645(-1)
		
		  //________________________________________
End case 