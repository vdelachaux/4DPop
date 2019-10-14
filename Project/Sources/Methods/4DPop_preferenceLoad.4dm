//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : 4DPop_preferenceLoad
  // ID[74729CCEC9AC414BB1DE2CAE7D51CC5A]
  // Created 08/12/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_node;$Dom_preference;$Dom_root;$Dom_tool;$Txt_buffer)
C_TEXT:C284($Txt_path;$Txt_tool)

If (False:C215)
	C_TEXT:C284(4DPop_preferenceLoad ;$0)
	C_TEXT:C284(4DPop_preferenceLoad ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Txt_tool:=$1
	$Txt_path:=4DPop_preferencePath 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

$Dom_preference:=DOM Parse XML source:C719($Txt_path)

If (OK=1)
	
	$Dom_node:=DOM Find XML element:C864($Dom_preference;"preference/"+$Txt_tool)
	
	If (OK=0)
		
		$Dom_node:=DOM Create XML element:C865($Dom_preference;"preference/"+$Txt_tool)
		
	End if 
End if 

If (OK=1)
	
	$Dom_root:=DOM Create XML Ref:C861("preference")
	
	If (OK=1)
		
		XML SET OPTIONS:C1090($Dom_root;XML indentation:K45:34;XML no indentation:K45:36)
		
		If (OK=1)
			
			$Dom_tool:=DOM Append XML element:C1082($Dom_root;$Dom_node)
			
			If (OK=1)
				
				DOM EXPORT TO VAR:C863($Dom_root;$Txt_buffer)
				
				$Txt_buffer:=Replace string:C233($Txt_buffer;"\r\n";"")
				$Txt_buffer:=Replace string:C233($Txt_buffer;"\n";"")
				$Txt_buffer:=Replace string:C233($Txt_buffer;"\r";"")
				
			End if 
		End if 
		
		DOM CLOSE XML:C722($Dom_root)
		
	End if 
	
	DOM CLOSE XML:C722($Dom_preference)
	
End if 

$0:=$Txt_buffer

  // ----------------------------------------------------
  // End