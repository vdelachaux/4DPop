Class constructor($component : Object; $manifest : Object)
	
	var $item; $key : Text
	var $tool : Object
	var $file : 4D:C1709.File
	
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
	This:C1470.button:=""
	This:C1470.index:=0
	
	If ($manifest.handler#Null:C1517)
		
		This:C1470.handler:=Formula from string:C1601($manifest.handler).call()
		OB REMOVE:C1226($manifest; "handler")
		
	End if 
	
	If ($manifest.initproc#Null:C1517)
		
		If (This:C1470.handler#Null:C1517)
			
			This:C1470.handler.call(Null:C1517; $manifest.initproc).call()
			
		Else 
			
			// MARK:###### TEMPO #######
			Formula from string:C1601($manifest.initproc).call()
			
		End if 
		
		OB REMOVE:C1226($manifest; "initproc")
		
	End if 
	
	// MARK:###### TEMPO #######
	If ($manifest.tool#Null:C1517)
		
		$manifest.tools:=$manifest.tool
		
	End if 
	
	This:C1470.tool:=This:C1470.tools
	
	For each ($key; $manifest)
		
		Case of 
				
				//______________________________________________________
			: ($key="name")\
				 | ($key="helptip")
				
				This:C1470[$key]:=$manifest[$key]
				
				If (Position:C15(":xliff:"; $manifest[$key])#1)
					
					continue
					
				End if 
				
				If (This:C1470.handler#Null:C1517)
					
					This:C1470[$key]:=This:C1470.handler.call(Null:C1517; ":C991($1)").call(Null:C1517; Delete string:C232($manifest[$key]; 1; 7))
					
					// MARK:###### TEMPO #######
					OB REMOVE:C1226($manifest; $key)
					
				End if 
				
				//______________________________________________________
			: ($key="media")
				
				This:C1470.icon:=This:C1470.getIcon($component.file("Resources/"+String:C10($manifest[$key])); 48)
				This:C1470.picture:=This:C1470.getIcon($component.file("Resources/"+String:C10($manifest[$key])); 48; True:C214)
				
				//______________________________________________________
			: ($key="tools")
				
				If (Value type:C1509($manifest.tools)=Is object:K8:27)
					
					This:C1470.default:=This:C1470.default || $manifest.tools.method
					This:C1470.tools.push({method: $manifest.tools.method})
					
					OB REMOVE:C1226($manifest; "tools")
					
				Else 
					
					If (This:C1470.handler#Null:C1517)
						
						If (($manifest.tools#Null:C1517) && ($manifest.tools.length>0))
							
							This:C1470.popup:=True:C214
							
							For each ($tool; $manifest.tool || $manifest.tools)
								
								For each ($item; $tool)
									
									Case of 
											
											//………………………………………………………………………………
										: ($item="name")
											
											If (Position:C15(":xliff:"; $tool.name)#1)
												
												continue
												
											End if 
											
											If (This:C1470.handler#Null:C1517)
												
												$tool.name:=This:C1470.handler.call(Null:C1517; ":C991($1)").call(Null:C1517; Delete string:C232($tool.name; 1; 7))
												
											End if 
											
											//………………………………………………………………………………
										: ($item="picture")
											
											$file:=$component.file("Resources/"+$tool.picture)
											
											If ($file.exists)
												
												$tool.picture_path:=$file.platformPath
												
											End if 
											
											//………………………………………………………………………………
									End case 
								End for each 
								
								This:C1470.tools.push($tool)
								
							End for each 
						End if 
						
						// MARK:###### TEMPO #######
						OB REMOVE:C1226($manifest; "tools")
						
					End if 
				End if 
				
				//______________________________________________________
			Else 
				
				This:C1470[$key]:=$manifest[$key]
				
				//______________________________________________________
		End case 
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create an icon from a media
Function getIcon($file : 4D:C1709.File; $iconSize : Integer; $crop : Boolean) : Picture
	
	var $image; $mask; $rect; $svg : Text
	var $icon; $pict : Picture
	var $height; $width : Integer
	
	If (Not:C34($file.exists))
		
		$file:=File:C1566("/.PRODUCT_RESOURCES/Images/Plugin.png")
		
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
	
	
	