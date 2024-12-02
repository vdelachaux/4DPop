//%attributes = {"invisible":true}
// ----------------------------------------------------
// Created 01/12/06 by Vincent de Lachaux
// ----------------------------------------------------
If (Process info:C1843(Current process:C322).name="$4DPop")
	
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
	
Else 
	
	// Create a new process
	
	If (Structure file:C489=Structure file:C489(*))
		
		var $process : Integer:=New process:C317("DISPLAY 4DPOP STRIP"; 0; "$4DPop"; *)
		
	Else 
		
		HIDE PROCESS:C324(New process:C317("DISPLAY 4DPOP STRIP"; 0; "$4DPop"; *))
		
	End if 
End if 