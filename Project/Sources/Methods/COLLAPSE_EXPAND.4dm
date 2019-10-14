//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : COLLAPSE_EXPAND
  // Created 05/06/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by vdl (04/06/08)
  // Adds the management of the number of tools to display ($1)
  // ----------------------------------------------------
  // Modified by vdl (01/07/08)
  // workaround for ACI0058409 & ACI0058410
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_LONGINT:C283($1)

C_LONGINT:C283($kLon_offset;$Lon_bottom;$Lon_displayed;$Lon_i;$Lon_left;$Lon_offset)
C_LONGINT:C283($Lon_right;$Lon_top;$Lon_width)

If (False:C215)
	C_LONGINT:C283(COLLAPSE_EXPAND ;$1)
End if 

$kLon_offset:=Form:C1466.offset+5

GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)

If (Count parameters:C259=0)
	
	If (Form:C1466.page=1)
		
		$Lon_width:=$Lon_right+$Lon_left
		
		If ($Lon_width<Form:C1466.maxWidth)
			
			$Lon_offset:=Form:C1466.maxWidth-$Lon_width
			$Lon_right:=$Lon_right+$Lon_offset
			SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
			OBJECT MOVE:C664(*;"@.Movable";$Lon_offset;0)
			
			For ($Lon_i;1;Form:C1466.widgets.length;1)
				
				OBJECT SET VISIBLE:C603(*;"toolButton_"+String:C10($Lon_i);True:C214)
				
			End for 
			
		Else 
			
			SET WINDOW RECT:C444(0;$Lon_top;$Lon_left+$kLon_offset;$Lon_bottom;Form:C1466.window)
			OBJECT MOVE:C664(*;"@.Movable";-$Lon_width+$kLon_offset;0)
			OBJECT MOVE:C664(*;"fix_@";-$Lon_width+$kLon_offset;0)
			OBJECT SET VISIBLE:C603(*;"toolButton_@";False:C215)
			
		End if 
		
	Else 
		
		$Lon_width:=$Lon_right-$Lon_left
		
		If ($Lon_width<Form:C1466.maxWidth)
			
			$Lon_offset:=Form:C1466.maxWidth-$Lon_width
			$Lon_left:=$Lon_left-$Lon_offset
			OBJECT MOVE:C664(*;"@.Movable";$Lon_offset;0)
			SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
			OBJECT SET VISIBLE:C603(*;"Fleche.@";False:C215)
			
			For ($Lon_i;1;Form:C1466.widgets.length;1)
				
				OBJECT SET VISIBLE:C603(*;"toolButton_"+String:C10($Lon_i);True:C214)
				
			End for 
			
		Else 
			
			$Lon_offset:=($Lon_right-$Lon_left)-$kLon_offset
			SET WINDOW RECT:C444($Lon_left+$Lon_offset;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
			OBJECT MOVE:C664(*;"@.Movable";-$Lon_offset;0)
			OBJECT SET VISIBLE:C603(*;"Fleche.@";True:C214)
			OBJECT SET VISIBLE:C603(*;"toolButton_@";False:C215)
			
		End if 
	End if 
	
	OBJECT MOVE:C664(*;"skin.background";0;0;Form:C1466.maxWidth;$Lon_bottom-$Lon_top;*)
	
Else 
	
	$Lon_displayed:=$1
	
	If ($Lon_displayed>Form:C1466.widgets.length) | (Form:C1466.widgets.length=0)
		
		$Lon_displayed:=Choose:C955(Form:C1466.widgets.length>0;Form:C1466.widgets.length;1)
		
	End if 
	
	Form:C1466.maxWidth:=((Form:C1466.cellWidth*$Lon_displayed)+$kLon_offset)
	
	If (Form:C1466.page=1)
		
		$Lon_width:=$Lon_right+$Lon_left
		
		$Lon_offset:=Form:C1466.maxWidth-$Lon_width
		$Lon_right:=$Lon_right+$Lon_offset
		OBJECT MOVE:C664(*;"@.Movable";$Lon_offset;0)
		
	Else 
		
		$Lon_width:=$Lon_right-$Lon_left
		
		$Lon_offset:=Form:C1466.maxWidth-$Lon_width
		$Lon_left:=$Lon_left-$Lon_offset
		OBJECT MOVE:C664(*;"@.Movable";$Lon_offset;0)
		
	End if 
	
	SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
	
	For ($Lon_i;1;Form:C1466.widgets.length;1)
		
		OBJECT SET VISIBLE:C603(*;"toolButton_"+String:C10($Lon_i);$Lon_displayed>0)
		
	End for 
	
	OBJECT MOVE:C664(*;"skin.background";0;0;Form:C1466.maxWidth;$Lon_bottom-$Lon_top;*)
	
	REDRAW WINDOW:C456
	
End if 