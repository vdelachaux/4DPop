  // ----------------------------------------------------
  // Method : Méthode objet : 4DPop_ButtonPalette.bUtil
  // Created 05/06/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_LONGINT:C283($0)

C_LONGINT:C283($Lon_bottom;$Lon_currentPage;$Lon_currentWindow;$Lon_formEvent;$Lon_left;$Lon_offset;$Lon_right;$Lon_screenWidth;$Lon_top)

Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Drag Over:K2:13)
		
		  // Added by Vincent de Lachaux (18/05/09)
		  // Automatic collapse/Expand
		If (Form:C1466.autoClose)
			
			COLLAPSE_EXPAND (Form:C1466.widgets.length)
			
			Form:C1466.event:=999
			SET TIMER:C645(100)
			
		End if 
		
		IDLE:C311
		
		  //……………………………………………………………………………
	: (Form event code:C388=On Mouse Move:K2:35)
		
		SET CURSOR:C469(Choose:C955(Macintosh control down:C544;9015;555))
		
		  //……………………………………………………………………………
	: (Form event code:C388=On Mouse Leave:K2:34)
		
		SET CURSOR:C469
		
		  //……………………………………………………………………………
	: (Contextual click:C713)
		
		CONTEXTUAL_MENU 
		
		  //……………………………………………………………………………
	Else 
		
		SET CURSOR:C469(556)
		DRAG WINDOW:C452
		
		$Lon_currentWindow:=Current form window:C827
		GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_currentWindow)
		
		$Lon_screenWidth:=Screen width:C187
		$Lon_currentPage:=FORM Get current page:C276
		
		Case of 
				  //………………………………………………………
			: ($Lon_right=$Lon_screenWidth)
				
				  //………………………………………………………
			: ($Lon_right<=(2*($Lon_screenWidth/3)))
				
				SET CURSOR:C469
				Form:C1466.page:=1
				FORM GOTO PAGE:C247(Form:C1466.page)
				$Lon_right:=$Lon_right-$Lon_left
				$Lon_left:=0
				SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_currentWindow)
				
				If ($Lon_currentPage=2)
					
					OBJECT MOVE:C664(*;"toolButton_@";10;0)
					
				End if 
				
				  //………………………………………………………
			Else 
				
				SET CURSOR:C469
				$Lon_offset:=$Lon_screenWidth-$Lon_right
				$Lon_left:=$Lon_left+$Lon_offset
				$Lon_right:=$Lon_right+$Lon_offset
				SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_currentWindow)
				
				  //………………………………………………………
		End case 
		
		_o_PREFERENCES ("palette.set";->$Lon_left;->$Lon_top;->$Lon_right;->$Lon_bottom)
		
		  //……………………………………………………………………………
End case 
