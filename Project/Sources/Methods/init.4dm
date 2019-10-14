//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : init
  // Created 01/12/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by vdl (21/05/07)
  // On drop
  // ----------------------------------------------------
  // Modified by vdl (01/04/08)
  // C/S compatibility
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (15/05/09)
  // v12 - Add component folder next application
  // ----------------------------------------------------
  // Description
  // Initialize the compatible components list and their attributes
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
  // Modified #9-6-2014 by Vincent de Lachaux
  // management id
  // ----------------------------------------------------
C_OBJECT:C1216($0)

C_LONGINT:C283($Lon_bottom;$Lon_height;$Lon_left;$Lon_right;$Lon_top;$Lon_version)
C_LONGINT:C283($Lon_width)
C_PICTURE:C286($p;$pp)
C_TEXT:C284($t;$Txt_buffer;$Txt_key;$Txt_tool)
C_OBJECT:C1216($file;$Dir_localized;$o;$Obj_database;$Obj_form;$Obj_manifest)
C_OBJECT:C1216($Obj_tool;$Obj_widget;$oo)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(init ;$0)
End if 

  // Update version {
_o_PREFERENCES ("version.get";->$Lon_version)

Case of 
		
		  //______________________________________________________
	: ($Lon_version<13)
		
		$Txt_buffer:="Default"
		_o_PREFERENCES ("Skin.set";->$Txt_buffer)
		
		$Lon_version:=13
		_o_PREFERENCES ("version.set";->$Lon_version)
		
		  //______________________________________________________
	: ($Lon_version<14)
		
		$Txt_buffer:="Flat"
		_o_PREFERENCES ("Skin.set";->$Txt_buffer)
		
		$Lon_version:=14
		_o_PREFERENCES ("version.set";->$Lon_version)
		
		  //______________________________________________________
End case   //}

$Obj_form:=New object:C1471(\
"leftOffset";20;\
"rightOffset";10;\
"offset";10+20;\
"cellWidth";66;\
"iconSize";48;\
"event";0;\
"default";New object:C1471("title";1;"icon";1;"style";3);\
"language";Get database localization:C1009;\
"mdi";Is Windows:C1573;\
"process";Current process:C322;\
"hidden";True:C214;\
"widgets";New collection:C1472;\
"window";Open window:C153($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;-(Plain dialog box:K34:4+Texture appearance:K34:17+_o_Compositing mode:K34:18)))

$c:=New collection:C1472

$Obj_database:=database 

If ($Obj_database.components.length>0)
	
	  // Get the application Components
	$c:=loadComponents (Folder:C1567(4DPop_applicationFolder (kComponents);fk platform path:K87:2)).combine($c)
	
	  // Get the database Components
	$c:=loadComponents (Folder:C1567(4DPop_hostDatabaseFolder (kComponents);fk platform path:K87:2)).combine($c)
	
	If (Application type:C494=4D Remote mode:K5:5)
		
		  // Get the 4D Server components distributed to the client
		$c:=loadComponents (Folder:C1567(4DPop_hostDatabaseFolder +"4D"+Folder separator:K24:12+"Components"+Folder separator:K24:12;fk platform path:K87:2)).combine($c)
		
	End if 
End if 

