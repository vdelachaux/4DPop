//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : 4DPop_applicationLanguage
  // ID[1F9BB1F797484240BE01467CFAE6A579]
  // Created 09/12/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Gives the 4D runtime language
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Txt_path)

If (False:C215)
	C_TEXT:C284(4DPop_applicationLanguage ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Txt_path:=4DPop_applicationFolder (kResources)

ARRAY TEXT:C222($tTxt_languages;0x0000)
ARRAY TEXT:C222($tTxt_folders;0x0000)

FOLDER LIST:C473($Txt_path;$tTxt_folders)
For ($Lon_i;1;Size of array:C274($tTxt_folders);1)
	
	If ($tTxt_folders{$Lon_i}="@.lproj")
		
		APPEND TO ARRAY:C911($tTxt_languages;$tTxt_folders{$Lon_i})
		
	End if 
	
End for 

If (Size of array:C274($tTxt_languages)>1)
	
	$tTxt_languages:=Find in array:C230($tTxt_languages;Substring:C12(Get database localization:C1009(User system localization:K5:23);1;2)+"@")
	
End if 

$0:=Replace string:C233($tTxt_languages{Choose:C955($tTxt_languages>0;$tTxt_languages;1)};".lproj";"")

  // ----------------------------------------------------
  // End 