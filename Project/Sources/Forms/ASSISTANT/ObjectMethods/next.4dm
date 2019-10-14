  // ----------------------------------------------------
  // Method : Méthode objet : Constant_Assistant.◊bContinue
  // Created 25/05/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_LONGINT:C283($Lon_currentPage)

$Lon_currentPage:=FORM Get current page:C276

(OBJECT Get pointer:C1124(Object named:K67:5;"targetPage"))->:=0

Case of 
		  //---------------------------
	: ($Lon_currentPage=1)
		
		INSTALL ("verify")
		
		  //---------------------------
	: ($Lon_currentPage=2)
		
		INSTALL ("go")
		
		  //---------------------------
	: ($Lon_currentPage=3)
		
		INSTALL ("end")
		
		  //---------------------------
	: ($Lon_currentPage=4)
		
		CANCEL:C270
		
		  //---------------------------
End case 

SET TIMER:C645(-1)
