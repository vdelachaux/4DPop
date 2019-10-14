//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : 4DPop_hostDatabaseFolder
  // ID[B3E5F09DC76D4EC285528B38C3B76E6C]
  // Created 09/12/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Public method.
  // txt := 4DPop_hostDatabaseFolder ( {selector { create }} )
  // Provides some useful pathnames for the host database according to the parameter $1.
  //           - Components | Plugins | Resources | Preferences |  Logs = path for that folder
  //           - Localized =  current language folder
  //           - omitted = Parent folder of the structure file
  // If 'creation' is true, the folder is created if not exist
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_LONGINT:C283($1)
C_BOOLEAN:C305($2)

C_BOOLEAN:C305($Boo_create;$Boo_remote)
C_LONGINT:C283($Lon_folder;$Lon_i;$Lon_parameters;$Lon_platform)
C_TEXT:C284($Txt_buffer;$Txt_language;$Txt_Path)

If (False:C215)
	C_TEXT:C284(4DPop_hostDatabaseFolder ;$0)
	C_LONGINT:C283(4DPop_hostDatabaseFolder ;$1)
	C_BOOLEAN:C305(4DPop_hostDatabaseFolder ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	If ($Lon_parameters>=1)
		
		$Lon_folder:=$1
		
		If ($Lon_parameters>=2)
			
			$Boo_create:=$2
			
		End if 
		
	End if 
	
	$Boo_remote:=(Application type:C494=4D Remote mode:K5:5)
	
	If ($Boo_remote)
		
		$Txt_Path:=Get 4D folder:C485(3;*)  //4D Client Database Folder (missing constante)
		
	Else 
		
		$Txt_Path:=Get 4D folder:C485(Database folder:K5:14;*)
		
	End if 
	
	_O_PLATFORM PROPERTIES:C365($Lon_platform)
	
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
	: ($Lon_folder=kPreferences)
		
		$Txt_Path:=$Txt_Path+"Preferences"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($Lon_folder=kResources)
		
		$Txt_Path:=$Txt_Path+"Resources"+Folder separator:K24:12
		
		  //______________________________________________________
	: ($Lon_folder=kLanguage)
		
		$Txt_language:=Get database localization:C1009(User system localization:K5:23)
		
		$Txt_Path:=$Txt_Path+"Resources"+Folder separator:K24:12
		
		ARRAY TEXT:C222($tTxt_languages;0x0000)
		ARRAY TEXT:C222($tTxt_folders;0x0000)
		FOLDER LIST:C473($Txt_path;$tTxt_folders)
		For ($Lon_i;1;Size of array:C274($tTxt_folders);1)
			
			If ($tTxt_folders{$Lon_i}="@.lproj")
				
				APPEND TO ARRAY:C911($tTxt_languages;$tTxt_folders{$Lon_i})
				
			End if 
			
		End for 
		
		If (Size of array:C274($tTxt_languages)=0)
			
			APPEND TO ARRAY:C911($tTxt_languages;4DPop_applicationLanguage )
			
		End if 
		
		If (Size of array:C274($tTxt_languages)=1)
			
			$tTxt_languages:=1
			
		Else 
			
			$Txt_buffer:=Substring:C12(Get database localization:C1009(User system localization:K5:23);1;2)
			$tTxt_languages:=Find in array:C230($tTxt_languages;$Txt_buffer+"@")
			
			If ($tTxt_languages<0)
				  //perhaps an older norme
				
				Case of 
						  //______________________
					: ($Txt_buffer="us")
						$Txt_buffer:="English"
						  //______________________
					: ($Txt_buffer="de")
						$Txt_buffer:="German"
						  //______________________
					: ($Txt_buffer="es")
						$Txt_buffer:="Spanish"
						  //______________________
				End case 
				
				$tTxt_languages:=Find in array:C230($tTxt_languages;$Txt_buffer+"@")
				
			End if 
		End if 
		
		$Txt_Path:=$Txt_Path+$tTxt_languages{Choose:C955($tTxt_languages>0;$tTxt_languages;1)}+Folder separator:K24:12
		
		  //______________________________________________________
	: ($Boo_remote)
		
		CLEAR VARIABLE:C89($Txt_Path)
		ASSERT:C1129(False:C215;"Invalid constant value in remote mode: \""+String:C10($Lon_folder)+"\"")
		
		  //______________________________________________________
	: ($Lon_folder=kLogs)
		
		$Txt_Path:=$Txt_Path+"Logs"+Folder separator:K24:12
		
		  //______________________________________________________
	Else 
		
		CLEAR VARIABLE:C89($Txt_Path)
		ASSERT:C1129(False:C215;"Unknown constant value: \""+String:C10($Lon_folder)+"\"")
		
		  //______________________________________________________
End case 

If ($Boo_create) & (Length:C16($Txt_Path)>0)
	
	CREATE FOLDER:C475($Txt_Path+"dummy";*)
	
End if 

$0:=$Txt_path

  // ----------------------------------------------------
  // End