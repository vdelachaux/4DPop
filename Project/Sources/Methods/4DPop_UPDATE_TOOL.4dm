//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : 4DPop_ADD_TO_TOOL_MENU
  // Database: 4DPop
  // ID[C7B057C7FD954C4581D3721D4A60C729]
  // Created #6-6-2014 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_toolID)
C_OBJECT:C1216($Obj_message)

ARRAY TEXT:C222($tDom_nodes;0)

If (False:C215)
	C_TEXT:C284(4DPop_UPDATE_TOOL ;$1)
	C_OBJECT:C1216(4DPop_UPDATE_TOOL ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  //Required parameters
	  //$Txt_toolID:=$1
	  //$Obj_message:=$2  //xml description of the menu
	
	  //Optional parameters
	If ($Lon_parameters>=3)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
update_tool ($1;$2)

  // ----------------------------------------------------
  // Return
  //<NONE>
  // ----------------------------------------------------
  // End