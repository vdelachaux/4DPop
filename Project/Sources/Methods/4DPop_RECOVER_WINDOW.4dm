//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Method : 4DPop_RECOVER_WINDOW
  // Created 22/05/08 by vdl
  // ----------------------------------------------------
  // Description
  // Sets, if necessary, the window on the screen
  // ----------------------------------------------------
C_BOOLEAN:C305($1)

C_BOOLEAN:C305($Boo_resize)
C_LONGINT:C283($Lon_Buffer;$Lon_dH;$Lon_dV;$Lon_frontmostWindow;$Lon_i)
C_LONGINT:C283($Lon_menuBarHeight;$Lon_menuBarScreenID;$Lon_offset;$Lon_Parameter;$Lon_screenIndex)
C_LONGINT:C283($Lon_screenNumber;$Lon_windowBottom;$Lon_windowHeight;$Lon_windowLeft;$Lon_windowRight)
C_LONGINT:C283($Lon_windowTop;$Lon_windowWidth)

If (False:C215)
	C_BOOLEAN:C305(4DPop_RECOVER_WINDOW ;$1)
End if 

  //Get the number of screen monitors connected to the machine
$Lon_screenNumber:=Count screens:C437
  //Get the number of the screen where the menu bar is located
$Lon_menuBarScreenID:=Menu bar screen:C441
  //Get the the frontmost window's reference number
$Lon_frontmostWindow:=Frontmost window:C447
  //Shift from the edge
$Lon_offset:=10

$Lon_Parameter:=Count parameters:C259
If ($Lon_Parameter>=1)
	$Boo_resize:=$1
End if 

  //Get the global coordinates of the screens...
ARRAY LONGINT:C221($tLon_screenLeft;$Lon_screenNumber)
ARRAY LONGINT:C221($tLon_screenTop;$Lon_screenNumber)
ARRAY LONGINT:C221($tLon_screenRight;$Lon_screenNumber)
ARRAY LONGINT:C221($tLon_screenBottom;$Lon_screenNumber)
  //… ID …
ARRAY LONGINT:C221($tLon_screenID;$Lon_screenNumber)
  //… Hight & Width.
ARRAY LONGINT:C221($tLon_screenWidth;$Lon_screenNumber)
ARRAY LONGINT:C221($tLon_screenHeight;$Lon_screenNumber)
For ($Lon_i;1;$Lon_screenNumber;1)
	$tLon_screenID{$Lon_i}:=$Lon_i
	SCREEN COORDINATES:C438($tLon_screenLeft{$Lon_i};$tLon_screenTop{$Lon_i};$tLon_screenRight{$Lon_i};$tLon_screenBottom{$Lon_i};$Lon_i)
	$tLon_screenWidth{$Lon_i}:=$tLon_screenRight{$Lon_i}-$tLon_screenLeft{$Lon_i}
	$tLon_screenHeight{$Lon_i}:=$tLon_screenBottom{$Lon_i}-$tLon_screenTop{$Lon_i}
End for 

  //Get the coordinates of the frontmost window
GET WINDOW RECT:C443($Lon_windowLeft;$Lon_windowTop;$Lon_windowRight;$Lon_windowBottom;$Lon_frontmostWindow)
$Lon_windowWidth:=$Lon_windowRight-$Lon_windowLeft
$Lon_windowHeight:=$Lon_windowBottom-$Lon_windowTop

$Lon_Buffer:=win_Lon_Get_Offsets (Window kind:C445($Lon_frontmostWindow))
$Lon_dH:=($Lon_Buffer & 0x0FFFF000) >> 16
$Lon_dV:=$Lon_Buffer & 0xFFFF

  //Get the extremes values
SORT ARRAY:C229($tLon_screenLeft;$tLon_screenTop;$tLon_screenRight;$tLon_screenBottom;$tLon_screenID;$tLon_screenWidth;$tLon_screenHeight)
$tLon_screenLeft{0}:=$tLon_screenLeft{1}
SORT ARRAY:C229($tLon_screenTop;$tLon_screenLeft;$tLon_screenRight;$tLon_screenBottom;$tLon_screenID;$tLon_screenWidth;$tLon_screenHeight)
$tLon_screenTop{0}:=$tLon_screenTop{1}
SORT ARRAY:C229($tLon_screenRight;$tLon_screenLeft;$tLon_screenTop;$tLon_screenBottom;$tLon_screenID;$tLon_screenWidth;$tLon_screenHeight;<)
$tLon_screenRight{0}:=$tLon_screenRight{1}
SORT ARRAY:C229($tLon_screenBottom;$tLon_screenLeft;$tLon_screenTop;$tLon_screenRight;$tLon_screenID;$tLon_screenWidth;$tLon_screenHeight;<)
$tLon_screenBottom{0}:=$tLon_screenBottom{1}

