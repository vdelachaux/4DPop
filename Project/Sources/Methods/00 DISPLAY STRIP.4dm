//%attributes = {}
var $name : Text
var $process; $dummy : Integer

For ($process; 1; Count user processes:C343; 1)
	
	PROCESS PROPERTIES:C336($process; $name; $dummy; $dummy)
	
	If ($name="$4DPop")
		
		POST OUTSIDE CALL:C329($process)
		
		Repeat 
			
			IDLE:C311
			
		Until (Process state:C330($process)=Aborted:K13:1)
		
		break
		
	End if 
End for 

DISPLAY 4DPOP STRIP