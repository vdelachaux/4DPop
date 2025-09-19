//%attributes = {"invisible":true}
// ----------------------------------------------------
// Created 01/12/06 by Vincent de Lachaux
// ----------------------------------------------------
var $p:=Current process:C322
var $matrix : Boolean:=Structure file:C489=Structure file:C489(*)

If (Process info:C1843($p).name="$4DPop")
	
	var strip : cs:C1710._4DPop
	
	If ($matrix)
		
		CLEAR VARIABLE:C89(strip)
		
		// Allow all errors and assertions
		ON ERR CALL:C155(""; ek global:K92:2)
		SET ASSERT ENABLED:C1131(True:C214; *)
		
	Else 
		
		// Hide all errors
		ON ERR CALL:C155(Formula:C1597(noError).source; ek local:K92:1)
		
	End if 
	
	strip:=strip || cs:C1710._4DPop.new()
	strip.display()
	
Else 
	
	// Create a new process
	If ($matrix)
		
		$p:=New process:C317("DISPLAY 4DPOP STRIP"; 0; "$4DPop"; *)
		
	Else 
		
		HIDE PROCESS:C324(New process:C317("DISPLAY 4DPOP STRIP"; 0; "$4DPop"; *))
		
	End if 
End if 