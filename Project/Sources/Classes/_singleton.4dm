Class constructor($instance : Object)
	
	// Get the class of the object passed in parameter
	This:C1470.class:=OB Class:C1730($instance)
	
	If (This:C1470.class.instance=Null:C1517)
		
		// Create the instance
		Use (This:C1470.class)
			
			// As shareable
			This:C1470.class.instance:=OB Copy:C1225($instance; ck shared:K85:29; This:C1470.class)
			
			// Save the new function…
			This:C1470.class._new:=This:C1470.new
			
			// And replace it
			This:C1470.class.new:=Formula:C1597(This:C1470.instance)
			
		End use 
	End if 