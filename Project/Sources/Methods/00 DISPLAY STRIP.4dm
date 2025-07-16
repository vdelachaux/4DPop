//%attributes = {}
// Close the existing, if any
var $p : Integer
For ($p; 1; Count user processes:C343; 1)
	
	If (Process info:C1843($p).name="$4DPop")
		
		POST OUTSIDE CALL:C329($p)
		
		Repeat 
			
			IDLE:C311
			
		Until (Process state:C330($p)=Aborted:K13:1)
		
		break
		
	End if 
End for 

DISPLAY 4DPOP STRIP