//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : doc_gTxt_Resolve_Alias
  // Created 18/09/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)

C_TEXT:C284($Txt_path;$Txt_type)

If (False:C215)
	C_TEXT:C284(doc_gTxt_Resolve_Alias ;$0)
	C_TEXT:C284(doc_gTxt_Resolve_Alias ;$1)
End if 

If (Count parameters:C259>0)
	
	$0:=$1
	
	  // #3-10-2014
	  // it is no longer necessary to catch the error
	  //$Txt_currentErrorMethod:=Method called on error
	  //ON ERR CALL(Current method name)
	
	  //Mac OS - fkpa, Windows - lnk
	  //$Txt_type:=Document type($Txt_path)
	  //If ($Txt_type="fkpa") | ($Txt_type="lnk")
	
	RESOLVE ALIAS:C695($1;$Txt_path)
	
	If (OK=1)
		
		$0:=$Txt_path
		
	End if 
	
	  //End if
	
	  //ON ERR CALL($Txt_currentErrorMethod)
	
Else 
	
	  //No error
	
End if 