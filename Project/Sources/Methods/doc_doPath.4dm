//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_doPath
  // ID[F7E8489BE4CD4209A335D95E65FD5F76]
  // Created 08/12/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_LONGINT:C283($1)
C_TEXT:C284(${2})

C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_type)
C_TEXT:C284($Txt_path)

If (False:C215)
	C_TEXT:C284(doc_doPath ;$0)
	C_LONGINT:C283(doc_doPath ;$1)
	C_TEXT:C284(doc_doPath ;${2})
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	$Lon_type:=$1
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For ($Lon_i;2;$Lon_parameters;1)
	
	$Txt_path:=$Txt_path+${$Lon_i}
	
	If ($Lon_i=$Lon_parameters)
		
		If ($Lon_type#Is a document:K24:1)
			
			$Txt_path:=$Txt_path+Folder separator:K24:12
			
		End if 
		
	Else 
		
		$Txt_path:=$Txt_path+Folder separator:K24:12
		
	End if 
	
End for 

$0:=$Txt_path
  // ----------------------------------------------------
  // End