// ----------------------------------------------------
// Created 01-02-2023 by Vincent de Lachaux
// ----------------------------------------------------
property motor : cs:C1710.motor
property database : cs:C1710.database
property preferences : cs:C1710.Preferences
property env : cs:C1710.env
property properties : Object

// Mark:-
Class constructor
	
	// Mark:Delegates 📦
	This:C1470.motor:=cs:C1710.motor.new()
	This:C1470.database:=cs:C1710.database.new()
	This:C1470.env:=cs:C1710.env.new(True:C214)
	This:C1470.preferences:=cs:C1710.Preferences.new()
	
	This:C1470.formName:="STRIP"
	This:C1470.windowType:=-(Plain dialog box:K34:4+Texture appearance:K34:17+_o_Compositing mode:K34:18)
	
	// Loading compatible components
	This:C1470.properties:=This:C1470.load()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Loading compatible components
Function load() : Object
	
	var $component; $manifest; $order; $plist; $result : Object
	var $components : Collection
	var $file : 4D:C1709.File
	var $widget : cs:C1710._widget
	
	// 4DPop plist
	$plist:=Folder:C1567(fk database folder:K87:14).file("Info.plist").getAppInfo()
	
	$result:={\
		titleWidth: 23; \
		handleWidth: 13; \
		offset: 35; \
		cellWidth: 70; \
		iconSize: 48; \
		event: 0; \
		default: {titleVisible: 1; iconVisible: 1; style: 3}; \
		language: Get database localization:C1009(*); \
		mdi: Is Windows:C1573; \
		process: Current process:C322; \
		hidden: True:C214; \
		plist: $plist; \
		infos: $plist.CFBundleDisplayName+"\rv"+$plist.CFBundleShortVersionString+" build "+$plist.CFBundleVersion; \
		copyright: $plist.NSHumanReadableCopyright; \
		icon: cs:C1710._widget.new().getIcon(File:C1566("/RESOURCES/Images/4DPop.png"); 48; True:C214); \
		widgets: []; \
		maxWidth: 0\
		}
	
	$components:=This:C1470.getTools()
	
	If ($components.length=0)  // No components
		
		$result.maxWidth:=$result.cellWidth
		return $result
		
	End if 
	
	$order:=This:C1470.preferences.get("order")
	
	For each ($component; $components)
		
		If ($component=Null:C1517)
			
			continue
			
		End if 
		
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
			
			$file:=$component.file("Resources/4DPop.xml")
			
			If ($file.exists)
				
				// Load the manifest
				$manifest:=cs:C1710.xml.new($file).toObject()
				
			End if 
		End if 
		
		If (Not:C34($file.exists))
			
			// No 4DPop
			continue
			
		End if 
		
		$widget:=cs:C1710._widget.new($component; $manifest)
		
		// Do not add twice
		If ($result.widgets.query("name = :1"; $widget.name).pop()=Null:C1517)
			
			// Get informations for the About dialog
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
				
				$widget.copyright:=String:C10($plist.NSHumanReadableCopyright)
				
			Else 
				
				$widget.infos:=$widget.file.name
				
			End if 
			
			$widget.order:=$order[$widget.name] || ($result.widgets.length+1)*10
			
			// TODO:Allow to set visibility
			$widget.visible:=True:C214
			
			$result.widgets.push($widget)
			$result.maxWidth+=$widget.width
			
		End if 
	End for each 
	
	$result.widgets:=$result.widgets.orderBy("order")
	
	return $result
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the found components
Function getTools() : Collection
	
	return This:C1470.getComponents(This:C1470.motor.root.folder("Components"))\
		.combine(This:C1470.getComponents(This:C1470.database.databaseFolder.folder("Components")))\
		.combine(This:C1470.getPMComponents())
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Filtering and resolving aliases
Function getComponents($folder : 4D:C1709.Folder) : Collection
	
	var $c : Collection
	
	// The components
	$c:=$folder.folders().query("extension = .4dbase")
	
	// The alias/shortcuts
	$c.combine($folder.files().query("extension = :1 & original.extension =:1"; ".4dbase"))
	$c.combine($folder.files().query("extension = :1 & original.extension =:1"; ".4DProject"))
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return the package manager dependencies folders
Function getPMComponents() : Collection
	
	var $name : Text
	var $env : Object
	var $c : Collection
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	var $o : 4D:C1709.Object
	
	If (This:C1470.motor.remote/* and FIXME not in situ*/)
		
		return This:C1470.motor.root.folder("PackageManager").folder("Components").folders()
		
	End if 
	
	// Get dependency files from the package manager
	$file:=This:C1470.database.databaseFolder.file("Project/Sources/dependencies.json")
	$file:=$file.original
	
	If (Not:C34($file.exists))
		
		return []
		
	End if 
	
	$o:=JSON Parse:C1218($file.getText())
	
	If ($o.dependencies=Null:C1517)
		
		return []  // Just empty, not yet defined
		
	End if 
	
	//TRACE
	
	// Get the package manager env file
	$folder:=This:C1470.database.databaseFolder
	$file:=$folder.file("environment4d.json")
	$file:=$file.original
	
	While (Not:C34($file.exists)\
		 && Not:C34($folder=Null:C1517))
		
		$folder:=$folder.parent
		
		If ($folder=Null:C1517)
			
			break
			
		End if 
		
		$file:=$folder.file("environment4d.json")
		$file:=$file.original
		
	End while 
	
	If ($file.exists)
		
		$env:=JSON Parse:C1218($file.getText()).dependencies
		
	End if 
	
	$c:=[]
	
	For each ($name; $o.dependencies)
		
		Case of 
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (($env=Null:C1517)\
				 || ($env[$name]=Null:C1517)\
				 || (Length:C16(String:C10($env[$name]))=0))
				
				$c.push(This:C1470.database.databaseFolder.parent.folder($name))
				
				continue
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (Position:C15("file://"; $env[$name])=1)
				
				$c.push(This:C1470.env.decodePathURL($env[$name]))
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (Position:C15("../"; $env[$name])=1)\
				 && (Not:C34($file.parent.parent=Null:C1517))
				
				$c.push($file.parent.parent.folder(Substring:C12($env[$name]; 4)))
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
			: (Position:C15("./"; $env[$name])=1)
				
				$c.push($file.parent.folder(Substring:C12($env[$name]; 3)))
				
				//┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅┅
		End case 
	End for each 
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Display the palett
Function display()
	
	var $height; $width : Integer
	var $coord : cs:C1710.coord
	
	If (This:C1470.motor.infos.headless)
		
		return 
		
	End if 
	
	This:C1470.properties.autoClose:=Bool:C1537(This:C1470.preferences.get("auto_hide"))
	
	FORM GET PROPERTIES:C674(String:C10(This:C1470.formName); $width; $height)
	
	$coord:=(Shift down:C543 ? /* Reset */Null:C1517 : This:C1470.preferences.get("palette"))\
		 || /* Default */({left: 0; bottom: Screen height:C188})
	
	$coord.top:=$coord.bottom-$height
	
	If ($coord.left=0)
		
		$coord.right:=$width
		
	Else 
		
		$coord.left:=This:C1470.env.mainScreen.workArea.right-$width
		$coord.right:=Screen width:C187
		
	End if 
	
	// TODO:Manage multi-screens
	
	If (Count screens:C437=1)
		
		If ($coord.left#0)
			
			$coord.left:=0  //C'est pas vrai si à droite
			$coord.right:=$width
			
		End if 
		
		If ($coord.bottom>This:C1470.env.mainScreen.workArea.bottom)
			
			$coord.bottom:=This:C1470.env.mainScreen.workArea.bottom
			$coord.top:=$coord.bottom-$height
			
		End if 
		
		If ($coord.right>This:C1470.env.mainScreen.workArea.right)
			
			$coord.right:=This:C1470.env.mainScreen.workArea.right
			$coord.left:=$coord.right-$width
			
		End if 
	End if 
	
	This:C1470.properties.window:=Open window:C153($coord.left; $coord.top; $coord.right; $coord.bottom; This:C1470.windowType)
	DIALOG:C40(This:C1470.formName; This:C1470.properties; *)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Initialization of the palett
Function init()
	
	var $format; $icon; $key; $tool; $varName : Text
	var $dummy; $indx; $left; $right : Integer
	var $hOffset : Time
	var $nilPtr; $ptr : Pointer
	var $default; $o; $properties : Object
	var $widget : cs:C1710._widget
	
	$o:={\
		title: ""; \
		picture: ""; \
		background: "?0"; \
		titlePos: 0; \
		titleVisible: 1; \
		iconVisible: 1; \
		style: 3; \
		horMargin: 8; \
		vertMargin: 0; \
		iconOffset: 0; \
		popupMenu: 0; \
		underline: 0\
		}
	
	$properties:=This:C1470.properties
	
	$default:=$properties.default
	$hOffset:=$properties.titleWidth
	
	For each ($widget; $properties.widgets)
		
		$indx+=1
		$tool:="tool_"+String:C10($indx)
		
		$left:=$hOffset
		$right:=$left+$widget.width
		
		If ($widget.form#Null:C1517)
			
			// MARK:Widget
			OBJECT DUPLICATE:C1111(*; "widget"; $tool; $nilPtr; ""; $left; 0; $right; 80; *)
			OBJECT SET SUBFORM:C1138(*; $tool; $widget.form; "")
			
		Else 
			
			// MARK:Button
			OBJECT DUPLICATE:C1111(*; "tool"; $tool; $nilPtr; ""; $left; 0; $right; 80; *)
			
			$icon:="icon_"+String:C10($indx)
			OBJECT DUPLICATE:C1111(*; "icon"; $icon; $nilPtr; ""; $left)
			
			// Set the icon
			$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $icon)
			RESOLVE POINTER:C394($ptr; $varName; $dummy; $dummy)
			$ptr->:=$widget.icon
			
			// Set the format
			$o.title:=$widget.name
			$o.picture:=$varName
			$o.titleVisible:=$default.titleVisible
			$o.iconVisible:=$default.iconVisible
			$o.style:=$default.style
			$o.popupMenu:=Bool:C1537($widget.popup) ? 1+Num:C11($widget.default#Null:C1517) : 0
			
			$format:=""
			
			For each ($key; $o)
				
				$format+=String:C10($o[$key])+";"
				
			End for each 
			
			OBJECT SET FORMAT:C236(*; $tool; $format)
			
			// Set the help tip, if any
			OBJECT SET HELP TIP:C1181(*; $tool; Length:C16($widget.helptip)>0 ? $widget.helptip : Bool:C1537($o.titleVisible) ? "" : $widget.name)
			
		End if 
		
		$widget.index:=$indx
		$widget.tool:=$tool
		
		$hOffset+=$widget.width
		
	End for each 
	
	$properties.maxWidth:=$hOffset+$properties.handleWidth
	$properties.displayedTools:=Num:C11(This:C1470.preferences.data.viewingNumber)
	
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
	// Reload the palett
Function reload()
	
	This:C1470.close()
	This:C1470.properties:=This:C1470.load()
	This:C1470.display()
	
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
	// Displays the Preferences dialog box
Function doSettings()
	
	var $i; $winRfef : Integer
	var $o; $order; $properties : Object
	
	If (This:C1470.motor.infos.headless)
		
		return 
		
	End if 
	
	$winRfef:=Open form window:C675("SETTINGS"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4; *)
	DIALOG:C40("SETTINGS"; This:C1470)
	CLOSE WINDOW:C154
	
	If (Bool:C1537(OK))
		
		$properties:=This:C1470.properties
		This:C1470.preferences.set("auto_hide"; Bool:C1537($properties.autoClose))
		
		If ($properties.autoClose)
			
			$properties.event:=$properties.AUTO
			SET TIMER:C645(-1)
			
		End if 
		
		If (This:C1470.$setPosition#Null:C1517)
			
			This:C1470.position(This:C1470.$setPosition)
			
		End if 
		
		If (Bool:C1537(This:C1470.$modifiedOrder))
			
			$order:={}
			
			For each ($o; $properties.widgets)
				
				$order[$o.name]:=$i
				$i+=1
				
			End for each 
			
			This:C1470.preferences.set("order"; $order)
			
			This:C1470.reload()
			
		End if 
	End if 
	
	OB REMOVE:C1226(This:C1470; "$modifiedOrder")
	OB REMOVE:C1226(This:C1470; "$setPosition")
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Pallet state management
Function collapseExpand($displayed : Integer)
	
	var $collapse : Boolean
	var $bottom; $left; $offset; $right; $top; $visibleTools : Integer
	var $wantedWidth : Integer
	var $form : Object
	var $widget : cs:C1710._widget
	var $coord : cs:C1710.coord
	
	$form:=This:C1470.properties
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; $form.window)
	$coord:=cs:C1710.coord.new($left; $top; $right; $bottom)
	
	$offset:=$form.offset+1  //+5
	
	$collapse:=$displayed=-1
	
	If ($collapse) | (Count parameters:C259=0)
		
		If ($form.page=1)
			
			If ($coord.width>$form.maxWidth)
				
				$offset:=$form.maxWidth-$coord.width
				$coord.right+=$offset
				
				OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
				OBJECT SET VISIBLE:C603(*; "tool_@"; True:C214)
				
			Else 
				
				// Collapse
				OBJECT MOVE:C664(*; "@.Movable"; -$coord.width+$offset; 0)
				OBJECT SET VISIBLE:C603(*; "tool_@"; False:C215)
				
				$coord.right:=$coord.left+$offset
				$coord.left:=0
				
			End if 
			
		Else 
			
			If ($coord.width<$form.maxWidth)
				
				// Expand
				$offset:=$form.maxWidth-$coord.width
				OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
				OBJECT SET VISIBLE:C603(*; "tool_@"; True:C214)
				
				$coord.left-=$offset
				
			Else 
				
				// Collapse
				$offset:=$coord.width-$offset
				OBJECT MOVE:C664(*; "@.Movable"; -$offset; 0)
				
				$coord.left+=$offset
				OBJECT SET VISIBLE:C603(*; "tool_@"; False:C215)
				
			End if 
		End if 
		
	Else 
		
		If ($displayed>$form.widgets.length)\
			 | ($form.widgets.length=0)
			
			$displayed:=$form.widgets.length>0 ? $form.widgets.length : 1
			
		End if 
		
		$visibleTools:=0
		$wantedWidth:=0
		
		For each ($widget; $form.widgets)
			
			$visibleTools+=1
			
			If ($visibleTools<=$displayed)
				
				$wantedWidth+=$widget.width
				
			Else 
				
				break
				
			End if 
		End for each 
		
		$wantedWidth+=$form.offset
		$wantedWidth:=$wantedWidth>$form.maxWidth ? $form.maxWidth : $wantedWidth
		$wantedWidth:=$wantedWidth<36 ? 36 : $wantedWidth
		
		If ($form.page=1)
			
			$offset:=$wantedWidth-$coord.width
			$coord.right+=$offset
			
		Else 
			
			$offset:=$wantedWidth-$coord.width
			$coord.left-=$offset
			
		End if 
		
		OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
		
		For each ($widget; $form.widgets)
			
			OBJECT SET VISIBLE:C603(*; $widget.tool; $widget.index<=$displayed)
			
		End for each 
	End if 
	
	// Fix the window rect
	$coord.applyToWindow($form.window)
	
	// Adjust the background position
	$coord.left:=0
	$coord.top:=0
	$coord.applyToWidget("_background")
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Palett menu
Function doMenu()
	
	var $item; $widget : Object
	var $c : Collection
	var $menu; $sub : cs:C1710.menu
	
	$menu:=cs:C1710.menu.new()
	
	$menu.append(":xliff:About"; "about")\
		.line()\
		.append(":xliff:settings"; "settings")\
		.icon("/.PRODUCT_RESOURCES/Images/ObjectIcons/Icon_924.png")\
		.line()
	
	For each ($widget; This:C1470.properties.widgets)
		
		If ($widget.tools.length<=1)
			
			$menu.append($widget.name; $widget.name+"/"+$widget.default)\
				.icon("/.PRODUCT_RESOURCES/Images/ObjectIcons/Icon_606.png")
			
		Else 
			
			$sub:=cs:C1710.menu.new()
			
			For each ($item; $widget.tools)
				
				If (Length:C16(String:C10($item.name))=0)
					
					continue
					
				End if 
				
				If ($item.name="-")
					
					$sub.line()
					
				Else 
					
					$sub.append($item.name; $widget.name+"/"+$item.method)
					
				End if 
			End for each 
			
			$menu.append($widget.name; $sub)\
				.icon("/.PRODUCT_RESOURCES/Images/ObjectIcons/Icon_606.png")
			
		End if 
	End for each 
	
	$menu.line()\
		.append(":xliff:closePalette"; "close")\
		.icon("/.PRODUCT_RESOURCES/Images/WatchIcons/Watch_851.png")
	
	If ($menu.popup().selected)
		
		$c:=Split string:C1554($menu.choice; "/")
		
		Case of 
				
				//______________________________________________________
			: ($menu.choice="about")
				
				This:C1470.doAbout()
				
				//______________________________________________________
			: ($menu.choice="settings")
				
				This:C1470.doSettings()
				
				//______________________________________________________
			: ($menu.choice="close")
				
				This:C1470.close()
				
				//______________________________________________________
			: ($c.length>1)
				
				// Calling a component item
				
				$item:={\
					method: $c[1]; \
					widget: This:C1470.properties.widgets.query("name= :1"; $c[0]).pop()\
					}
				
				$item.success:=This:C1470.execute($item)
				
				//______________________________________________________
			Else 
				
				// Calling the component
				$item:={\
					method: $menu.choice; \
					widget: $menu.getData($menu.choice)\
					}
				
				$item.success:=This:C1470.execute($item)
				
				//______________________________________________________
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function position($position : Text)
	
	var $bottom; $height; $left; $right; $top; $width : Integer
	var $screen : Object
	var $coord : cs:C1710.coord
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; Form:C1466.window)
	$coord:=cs:C1710.coord.new($left; $top; $right; $bottom)
	$width:=$coord.width
	$height:=$coord.height
	
	// Get current screen
	For each ($screen; strip.env.screens)
		
		If ($coord.left>=$screen.coordinates.left)\
			 & ($coord.left<=$screen.coordinates.right)
			
			break
			
		End if 
	End for each 
	
	Case of 
			
			//……………………………………………………………………………………………
		: ($position="Top@")
			
			$coord.top:=$screen.workArea.top+Tool bar height:C1016
			$coord.bottom:=$coord.top+$height
			
			//……………………………………………………………………………………………
		: ($position="Bottom@")
			
			$coord.bottom:=$screen.workArea.bottom
			$coord.top:=$coord.bottom-$height
			
			//……………………………………………………………………………………………
	End case 
	
	Case of 
			
			//……………………………………………………………………………………………
		: ($position="@Left")
			
			$coord.left:=$screen.workArea.left
			$coord.right:=$coord.left+$width
			This:C1470.properties.page:=1
			
			//……………………………………………………………………………………………
		: ($position="@Right")
			
			$coord.right:=$screen.workArea.right
			$coord.left:=$coord.right-$width
			This:C1470.properties.page:=2
			
			//……………………………………………………………………………………………
	End case 
	
	This:C1470.preferences.set("palette"; $coord)
	
	SET WINDOW RECT:C444($coord.left; $coord.top; $coord.right; $coord.bottom; This:C1470.properties.window)
	FORM GOTO PAGE:C247(This:C1470.properties.page)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Calling a component
Function execute($e : Object) : Boolean
	
	var $method : Text
	var $nil; $ptr : Pointer
	var $widget : Object
	
	$widget:=$e.widget
	
	Case of 
			
			//______________________________________________________
		: ($e.method="default")
			
			$method:=$widget.default
			
			//______________________________________________________
		: ($e.method="onDrop")
			
			$method:=$widget.ondrop
			
			//______________________________________________________
		Else 
			
			// Tool
			$method:=$e.method
			
			//______________________________________________________
	End case 
	
	If (Length:C16($method)=0)\
		 | ($widget.handler=Null:C1517)
		
		ERROR:=-15002
		return False:C215
		
	End if 
	
	CLEAR VARIABLE:C89(ERROR)
	$widget.handler.call(Null:C1517; $method).call(Null:C1517; $widget)
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
			// CLOSE WINDOW
			
			//______________________________________________________
	End case 
	
	// Show or hide the visual effect of drag & drop.
	OBJECT SET VISIBLE:C603(*; "hightlight"; $accept)
	
	// Set the timer for hide the visual effect if user chooses to don't drop the dragged elements
	Form:C1466.event:=This:C1470.properties.DROP
	SET TIMER:C645(20)
	
	return $accept ? 0 : -1