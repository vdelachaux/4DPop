
var $e : Object
$e:=FORM Event:C1606

Case of 
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($e.code=On Load:K2:1)
		
		OBJECT SET SCROLLBAR:C843(*; "list"; 0; 2)
		
		Form:C1466._modifiedOrder:=False:C215
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($e.code=On Clicked:K2:4)
		
		If ($e.objectName="TopLeft")\
			 || ($e.objectName="TopRight")\
			 || ($e.objectName="BottomLeft")\
			 || ($e.objectName="BottomRight")
			
			Form:C1466._setPosition:=$e.objectName
			
		End if 
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($e.code=On Close Box:K2:21)
		
		CANCEL:C270
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 
