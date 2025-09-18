//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : 4DPop_RECOVER_WINDOW
// Created 22/05/08 by vdl
// ----------------------------------------------------
// Description
// Sets, if necessary, the window on the screen
// ----------------------------------------------------
#DECLARE($resize : Boolean)

// Get the number of screen monitors connected to the machine
var $screenNumber:=Count screens:C437

// Get the number of the screen where the menu bar is located
var $mainScreen:=Menu bar screen:C441

// Get the the frontmost window's reference number
var $winRef:=Frontmost window:C447

// Shift from the edge
var $offset : Integer:=10

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

var $i : Integer
For ($i; 1; $screenNumber; 1)
	
	$screenIDs{$i}:=$i
	SCREEN COORDINATES:C438($screenLefts{$i}; $screenTops{$i}; $screenRights{$i}; $screenBottoms{$i}; $i)
	$screenWidths{$i}:=$screenRights{$i}-$screenLefts{$i}
	$screenHeights{$i}:=$screenBottoms{$i}-$screenTops{$i}
	
End for 

// Get the coordinates of the frontmost window
var $left; $top; $right; $bottom : Integer
GET WINDOW RECT:C443($left; $top; $right; $bottom; $winRef)
var $width : Integer:=$right-$left
var $height : Integer:=$bottom-$top

var $winOffset:=getWindowOffsets(Window kind:C445($winRef))
var $dH : Integer:=($winOffset & 0x0FFFF000) >> 16
var $dV : Integer:=$winOffset & 0xFFFF

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

$winOffset:=$top

If ($winOffset<$screenTops{0})
	
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
			
			var $screen:=$i
			
			break
			
		End if 
	End if 
End for 

var $menuBarHeight : Integer:=Menu bar height:C440*Num:C11($screenIDs{$screen}=$mainScreen)

$winOffset:=$screenTops{$screen}+$menuBarHeight+$offset+$dV

If ($top<$winOffset)
	
	$top:=$winOffset
	$bottom:=$top+$height
	
End if 

$winOffset:=$screenRights{$screen}-($offset+$dH)

If ($right>$winOffset)
	
	If ($resize)
		
		// Resize the window
		$right:=$winOffset
		
	Else 
		
		// Try to move the window
		$winOffset:=$right-$winOffset+$offset+$dH
		
		If ($winOffset>$screenLefts{$screen})
			
			// Ok, the left stay in the window
			$left:=$left-$winOffset
			$right:=$left+$width
			
		End if 
	End if 
End if 

$winOffset:=$screenBottoms{$screen}-$offset

If ($bottom>$winOffset)
	
	If ($resize)
		
		// Resize the window
		$bottom:=$winOffset
		
	Else 
		
		// Try to move the window
		$winOffset:=$bottom-$winOffset+$menuBarHeight+$offset+$dH
		
		If ($winOffset>$screenTops{$screen})
			
			// Ok, the top stay in the window
			$top:=$top-$winOffset
			$bottom:=$top+$height
			
		End if 
	End if 
End if 

SET WINDOW RECT:C444($left; $top; $right; $bottom; $winRef)