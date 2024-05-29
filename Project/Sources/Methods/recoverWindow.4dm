//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Method : 4DPop_RECOVER_WINDOW
// Created 22/05/08 by vdl
// ----------------------------------------------------
// Description
// Sets, if necessary, the window on the screen
// ----------------------------------------------------
#DECLARE($resize : Boolean)

var $bottom; $buffer; $dH; $dV; $height; $i : Integer
var $left; $mainScreen; $menuBarHeight; $offset; $right; $screen : Integer
var $screenNumber; $top; $width; $winRef : Integer

// Get the number of screen monitors connected to the machine
$screenNumber:=Count screens:C437

// Get the number of the screen where the menu bar is located
$mainScreen:=Menu bar screen:C441

// Get the the frontmost window's reference number
$winRef:=Frontmost window:C447

// Shift from the edge
$offset:=10

// Get the global coordinates of the screens...
ARRAY LONGINT:C221($screenLefts; $screenNumber)
ARRAY LONGINT:C221($screenTops; $screenNumber)
ARRAY LONGINT:C221($screenRights; $screenNumber)
ARRAY LONGINT:C221($screenBottoms; $screenNumber)

// … ID …
ARRAY LONGINT:C221($screenIDs; $screenNumber)

// … Hight & Width.
ARRAY LONGINT:C221($screenWidths; $screenNumber)
ARRAY LONGINT:C221($screenHeights; $screenNumber)

For ($i; 1; $screenNumber; 1)
	
	$screenIDs{$i}:=$i
	SCREEN COORDINATES:C438($screenLefts{$i}; $screenTops{$i}; $screenRights{$i}; $screenBottoms{$i}; $i)
	$screenWidths{$i}:=$screenRights{$i}-$screenLefts{$i}
	$screenHeights{$i}:=$screenBottoms{$i}-$screenTops{$i}
	
End for 

// Get the coordinates of the frontmost window
GET WINDOW RECT:C443($left; $top; $right; $bottom; $winRef)
$width:=$right-$left
$height:=$bottom-$top

$buffer:=getWindowOffsets(Window kind:C445($winRef))
$dH:=($buffer & 0x0FFFF000) >> 16
$dV:=$buffer & 0xFFFF

// Get the extremes values
SORT ARRAY:C229($screenLefts; $screenTops; $screenRights; $screenBottoms; $screenIDs; $screenWidths; $screenHeights)
$screenLefts{0}:=$screenLefts{1}
SORT ARRAY:C229($screenTops; $screenLefts; $screenRights; $screenBottoms; $screenIDs; $screenWidths; $screenHeights)
$screenTops{0}:=$screenTops{1}
SORT ARRAY:C229($screenRights; $screenLefts; $screenTops; $screenBottoms; $screenIDs; $screenWidths; $screenHeights; <)
$screenRights{0}:=$screenRights{1}
SORT ARRAY:C229($screenBottoms; $screenLefts; $screenTops; $screenRights; $screenIDs; $screenWidths; $screenHeights; <)
$screenBottoms{0}:=$screenBottoms{1}

If (($left-$dH)<$screenLefts{0})
	
	// The window is too left
	$left:=$screenLefts{0}+$dH+$offset
	$right:=$left+$width
	
End if 

$buffer:=$top

If ($buffer<$screenTops{0})
	
	// The window is too high
	$top:=$screenTops{0}+$dV+$offset
	$bottom:=$top+$height
	
End if 

// On which screen is the upper left corner
MULTI SORT ARRAY:C718($screenLefts; >; $screenTops; >; $screenRights; $screenBottoms; $screenWidths; $screenHeights; $screenIDs)

For ($i; 1; $screenNumber; 1)
	
	If ($left>=$screenLefts{$i})\
		 & ($left<$screenRights{$i})\
		 | ($left<$screenLefts{$i})
		
		If ($top<$screenTops{$i})\
			 | (($top>=$screenTops{$i})\
			 & ($top<$screenBottoms{$i}))\
			 | ($top>$screenBottoms{$i})
			
			$screen:=$i
			break
			
		End if 
	End if 
End for 

$menuBarHeight:=Menu bar height:C440*Num:C11($screenIDs{$screen}=$mainScreen)

$buffer:=$screenTops{$screen}+$menuBarHeight+$offset+$dV

If ($top<$buffer)
	
	$top:=$buffer
	$bottom:=$top+$height
	
End if 

$buffer:=$screenRights{$screen}-($offset+$dH)

If ($right>$buffer)
	
	If ($resize)
		
		// Resize the window
		$right:=$buffer
		
	Else 
		
		// Try to move the window
		$buffer:=$right-$buffer+$offset+$dH
		
		If ($buffer>$screenLefts{$screen})
			
			// Ok, the left stay in the window
			$left:=$left-$buffer
			$right:=$left+$width
			
		End if 
	End if 
End if 

$buffer:=$screenBottoms{$screen}-$offset

If ($bottom>$buffer)
	
	If ($resize)
		
		// Resize the window
		$bottom:=$buffer
		
	Else 
		
		// Try to move the window
		$buffer:=$bottom-$buffer+$menuBarHeight+$offset+$dH
		
		If ($buffer>$screenTops{$screen})
			
			// Ok, the top stay in the window
			$top:=$top-$buffer
			$bottom:=$top+$height
			
		End if 
	End if 
End if 

SET WINDOW RECT:C444($left; $top; $right; $bottom; $winRef)