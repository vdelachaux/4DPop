// ----------------------------------------------------
// Created 01-02-2023 by Vincent de Lachaux
// ----------------------------------------------------
property motor : cs:C1710.motor
property database : cs:C1710.database
property preferences : cs:C1710.Preferences

// Mark:-
Class constructor
	
	// Mark:Delegates 📦
	This:C1470.motor:=cs:C1710.motor.new()
	This:C1470.database:=cs:C1710.database.new()
	This:C1470.preferences:=cs:C1710.Preferences.new()
	
	This:C1470.formName:="STRIP"
	
	// Loading compatible components
	This:C1470.properties:=This:C1470.getDefinition()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Loading compatible components
Function getDefinition() : Object
	
	var $item; $key : Text
	var $component; $manifest; $plist; $result; $tool; $widget : Object
	var $components : Collection
	var $file : 4D:C1709.File
	
	$result:=New object:C1471(\
		"leftOffset"; 20; \
		"rightOffset"; 20; \
		"offset"; 30; \
		"cellWidth"; 70; \
		"iconSize"; 48; \
		"event"; 0; \
		"default"; New object:C1471("title"; 1; "icon"; 1; "style"; 3); \
		"language"; Get database localization:C1009(*); \
		"mdi"; Is Windows:C1573; \
		"process"; Current process:C322; \
		"hidden"; True:C214; \
		"widgets"; New collection:C1472)
	
	$plist:=Folder:C1567(fk database folder:K87:14).file("Info.plist").getAppInfo()
	
	$result.plist:=$plist
	$result.infos:=$plist.CFBundleDisplayName+"\rv"+$plist.CFBundleShortVersionString
	$result.infos+=" build "+$plist.CFBundleVersion
	$result.copyright:=$plist.NSHumanReadableCopyright
	$result.icon:=This:C1470.getIcon(File:C1566("/RESOURCES/Images/4DPop.png"); 48; True:C214)
	
	$components:=This:C1470.getTools()
	
	If ($components.length=0)
		
		return $result
		
	End if 
	
	For each ($component; $components)
		
		// Always resolve alias
		$component:=$component.original
		
		If ($component.name="4DPop")
			
			continue
			
		End if 
		
		If ($component.isFile)  // .4DProject
			
			$component:=$component.parent.parent
			
		End if 
		
		// Get the definition file
		$file:=$component.file("Resources/4DPop.json")
		
		If ($file.exists)
			
			$manifest:=JSON Parse:C1218($file.getText())
			
		Else 
			
			//MARK:#### TEMPO ####
			$file:=$component.file("Resources/4DPop.xml")
			
			If (Not:C34($file.exists))
				
				// No 4dPop definition
				continue
				
			End if 
			
			// Load the manifest
			$manifest:=cs:C1710.xml.new($file).toObject()
			
		End if 
		
		If (Not:C34($file.exists))
			
			// No 4dPop definition
			continue
			
		End if 
		
		$widget:=New object:C1471(\
			"file"; $component; \
			"name"; ""; \
			"icon"; Null:C1517; \
			"helptip"; ""; \
			"default"; ""; \
			"ondrop"; ""; \
			"popup"; False:C215; \
			"tool"; New collection:C1472; \
			"help"; $component.file($component.name+".htm"); \
			"manifest"; $manifest; \
			"lproj"; This:C1470._lproj($component; $result.language))
		
		For each ($key; $manifest)
			
			Case of 
					
					//______________________________________________________
				: ($key="popup")
					
					$widget.popup:=Bool:C1537($manifest.popup)
					
					//______________________________________________________
				: (($key="name") | ($key="helptip")) & ($widget.lproj#Null:C1517)
					
					$widget[$key]:=This:C1470.getLocalizedString(String:C10($manifest[$key]); $widget.lproj)
					
					//______________________________________________________
				: ($key="picture")
					
					$widget.icon:=This:C1470.getIcon($component.file("Resources/"+String:C10($manifest[$key])); $result.iconSize)
					$widget.picture:=This:C1470.getIcon($component.file("Resources/"+String:C10($manifest[$key])); 48; True:C214)
					
					//______________________________________________________
				: ($key="default")
					
					$widget.default:=String:C10($manifest[$key])
					
					//______________________________________________________
				: ($key="initproc")
					
					Formula from string:C1601($manifest[$key]).call()
					
					//______________________________________________________
				: ($key="tool")
					
					If (Value type:C1509($manifest.tool)=Is object:K8:27)
						
						$widget.default:=$widget.default || $manifest.tool.method
						$widget.tool.push(New object:C1471("method"; $manifest.tool.method))
						
					Else 
						
						If ($manifest.tool#Null:C1517) && ($manifest.tool.length>0)
							
							$widget.popup:=True:C214
							
							For each ($tool; $manifest.tool || $manifest.tools)
								
								For each ($item; $tool)
									
									Case of 
											
											//………………………………………………………………………………
										: ($item="name")
											
											$tool.name:=($widget.lproj#Null:C1517) ? This:C1470.getLocalizedString(String:C10($tool.name); $widget.lproj) : String:C10($tool.name)
											
											//………………………………………………………………………………
										: ($item="picture")
											
											$file:=$component.file("Resources/"+$tool.picture)
											
											If ($file.exists)
												
												$tool.picture_path:=$file.platformPath
												
											End if 
											
											//………………………………………………………………………………
									End case 
								End for each 
								
								$widget.tool.push($tool)
								
							End for each 
						End if 
					End if 
					
					//______________________________________________________
				Else 
					
					$widget[$key]:=$manifest[$key]
					
					//______________________________________________________
			End case 
		End for each 
		
		// Do not add twice
		If ($result.widgets.query("name = :1"; $widget.name).pop()=Null:C1517)
			
			// Get informations for dialog About
			$widget.plist:=$component.file("Info.plist")
			
			If ($widget.plist.exists)
				
				$plist:=$widget.plist.getAppInfo()
				
				$widget.infos:=String:C10($plist.CFBundleDisplayName || $widget.file.name)
				
				If (Length:C16(String:C10($plist.CFBundleShortVersionString))>0)
					
					$widget.infos+="\rv"+$plist.CFBundleShortVersionString
					
					If (Length:C16(String:C10($plist.CFBundleVersion))>0)
						
						$widget.infos+=" build "+$plist.CFBundleVersion
						
					End if 
				End if 
				
			Else 
				
				$widget.infos:=$widget.file.name
				
			End if 
			
			$widget.copyright:=String:C10($plist.NSHumanReadableCopyright)
			
			$result.widgets.push($widget)
			
		End if 
		
	End for each 
	
	return $result
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Component localization folder
Function _lproj($component : Object; $language : Text) : 4D:C1709.Folder
	
	var $folder : 4D:C1709.Folder
	
	$folder:=$component.folder("Resources/"+$language+".lproj")
	
	If ($folder.exists)
		
		return $folder
		
	End if 
	
	// Try en
	$folder:=$component.folder("Resources/en.lproj")
	
	If ($folder.exists)
		
		return $folder
		
	End if 
	
	// Try en-us
	$folder:=$component.folder("Resources/en-us.lproj")
	
	If ($folder.exists)
		
		return $folder
		
	End if 
	
	// Try English
	$folder:=$component.folder("Resources/English.lproj")
	
	If ($folder.exists)
		
		return $folder
		
	End if 
	
	// Take the first
	return $component.folder("Resources").folders().query("extension = .lproj").pop()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the found components
Function getTools() : Collection
	
	If (This:C1470.motor.remote)
		
		return This:C1470.getComponents(This:C1470.motor.root.folder("Components"))\
			.combine(This:C1470.getComponents(This:C1470.database.databaseFolder.folder("Components")))
		
	Else 
		
		return This:C1470.getComponents(This:C1470.motor.root.folder("Components"))\
			.combine(This:C1470.getComponents(This:C1470.database.databaseFolder.folder("Components")))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Filtering and resolving aliases
Function getComponents($folder : 4D:C1709.Folder) : Collection
	
	var $c : Collection
	
	// The components
	$c:=$folder.folders().query("extension = .4dbase")
	
	// The alias/shortcuts
	$c.combine($folder.files().query("extension = :1 & original.extension =:1"; ".4dbase"))
	$c.combine($folder.files().query("extension = :1 & original.extension =:1"; ".4DProject"))
	
	return $c.orderBy("name")
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create an icon from a media
Function getIcon($file : 4D:C1709.File; $iconSize : Integer; $crop : Boolean) : Picture
	
	var $image; $mask; $rect; $svg : Text
	var $icon; $pict : Picture
	var $height; $width : Integer
	
	If (Not:C34($file.exists))
		
		$file:=File:C1566("/RESOURCES/missing.png")
		
	End if 
	
	If ($file.exists)
		
		READ PICTURE FILE:C678($file.platformPath; $icon)
		
		If (Bool:C1537(OK))
			
			PICTURE PROPERTIES:C457($icon; $width; $height)
			
			If ($height<($width*4))
				
				// Create a 4-state button
				CREATE THUMBNAIL:C679($icon; $pict; $iconSize; $iconSize)
				COMBINE PICTURES:C987($icon; $pict; Vertical concatenation:K61:9; $pict; 0; $iconSize)
				COMBINE PICTURES:C987($icon; $icon; Vertical concatenation:K61:9; $pict; 0; $iconSize*2)
				TRANSFORM PICTURE:C988($pict; Fade to grey scale:K61:6)
				COMBINE PICTURES:C987($icon; $icon; Vertical concatenation:K61:9; $pict; 0; $iconSize*3)
				
			End if 
			
			TRANSFORM PICTURE:C988($icon; Crop:K61:7; 0; 0; $iconSize; $iconSize)
			
			$svg:=SVG_New
			$mask:=SVG_Define_clip_Path($svg; "mask")
			SVG_SET_CLIP_PATH($svg; "mask")
			$rect:=SVG_New_rect($mask; 0; 0; $iconSize; $iconSize; 10; 10; "none"; "none")
			$image:=SVG_New_embedded_image($svg; $icon; 0; 0; ".png")
			$icon:=SVG_Export_to_picture($svg; Get XML data source:K45:16)
			
			CONVERT PICTURE:C1002($icon; ".png")
			
			CREATE THUMBNAIL:C679($icon; $pict; $iconSize; $iconSize)
			COMBINE PICTURES:C987($icon; $pict; Vertical concatenation:K61:9; $pict; 0; $iconSize)
			COMBINE PICTURES:C987($icon; $icon; Vertical concatenation:K61:9; $pict; 0; $iconSize*2)
			TRANSFORM PICTURE:C988($pict; Fade to grey scale:K61:6)
			COMBINE PICTURES:C987($icon; $icon; Vertical concatenation:K61:9; $pict; 0; $iconSize*3)
			
			If ($crop)
				
				// Keep only the first state
				TRANSFORM PICTURE:C988($icon; Crop:K61:7; 0; 0; $iconSize; $iconSize)
				
			End if 
			
			return $icon
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a localized string from the component
Function getLocalizedString($string : Text; $lproj : 4D:C1709.Folder) : Text
	
	var $localized; $node : Text
	var $c : Collection
	var $file : 4D:C1709.File
	var $xml : cs:C1710.xml
	
	If ($lproj#Null:C1517)\
		 && ($lproj.exists)\
		 && (Length:C16($string)>0)\
		 && (Position:C15(":xliff:"; $string)=1)
		
		$xml:=cs:C1710.xml.new()
		
		For each ($file; $lproj.files().query("extension = .xlf"))
			
			$c:=$xml.load($file)\
				.findByAttribute($xml.root; "resname"; Delete string:C232($string; 1; 7))
			
			If ($c.length>0)
				
				$node:=$xml.findByXPath("target"; $c[0])
				
				If (Not:C34($xml.success))
					
					$node:=$xml.findByXPath("source"; $c[0])
					
				End if 
				
				If ($xml.success)
					
					$string:=$xml.getValue($node)
					$xml.close()
					
					break
					
				End if 
			End if 
			
			$xml.close()
			
		End for each 
	End if 
	
	return $string
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Display the palett
Function display()
	
	var $height; $width : Integer
	var $coordinates; $form : Object
	
	If (This:C1470.motor.infos.headless)
		
		return 
		
	End if 
	
	$form:=This:C1470.properties
	
	$form.autoClose:=Bool:C1537(This:C1470.preferences.get("auto_hide"))
	
	FORM GET PROPERTIES:C674(String:C10(This:C1470.formName); $width; $height)
	
	$coordinates:=(Shift down:C543 ? /* Reset */Null:C1517 : This:C1470.preferences.get("palette"))\
		 || /* Default */New object:C1471("left"; 0; "bottom"; Screen height:C188)
	
	$coordinates.top:=$coordinates.bottom-$height
	
	If ($coordinates.left=0)
		
		$coordinates.right:=$width
		
	Else 
		
		$coordinates.left:=Screen width:C187-$width
		$coordinates.right:=Screen width:C187
		
	End if 
	
	If ($coordinates.bottom>Screen height:C188)
		
		$height:=$coordinates.bottom-$coordinates.top
		$coordinates.bottom:=Screen height:C188
		$coordinates.top:=$coordinates.bottom-$height
		
	End if 
	
	If (Count screens:C437=1)
		
		If ($coordinates.left<0)
			
			$coordinates.left:=0
			$coordinates.right:=$width
			
		End if 
		
		If ($coordinates.right>Screen width:C187)
			
			$coordinates.right:=Screen width:C187
			
		End if 
	End if 
	
	$form.window:=Open window:C153($coordinates.left; $coordinates.top; $coordinates.right; $coordinates.bottom; -(Plain dialog box:K34:4+Texture appearance:K34:17+_o_Compositing mode:K34:18))
	DIALOG:C40(This:C1470.formName; $form; *)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Initialization of the palett
Function init()
	
	var $format; $template; $toolButton; $toolPicture; $varName : Text
	var $dummy; $i : Integer
	var $nilPtr; $ptr : Pointer
	var $form; $widget : Object
	
	OBJECT SET VISIBLE:C603(*; "toolButton_@"; False:C215)
	
	$template:="{title};{picture};{background};{titlePos};{titleVisible};{iconVisible};{style};{horMargin};{vertMargin};{iconOffset};{popupMenu};{underline}"
	
	$form:=This:C1470.properties
	
	For each ($widget; $form.widgets)
		
		$i+=1
		
		$toolButton:="toolButton_"+String:C10($i)
		$toolPicture:="toolIcon."+String:C10($i)
		
		If ($i>1)
			
			OBJECT DUPLICATE:C1111(*; "toolButton_"+String:C10($i-1); $toolButton; $nilPtr; ""; $form.cellWidth)
			OBJECT DUPLICATE:C1111(*; "toolIcon."+String:C10($i-1); $toolPicture; $nilPtr; ""; $form.cellWidth)
			
		End if 
		
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $toolPicture)
		RESOLVE POINTER:C394($ptr; $varName; $dummy; $dummy)
		
		$ptr->:=$widget.icon
		
		$format:=Replace string:C233($template; "{title}"; $widget.name)
		$format:=Replace string:C233($format; "{picture}"; $varName)
		$format:=Replace string:C233($format; "{background}"; "?0")
		$format:=Replace string:C233($format; "{titlePos}"; "0")
		$format:=Replace string:C233($format; "{titleVisible}"; String:C10($form.default.title))
		$format:=Replace string:C233($format; "{iconVisible}"; String:C10($form.default.icon))
		$format:=Replace string:C233($format; "{style}"; String:C10($form.default.style))
		$format:=Replace string:C233($format; "{horMargin}"; "8")
		$format:=Replace string:C233($format; "{vertMargin}"; "0")
		$format:=Replace string:C233($format; "{iconOffset}"; "0")
		$format:=Replace string:C233($format; "{popupMenu}"; String:C10(Bool:C1537($widget.popup) ? 1+Num:C11($widget.default#Null:C1517) : 0))
		$format:=Replace string:C233($format; "{underline}"; "0")
		OBJECT SET FORMAT:C236(*; $toolButton; $format)
		
		OBJECT SET HELP TIP:C1181(*; $toolButton; Length:C16($widget.helptip)>0 ? $widget.helptip : $widget.name)
		
	End for each 
	
	If (Not:C34(Bool:C1537($form.autoClose)))
		
		$form.viewing:=Num:C11(This:C1470.preferences.data.viewingNumber)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sends an abort message to the pallet
Function abort()
	
	var $t : Text
	var $i; $l : Integer
	
	For ($i; 1; Count user processes:C343; 1)
		
		PROCESS PROPERTIES:C336($i; $t; $l; $l)
		
		If ($t="$4DPop")
			
			POST OUTSIDE CALL:C329($i)
			break
			
		End if 
	End for 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Closes the palett
Function close()
	
	SET TIMER:C645(0)
	CANCEL:C270
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Displays the About dialog box
Function doAbout()
	
	var $winRfef : Integer
	
	If (This:C1470.motor.infos.headless)
		
		return 
		
	End if 
	
	$winRfef:=Open form window:C675("ABOUT"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4; *)
	DIALOG:C40("ABOUT"; This:C1470)
	CLOSE WINDOW:C154
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Pallet state management
Function collapseExpand($displayed : Integer)
	
	var $bottom; $height; $i; $offset; $left; $offset : Integer
	var $right; $top; $width : Integer
	var $form : Object
	
	$form:=This:C1470.properties
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; $form.window)
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	
	$offset:=$form.offset+5
	
	If (Count parameters:C259=0)
		
		If ($form.page=1)
			
			$width:=$right+$left
			
			If ($width<$form.maxWidth)
				
				$offset:=$form.maxWidth-$width
				$right:=$right+$offset
				SET WINDOW RECT:C444($left; $top; $right; $bottom; $form.window)
				OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
				
				For ($i; 1; $form.widgets.length; 1)
					
					OBJECT SET VISIBLE:C603(*; "toolButton_"+String:C10($i); True:C214)
					
				End for 
				
			Else 
				
				SET WINDOW RECT:C444(0; $top; $left+$offset; $bottom; $form.window)
				OBJECT MOVE:C664(*; "@.Movable"; -$width+$offset; 0)
				OBJECT MOVE:C664(*; "fix_@"; -$width+$offset; 0)
				OBJECT SET VISIBLE:C603(*; "toolButton_@"; False:C215)
				
			End if 
			
		Else 
			
			$width:=$right-$left
			
			If ($width<$form.maxWidth)
				
				$offset:=$form.maxWidth-$width
				$left:=$left-$offset
				OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
				SET WINDOW RECT:C444($left; $top; $right; $bottom; $form.window)
				OBJECT SET VISIBLE:C603(*; "Fleche.@"; False:C215)
				
				For ($i; 1; $form.widgets.length; 1)
					
					OBJECT SET VISIBLE:C603(*; "toolButton_"+String:C10($i); True:C214)
					
				End for 
				
			Else 
				
				$offset:=($right-$left)-$offset
				SET WINDOW RECT:C444($left+$offset; $top; $right; $bottom; $form.window)
				OBJECT MOVE:C664(*; "@.Movable"; -$offset; 0)
				OBJECT SET VISIBLE:C603(*; "Fleche.@"; True:C214)
				OBJECT SET VISIBLE:C603(*; "toolButton_@"; False:C215)
				
			End if 
		End if 
		
	Else 
		
		If ($displayed>$form.widgets.length) | ($form.widgets.length=0)
			
			$displayed:=Choose:C955($form.widgets.length>0; $form.widgets.length; 1)
			
		End if 
		
		$form.maxWidth:=(($form.cellWidth*$displayed)+$offset)
		
		If ($form.page=1)
			
			$width:=$right+$left
			
			$offset:=$form.maxWidth-$width
			$right:=$right+$offset
			OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
			
		Else 
			
			$width:=$right-$left
			
			$offset:=$form.maxWidth-$width
			$left:=$left-$offset
			OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
			
		End if 
		
		SET WINDOW RECT:C444($left; $top; $right; $bottom; $form.window)
		
		For ($i; 1; $form.widgets.length; 1)
			
			OBJECT SET VISIBLE:C603(*; "toolButton_"+String:C10($i); $displayed>0)
			
		End for 
		
		OBJECT MOVE:C664(*; "_background"; 0; 0; $form.maxWidth; $height; *)
		
		REDRAW WINDOW:C456
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Palett menu
Function doMenu()
	
	var $height; $width : Integer
	var $coordinates; $form; $item; $widget : Object
	var $menu; $sub : cs:C1710.menu
	
	$form:=This:C1470.properties
	
	$menu:=cs:C1710.menu.new()
	
	$menu.append(":xliff:About"; "about")\
		.line()
	
	$menu.append(":xliff:Position"; cs:C1710.menu.new()\
		.append(":xliff:TopLeft"; "Pos_TopLeft")\
		.append(":xliff:BottomLeft"; "Pos_BottomLeft")\
		.append(":xliff:TopRight"; "Pos_TopRight")\
		.append(":xliff:BottomRight"; "Pos_BottomRight"))
	
	$menu.line()\
		.append(":xliff:Collapse"; "Collapse").enable(Not:C34($form.autoClose))\
		.append(":xliff:Expand"; "Expand").enable(Not:C34($form.autoClose))\
		.append(":xliff:automaticMode"; "automatic").mark($form.autoClose)
	
	$menu.line()
	
	For each ($widget; $form.widgets)
		
		If ($widget.tool.length=0)
			
			$menu.append($widget.name; $widget.default).icon("Images/tool.png")
			
		Else 
			
			$sub:=cs:C1710.menu.new()
			
			For each ($item; $widget.tool)
				
				If ($item.name="-")
					
					$sub.line()
					
				Else 
					
					$sub.append($item.name; $item.method)
					
				End if 
				
				$sub.setData("widget"; $widget)
				
			End for each 
			
			$menu.append($widget.name; $sub).icon("Images/tool.png")
			
		End if 
	End for each 
	
	$menu.append($widget.name; $sub)
	
	$menu.line()\
		.append(":xliff:closePalette"; "close")
	
	$menu.popup()
	
	Case of 
			
			//______________________________________________________
		: (Not:C34($menu.selected))
			
			return 
			
			//______________________________________________________
		: ($menu.choice="about")
			
			This:C1470.doAbout(Form:C1466)
			
			//______________________________________________________
		: ($menu.choice="close")
			
			This:C1470.close()
			
			//______________________________________________________
		: ($menu.choice="Pos_@")
			
			$menu.choice:=Replace string:C233($menu.choice; "Pos_"; "")
			
			OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
			
			$coordinates:=New object:C1471(\
				"left"; 0; \
				"top"; 0; \
				"right"; 0; \
				"bottom"; 0)
			
			Case of 
					
					//……………………………………………………………………………………………
				: ($menu.choice="Top@")
					
					$coordinates.top:=Menu bar height:C440+Tool bar height:C1016
					$coordinates.bottom:=$coordinates.top+$height
					
					//……………………………………………………………………………………………
				: ($menu.choice="Bottom@")
					
					$coordinates.bottom:=Screen height:C188(*)
					$coordinates.top:=$coordinates.bottom-$height
					
					//……………………………………………………………………………………………
			End case 
			
			Case of 
					
					//……………………………………………………………………………………………
				: ($menu.choice="@Left")
					
					$coordinates.left:=0
					$coordinates.right:=$width
					$form.page:=1
					
					//……………………………………………………………………………………………
				: ($menu.choice="@Right")
					
					$coordinates.right:=Screen width:C187(*)
					$coordinates.left:=$coordinates.right-$width
					$form.page:=2
					
					//……………………………………………………………………………………………
			End case 
			
			This:C1470.preferences.set("palette"; $coordinates)
			
			SET WINDOW RECT:C444($coordinates.left; $coordinates.top; $coordinates.right; $coordinates.bottom; $form.window)
			FORM GOTO PAGE:C247($form.page)
			
			//______________________________________________________
		: ($menu.choice="Collapse")\
			 | ($menu.choice="Expand")
			
			This:C1470.collapseExpand()
			
			//______________________________________________________
		: ($menu.choice="automatic")
			
			$form.autoClose:=Not:C34($form.autoClose)
			This:C1470.preferences.set("auto_hide"; $form.autoClose)
			
			If ($form.autoClose)
				
				$form.event:=999
				SET TIMER:C645(-1)
				
			End if 
			
			//______________________________________________________
		Else 
			
			// Calling the component
			$item:=New object:C1471
			$item.method:=$menu.choice
			$item.widget:=$menu.getData("widget")
			$item.success:=This:C1470.execute($item)
			ASSERT:C1129($item.success; Replace string:C233(Get localized string:C991("ErrorOccuredDuringExecutionOfTheMethod"); "{methodName}"; $menu.choice))
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Calling a component
Function execute($e : Object) : Boolean
	
	var $method : Text
	var $nil; $ptr : Pointer
	
	Case of 
			
			//______________________________________________________
		: ($e.method="default")
			
			$method:=$e.widget.default
			
			//______________________________________________________
		: ($e.method="onDrop")
			
			$method:=$e.widget.ondrop
			
			//______________________________________________________
		Else 
			
			// Tool
			$method:=$e.method
			
			//______________________________________________________
	End case 
	
	If (Length:C16($method)=0)
		
		ERROR:=-15002
		return False:C215
		
	End if 
	
	CLEAR VARIABLE:C89(ERROR)
	
	If (Position:C15("("; $method)=0)
		
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; String:C10($e.objectName))
		
		If (True:C214)
			
			If (Not:C34(Is nil pointer:C315($ptr)))
				
				EXECUTE METHOD:C1007($method; *; $ptr)
				
			Else 
				
				EXECUTE METHOD:C1007($method; *; $nil)
				
			End if 
			
		Else 
			
			// FIXME:Use formula
			Formula:C1597($e.widget.handler).call(Null:C1517; $ptr)
			
		End if 
		
	Else 
		
		If ($method="@()")
			
			$method:=Replace string:C233($method; "()"; "")
			
		End if 
		
		EXECUTE FORMULA:C63($method)
		
	End if 
	
	If (ERROR=-10508)
		
		ALERT:C41(Replace string:C233(Get localized string:C991("AlertExecute"); "{method}"; $method))
		
	End if 
	
	return ERROR=0
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doDrop() : Integer
	
	var $pathname : Text
	var $accept : Boolean
	var $e : Object
	
	$e:=FORM Event:C1606
	$pathname:=Get file from pasteboard:C976(1)
	
	SET CURSOR:C469(9019)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Mouse Leave:K2:34)
			
			//______________________________________________________
		: (Application type:C494=4D Remote mode:K5:5)
			
			// Installing a new component is not possible, for the moment,  in remote mode
			
			//______________________________________________________
		: (Test path name:C476($pathname)#Is a document:K24:1)
			
			// Only folders are allowed for installation by drag & drop
			
			//______________________________________________________
		: ($pathname#"@.4dbase")
			
			//Only ".4dbase" are allowed for installation by drag & drop
			
			//______________________________________________________
		: (Test path name:C476($pathname+Folder separator:K24:12+"Resources"+Folder separator:K24:12+"4DPop.xml")#Is a document:K24:1)\
			 & (Test path name:C476($pathname+Folder separator:K24:12+"Extras"+Folder separator:K24:12+"4DPop.xml")#Is a document:K24:1)
			
			// This component is not compatible with 4DPop
			
			//______________________________________________________
		: ($e.code=On Drag Over:K2:13)
			
			// Accept the drop
			SET CURSOR:C469(9016)
			$accept:=True:C214
			
			//______________________________________________________
		Else   // On drop
			
			// Display the installation wizard
			//$winRef:=Open form window("ASSISTANT"; Movable form dialog box; Horizontally centered; Vertically centered)
			//DIALOG("ASSISTANT")
			//CLOSE WINDOW
			
			//______________________________________________________
	End case 
	
	// Show or hide the visual effect of drag & drop.
	OBJECT SET VISIBLE:C603(*; "hightlight"; $accept)
	
	// Set the timer for hide the visual effect if user chooses to don't drop the dragged elements
	Form:C1466.event:=99
	SET TIMER:C645(20)
	
	return $accept ? 0 : -1