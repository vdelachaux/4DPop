C_LONGINT:C283($0)

C_LONGINT:C283($Lon_formEvent)

$Lon_formEvent:=Form event code:C388

Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Drag Over:K2:13)
		
		  // Added by Vincent de Lachaux (18/05/09)
		  // Automatic collapse/Expand
		If (Form:C1466.autoClose)
			
			COLLAPSE_EXPAND (Form:C1466.widgets.length)
			
			Form:C1466.event:=999
			SET TIMER:C645(-1)
			
		Else 
			
			SET CURSOR:C469(9010)
			
		End if 
		
		IDLE:C311
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Move:K2:35)
		
		  // Added by Vincent de Lachaux (18/05/09)
		  // Automatic collapse/Expand
		If (Form:C1466.autoClose)
			
			COLLAPSE_EXPAND (Form:C1466.widgets.length)
			
			Form:C1466.event:=999
			SET TIMER:C645(-1)
			
		Else 
			
			SET CURSOR:C469(9010)
			
		End if 
		
		IDLE:C311
		
		  //______________________________________________________
	: (Form:C1466.autoClose)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Leave:K2:34)
		
		SET CURSOR:C469
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		Form:C1466.event:=1
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Double Clicked:K2:5)
		
		COLLAPSE_EXPAND 
		
		  //______________________________________________________
End case 
