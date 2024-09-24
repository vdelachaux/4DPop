If (Not:C34(Is compiled mode:C492))
	
	ARRAY TEXT:C222($componentsArray; 0)
	COMPONENT LIST:C1001($componentsArray)
	
	If (Find in array:C230($componentsArray; "4DPop QuickOpen")>0)
		
		// Installing quickOpen
		EXECUTE METHOD:C1007("quickOpenInit"; *; Formula:C1597(MODIFIERS); Formula:C1597(KEYCODE))
		ON EVENT CALL:C190("quickOpenEventHandler"; "$quickOpenListener")
		
		EXECUTE METHOD:C1007("INSTALL ACTIONS")
		
	End if 
End if 

If (Not:C34(Shift down:C543))
	
	EXECUTE METHOD:C1007("DISPLAY 4DPOP STRIP")
	
End if 
