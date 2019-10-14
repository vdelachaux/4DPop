//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : 4DPop_preferenceDelete
  // ID[1AC7FCAE6BFB42D18CB9D8849D77B445]
  // Created 08/12/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_buffer;$Dom_preference;$Txt_path;$Txt_tool)

If (False:C215)
	C_BOOLEAN:C305(4DPop_preferenceDelete ;$0)
	C_TEXT:C284(4DPop_preferenceDelete ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	$Txt_tool:=$1
	
	$Txt_path:=4DPop_preferencePath 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Dom_preference:=DOM Parse XML source:C719($Txt_path)

If (OK=1)
	
	$Dom_buffer:=DOM Find XML element:C864($Dom_preference;"preference/"+$Txt_tool)
	
	If (OK=1)
		
		DOM REMOVE XML ELEMENT:C869($Dom_buffer)
		
	End if 
	
	DOM CLOSE XML:C722($Dom_preference)
	
End if 

$0:=(OK=1)

  // ----------------------------------------------------
  // End