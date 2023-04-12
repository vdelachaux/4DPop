//%attributes = {"invisible":true}
// ----------------------------------------------------
// Created 01/12/06 by Vincent de Lachaux
// ----------------------------------------------------
var $name : Text
var $process; $tate; $time : Integer

PROCESS PROPERTIES:C336(Current process:C322; $name; $tate; $time)

If ($name#("$4DPop"))  // Create a new process
	
	If (Structure file:C489=Structure file:C489(*))
		
		$process:=New process:C317(Formula:C1597(displayStrip).source; 0; "$4DPop"; *)
		
	Else 
		
		HIDE PROCESS:C324(New process:C317(Formula:C1597(displayStrip).source; 0; "$4DPop"; *))
		
	End if 
	
Else 
	
	var component : cs:C1710._component
	
	If (Structure file:C489=Structure file:C489(*))
		
		CLEAR VARIABLE:C89(component)
		
		ON ERR CALL:C155(""; ek global:K92:2)
		SET ASSERT ENABLED:C1131(True:C214; *)
		
	Else 
		
		ON ERR CALL:C155("noError"; ek global:K92:2)
		
	End if 
	
	component:=component || cs:C1710._component.new()
	component.display()
	
End if 