If (($Lon_windowLeft-$Lon_dH)<$tLon_screenLeft{0})
	  //The window is too left
	$Lon_windowLeft:=$tLon_screenLeft{0}+$Lon_dH+$Lon_offset
	$Lon_windowRight:=$Lon_windowLeft+$Lon_windowWidth
End if 

$Lon_Buffer:=$Lon_windowTop
If ($Lon_Buffer<$tLon_screenTop{0})
	  //The window is too high
	$Lon_windowTop:=$tLon_screenTop{0}+$Lon_dV+$Lon_offset
	$Lon_windowBottom:=$Lon_windowTop+$Lon_windowHeight
End if 

  //On which screen is the upper left corner
MULTI SORT ARRAY:C718($tLon_screenLeft;>;$tLon_screenTop;>;$tLon_screenRight;$tLon_screenBottom;$tLon_screenWidth;$tLon_screenHeight;$tLon_screenID)
For ($Lon_i;1;$Lon_screenNumber;1)
	If ($Lon_windowLeft>=$tLon_screenLeft{$Lon_i}) & ($Lon_windowLeft<$tLon_screenRight{$Lon_i}) | ($Lon_windowLeft<$tLon_screenLeft{$Lon_i})
		If ($Lon_windowTop<$tLon_screenTop{$Lon_i}) | (($Lon_windowTop>=$tLon_screenTop{$Lon_i}) & ($Lon_windowTop<$tLon_screenBottom{$Lon_i})) | ($Lon_windowTop>$tLon_screenBottom{$Lon_i})
			$Lon_screenIndex:=$Lon_i
			$Lon_i:=MAXLONG:K35:2-1
		End if 
	End if 
End for 

$Lon_menuBarHeight:=Menu bar height:C440*Num:C11($tLon_screenID{$Lon_screenIndex}=$Lon_menuBarScreenID)

$Lon_Buffer:=$tLon_screenTop{$Lon_screenIndex}+$Lon_menuBarHeight+$Lon_offset+$Lon_dV
If ($Lon_windowTop<$Lon_Buffer)
	$Lon_windowTop:=$Lon_Buffer
	$Lon_windowBottom:=$Lon_windowTop+$Lon_windowHeight
End if 

$Lon_Buffer:=$tLon_screenRight{$Lon_screenIndex}-($Lon_offset+$Lon_dH)
If ($Lon_windowRight>$Lon_Buffer)
	If ($Boo_resize)
		  //Resize the window
		$Lon_windowRight:=$Lon_Buffer
	Else 
		  //Try to move the window
		$Lon_Buffer:=$Lon_windowRight-$Lon_Buffer+$Lon_offset+$Lon_dH  //Temporary left
		If ($Lon_Buffer>$tLon_screenLeft{$Lon_screenIndex})
			  //Ok, the left stay in the window
			$Lon_windowLeft:=$Lon_windowLeft-$Lon_Buffer
			$Lon_windowRight:=$Lon_windowLeft+$Lon_windowWidth
		End if 
	End if 
End if 

$Lon_Buffer:=$tLon_screenBottom{$Lon_screenIndex}-$Lon_offset
If ($Lon_windowBottom>$Lon_Buffer)
	If ($Boo_resize)
		  //Resize the window
		$Lon_windowBottom:=$Lon_Buffer
	Else 
		  //Try to move the window
		$Lon_Buffer:=$Lon_windowBottom-$Lon_Buffer+$Lon_menuBarHeight+$Lon_offset+$Lon_dH  //Temporary top
		If ($Lon_Buffer>$tLon_screenTop{$Lon_screenIndex})
			  //Ok, the top stay in the window
			$Lon_windowTop:=$Lon_windowTop-$Lon_Buffer
			$Lon_windowBottom:=$Lon_windowTop+$Lon_windowHeight
		End if 
	End if 
End if 

SET WINDOW RECT:C444($Lon_windowLeft;$Lon_windowTop;$Lon_windowRight;$Lon_windowBottom;$Lon_frontmostWindow)
