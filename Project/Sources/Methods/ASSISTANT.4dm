//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : Assistant
  // Created 31/05/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_TEXT:C284($1)

C_LONGINT:C283($Lon_currentPage)
C_POINTER:C301($Ptr_targetPage)
C_TEXT:C284($Txt_entryPoint)

If (False:C215)
	C_TEXT:C284(ASSISTANT ;$1)
End if 

$Txt_entryPoint:=$1

$Lon_currentPage:=FORM Get current page:C276
$Ptr_targetPage:=OBJECT Get pointer:C1124(Object named:K67:5;"targetPage")

Case of 
		
		  //______________________________________________________
	: ($Txt_entryPoint="onTimer")
		
		SET TIMER:C645(0)
		
		Case of 
				
				  //……………………………………
			: ($Lon_currentPage=1)
				
				OBJECT SET TITLE:C194(*;"previous";Get localized string:C991("Escape"))
				OBJECT SET ENABLED:C1123(*;"previous";True:C214)
				OBJECT SET TITLE:C194(*;"next";Get localized string:C991("Continue"))
				
				  //……………………………………
			: ($Lon_currentPage=2)
				
				OBJECT SET TITLE:C194(*;"previous";Get localized string:C991("Return"))
				OBJECT SET ENABLED:C1123(*;"previous";True:C214)
				OBJECT SET TITLE:C194(*;"next";Get localized string:C991("Continue"))
				
				  //……………………………………
			: ($Lon_currentPage=3)
				
				OBJECT SET TITLE:C194(*;"previous";Get localized string:C991("Return"))
				OBJECT SET ENABLED:C1123(*;"previous";True:C214)
				OBJECT SET TITLE:C194(*;"next";Get localized string:C991("Finish"))
				
				  //……………………………………
			: ($Lon_currentPage=4)
				
				OBJECT SET TITLE:C194(*;"previous";Get localized string:C991("Return"))
				OBJECT SET ENABLED:C1123(*;"next";$Ptr_targetPage->#0)
				OBJECT SET TITLE:C194(*;"next";Get localized string:C991("Close"))
				
				  //……………………………………
		End case 
		
		GOTO OBJECT:C206(*;"")
		
		  //______________________________________________________
	: ($Txt_entryPoint="return")
		
		Case of 
				
				  //……………………………………
			: ($Lon_currentPage=1)
				
				CANCEL:C270
				
				  //……………………………………
			: ($Lon_currentPage=2)
				
				FORM GOTO PAGE:C247(1)
				
				  //……………………………………
			: ($Lon_currentPage=3)
				
				FORM GOTO PAGE:C247(2)
				
				  //……………………………………
			: ($Lon_currentPage=4)
				
				If ($Ptr_targetPage->#0)
					
					FORM GOTO PAGE:C247($Ptr_targetPage->)
					$Ptr_targetPage->:=0
					
				Else 
					
					CANCEL:C270
					
				End if 
				
				  //……………………………………
		End case 
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
End case 