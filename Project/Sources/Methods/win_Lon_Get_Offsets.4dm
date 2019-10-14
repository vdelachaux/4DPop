//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : win_Lon_Get_Offsets
  // Alias : zFF_Get_Offsets
  // Created 22/04/98 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // Retourne l'offset pour chaque type de fenêtre
  // ----------------------------------------------------
C_LONGINT:C283($0)
C_LONGINT:C283($1)
C_BOOLEAN:C305($2)

C_BOOLEAN:C305($Boo_Windows)
C_LONGINT:C283($Lon_dH;$Lon_dV;$Lon_Platform;$Lon_Type)

If (False:C215)
	C_LONGINT:C283(win_Lon_Get_Offsets ;$0)
	C_LONGINT:C283(win_Lon_Get_Offsets ;$1)
	C_BOOLEAN:C305(win_Lon_Get_Offsets ;$2)
End if 

_O_PLATFORM PROPERTIES:C365($Lon_Platform)
$Boo_Windows:=($Lon_Platform=Windows:K25:3)

$Lon_Type:=Window kind:C445

If (Count parameters:C259>=1)
	
	$Lon_Type:=$1
	
	If (Count parameters:C259>=2)
		
		$Boo_Windows:=$2
		
	End if 
End if 

$Lon_Type:=Abs:C99($1)  // Valeure absolue du type de fenêtre , offsets identiques pour les palettes

If ($Boo_Windows)  //Window
	
	Case of 
			
			  //__________________________________________________________________________________________
		: ($Lon_Type=Plain no zoom box window:K34:1)\
			 | ($Lon_Type=Plain window:K34:13)
			
			$Lon_dH:=6
			$Lon_dV:=28
			
			  //__________________________________________________________________________________________
		: ($Lon_Type=Plain fixed size window:K34:6)\
			 | ($Lon_Type=Round corner window:K34:8)\
			 | ($Lon_Type=Movable dialog box:K34:7)
			
			$Lon_dH:=6
			$Lon_dV:=27
			
			  //__________________________________________________________________________________________
		: ($Lon_Type=Modal dialog box:K34:2)
			
			$Lon_dH:=6
			$Lon_dV:=9
			
			  //__________________________________________________________________________________________
		: ($Lon_Type=Plain dialog box:K34:4)\
			 | ($Lon_Type=Alternate dialog box:K34:5)
			
			$Lon_dH:=4
			$Lon_dV:=6
			
			  //__________________________________________________________________________________________
		Else   // Palette flottante
			
			$Lon_dH:=3
			$Lon_dV:=20
			
			  //__________________________________________________________________________________________
	End case 
	
Else   // Macintosh
	
	Case of 
			
			  //__________________________________________________________________________________________
		: ($Lon_Type=Plain no zoom box window:K34:1)\
			 | ($Lon_Type=Plain fixed size window:K34:6)\
			 | ($Lon_Type=Plain window:K34:13)\
			 | ($Lon_Type=Round corner window:K34:8)
			
			$Lon_dH:=3
			$Lon_dV:=21
			
			  //__________________________________________________________________________________________
		: ($Lon_Type=Modal dialog box:K34:2)
			
			$Lon_dH:=10
			$Lon_dV:=10
			
			  //__________________________________________________________________________________________
		: ($Lon_Type=Plain dialog box:K34:4)\
			 | ($Lon_Type=Alternate dialog box:K34:5)
			
			$Lon_dH:=3
			$Lon_dV:=4
			
			  //__________________________________________________________________________________________
		: ($Lon_Type=Movable dialog box:K34:7)
			
			$Lon_dH:=8
			$Lon_dV:=25
			
			  //__________________________________________________________________________________________
		Else   // Palette flottante
			
			$Lon_dH:=3
			$Lon_dV:=13
			
			  //__________________________________________________________________________________________
	End case 
End if 

$0:=($Lon_dH << 16)+$Lon_dV