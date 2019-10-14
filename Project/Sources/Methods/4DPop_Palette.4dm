//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Method : 4DPop_Palette
  // Created 01/12/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // Open the 4DPop palette and display available tools
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_BOOLEAN:C305($b)
C_LONGINT:C283($l;$Lon_bottom;$Lon_height;$Lon_left;$Lon_right;$Lon_screenHeight)
C_LONGINT:C283($Lon_screenWidth;$Lon_top;$Lon_width)
C_TEXT:C284($t)
C_OBJECT:C1216($Obj_form)

PROCESS PROPERTIES:C336(Current process:C322;$t;$l;$l)

If ($t#("$4DPop_Palette"))  // Create a new process
	
	HIDE PROCESS:C324(New process:C317("4DPop_Palette";0;"$4DPop_Palette";*))
	
Else 
	
	COMPILER_4DPOP 
	
	$Obj_form:=4DPop_INIT 
	
	FORM GET PROPERTIES:C674("4DPOP";$Lon_width;$Lon_height)
	
	If (Shift down:C543)
		
		$Lon_left:=-1
		
	Else 
		
		_o_PREFERENCES ("palette.get";->$Lon_left;->$Lon_top;->$Lon_right;->$Lon_bottom)
		
	End if 
	
	_o_PREFERENCES ("auto_hide.get";->$b)
	$Obj_form.autoClose:=$b
	
	$Lon_screenWidth:=Screen width:C187
	$Lon_screenHeight:=Screen height:C188
	
	If ($Lon_left=-1)
		
		$Lon_left:=0
		$Lon_bottom:=$Lon_screenHeight
		
	End if 
	
	$Lon_top:=$Lon_bottom-$Lon_height
	
	If ($Lon_left=0)
		
		$Lon_right:=$Lon_width
		
	Else 
		
		$Lon_left:=$Lon_screenWidth-$Lon_width
		$Lon_right:=$Lon_screenWidth
		
	End if 
	
	  //http://forums.4d.fr/Post/FR/1467515/2/1723383#1723383
	If ($Lon_bottom>$Lon_screenHeight)
		
		$Lon_height:=$Lon_bottom-$Lon_top
		$Lon_bottom:=$Lon_screenHeight
		$Lon_top:=$Lon_bottom-$Lon_height
		
	End if 
	
	If (Count screens:C437=1)
		
		If ($Lon_left<0)
			
			$Lon_left:=0
			$Lon_right:=$Lon_width
			
		End if 
		
		If ($Lon_right>$Lon_screenWidth)
			
			$Lon_right:=$Lon_screenWidth
			
		End if 
	End if 
	
	$Obj_form.window:=Open window:C153($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;-(Plain dialog box:K34:4+Texture appearance:K34:17+_o_Compositing mode:K34:18))
	
	DIALOG:C40("4DPOP";$Obj_form)
	
	  // Modified by vdl (04/06/08)
	  // Adds the management of the number of tools to display when the palette will be next open {
	GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Obj_form.window)
	$l:=($Lon_right-$Lon_left)\$Obj_form.cellWidth
	_o_PREFERENCES ("Viewing.set";->$l)
	  //}
	
	CLOSE WINDOW:C154
	
End if 