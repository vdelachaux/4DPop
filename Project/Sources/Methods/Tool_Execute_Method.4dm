//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : Tool_Execute_Method
  // Created 11/12/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (21/05/07)
  // - Pointer to the button as argument
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_BOOLEAN:C305($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_Firt_Error;$Lon_x)
C_POINTER:C301($Ptr_Nil;$Ptr_self)
C_TEXT:C284($Txt_method)

If (False:C215)
	C_BOOLEAN:C305(Tool_Execute_Method ;$0)
	C_TEXT:C284(Tool_Execute_Method ;$1)
End if 

If (Count parameters:C259>0)
	
	$Txt_method:=$1
	
	If (Length:C16($Txt_method)>0)
		
		$Lon_x:=Position:C15("(";$Txt_method)
		
		If ($Lon_x=0)
			
			err_NoERROR ("Init")
			
			$Ptr_self:=Self:C308
			
			If (Is nil pointer:C315($Ptr_self))
				
				EXECUTE METHOD:C1007($Txt_method;*;$Ptr_Nil)
				
			Else 
				
				EXECUTE METHOD:C1007($Txt_method;*;$Ptr_self)
				
			End if 
			
		Else 
			
			If ($Txt_method="@()")
				
				$Txt_method:=Replace string:C233($Txt_method;"()";"")
				
			End if 
			
			EXECUTE FORMULA:C63($Txt_method)
			
		End if 
		
		If (<>4DPop_Error#0)
			
			$Lon_Firt_Error:=<>4DPop_Error
			<>4DPop_Error:=0
			
			If ($Txt_method="@()")
				
				$Txt_method:=Replace string:C233($Txt_method;"()";"")
				
			End if 
			
			EXECUTE FORMULA:C63($Txt_method)
			
		End if 
		
		err_NoERROR ("Deinit")
		
		If (<>4DPop_Error#0)\
			 & ($Lon_Firt_Error=-10508)
			
			ALERT:C41(Replace string:C233(Get localized string:C991("AlertExecute");"{method}";$Txt_method))
			
		End if 
		
	Else 
		
		<>4DPop_Error:=-15002
		
	End if 
	
Else 
	
	<>4DPop_Error:=-15001
	
End if 

$0:=(<>4DPop_Error=0)