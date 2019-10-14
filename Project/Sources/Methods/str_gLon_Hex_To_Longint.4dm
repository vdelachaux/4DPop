//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : str_gLon_Hex_To_Longint
  // Alias zRes_Hex_en_décimal
  // Crée le 3/09/98 par Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // Return num from hexa string
  // ----------------------------------------------------
C_LONGINT:C283($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_ASCII;$Lon_End_i;$Lon_i)
C_REAL:C285($Num_Result)
C_TEXT:C284($Txt_Hexa)

If (False:C215)
	C_LONGINT:C283(str_gLon_Hex_To_Longint ;$0)
	C_TEXT:C284(str_gLon_Hex_To_Longint ;$1)
End if 

$Txt_Hexa:=Uppercase:C13($1)
$Lon_End_i:=Length:C16($Txt_Hexa)

For ($Lon_i;$Lon_End_i;1;-1)
	
	$Lon_ASCII:=Character code:C91($Txt_Hexa[[$Lon_i]])
	
	Case of 
			
			  //……………………………………………………………
		: (($Lon_ASCII>47) & ($Lon_ASCII<58))  //0..9
			
			$Num_Result:=$Num_Result+(($Lon_ASCII-48)*(16^($Lon_End_i-$Lon_i)))
			
			  //……………………………………………………………
		: (($Lon_ASCII>64) & ($Lon_ASCII<71))  //A..F
			
			$Num_Result:=$Num_Result+(($Lon_ASCII-55)*(16^($Lon_End_i-$Lon_i)))
			
			  //……………………………………………………………
		Else   //x or 0x from 4D or other character…
			
			  //…Stop it
			$Lon_i:=0
			
			  //……………………………………………………………
	End case 
End for 

$0:=Int:C8($Num_Result)