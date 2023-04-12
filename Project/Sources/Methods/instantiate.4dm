//%attributes = {"invisible":true}
#DECLARE($name : Text)->$class : 4D:C1709.Class

If (False:C215)
	C_TEXT:C284(instantiate; $1)
	C_OBJECT:C1216(instantiate; $0)
End if 

If (Asserted:C1132(Count parameters:C259>0; "Class name is missing"))
	
	If (Asserted:C1132(cs:C1710[$name]#Null:C1517; "The class '"+$name+"' does not exist"))
		
		$class:=cs:C1710[$name]
		
	End if 
End if 

