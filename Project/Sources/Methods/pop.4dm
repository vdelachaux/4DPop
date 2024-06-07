//%attributes = {"invisible":true,"shared":true}
#DECLARE($class : Text) : 4D:C1709.Class

If (Count parameters:C259>=1)
	
	If (Asserted:C1132(OB Instance of:C1731(cs:C1710[$class]; 4D:C1709.Function); "class not found: "+$class))
		
		return cs:C1710[$class]
		
	End if 
	
Else 
	
	return cs:C1710
	
End if 
