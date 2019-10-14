  // ----------------------------------------------------
  // Method : Méthode formulaire : ASSISTANT
  // Created 25/05/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_LONGINT:C283($Lon_formEvent)

$Lon_formEvent:=Form event code:C388

Case of 
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"targetPage"))->:=1
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"alias"))->:=1
		(OBJECT Get pointer:C1124(Object named:K67:5;"alldatabases"))->:=1
		(OBJECT Get pointer:C1124(Object named:K67:5;"restart"))->:=1
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		SET TIMER:C645(0)
		
		ASSISTANT ("onTimer")
		
		  //______________________________________________________
End case 

