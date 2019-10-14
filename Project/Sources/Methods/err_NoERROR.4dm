//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : err_NoERROR
  // Created 11/12/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($1)

Case of 
		
		  //______________________________________________________
	: (Count parameters:C259=0)
		
		C_TEXT:C284(<>4DPop_CurrentMethodError)
		C_LONGINT:C283(<>4DPop_Error)
		
		<>4DPop_Error:=ERROR
		
		  //______________________________________________________
	: ($1="Init")
		
		<>4DPop_CurrentMethodError:=Method called on error:C704
		
		If (<>4DPop_CurrentMethodError#"err_NoERROR")
			
			ON ERR CALL:C155("err_NoERROR")
			
		End if 
		
		<>4DPop_Error:=0
		
		  //______________________________________________________
	: ($1="Deinit")
		
		ON ERR CALL:C155(<>4DPop_CurrentMethodError)
		<>4DPop_CurrentMethodError:=""
		
		  //______________________________________________________
End case 