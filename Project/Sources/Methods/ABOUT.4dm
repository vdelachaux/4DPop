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

C_LONGINT:C283($Lon_height;$Lon_width;$Win_hdl)
C_PICTURE:C286($p)
C_TEXT:C284($t;$Txt_build;$Txt_entrypoint)
C_OBJECT:C1216($file;$o)

If (False:C215)
	C_TEXT:C284(ABOUT ;$1)
	C_OBJECT:C1216(ABOUT ;$2)
End if 

If (Count parameters:C259>=1)
	
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
		
		LISTBOX SET ROWS HEIGHT:C835(*;"about";64;lk pixels:K53:22)
		
		  // Create a line for each 4DPop component
		For each ($o;Form:C1466.widgets)
			
			$t:=String:C10($o.plist.CFBundleDisplayName)
			
			  //$t:=Choose(Length($t)>0;$t;$o.name)
			$t:=Choose:C955(Length:C16($t)>0;$t;$o.file.name)
			
			If (Length:C16(String:C10($o.plist.CFBundleShortVersionString))>0)
				
				$t:=$t+"\rv"+String:C10($o.plist.CFBundleShortVersionString)
				
				If (Length:C16(String:C10($o.plist.CFBundleVersion))>0)
					
					$t:=$t+" build "+String:C10($o.plist.CFBundleVersion)
					
				End if 
			End if 
			
			$o.infos:=$t
			$o.copyright:=String:C10($o.plist.NSHumanReadableCopyright)
			
			$file:=$o.file.file("Resources/4DPop_About.png")
			
			If ($file.exists)
				
				READ PICTURE FILE:C678($file.platformPath;$p)
				
				If (OK=1)
					
					CREATE THUMBNAIL:C679($p;$p;48)
					
				End if 
				
			Else 
				
				$t:=String:C10($o.manifest.tools.picture)
				
				If (Length:C16($t)>0)
					
					$file:=$o.file.file("Resources/"+$t)
					
					If ($file.exists)
						
						READ PICTURE FILE:C678($file.platformPath;$p)
						
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
			
			$o.picture:=$p
			
		End for each 
		
		  // #12-12-2013 - Dont forget 4DPop ;-)
		Form:C1466.me:=New object:C1471(\
			"copyright";"")
		
		READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"4DPop.png";$p)
		
		If (OK=1)
			
			PICTURE PROPERTIES:C457($p;$Lon_width;$Lon_height)
			
			If ($Lon_height<($Lon_width*4))
				
				CREATE THUMBNAIL:C679($p;$p;48)
				
			Else 
				
				TRANSFORM PICTURE:C988($p;Crop:K61:7;0;0;32;32)
				
			End if 
		End if 
		
		Form:C1466.me.picture:=$p
		
		$o:=plist 
		
		If ($o.success)
			
			$t:=$o.get("CFBundleDisplayName";True:C214)+"\rv"+$o.get("CFBundleShortVersionString";True:C214)
			$Txt_build:=$o.get("CFBundleVersion";True:C214)
			
			If (Length:C16($Txt_build)>0)
				
				$t:=$t+" build "+$Txt_build
				
			End if 
			
			Form:C1466.me.copyright:=$o.get("NSHumanReadableCopyright")
			
		Else 
			
			$t:=File:C1566(Structure file:C489;fk platform path:K87:2).name
			
		End if 
		
		Form:C1466.me.infos:=$t
		
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