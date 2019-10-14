//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : 4DPop_preferenceStore
  // ID[65B64F8DBF4F43F2BF3CB8D5A08DEE4B]
  // Created 08/12/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_buffer;$Dom_node;$Dom_preference;$Txt_buffer;$Txt_path)
C_TEXT:C284($Txt_tool)

If (False:C215)
	C_BOOLEAN:C305(4DPop_preferenceStore ;$0)
	C_TEXT:C284(4DPop_preferenceStore ;$1)
	C_TEXT:C284(4DPop_preferenceStore ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	$Txt_tool:=$1
	$Dom_node:=$2
	
	$Txt_path:=4DPop_preferencePath 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Dom_preference:=DOM Parse XML source:C719($Txt_path)

If (OK=1)
	
	  //Delete the current node is any {
	$Dom_buffer:=DOM Find XML element:C864($Dom_preference;"preference/"+$Txt_tool)
	
	If (OK=1)
		
		DOM REMOVE XML ELEMENT:C869($Dom_buffer)
		
	End if   //}
	
	  //get the new node
	$Dom_node:=DOM Find XML element:C864($Dom_node;"preference/"+$Txt_tool)
	
	If (OK=1)
		
		  //copy the new node
		$Dom_buffer:=DOM Append XML element:C1082($Dom_preference;$Dom_node)
		
		  //Cleanup the file (remove the extra line feeds and carriage returns added by 4D)
		If (OK=1)
			
			DOM EXPORT TO VAR:C863($Dom_preference;$Txt_buffer)
			DOM CLOSE XML:C722($Dom_preference)
			
			$Txt_buffer:=Replace string:C233($Txt_buffer;"\r\n";"")
			$Txt_buffer:=Replace string:C233($Txt_buffer;"\n";"")
			$Txt_buffer:=Replace string:C233($Txt_buffer;"\r";"")
			$Txt_buffer:=Replace string:C233($Txt_buffer;"\t";"")
			
			While (Position:C15("  ";$Txt_buffer)>0)
				
				$Txt_buffer:=Replace string:C233($Txt_buffer;"  ";" ")
				
			End while 
			
			$Txt_buffer:=Replace string:C233($Txt_buffer;"> <";"><")
			
			$Dom_preference:=DOM Parse XML variable:C720($Txt_buffer)
			
			DOM EXPORT TO FILE:C862($Dom_preference;$Txt_path)
			
		End if 
	End if 
	
	DOM CLOSE XML:C722($Dom_preference)
	
End if 

$0:=(OK=1)

  // ----------------------------------------------------
  // End