If ($c.length>0)
	
	For each ($o;$c)
		
		If ($o.name#$Obj_database.name)  // Not me ;-)
			
			  // Always resolve alias
			$o:=$o.original
			
			If ($o.isFile)  // Project
				
				$o:=$o.parent.parent
				
			End if 
			
			  // Get the definition file
			$file:=$o.file("Resources/4DPop.xml")
			
			If (Not:C34($file.exists))
				
				  // Compatibility for old components
				$file:=$o.file("Extras/4DPop.xml")
				
			End if 
			
			If ($file.exists)
				
				  // Load the definition
				$Obj_manifest:=xml ("load";$file).toObject()
				
				$Obj_widget:=New object:C1471(\
					"file";$o;\
					"name";"";\
					"icon";Null:C1517;\
					"helptip";"";\
					"default";"";\
					"popup";False:C215;\
					"tool";New collection:C1472;\
					"help";$o.file($o.name+".html");\
					"manifest";$Obj_manifest)
				
				  // Localization folder
				$Dir_localized:=$o.folder("Resources/"+$Obj_form.language+".lproj")
				
				For each ($Txt_key;$Obj_manifest.tools)
					
					Case of 
							
							  //______________________________________________________
						: ($Txt_key="popup")
							
							$Obj_widget.popup:=Bool:C1537($Obj_manifest.tools.popup)
							
							  //______________________________________________________
						: ($Txt_key="name")
							
							$t:=String:C10($Obj_manifest.tools.name)
							
							If (Length:C16($t)>0)
								
								If (Position:C15(":xliff:";$t)=1)  // Localised
									
									If ($Dir_localized.exists)
										
										$Obj_widget.name:=xliff_getString (Delete string:C232($t;1;7);$Dir_localized.platformPath)
										
									End if 
									
								Else 
									
									$Obj_widget.name:=$t
									
								End if 
							End if 
							
							  //______________________________________________________
						: ($Txt_key="picture")
							
							$t:=String:C10($Obj_manifest.tools.picture)
							
							If (Length:C16($t)>0)
								
								$file:=$o.file("Resources/"+$t)
								
								If ($file.exists)
									
									READ PICTURE FILE:C678($file.platformPath;$p)
									
									If (OK=1)
										
										PICTURE PROPERTIES:C457($p;$Lon_width;$Lon_height)
										
										If ($Lon_height<($Lon_width*4))
											
											CREATE THUMBNAIL:C679($p;$pp;$Obj_form.iconSize;$Obj_form.iconSize)
											COMBINE PICTURES:C987($p;$pp;Vertical concatenation:K61:9;$pp;0;$Obj_form.iconSize)
											COMBINE PICTURES:C987($p;$p;Vertical concatenation:K61:9;$pp;0;$Obj_form.iconSize*2)
											TRANSFORM PICTURE:C988($pp;Fade to grey scale:K61:6)
											COMBINE PICTURES:C987($p;$p;Vertical concatenation:K61:9;$pp;0;$Obj_form.iconSize*3)
											
										End if 
										
										$Obj_widget.icon:=$p
										
									End if 
								End if 
							End if 
							
							  //______________________________________________________
						: ($Txt_key="helptip")
							
							$t:=String:C10($Obj_manifest.tools.helptip)
							
							If (Length:C16($t)>0)
								
								If (Position:C15(":xliff:";$t)=1)  // Localised
									
									If ($Dir_localized.exists)
										
										$Obj_widget.helptip:=xliff_getString (Delete string:C232($t;1;7);$Dir_localized.platformPath)
										
									End if 
									
								Else 
									
									$Obj_widget.helptip:=$t
									
								End if 
							End if 
							
							  //______________________________________________________
						: ($Txt_key="initproc")
							
							Formula from string:C1601($Obj_manifest.tools[$Txt_key]).call()
							
							  //______________________________________________________
						: ($Txt_key="tool")
							
							If (Value type:C1509($Obj_manifest.tools.tool)=Is object:K8:27)
								
								$Obj_widget.default:=$Obj_manifest.tools.tool.method
								
							Else 
								
								If ($Obj_manifest.tools.tool.length>0)
									
									$Obj_widget.popup:=True:C214
									
									For each ($Obj_tool;$Obj_manifest.tools.tool)
										
										For each ($Txt_tool;$Obj_tool)
											
											Case of 
													
													  //………………………………………………………………………………
												: ($Txt_tool="name")
													
													$t:=String:C10($Obj_tool.name)
													
													If (Length:C16($t)>0)
														
														If (Position:C15(":xliff:";$t)=1)  // Localised
															
															If ($Dir_localized.exists)
																
																$Obj_tool.name:=xliff_getString (Delete string:C232($t;1;7);$Dir_localized.platformPath)
																
															End if 
														End if 
													End if 
													
													  //………………………………………………………………………………
												: ($Txt_tool="picture")
													
													$file:=$o.file("Resources/"+$t)
													
													If ($file.exists)
														
														$Obj_tool.picture_path:=$file.platformPath
														
													End if 
													
													  //………………………………………………………………………………
											End case 
										End for each 
										
										$Obj_widget.tool.push($Obj_tool)
										
									End for each 
								End if 
							End if 
							
							  //______________________________________________________
						Else 
							
							$Obj_widget[$Txt_key]:=$Obj_manifest.tools[$Txt_key]
							
							  //______________________________________________________
					End case 
				End for each 
				
				  // Get informations for dialog About
				$oo:=plist ("load";$o.file("Info.plist"))
				
				If ($oo.success)
					
					$Obj_widget.plist:=$oo.toObject()
					
				End if 
				
				$Obj_form.widgets.push($Obj_widget)
				
			Else 
				
				  // NOT A 4DPop COMPONENT
				
			End if 
		End if 
	End for each 
	
	  // Sort tools by name
	$Obj_form.widgets:=$Obj_form.widgets.orderBy("name")
	
End if 

  //$t:="\t\t\t\t<td  class=\"styleSmall\"><H4><a href=\"{href}\"target=\"_blank\">{linkname}</a></h4></td>\r"
  //$Txt_buffer:="<html>\r\r"+"\t<head>\r"+"\t\t<style type=\"text/css\">\r<!--\r.styleSmall {font-size: small}\r-->\r</style>\r"+"\t</head>\r\r"+"\t<body leftmargin=\"0\" marginwidth=\"0\" topmargin=\"0\" marginheight=\"0\">\r"
  //If (Size of array($tTxt_helpFiles)>0)
  //$Txt_buffer:=$Txt_buffer+"\t\t<table border=\"0\" cellpadding=\"4\" cellspacing=\"0\" height=\"50\">\r"+"\t\t\t<tr valign=\"bottom\" align=\"center\">\r"
  //For ($i;1;Size of array($tTxt_helpFiles);1)
  //$Txt_cell:=Replace string($t;"{href}";$tTxt_helpFiles{$i})
  //$Txt_cell:=Replace string($Txt_cell;"{linkname}";$tTxt_structurefiles{$i})
  //$Txt_buffer:=$Txt_buffer+$Txt_cell
  // End for
  //$Txt_buffer:=$Txt_buffer+"\t\t\t</tr>\r"+"\t\t</table>\r"
  // End if
  //$Txt_buffer:=$Txt_buffer+"\t</body>\r\r"+"</html>"
  //TEXT TO BLOB($Txt_buffer;$Blb_html;Mac text without length)
  //$Txt_path:=Get 4D folder(Current resources folder)+"Components.html"
  //If (Test path name($Txt_path)=Is a document)
  //DELETE DOCUMENT($Txt_path)
  // End if
  //BLOB TO DOCUMENT($Txt_path;$Blb_html)

$0:=$Obj_form