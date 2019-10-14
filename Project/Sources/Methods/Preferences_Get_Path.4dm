//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : Preferences_Get_Path
  // Created 18/03/08 by Vincent de Lachaux
  // ----------------------------------------------------
  // v11.2 4D folder moved : Try to get file from old place
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_LONGINT:C283($2)

C_LONGINT:C283($Lon_currentVersion;$Lon_i;$Lon_platform;$Lon_system;$Lon_wantedVersion)
C_LONGINT:C283($Lon_x)
C_TEXT:C284($Txt_buffer;$Txt_new;$Txt_old;$Txt_oldPath;$Txt_parentPath)
C_TEXT:C284($Txt_path;$Txt_target)

If (False:C215)
	C_TEXT:C284(Preferences_Get_Path ;$0)
	C_TEXT:C284(Preferences_Get_Path ;$1)
	C_LONGINT:C283(Preferences_Get_Path ;$2)
End if 

$Txt_path:=Get 4D folder:C485(Active 4D Folder:K5:10)

$Txt_target:=Replace string:C233($1;"/";Folder separator:K24:12)

$Txt_path:=$Txt_path+$Txt_target

If (Test path name:C476($Txt_path)#Is a document:K24:1)
	
	_O_PLATFORM PROPERTIES:C365($Lon_platform;$Lon_system)
	
	$Lon_currentVersion:=Num:C11(Substring:C12(Application version:C493;1;2))
	
	If (Count parameters:C259>=2)
		
		  //The method return the standard path for the version wanted by user
		$Lon_wantedVersion:=$2
		
	Else 
		
		  //The method return the standard path for the current version
		  //and tries to load file from an older path
		$Lon_wantedVersion:=$Lon_currentVersion
		
	End if 
	
	Case of 
			
			  //----------------------------------------------------
		: ($Lon_platform=Mac OS:K25:2)  //OSX
			
			Case of 
					
					  //______________________________________________________
				: ($Lon_currentVersion=12)
					
					  //**********************************
					  //Get from "/library/application support/4D/" or "/users/{user_name}/library/application support/4D/"
					  //**********************************
					
					$Txt_old:="Application Support"
					$Txt_new:="Preferences"
					
					  //______________________________________________________
				: ($Lon_currentVersion=13)
					
					  //**********************************
					  //Get from "/library/Preferences/4D/" or "/users/{user_name}/library/Preferences/4D/"
					  //**********************************
					
					$Txt_old:="Preferences"
					$Txt_new:="Application Support"
					
					  //______________________________________________________
				: ($Lon_currentVersion=14)
					
					  //**********************************
					  //Get from "/library/Preferences/4D/" or "/users/{user_name}/library/Preferences/4D/"
					  //**********************************
					
					$Txt_old:="Preferences"
					$Txt_new:="Application Support"
					
					  //______________________________________________________
				: ($Lon_currentVersion=15)
					
					  //**********************************
					  //Get from "/library/Preferences/4D/" or "/users/{user_name}/library/Preferences/4D/"
					  //**********************************
					
					$Txt_old:="Preferences"
					$Txt_new:="Application Support"
					
					  //______________________________________________________
				Else 
					
					TRACE:C157
					
					  //______________________________________________________
			End case 
			
			$Txt_oldPath:=doc_doPath (Is a document:K24:1;Replace string:C233(System folder:C487(User preferences_user:K41:4);$Txt_new;$Txt_old)+"4D";$Txt_target)
			
			If ($Lon_wantedVersion=$Lon_currentVersion)
				
				If (Test path name:C476($Txt_oldPath)#Is a document:K24:1)
					
					$Txt_oldPath:=doc_doPath (Is a document:K24:1;Replace string:C233(System folder:C487(User preferences_all:K41:3);$Txt_new;$Txt_old)+"4D";$Txt_target)
					
				End if 
			End if 
			
			  //----------------------------------------------------
		: (($Lon_system%256)=7)  //Seven
			
			  //**********************************
			  //Get from "C:\ProgramData\4D\"
			  //**********************************
			
			$Txt_oldPath:=doc_doPath (Is a document:K24:1;System folder:C487(User preferences_all:K41:3)+"4D";$Txt_target)
			
			  // ----------------------------------------------------
		: (($Lon_system%256)=6)  //Vista
			
			  //**********************************
			  //Get from "C:\ProgramData\4D\"
			  //**********************************
			
			$Txt_oldPath:=doc_doPath (Is a document:K24:1;System folder:C487(User preferences_all:K41:3)+"4D";$Txt_target)
			
			  //----------------------------------------------------
		: (($Lon_system%256)=5) & ((($Lon_system\256)%256)#0)  //XP
			
			  //**********************************
			  //Get from "C:\Documents and Settings\All Users\Application Data\4D\"
			  //**********************************
			
			$Txt_oldPath:=doc_doPath (Is a document:K24:1;System folder:C487(User preferences_all:K41:3)+"All Users";"Application Data";"4D";$Txt_target)
			
			  //----------------------------------------------------
	End case 
	
	If ($Lon_wantedVersion#$Lon_currentVersion)
		
		$Txt_path:=$Txt_oldPath
		
	Else 
		
		If (Test path name:C476($Txt_oldPath)=Is a document:K24:1)
			
			  //Get Parent path....
			For ($Lon_i;Length:C16($Txt_path);1;-1)
				
				If ($Txt_path[[$Lon_i]]=Folder separator:K24:12)
					
					$Txt_parentPath:=Substring:C12($Txt_path;1;$Lon_i)
					$Lon_i:=0
					
				End if 
			End for 
			
			  //Create parent path hierarchy if necessary
			$Lon_x:=Position:C15(Folder separator:K24:12;$Txt_parentPath;3)
			
			Repeat 
				
				If ($Lon_x>0)
					
					$Txt_buffer:=Substring:C12($Txt_parentPath;1;$Lon_x)
					
					If (Test path name:C476($Txt_buffer)#Is a folder:K24:2)
						
						CREATE FOLDER:C475($Txt_buffer)
						
					End if 
				End if 
				
				$Lon_x:=Position:C15(Folder separator:K24:12;$Txt_parentPath;$Lon_x+1)
				
			Until ($Lon_x=0) | (OK=0)
			
			If (OK=1)
				
				COPY DOCUMENT:C541($Txt_oldPath;$Txt_path)
				
			End if 
		End if 
	End if 
End if 

$0:=$Txt_path