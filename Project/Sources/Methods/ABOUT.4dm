//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : ABOUT
  // Created 21/10/08 by vdl
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (12/01/13)
  // v14 refactoring
  // ----------------------------------------------------
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_height;$Lon_parameters;$Lon_width;$Win_hdl)
C_PICTURE:C286($p)
C_POINTER:C301($Ptr_component;$Ptr_infos;$Ptr_picture)
C_TEXT:C284($t;$Txt_build;$Txt_displayName;$Txt_entrypoint;$Txt_getInfoString;$Txt_shortVersionString)
C_TEXT:C284($Txt_toolName)
C_OBJECT:C1216($file;$o;$o;$Path_file)

If (False:C215)
	C_TEXT:C284(ABOUT ;$1)
	C_OBJECT:C1216(ABOUT ;$2)
End if 

$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>=1)
	
	$Txt_entrypoint:=$1
	
End if 

Case of 
		
		  //___________________________________________________________
	: (Length:C16($Txt_entrypoint)=0)
		
		Case of 
				
				  //……………………………………………………………………
			: (Method called on error:C704=Current method name:C684)
				
				  // Error managemnt routine
				
				  //……………………………………………………………………
			Else 
				
				  // This method must be executed in a new process
				BRING TO FRONT:C326(New process:C317(Current method name:C684;0;"$4DPop_About";"_run";$2;*))
				
				  //……………………………………………………………………
		End case 
		
		  //___________________________________________________________
	: ($Txt_entrypoint="_run")
		
		  // First launch of this method executed in a new process
		ABOUT ("_declarations")
		ABOUT ("_init")
		
		$Win_hdl:=Open form window:C675("ABOUT";Movable form dialog box:K39:8;Horizontally centered:K39:1;Vertically centered:K39:4)
		DIALOG:C40("ABOUT";$2)
		CLOSE WINDOW:C154
		
		ABOUT ("_deinit")
		
		  //___________________________________________________________
	: ($Txt_entrypoint="list")
		
		$Ptr_picture:=OBJECT Get pointer:C1124(Object named:K67:5;"pictures")
		$Ptr_component:=OBJECT Get pointer:C1124(Object named:K67:5;"components")
		$Ptr_infos:=OBJECT Get pointer:C1124(Object named:K67:5;"infos")
		
		  // Create a line for each 4DPop component
		For each ($o;Form:C1466.widgets)
			
			$Txt_displayName:=String:C10($o.plist.CFBundleDisplayName)
			
			$Txt_displayName:=Choose:C955(Length:C16($Txt_displayName)>0;$Txt_displayName;$Txt_toolName)
			
			If (Length:C16(String:C10($o.plist.CFBundleShortVersionString))>0)
				
				$Txt_displayName:=$Txt_displayName+"\rv"+String:C10($o.plist.CFBundleShortVersionString)
				
				If (Length:C16(String:C10($o.plist.CFBundleVersion))>0)
					
					$Txt_displayName:=$Txt_displayName+" build "+String:C10($o.plist.CFBundleVersion)
					
				End if 
			End if 
			
			APPEND TO ARRAY:C911($Ptr_component->;$Txt_displayName)
			APPEND TO ARRAY:C911($Ptr_infos->;String:C10($o.plist.NSHumanReadableCopyright))
			
			$file:=$o.file.file("Resources/4DPop_About.png")
			
			If ($file.exists)
				
				READ PICTURE FILE:C678($file.platformPath;$p)
				
				If (OK=1)
					
					CREATE THUMBNAIL:C679($p;$p;48)
					
				End if 
				
			Else 
				
				$t:=String:C10($o.manifest.tools.picture)
				
				If (Length:C16($t)>0)
					
					$Path_file:=$o.file.file("Resources/"+$t)
					
					If ($Path_file.exists)
						
						READ PICTURE FILE:C678($Path_file.platformPath;$p)
						
						If (OK=1)
							
							PICTURE PROPERTIES:C457($p;$Lon_width;$Lon_height)
							
							If ($Lon_height<($Lon_width*4))
								
								CREATE THUMBNAIL:C679($p;$p;48)
								
							Else 
								
								TRANSFORM PICTURE:C988($p;Crop:K61:7;0;0;32;32)
								
							End if 
						End if 
					End if 
				End if 
			End if 
			
			If (Picture size:C356($p)=0)
				
				READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"generic.png";$p)
				
			End if 
			
			APPEND TO ARRAY:C911($Ptr_picture->;$p)
			
		End for each 
		
		  // #12-12-2013 - Dont forget 4DPop ;-)
		READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"4DPop.png";$p)
		
		If (OK=1)
			
			PICTURE PROPERTIES:C457($p;$Lon_width;$Lon_height)
			
			If ($Lon_height<($Lon_width*4))
				
				CREATE THUMBNAIL:C679($p;$p;48)
				
			Else 
				
				TRANSFORM PICTURE:C988($p;Crop:K61:7;0;0;32;32)
				
			End if 
		End if 
		
		INSERT IN ARRAY:C227($Ptr_picture->;1;1)
		INSERT IN ARRAY:C227($Ptr_component->;1;1)
		INSERT IN ARRAY:C227($Ptr_infos->;1;1)
		
		$Ptr_picture->{1}:=$p
		
		$o:=plist 
		
		If ($o.success)
			
			$Txt_displayName:=$o.get("CFBundleDisplayName";True:C214)+"\rv"+$o.get("CFBundleShortVersionString";True:C214)
			$Txt_build:=$o.get("CFBundleVersion";True:C214)
			
			If (Length:C16($Txt_build)>0)
				
				$Txt_displayName:=$Txt_displayName+" build "+$Txt_build
				
			End if 
			
			$Ptr_infos->{1}:=$o.get("NSHumanReadableCopyright")
			
		Else 
			
			$Txt_displayName:=File:C1566(Structure file:C489;fk platform path:K87:2).name
			
		End if 
		
		$Ptr_component->{1}:=$Txt_displayName
		
		  //___________________________________________________________
	: ($Txt_entrypoint="_declarations")
		
		  //___________________________________________________________
	: ($Txt_entrypoint="_init")
		
		  //___________________________________________________________
	: ($Txt_entrypoint="_deinit")
		
		  //___________________________________________________________
	Else 
		
		TRACE:C157
		
		  //___________________________________________________________
End case 