//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : 4DPop_applicationFolder
  // ID[6EF82DDAEEDB4E42B62C55D363E25483]
  // Created 09/12/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Public method.
  // txt := 4DPop_applicationFolder ( {selector} )
  // Provides some useful pathnames for the current application according to the parameter $1.
  //           - Components | Plugins | Resources = path for that folder
  //           - Localized =  current language folder
  //           - omitted = Mac: "contents" folder. PC: parent folder of the exe
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_LONGINT:C283($1)

C_LONGINT:C283($Lon_folder;$i;$Lon_parameters)
C_TEXT:C284($Txt_path)

If (False:C215)
	C_TEXT:C284(4DPop_applicationFolder ;$0)
	C_LONGINT:C283(4DPop_applicationFolder ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	If ($Lon_parameters>=1)
		
		$Lon_folder:=$1
		
	End if 
	
	$Txt_path:=Application file:C491
	
	If (Is Windows:C1573)
		
		  //Get Parent path
		For ($i;Length:C16($Txt_path);1;-1)
			
			If ($Txt_path[[$i]]=Folder separator:K24:12)
				
				$Txt_path:=Substring:C12($Txt_path;1;$i)
				$i:=0
				
			End if 
			
		End for 
		
	Else 
		
		  //Get Content path
		$Txt_path:=$Txt_path+Folder separator:K24:12+"Contents"+Folder separator:K24:12
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		  //______________________________________________________
	: ($Lon_folder=kRoot)
		
		  //Nothing more to do
		
		  //______________________________________________________
	: ($Lon_folder=kComponents)
		
		$Txt_Path:=$Txt_Path+"Components"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($Lon_folder=kPlugins)
		
		$Txt_Path:=$Txt_Path+"Plugins"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($Lon_folder=kResources)
		
		$Txt_Path:=$Txt_Path+"Resources"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($Lon_folder=kLanguage)
		
		$Txt_Path:=$Txt_Path+"Resources"+Folder separator:K24:12
		
		ARRAY TEXT:C222($tTxt_languages;0x0000)
		ARRAY TEXT:C222($tTxt_folders;0x0000)
		
		FOLDER LIST:C473($Txt_path;$tTxt_folders)
		For ($i;1;Size of array:C274($tTxt_folders);1)
			
			If ($tTxt_folders{$i}="@.lproj")
				
				APPEND TO ARRAY:C911($tTxt_languages;$tTxt_folders{$i})
				
			End if 
			
		End for 
		
		If (Size of array:C274($tTxt_languages)=1)
			
			$tTxt_languages:=1
			
		Else 
			
			$tTxt_languages:=Find in array:C230($tTxt_languages;Substring:C12(Get database localization:C1009(User system localization:K5:23);1;2)+"@")
			
		End if 
		
		$Txt_Path:=$Txt_Path+$tTxt_languages{Choose:C955($tTxt_languages>0;$tTxt_languages;1)}+Folder separator:K24:12
		
		  //______________________________________________________
	Else 
		
		CLEAR VARIABLE:C89($Txt_Path)
		ASSERT:C1129(False:C215;"Unknown constant value: \""+String:C10($Lon_folder)+"\"")
		
		  //______________________________________________________
End case 

$0:=$Txt_path

  // ----------------------------------------------------
  // End 