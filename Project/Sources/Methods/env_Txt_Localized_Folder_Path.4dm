//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : env_Txt_Localized_Folder_Path
  // Created 11/01/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_language;$Txt_localizedFolder;$Txt_resourceFolderPath)

If (False:C215)
	C_TEXT:C284(env_Txt_Localized_Folder_Path ;$0)
	C_TEXT:C284(env_Txt_Localized_Folder_Path ;$1)
	C_TEXT:C284(env_Txt_Localized_Folder_Path ;$2)
End if 

$Txt_language:=Get database localization:C1009
$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>0)
	
	$Txt_resourceFolderPath:=$1
	
	If ($Lon_parameters>1)
		
		$Txt_language:=$2
		
	End if 
	
Else 
	
	$Txt_resourceFolderPath:=Get 4D folder:C485(Current resources folder:K5:16)
	
End if 

Case of 
		
		  //______________________________________________________
	: (Position:C15("en";$Txt_language)=1)
		
		$Txt_localizedFolder:="English"
		
		If (Test path name:C476($Txt_resourceFolderPath+$Txt_localizedFolder+".lproj")#Is a folder:K24:2)
			
			$Txt_localizedFolder:="en"
			
		End if 
		
		  //______________________________________________________
	: (Position:C15("fr";$Txt_language)=1)
		
		$Txt_localizedFolder:="French"
		
		If (Test path name:C476($Txt_resourceFolderPath+$Txt_localizedFolder+".lproj")#Is a folder:K24:2)
			
			$Txt_localizedFolder:="fr"
			
		End if 
		
		  //______________________________________________________
	: (Position:C15("de";$Txt_language)=1)
		
		$Txt_localizedFolder:="German"
		
		If (Test path name:C476($Txt_resourceFolderPath+$Txt_localizedFolder+".lproj")#Is a folder:K24:2)
			
			$Txt_localizedFolder:="de"
			
		End if 
		
		  //______________________________________________________
	: (Position:C15("it";$Txt_language)=1)
		
		$Txt_localizedFolder:="Italian"
		
		If (Test path name:C476($Txt_resourceFolderPath+$Txt_localizedFolder+".lproj")#Is a folder:K24:2)
			
			$Txt_localizedFolder:="it"
			
		End if 
		
		  //______________________________________________________
	: (Position:C15("ja";$Txt_language)=1)
		
		$Txt_localizedFolder:="Japanese"
		
		If (Test path name:C476($Txt_resourceFolderPath+$Txt_localizedFolder+".lproj")#Is a folder:K24:2)
			
			$Txt_localizedFolder:="ja"
			
		End if 
		
		  //______________________________________________________
	: (Position:C15("es";$Txt_language)=1)
		
		$Txt_localizedFolder:="Spanish"
		
		If (Test path name:C476($Txt_resourceFolderPath+$Txt_localizedFolder+".lproj")#Is a folder:K24:2)
			
			$Txt_localizedFolder:="es"
			
		End if 
		
		  //______________________________________________________
	Else 
		
		$Txt_localizedFolder:="English"
		
		If (Test path name:C476($Txt_resourceFolderPath+$Txt_localizedFolder+".lproj")#Is a folder:K24:2)
			
			$Txt_localizedFolder:="en"
			
		End if 
		
		  //______________________________________________________
End case 

If (Length:C16($Txt_localizedFolder)>0)
	
	  //http://forums.4d.fr/Post/FR/8234238/0/0/ {
	If (Test path name:C476($Txt_resourceFolderPath+$Txt_localizedFolder+".lproj")#Is a folder:K24:2)
		
		  //The wanted language isn't available - Default is English
		$Txt_localizedFolder:="English"
		
		If (Test path name:C476($Txt_resourceFolderPath+$Txt_localizedFolder+".lproj")#Is a folder:K24:2)
			
			$Txt_localizedFolder:="en"
			
		End if 
	End if 
	  //}
	
	$Txt_resourceFolderPath:=$Txt_resourceFolderPath+$Txt_localizedFolder+".lproj"+Folder separator:K24:12
	
End if 

$0:=$Txt_resourceFolderPath