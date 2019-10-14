//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : INSTALL
  // Created 24/09/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_OK)
C_LONGINT:C283($Lon_componentLoaded;$Lon_i;$Lon_index;$Lon_installed)
C_POINTER:C301($Ptr_component;$Ptr_sourceFolder;$Ptr_sourcePath)
C_TEXT:C284($Txt_componentName;$Txt_entryPoint;$Txt_sourceFolder;$Txt_sourcePath;$Txt_targetComponentFolder)

ARRAY TEXT:C222($tTxt_loadedComponents;0)

If (False:C215)
	C_TEXT:C284(INSTALL ;$1)
End if 

If (Count parameters:C259>0)
	
	$Txt_entryPoint:=$1
	
End if 

Case of 
		
		  //______________________________________________________
	: (Length:C16($Txt_entryPoint)=0)
		
		If (Method called on error:C704=Current method name:C684)
			
			(OBJECT Get pointer:C1124(Object named:K67:5;"error"))->:=ERROR
			
		Else 
			
			TRACE:C157
			
		End if 
		
		  //______________________________________________________
	: ($Txt_entryPoint="verify")
		
		COMPONENT LIST:C1001($tTxt_loadedComponents)
		
		Repeat 
			
			$Lon_index:=$Lon_index+1
			$Txt_sourcePath:=Get file from pasteboard:C976($Lon_index)
			
			If (Length:C16($Txt_sourcePath)>0)
				
				If ($Txt_sourcePath[[Length:C16($Txt_sourcePath)]]=Folder separator:K24:12)
					
					$Txt_sourcePath:=Substring:C12($Txt_sourcePath;1;Length:C16($Txt_sourcePath)-1)
					
				End if 
			End if 
			
			Case of 
					
					  //______________________________________________________
				: (Length:C16($Txt_sourcePath)=0)
					
					  //______________________________________________________
				: (Test path name:C476($Txt_sourcePath)#Is a folder:K24:2)
					
					  //______________________________________________________
				: ($Txt_sourcePath#"@.4dbase")
					
					  //______________________________________________________
				: (Test path name:C476($Txt_sourcePath+Folder separator:K24:12+"Resources"+Folder separator:K24:12+"4DPop.xml")#Is a document:K24:1)\
					 & (Test path name:C476($Txt_sourcePath+Folder separator:K24:12+"Extras"+Folder separator:K24:12+"4DPop.xml")#Is a document:K24:1)
					
					
					  //______________________________________________________
				Else 
					
					  //Get the Component folder name
					For ($Lon_i;Length:C16($Txt_sourcePath);1;-1)
						
						If ($Txt_sourcePath[[$Lon_i]]=Folder separator:K24:12)
							
							$Txt_sourceFolder:=Substring:C12($Txt_sourcePath;$Lon_i+1)
							$Lon_i:=0
							
						End if 
					End for 
					
					  //Get the Component name
					$Txt_componentName:=$Txt_sourceFolder
					
					For ($Lon_i;Length:C16($Txt_componentName);1;-1)
						
						If ($Txt_componentName[[$Lon_i]]=".")
							
							$Txt_componentName:=Substring:C12($Txt_componentName;1;$Lon_i-1)
							$Lon_i:=0
							
						End if 
					End for 
					
					$Ptr_component:=OBJECT Get pointer:C1124(Object named:K67:5;"ComponentName")
					$Ptr_sourceFolder:=OBJECT Get pointer:C1124(Object named:K67:5;"sourceFolder")
					$Ptr_sourcePath:=OBJECT Get pointer:C1124(Object named:K67:5;"sourcePath")
					
					If (Find in array:C230($tTxt_loadedComponents;$Txt_componentName)=-1)
						
						APPEND TO ARRAY:C911($Ptr_sourcePath->;$Txt_sourcePath)
						APPEND TO ARRAY:C911($Ptr_sourceFolder->;$Txt_sourceFolder)
						APPEND TO ARRAY:C911($Ptr_component->;$Txt_componentName)
						
					Else 
						
						$Lon_componentLoaded:=$Lon_componentLoaded+1
						
					End if 
					
					  //______________________________________________________
			End case 
		Until (Length:C16($Txt_sourcePath)=0)
		
		If (Size of array:C274($Ptr_component->)>0)
			
			FORM GOTO PAGE:C247(2)
			
		Else 
			
			If ($Lon_componentLoaded>0)
				
				(OBJECT Get pointer:C1124(Object named:K67:5;"errorMessage"))->:=Get localized string:C991("Error_2")
				
			Else 
				
				(OBJECT Get pointer:C1124(Object named:K67:5;"errorMessage"))->:=Get localized string:C991("Error_3")
				
			End if 
			
			FORM GOTO PAGE:C247(4)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_entryPoint="go")
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"error"))->:=0
		
		$Ptr_component:=OBJECT Get pointer:C1124(Object named:K67:5;"ComponentName")
		$Ptr_sourceFolder:=OBJECT Get pointer:C1124(Object named:K67:5;"sourceFolder")
		$Ptr_sourcePath:=OBJECT Get pointer:C1124(Object named:K67:5;"sourcePath")
		
		COMPONENT LIST:C1001($tTxt_loadedComponents)
		
		If ((OBJECT Get pointer:C1124(Object named:K67:5;"alldatabases"))->=1)
			
			$Txt_targetComponentFolder:=4DPop_applicationFolder (kComponents)
			
			  //create the folder if not exist
			CREATE FOLDER:C475($Txt_targetComponentFolder+"dummy";*)
			
		Else 
			
			$Txt_targetComponentFolder:=4DPop_hostDatabaseFolder (kComponents;True:C214)
			
		End if 
		
		$Boo_OK:=True:C214
		
		ON ERR CALL:C155(Current method name:C684)
		
		For ($Lon_i;1;Size of array:C274($Ptr_component->);1)
			
			If ((OBJECT Get pointer:C1124(Object named:K67:5;"alias"))->=1)
				
				CREATE ALIAS:C694($Ptr_sourcePath->{$Lon_i};$Txt_targetComponentFolder+$Ptr_sourceFolder->{$Lon_i})
				
			Else 
				
				  //#v14 
				COPY DOCUMENT:C541($Ptr_sourcePath->{$Lon_i}+Folder separator:K24:12;$Txt_targetComponentFolder)
				
			End if 
			
			If (OK=1)
				
				$Lon_installed:=$Lon_installed+1
				
			Else 
				
				$Boo_OK:=False:C215
				$Lon_i:=MAXINT:K35:1
				
			End if 
		End for 
		
		ON ERR CALL:C155("")
		
		If ($Boo_OK)
			
			If ($Lon_installed=1)
				
				(OBJECT Get pointer:C1124(Object named:K67:5;"message"))->:=Get localized string:C991("Comment_3_One")
				
			Else 
				
				(OBJECT Get pointer:C1124(Object named:K67:5;"message"))->:=\
					Replace string:C233(Get localized string:C991("Comment_3_More");"{number}";String:C10($Lon_installed))
				
			End if 
			
			FORM GOTO PAGE:C247(3)
			
		Else 
			
			If (Length:C16((OBJECT Get pointer:C1124(Object named:K67:5;"message"))->)=0)
				
				(OBJECT Get pointer:C1124(Object named:K67:5;"errorMessage"))->:=\
					Replace string:C233(Get localized string:C991("Error_1");"{Error}";\
					String:C10((OBJECT Get pointer:C1124(Object named:K67:5;"error"))->;"## ###;-## ###;unknown"))
				
			End if 
			
			FORM GOTO PAGE:C247(4)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_entryPoint="end")
		
		CANCEL:C270
		
		If ((OBJECT Get pointer:C1124(Object named:K67:5;"restart"))->=1)  //Restart the database
			
			OPEN DATA FILE:C312(Data file:C490)
			
		End if 
		
		  //______________________________________________________
	Else 
		
		TRACE:C157
		
		  //______________________________________________________
End case 