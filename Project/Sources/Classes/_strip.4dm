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
	
	// Loading compatible components
	This:C1470.properties:=This:C1470.load()
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Loading compatible components
Function load() : Object
	
	var $item; $key : Text
	var $component; $manifest; $order; $plist; $result; $tool : Object
	var $components : Collection
	var $file : 4D:C1709.File
	var $widget : cs:C1710._widget
	
	$plist:=Folder:C1567(fk database folder:K87:14).file("Info.plist").getAppInfo()
	
	$result:={\
		/* ?? */leftOffset: 25; \
		/* ?? */rightOffset: 25; \
		offset: 31; \
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
		widgets: []\
		}
	
	$components:=This:C1470.getTools()
	
	If ($components.length=0)  // No components
		
		return $result
		
	End if 
	
	$order:=This:C1470.preferences.get("order")
	
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
			
			// MARK:###### TEMPO #######
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
		
		// MARK:###### TEMPO #######
		$widget.lproj:=This:C1470._o_lproj($component; $result.language)
		
		For each ($key; $manifest)
			
			Case of 
					
					//______________________________________________________
				: ($key="name")\
					 | ($key="helptip")
					
					$widget[$key]:=$manifest[$key]
					
					If (Position:C15(":xliff:"; $manifest[$key])#1)
						
						continue
						
					End if 
					
					$widget[$key]:=$widget.lproj#Null:C1517 ? This:C1470._o_getLocalizedString(String:C10($manifest[$key]); $widget.lproj) : $widget[$key]
					
					//______________________________________________________
				: ($key="tools")
					
					If (Value type:C1509($manifest.tools)=Is object:K8:27)
						
						$widget.default:=$widget.default || $manifest.tools.method
						$widget.tools.push({method: $manifest.tools.method})
						
					Else 
						
						If (($manifest.tools#Null:C1517) && ($manifest.tools.length>0))
							
							$widget.popup:=True:C214
							
							For each ($tool; $manifest.tool || $manifest.tools)
								
								For each ($item; $tool)
									
									Case of 
											
											//………………………………………………………………………………
										: ($item="name")
											
											If (Position:C15(":xliff:"; $tool.name)#1)
												
												continue
												
											End if 
											
											$tool.name:=$widget.lproj#Null:C1517 ? This:C1470._o_getLocalizedString(String:C10($tool.name); $widget.lproj) : $tool.name
											
											//………………………………………………………………………………
										: ($item="picture")
											
											$file:=$component.file("Resources/"+$tool.picture)
											
											If ($file.exists)
												
												$tool.picture_path:=$file.platformPath
												
											End if 
											
											//………………………………………………………………………………
									End case 
								End for each 
								
								$widget.tools.push($tool)
								
							End for each 
						End if 
					End if 
					
					//______________________________________________________
			End case 
		End for each 
		
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
			
		End if 
	End for each 
	
	$result.widgets:=$result.widgets.orderBy("order")
	
	$result.maxWidth:=$result.widgets.length>0\
		 ? $result.cellWidth*$result.widgets.length\
		 : $result.cellWidth
	
	$result.maxWidth+=$result.offset
	
	return $result
	
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
		
		$coord.left:=Screen width:C187-$width
		$coord.right:=Screen width:C187
		
	End if 
	
	If ($coord.bottom>Screen height:C188)
		
		$coord.bottom:=Screen height:C188
		$height:=$coord.bottom-$coord.top
		$coord.top:=$coord.bottom-$height
		
	End if 
	
	If (Count screens:C437=1)
		
		If ($coord.left<0)
			
			$coord.left:=0
			$coord.right:=$width
			
		End if 
		
		If ($coord.right>Screen width:C187)
			
			$coord.right:=Screen width:C187
			
		End if 
	End if 
	
	This:C1470.properties.window:=Open window:C153($coord.left; $coord.top; $coord.right; $coord.bottom; -(Plain dialog box:K34:4+Texture appearance:K34:17+_o_Compositing mode:K34:18))
	DIALOG:C40(This:C1470.formName; This:C1470.properties; *)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Initialization of the palett
Function init()
	
	var $button; $format; $icon; $key; $varName : Text
	var $dummy; $indx : Integer
	var $nilPtr; $ptr : Pointer
	var $o; $widget : Object
	
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
	
	For each ($widget; This:C1470.properties.widgets)
		
		$indx+=1
		$button:="tool_"+String:C10($indx)
		$icon:="icon_"+String:C10($indx)
		
		If ($indx>1)
			
			OBJECT DUPLICATE:C1111(*; "tool_"+String:C10($indx-1); $button; $nilPtr; ""; This:C1470.properties.cellWidth)
			OBJECT DUPLICATE:C1111(*; "icon_"+String:C10($indx-1); $icon; $nilPtr; ""; This:C1470.properties.cellWidth)
			
		End if 
		
		$widget.index:=$indx
		$widget.button:=$button
		
		// Set the icon
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; $icon)
		RESOLVE POINTER:C394($ptr; $varName; $dummy; $dummy)
		$ptr->:=$widget.icon
		
		// Set the format
		$o.title:=$widget.name
		$o.picture:=$varName
		$o.titleVisible:=This:C1470.properties.default.titleVisible
		$o.iconVisible:=This:C1470.properties.default.iconVisible
		$o.style:=This:C1470.properties.default.style
		$o.popupMenu:=Bool:C1537($widget.popup) ? 1+Num:C11($widget.default#Null:C1517) : 0
		
		$format:=""
		
		For each ($key; $o)
			
			$format+=String:C10($o[$key])+";"
			
		End for each 
		
		OBJECT SET FORMAT:C236(*; $button; $format)
		
		// Set the help tip, if any
		OBJECT SET HELP TIP:C1181(*; $button; Length:C16($widget.helptip)>0 ? $widget.helptip : Bool:C1537($o.titleVisible) ? "" : $widget.name)
		
		//OBJECT SET VISIBLE(*; $button; True)
		
	End for each 
	
	This:C1470.properties.displayedTools:=Num:C11(This:C1470.preferences.data.viewingNumber)
	
	//If (Not(This.properties.autoClose))
	
	//This.collapseExpand(This.properties.displayedTools)
	
	//End if 
	
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
	var $o; $order : Object
	
	If (This:C1470.motor.infos.headless)
		
		return 
		
	End if 
	
	$winRfef:=Open form window:C675("SETTINGS"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4; *)
	DIALOG:C40("SETTINGS"; This:C1470)
	CLOSE WINDOW:C154
	
	If (Bool:C1537(OK))
		
		This:C1470.preferences.set("auto_hide"; Bool:C1537(This:C1470.properties.autoClose))
		
		If (This:C1470.properties.autoClose)
			
			This:C1470.properties.event:=This:C1470.properties.AUTO
			SET TIMER:C645(-1)
			
		End if 
		
		If (This:C1470.$setPosition#Null:C1517)
			
			This:C1470.position(This:C1470.$setPosition)
			
		End if 
		
		If (Bool:C1537(This:C1470.$modifiedOrder))
			
			$order:={}
			
			For each ($o; This:C1470.properties.widgets)
				
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
	
	var $bottom; $left; $offset; $right; $top : Integer
	var $form : Object
	var $widget : cs:C1710._widget
	var $coord : cs:C1710.coord
	
	$form:=This:C1470.properties
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; $form.window)
	$coord:=cs:C1710.coord.new($left; $top; $right; $bottom)
	
	$offset:=$form.offset+5
	
	$form.maxWidth:=$form.widgets.length>0\
		 ? $form.cellWidth*$form.widgets.length\
		 : $form.cellWidth
	
	$form.maxWidth+=$form.offset
	
	If (Count parameters:C259=0)
		
		If ($form.page=1)
			
			If ($coord.width<$form.maxWidth)
				
				// Expand
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
		
		$form.maxWidth:=(($form.cellWidth*$displayed)+$offset)
		
		If ($form.page=1)
			
			$offset:=$form.maxWidth-$coord.width
			$coord.right+=$offset
			
		Else 
			
			$offset:=$form.maxWidth-$coord.width
			$coord.left-=$offset
			
		End if 
		
		OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
		
		For each ($widget; $form.widgets)
			
			OBJECT SET VISIBLE:C603(*; $widget.button; $widget.index<=$displayed)
			
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
	var $menu; $sub : cs:C1710.menu
	
	$menu:=cs:C1710.menu.new()
	
	$menu.append(":xliff:About"; "about")\
		.line()\
		.append(":xliff:settings"; "settings")\
		.icon("/.PRODUCT_RESOURCES/Images/ObjectIcons/Icon_924.png")\
		.line()
	For each ($widget; This:C1470.properties.widgets)
		
		If ($widget.tools.length<=1)
			
			$menu.append($widget.name; $widget.default)\
				.icon("/.PRODUCT_RESOURCES/Images/ObjectIcons/Icon_606.png")\
				.setData($widget.name; $widget)
			
		Else 
			
			$sub:=cs:C1710.menu.new()
			
			For each ($item; $widget.tools)
				
				If (Length:C16(String:C10($item.name))=0)
					
					continue
					
				End if 
				
				If ($item.name="-")
					
					$sub.line()
					
				Else 
					
					$sub.append($item.name; $item.method)
					
				End if 
				
				$sub.setData($widget.name; $widget)
				
			End for each 
			
			$menu.append($widget.name; $sub)\
				.icon("/.PRODUCT_RESOURCES/Images/ObjectIcons/Icon_606.png")
			
		End if 
	End for each 
	
	$menu.line()\
		.append(":xliff:closePalette"; "close")\
		.icon("/.PRODUCT_RESOURCES/Images/WatchIcons/Watch_851.png")
	
	If ($menu.popup().selected)
		
		Case of 
				
				//______________________________________________________
			: ($menu.choice="about")
				
				This:C1470.doAbout(Form:C1466)
				
				//______________________________________________________
			: ($menu.choice="settings")
				
				This:C1470.doSettings(Form:C1466)
				
				//______________________________________________________
			: ($menu.choice="close")
				
				This:C1470.close()
				
				//______________________________________________________
			Else 
				
				// Calling the component
				$item:={\
					method: $menu.choice; \
					widget: $menu.getData($widget.name)\
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
	
	If (Length:C16($method)=0)
		
		ERROR:=-15002
		return False:C215
		
	End if 
	
	CLEAR VARIABLE:C89(ERROR)
	
	If ($widget.handler#Null:C1517)
		
		$widget.handler.call(Null:C1517; $method).call(Null:C1517; $widget)
		return True:C214
		
	End if 
	
	// MARK:###### TEMPO #######
	If (Position:C15("("; $method)=0)
		
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; String:C10($e.objectName))
		
		If (Not:C34(Is nil pointer:C315($ptr)))
			
			EXECUTE METHOD:C1007($method; *; $ptr)
			
		Else 
			
			EXECUTE METHOD:C1007($method; *; $nil)
			
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
			// CLOSE WINDOW
			
			//______________________________________________________
	End case 
	
	// Show or hide the visual effect of drag & drop.
	OBJECT SET VISIBLE:C603(*; "hightlight"; $accept)
	
	// Set the timer for hide the visual effect if user chooses to don't drop the dragged elements
	Form:C1466.event:=This:C1470.properties.DROP
	SET TIMER:C645(20)
	
	return $accept ? 0 : -1
	
	// MARK:-OBSOLETE
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Component localization folder
Function _o_lproj($component : Object; $language : Text) : 4D:C1709.Folder
	
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
	// Returns a localized string from the component
Function _o_getLocalizedString($string : Text; $lproj : 4D:C1709.Folder) : Text
	
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