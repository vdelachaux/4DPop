var $e:=FORM Event:C1606

Case of 
		
		// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($e.code=On Load:K2:1)
		
		OBJECT SET SCROLLBAR:C843(*; "list"; 0; 2)
		
		Form:C1466._positions:=Form:C1466._positions || [\
			"TopLeft"; \
			"TopRight"; \
			"BottomLeft"; \
			"BottomRight"]
		
		var $color:=FORM Get color scheme:C1761="light" ? "black" : "white"
		var $button : Text
		For each ($button; Form:C1466._positions)
			
			OBJECT SET RGB COLORS:C628(*; $button; $color)
			
		End for each 
		
		If (Length:C16(String:C10(Form:C1466._setPosition))#0)
			
			OBJECT SET BORDER STYLE:C1262(*; Form:C1466._setPosition; Border Plain:K42:28)
			
		End if 
		
		OB REMOVE:C1226(Form:C1466; "_setPosition")
		Form:C1466._modifiedOrder:=False:C215
		
		// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($e.code=On Clicked:K2:4)
		
		If (Form:C1466._positions.includes($e.objectName))
			
			Form:C1466._setPosition:=$e.objectName
			
			For each ($button; Form:C1466._positions)
				
				OBJECT SET BORDER STYLE:C1262(*; $button; Border None:K42:27)
				
			End for each 
			
			OBJECT SET BORDER STYLE:C1262(*; $e.objectName; Border Plain:K42:28)
			
		End if 
		
		// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($e.code=On Close Box:K2:21)
		
		CANCEL:C270
		
		// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 