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

C_LONGINT:C283($bottom;$height;$left;$Lon_version;$right;$top)
C_LONGINT:C283($width)
C_PICTURE:C286($p;$pp)
C_TEXT:C284($t;$Txt_buffer;$Txt_key;$Txt_tool)
C_OBJECT:C1216($file;$folder;$o;$o_database;$o_localized;$o_manifest)
C_OBJECT:C1216($o_result;$o_tool;$o_widget;$oo)
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

$o_result:=New object:C1471(\
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
"window";Open window:C153($left;$top;$right;$bottom;-(Plain dialog box:K34:4+Texture appearance:K34:17+_o_Compositing mode:K34:18)))

$c:=New collection:C1472

$o_database:=database 

  // Add current database in dev mode, if it's not me ;-)
If ($o_database.name#"4DPop")
	
	$c.push($o_database.root)
	
End if 

If ($o_database.components.length>0)
	
	  // Get the application Components
	$folder:=Folder:C1567(Application file:C491;fk platform path:K87:2)
	$folder:=Choose:C955(Is Windows:C1573;$folder.parent;$folder.folder("Contents")).folder("Components")
	$c:=loadComponents ($folder).combine($c)
	
	  // Get the database Components
	$folder:=Folder:C1567(Get 4D folder:C485(Database folder:K5:14;*);fk platform path:K87:2).folder("Components")
	If ($folder.exists)
		
		$c:=loadComponents ($folder).combine($c)
		
	End if 
	
	If (Application type:C494=4D Remote mode:K5:5)
		
		  // Get the 4D Server components distributed to the client
		$c:=loadComponents (Folder:C1567(fk remote database folder:K87:9).folder("4D/Components")).combine($c)
		
	End if 
End if 

If ($c.length>0)
	
	For each ($o;$c)
		
		If ($o.name#"4DPop")
			
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
				$o_manifest:=xml ("load";$file).toObject()
				
				$o_widget:=New object:C1471(\
					"file";$o;\
					"name";"";\
					"icon";Null:C1517;\
					"helptip";"";\
					"default";"";\
					"popup";False:C215;\
					"tool";New collection:C1472;\
					"help";$o.file($o.name+".html");\
					"manifest";$o_manifest)
				
				  // database localization folder
				$o_localized:=$o.folder("Resources/"+$o_result.language+".lproj")
				
				For each ($Txt_key;$o_manifest.tools)
					
					Case of 
							
							  //______________________________________________________
						: ($Txt_key="popup")
							
							$o_widget.popup:=Bool:C1537($o_manifest.tools.popup)
							
							  //______________________________________________________
						: ($Txt_key="name")
							
							$t:=String:C10($o_manifest.tools.name)
							
							If (Length:C16($t)>0)
								
								If (Position:C15(":xliff:";$t)=1)  // Localised
									
									If ($o_localized.exists)
										
										$t:=xliff_getString (Delete string:C232($t;1;7);$o_localized.platformPath)
										
									End if 
								End if 
							End if 
							
							$o_widget.name:=$t
							
							  //______________________________________________________
						: ($Txt_key="picture")
							
							$t:=String:C10($o_manifest.tools.picture)
							
							If (Length:C16($t)>0)
								
								$file:=$o.file("Resources/"+$t)
								
								If ($file.exists)
									
									READ PICTURE FILE:C678($file.platformPath;$p)
									
									If (OK=1)
										
										PICTURE PROPERTIES:C457($p;$width;$height)
										
										If ($height<($width*4))
											
											CREATE THUMBNAIL:C679($p;$pp;$o_result.iconSize;$o_result.iconSize)
											COMBINE PICTURES:C987($p;$pp;Vertical concatenation:K61:9;$pp;0;$o_result.iconSize)
											COMBINE PICTURES:C987($p;$p;Vertical concatenation:K61:9;$pp;0;$o_result.iconSize*2)
											TRANSFORM PICTURE:C988($pp;Fade to grey scale:K61:6)
											COMBINE PICTURES:C987($p;$p;Vertical concatenation:K61:9;$pp;0;$o_result.iconSize*3)
											
										End if 
										
										$o_widget.icon:=$p
										
									End if 
								End if 
							End if 
							
							  //______________________________________________________
						: ($Txt_key="helptip")
							
							$t:=String:C10($o_manifest.tools.helptip)
							
							If (Length:C16($t)>0)
								
								If (Position:C15(":xliff:";$t)=1)  // Localised
									
									If ($o_localized.exists)
										
										$o_widget.helptip:=xliff_getString (Delete string:C232($t;1;7);$o_localized.platformPath)
										
									End if 
									
								Else 
									
									$o_widget.helptip:=$t
									
								End if 
							End if 
							
							  //______________________________________________________
						: ($Txt_key="initproc")
							
							Formula from string:C1601($o_manifest.tools[$Txt_key]).call()
							
							  //______________________________________________________
						: ($Txt_key="tool")
							
							If (Value type:C1509($o_manifest.tools.tool)=Is object:K8:27)
								
								$o_widget.default:=$o_manifest.tools.tool.method
								
							Else 
								
								If ($o_manifest.tools.tool.length>0)
									
									$o_widget.popup:=True:C214
									
									For each ($o_tool;$o_manifest.tools.tool)
										
										For each ($Txt_tool;$o_tool)
											
											Case of 
													
													  //………………………………………………………………………………
												: ($Txt_tool="name")
													
													$t:=String:C10($o_tool.name)
													
													If (Length:C16($t)>0)
														
														If (Position:C15(":xliff:";$t)=1)  // Localised
															
															If ($o_localized.exists)
																
																$o_tool.name:=xliff_getString (Delete string:C232($t;1;7);$o_localized.platformPath)
																
															End if 
														End if 
													End if 
													
													  //………………………………………………………………………………
												: ($Txt_tool="picture")
													
													$file:=$o.file("Resources/"+$t)
													
													If ($file.exists)
														
														$o_tool.picture_path:=$file.platformPath
														
													End if 
													
													  //………………………………………………………………………………
											End case 
										End for each 
										
										$o_widget.tool.push($o_tool)
										
									End for each 
								End if 
							End if 
							
							  //______________________________________________________
						Else 
							
							$o_widget[$Txt_key]:=$o_manifest.tools[$Txt_key]
							
							  //______________________________________________________
					End case 
				End for each 
				
				  // Get informations for dialog About
				$oo:=plist ("load";$o.file("Info.plist"))
				
				If ($oo.success)
					
					$o_widget.plist:=$oo.toObject()
					
				End if 
				
				If ($o_result.widgets.query("name = :1";$o_widget.name).length=0)
					
					$o_result.widgets.push($o_widget)
					
				End if 
				
			Else 
				
				  // Not a 4dpop component
				
			End if 
			
		Else 
			
			  // Not me ;-)
			
		End if 
	End for each 
	
	  // Sort tools by name
	$o_result.widgets:=$o_result.widgets.orderBy("name")
	
End if 

$0:=$o_result