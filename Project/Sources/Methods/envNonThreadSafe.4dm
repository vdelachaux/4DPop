//%attributes = {"invisible":true,"preemptive":"incapable"}
/*
Non-thread-safe screen commands to be called in a cooperative process
*/

#DECLARE($signal : 4D:C1709.Signal)

Case of 
		
		//______________________________________________________
	: ($signal.action="windowOffsets")
		
		var $hOffset; $vOffset; $type : Integer
		
		// Absolute value of the window type, identical offsets for the palettes
		$type:=Abs:C99($signal.type=Null:C1517 ? Window kind:C445 : Num:C11($signal.type))
		
		If ($signal.WonWindows=Null:C1517 ? Is Windows:C1573 : Bool:C1537($signal.WonWindows))
			
			Case of 
					
					//__________________________________________
				: ($type=Plain no zoom box window:K34:1)\
					 || ($type=Plain window:K34:13)
					
					$hOffset:=6
					$vOffset:=28
					
					//__________________________________________
				: ($type=Plain fixed size window:K34:6)\
					 || ($type=Round corner window:K34:8)\
					 || ($type=Movable dialog box:K34:7)
					
					$hOffset:=6
					$vOffset:=27
					
					//__________________________________________
				: ($type=Modal dialog box:K34:2)
					
					$hOffset:=6
					$vOffset:=27
					
					//__________________________________________
				: ($type=Plain dialog box:K34:4)\
					 || ($type=Alternate dialog box:K34:5)
					
					$hOffset:=4
					$vOffset:=6
					
					//__________________________________________
				Else   // Floating pallet
					
					$hOffset:=3
					$vOffset:=20
					
					//__________________________________________
			End case 
			
		Else 
			
			Case of 
					
					//__________________________________________
				: ($type=Plain no zoom box window:K34:1)\
					 || ($type=Plain fixed size window:K34:6)\
					 || ($type=Plain window:K34:13)\
					 || ($type=Round corner window:K34:8)
					
					$hOffset:=3
					$vOffset:=21
					
					//__________________________________________
				: ($type=Modal dialog box:K34:2)
					
					$hOffset:=10
					$vOffset:=10
					
					//__________________________________________
				: ($type=Plain dialog box:K34:4)\
					 || ($type=Alternate dialog box:K34:5)
					
					$hOffset:=3
					$vOffset:=4
					
					//__________________________________________
				: ($type=Movable dialog box:K34:7)
					
					$hOffset:=8
					$vOffset:=25
					
					//__________________________________________
				Else   // Floating pallet
					
					$hOffset:=3
					$vOffset:=13
					
					//__________________________________________
			End case 
		End if 
		
		Use ($signal)
			
			$signal.hOffset:=$hOffset
			$signal.vOffset:=$vOffset
			
		End use 
		
		//______________________________________________________
		
	: ($signal.action=Null:C1517)\
		 || ($signal.action="screenInfos")
		
		var $bottom; $i; $left; $right; $top : Integer
		var $screen : Object
		var $screens : Collection
		
		$screens:=[]
		
		For ($i; 1; Count screens:C437; 1)
			
			$screen:={\
				coordinates: {}; \
				dimensions: {}; \
				workArea: {}\
				}
			
			SCREEN COORDINATES:C438($left; $top; $right; $bottom; $i; Screen size:K27:9)
			$screen.coordinates.left:=$left
			$screen.coordinates.top:=$top
			$screen.coordinates.right:=$right
			$screen.coordinates.bottom:=$bottom
			
			$screen.dimensions.width:=$right-$left
			$screen.dimensions.height:=$bottom-$top
			
			SCREEN COORDINATES:C438($left; $top; $right; $bottom; $i; Screen work area:K27:10)
			$screen.workArea.left:=$left
			$screen.workArea.top:=$top
			$screen.workArea.right:=$right
			$screen.workArea.bottom:=$bottom
			
			$screens.push($screen)
			
		End for 
		
		Use ($signal)
			
			$signal.mainScreenID:=Menu bar screen:C441  // On Windows, Menu bar screen always returns 1
			$signal.menuBarHeight:=Menu bar height:C440
			$signal.screens:=$screens.copy(ck shared:K85:29; $signal)
			$signal.toolBarHeight:=Tool bar height:C1016
			
		End use 
		
		//______________________________________________________
		
End case 

$signal.trigger()