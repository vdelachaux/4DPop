property file; manifest : Object
property name; default; ondrop; helptip; tool; form; infos; copyright : Text
property help; plist : 4D:C1709.File
property icon : Picture
property popup; visible : Boolean
property handler : 4D:C1709.Function
property tools : Collection
property order : Integer
property index : Integer
property width : Integer

Class constructor($component : Object; $manifest : Object)
	
	If ($component=Null:C1517)
		
		return 
		
	End if 
	
	This:C1470.file:=$component
	This:C1470.manifest:=OB Copy:C1225($manifest)  // Keep the original manifest
	This:C1470.name:=$component.name
	This:C1470.help:=$component.file($component.name+".htm")
	This:C1470.helptip:=""
	This:C1470.icon:=Null:C1517
	This:C1470.default:=String:C10($manifest.default)
	This:C1470.ondrop:=String:C10($manifest.ondrop)
	This:C1470.popup:=Bool:C1537($manifest.popup)
	This:C1470.handler:=Null:C1517
	This:C1470.tools:=[]
	This:C1470.order:=0
	This:C1470.index:=0
	This:C1470.width:=70
	
	If ($manifest.handler#Null:C1517)
		
		This:C1470.handler:=Formula from string:C1601($manifest.handler).call()
		
	End if 
	
	If ($manifest.initproc#Null:C1517)
		
		If (This:C1470.handler#Null:C1517)
			
			This:C1470.handler.call(Null:C1517; $manifest.initproc).call()
			
		End if 
	End if 
	
	var $key : Text
	For each ($key; $manifest)
		
		Case of 
				
				// ______________________________________________________
			: ($key="handler")\
				 | ($key="initproc")
				
				// Already handled
				
				// ______________________________________________________
			: ($key="widget")
				
				This:C1470.form:=$manifest[$key].name
				This:C1470.width:=$manifest[$key].width
				
				// ______________________________________________________
			: ($key="name")\
				 | ($key="helptip")
				
				This:C1470[$key]:=$manifest[$key]
				
				If (Position:C15(":xliff:"; $manifest[$key])#1)
					
					continue
					
				End if 
				
				If (This:C1470.handler=Null:C1517)
					
					// FIXME: ERROR
					continue
					
				End if 
				
				This:C1470[$key]:=This:C1470.handler.call(Null:C1517; ":C991($1)").call(Null:C1517; Delete string:C232($manifest[$key]; 1; 7))
				
				// ______________________________________________________
			: ($key="media")
				
				continue
				
				// ______________________________________________________
			: ($key="tools")
				
				If (Value type:C1509($manifest.tools)=Is object:K8:27)
					
					This:C1470.default:=This:C1470.default || $manifest.tools.method
					This:C1470.tools.push({method: $manifest.tools.method})
					
					OB REMOVE:C1226($manifest; "tools")
					
				Else 
					
					If (This:C1470.handler#Null:C1517)
						
						If (($manifest.tools#Null:C1517)\
							 && ($manifest.tools.length>0))
							
							
							This:C1470.popup:=True:C214
							
							var $tool : Object
							
							For each ($tool; $manifest.tools)
								
								var $item : Text
								
								For each ($item; $tool)
									
									Case of 
											
											// ………………………………………………………………………………
										: ($item="name")
											
											If ($item="-")\
												 || ($item="(-")\
												 || (Position:C15(":xliff:"; $tool.name)#1)
												
												continue
												
											End if 
											
											If (This:C1470.handler#Null:C1517)
												
												$tool.name:=This:C1470.handler.call(Null:C1517; ":C991($1)").call(Null:C1517; Delete string:C232($tool.name; 1; 7))
												
											End if 
											
											// ………………………………………………………………………………
									End case 
								End for each 
								
								This:C1470.tools.push($tool)
								
							End for each 
						End if 
					End if 
				End if 
				
				// ______________________________________________________
			Else 
				
				This:C1470[$key]:=$manifest[$key]
				
				// ______________________________________________________
		End case 
	End for each 
	
	var $path : Text
	For each ($path; [\
		"logo.svg"; \
		"logo.png"; \
		"Resources/logo.svg"; \
		"Resources/logo.png"])
		
		var $file : 4D:C1709.File:=$component.file($path)
		
		If (Not:C34($file.exists))
			
			continue
			
		End if 
		
		If ($file.extension=".svg")\
			 || ($file.extension=".png")
			
			break
			
		End if 
	End for each 
	
	This:C1470.icon:=This:C1470.getIcon($file; 48)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create an icon from the media
Function getIcon($file : 4D:C1709.File; $size : Integer) : Picture
	
	var $media : Picture
	
	If (Not:C34($file.exists))
		
		$file:=File:C1566("/.PRODUCT_RESOURCES/Images/Plugin.png")
		
	End if 
	
	If ($file.exists)
		
		var $svg:=cs:C1710.svg.new()
		
		$svg.square($size).radius(10).clipPath("mask")
		
		// Place logo
		If ($file.extension=".svg")  // link
			
			$svg.square($size).color("darkgray")  // Ensure a colored background
			$svg.image($file).width($size).height($size)
			
		Else   // Embedded 
			
			READ PICTURE FILE:C678($file.platformPath; $media)
			var $width : Integer
			PICTURE PROPERTIES:C457($media; $width; $width)
			$svg.image($media)/*.opacity(0.8)*/.scale($SIZE/$width)
			
		End if 
		
/*
If (Is macOS)\
& ($file.fullName#"Plugin.png")
		
$svg.linearGradient("liquidGlass"; ""; ""; {rotation: 90})
$svg.Square($size).radius(10).color("url(#liquidGlass)").fillOpacity(0.3).strokeWidth(1).strokeOpacity(0.5).position(0.5; 0.5)
		
End if 
*/
		
		return $svg.picture()
		
	End if 