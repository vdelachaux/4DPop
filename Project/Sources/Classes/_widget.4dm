Class constructor($component : Object; $manifest : Object)
	
	This:C1470.file:=$component
	This:C1470.manifest:=$manifest
	This:C1470.name:=$component.name
	This:C1470.help:=$component.file($component.name+".htm")
	This:C1470.helptip:=""
	This:C1470.icon:=Null:C1517
	This:C1470.default:=String:C10($manifest.default)
	This:C1470.ondrop:=String:C10($manifest.ondrop)
	This:C1470.popup:=Bool:C1537($manifest.popup)
	This:C1470.handler:=$manifest.handler
	This:C1470.tools:=New collection:C1472
	
	// MARK:###### TEMPO #######
	This:C1470.tool:=This:C1470.tools
	
	
	
	