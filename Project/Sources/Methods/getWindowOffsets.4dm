//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : win_Lon_Get_Offsets
// Alias : zFF_Get_Offsets
// Created 22/04/98 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Returns the offset for each window type
// ----------------------------------------------------
#DECLARE($type : Integer; $onWindows : Boolean) : Integer

var $dH; $dV : Integer

// Absolute value of the window type, identical offsets for the palettes
$type:=Abs:C99(Count parameters:C259=0 ? Window kind:C445 : $type)

$onWindows:=Count parameters:C259=1 ? Is Windows:C1573 : $onWindows

If ($onWindows)
	
	Case of 
			
			//__________________________________________
		: ($type=Plain no zoom box window:K34:1)\
			 | ($type=Plain window:K34:13)
			
			$dH:=6
			$dV:=28
			
			//__________________________________________
		: ($type=Plain fixed size window:K34:6)\
			 | ($type=Round corner window:K34:8)\
			 | ($type=Movable dialog box:K34:7)
			
			$dH:=6
			$dV:=27
			
			//__________________________________________
		: ($type=Modal dialog box:K34:2)
			
			$dH:=6
			$dV:=9
			
			//__________________________________________
		: ($type=Plain dialog box:K34:4)\
			 | ($type=Alternate dialog box:K34:5)
			
			$dH:=4
			$dV:=6
			
			//__________________________________________
		Else   // Floating pallet
			
			$dH:=3
			$dV:=20
			
			//__________________________________________
	End case 
	
Else 
	
	Case of 
			
			//__________________________________________
		: ($type=Plain no zoom box window:K34:1)\
			 | ($type=Plain fixed size window:K34:6)\
			 | ($type=Plain window:K34:13)\
			 | ($type=Round corner window:K34:8)
			
			$dH:=3
			$dV:=21
			
			//__________________________________________
		: ($type=Modal dialog box:K34:2)
			
			$dH:=10
			$dV:=10
			
			//__________________________________________
		: ($type=Plain dialog box:K34:4)\
			 | ($type=Alternate dialog box:K34:5)
			
			$dH:=3
			$dV:=4
			
			//__________________________________________
		: ($type=Movable dialog box:K34:7)
			
			$dH:=8
			$dV:=25
			
			//__________________________________________
		Else   // Floating pallet
			
			$dH:=3
			$dV:=13
			
			//__________________________________________
	End case 
End if 

return ($dH << 16)+$dV