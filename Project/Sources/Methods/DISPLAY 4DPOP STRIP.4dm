//%attributes = {"invisible":true}
// ----------------------------------------------------
// Created 01/12/06 by Vincent de Lachaux
// ----------------------------------------------------
var $name : Text
var $process; $state; $time : Integer

_O_PROCESS PROPERTIES:C336(Current process:C322; $name; $state; $time)

If ($name#("$4DPop"))  // Create a new process
	
	If (Structure file:C489=Structure file:C489(*))
		
		// $process:=New process(Formula(DISPLAY 4DPOP STRIP).source; 0; "$4DPop"; *)
		$process:=New process:C317("DISPLAY 4DPOP STRIP"; 0; "$4DPop"; *)
		
	Else 
		
		// HIDE PROCESS(New process(Formula(DISPLAY 4DPOP STRIP).source; 0; "$4DPop"; *))
		HIDE PROCESS:C324(New process:C317("DISPLAY 4DPOP STRIP"; 0; "$4DPop"; *))
		
	End if 
	
Else 
	
	var strip : cs:C1710._4DPop
	
	If (Structure file:C489=Structure file:C489(*))
		
		CLEAR VARIABLE:C89(strip)
		
		ON ERR CALL:C155(""; ek global:K92:2)
		SET ASSERT ENABLED:C1131(True:C214; *)
		
	Else 
		
		ON ERR CALL:C155(Formula:C1597(noError).source; ek global:K92:2)
		
	End if 
	
	strip:=strip || cs:C1710._4DPop.new()
	strip.display()
	
End if 