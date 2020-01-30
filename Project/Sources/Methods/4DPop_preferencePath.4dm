//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : 4DPop_preferencePath
  // ID[43FABEB189454595A4E2C989E7F7386C]
  // Created 08/12/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)

C_LONGINT:C283($Lon_parameters;$Lon_version)
C_TEXT:C284($Dom_preferences;$Txt_buffer;$Txt_path;$Txt_pathOld;$Txt_version)

If (False:C215)
	C_TEXT:C284(4DPop_preferencePath ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
	$Txt_version:=Substring:C12(Application version:C493;1;2)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  //Get the path of current  4DPop preference's file
$Txt_path:=Preferences_Get_Path ("4dPop v"+$Txt_version+" preference.xml")

If (Test path name:C476($Txt_path)#Is a document:K24:1)
	
	  //The file doesn't exist: perhaps an older version is it available
	
	$Lon_version:=Num:C11($Txt_version)
	
	Case of 
			  //______________________________________________________
		: ($Lon_version=12)
			
			  //Just the name of the file change
			$Txt_pathOld:=Replace string:C233($Txt_path;"v12";"v11")
			
			If (Test path name:C476($Txt_pathOld)=Is a document:K24:1)
				
				COPY DOCUMENT:C541($Txt_pathOld;$Txt_path)
				
			End if 
			
			  //______________________________________________________
		: ($Lon_version=13)
			
			  //Location changed on Mac OS
			$Txt_pathOld:=Preferences_Get_Path ("4dPop v12 preference.xml";12)
			
			If (Test path name:C476($Txt_pathOld)=Is a document:K24:1)
				
				COPY DOCUMENT:C541($Txt_pathOld;$Txt_path)
				
			End if 
			
			  //______________________________________________________
		Else 
			
			  //______________________________________________________
	End case 
	
End if 

If (Test path name:C476($Txt_path)#Is a document:K24:1)
	
	  //Create a new one
	$Dom_preferences:=DOM Create XML Ref:C861("preference")
	XML SET OPTIONS:C1090($Dom_preferences;XML indentation:K45:34;XML with indentation:K45:35)
	
Else 
	
	$Dom_preferences:=DOM Parse XML source:C719($Txt_path)
	
	If (OK=1)
		
		DOM EXPORT TO VAR:C863($Dom_preferences;$Txt_buffer)
		DOM CLOSE XML:C722($Dom_preferences)
		
		$Txt_buffer:=Replace string:C233($Txt_buffer;"\r\n";"")
		$Txt_buffer:=Replace string:C233($Txt_buffer;"\n";"")
		$Txt_buffer:=Replace string:C233($Txt_buffer;"\r";"")
		
		$Dom_preferences:=DOM Parse XML variable:C720($Txt_buffer)
		
	End if 
	
End if 

If (OK=1)
	
	DOM EXPORT TO FILE:C862($Dom_preferences;$Txt_path)
	DOM CLOSE XML:C722($Dom_preferences)
	
End if 

$0:=$Txt_path

  // ----------------------------------------------------
  // End 