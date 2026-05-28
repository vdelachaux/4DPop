var $isOk : Boolean
If (Not:C34(Is compiled mode:C492))
	
	ARRAY TEXT:C222($componentsArray; 0)
	COMPONENT LIST:C1001($componentsArray)
	
	If (Find in array:C230($componentsArray; "4DPop QuickOpen")>0)
		
		// Installing quickOpen
		EXECUTE METHOD:C1007("quickOpenInit"; *; Formula:C1597(MODIFIERS); Formula:C1597(KEYCODE))
		ON EVENT CALL:C190("quickOpenEventHandler"; "$quickOpenListener")
		
		EXECUTE METHOD:C1007("INSTALL ACTIONS")
		
	End if 
	
	If (Find in array:C230($componentsArray; "wod_DevTools")>0)
		EXECUTE METHOD:C1007("wod_initRegister"; $isOk)
		//EXECUTE METHOD("wod__storage_prefs"; $vJ_prefs)
		//Use ($vJ_prefs)
		//$vJ_prefs.fu_FORM_EDIT:=Formula(_wod_FORM_EDIT)
		//End use 
		EXECUTE METHOD:C1007("wod_palette")
		// *****
	End if 
	
	//woc_initRegister
	//If (Find in array($aT_components; "wom_Make")>0)
	//EXECUTE METHOD("wom_initRegister"; $isOk; ""; "")
	//EXECUTE METHOD("wom_configurate_vJ"; *; woc__storage_prefs)
	//// *
	//// *****
	//End if 
	
End if 

If (Not:C34(Shift down:C543))
	
	EXECUTE METHOD:C1007("DISPLAY 4DPOP STRIP")
	
End if 