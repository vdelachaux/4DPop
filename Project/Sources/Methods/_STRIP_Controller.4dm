//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : Méthode formulaire : 4DPop_ButtonPalette
// Created 01/12/06 by Vincent de Lachaux
// ----------------------------------------------------
// Modified by vdl  (04/06/08)
// Adds the management of the number of tools to display when the palette is open
// ----------------------------------------------------
// Modified by vdl (01/07/08)
// Workaround for ACI0058409, ACI0058410 & ACI0058411
// ----------------------------------------------------
// Modified by Vincent de Lachaux (18/05/09)
// Add Automatic Collapse/Expand
// ----------------------------------------------------
// Modified by Vincent de Lachaux (05/01/12)
// V13 refactoring
// ----------------------------------------------------
// Modified #9-6-2014 by Vincent de Lachaux
// Management id
// ----------------------------------------------------
// Modified #06-02-2023 by Vincent de Lachaux
// v20 refactoring
// ----------------------------------------------------
var $t : Text
var $visible : Boolean
var $bottom; $height; $i; $l; $left; $mouseButton : Integer
var $offset; $origin; $right; $screenIndex; $screenNumber; $screenWidth : Integer
var $top; $visibleTools; $wantedWidth; $width; $windowWidth : Integer
var $x; $y : Integer
var $e : Object

$e:=FORM Event:C1606

// MARK:Form Method
If ($e.objectName=Null:C1517)  // <== FORM METHOD
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			GET WINDOW RECT:C443($left; $top; $right; $bottom; Form:C1466.window)
			Form:C1466.page:=1+Num:C11($left#0)
			
			FORM GOTO PAGE:C247(Form:C1466.page)
			
			If (Form:C1466.widgets.length>0)
				
				OBJECT SET VISIBLE:C603(*; "Animated@"; False:C215)
				Form:C1466.maxWidth:=((Form:C1466.cellWidth*Form:C1466.widgets.length)+Form:C1466.offset)
				
				SET TIMER:C645(-1)
				
			Else 
				
				OBJECT SET VISIBLE:C603(*; "Animated@"; True:C214)
				Form:C1466.maxWidth:=Form:C1466.cellWidth+Form:C1466.offset
				
				SET TIMER:C645(100)
				
			End if 
			
			If (Form:C1466.plist.CFBundleDisplayName#Null:C1517)
				
				Form:C1466.version:=String:C10(Form:C1466.plist.CFBundleDisplayName)
				
				$e.version:=String:C10(Form:C1466.plist.CFBundleShortVersionString)
				
				If (Length:C16($e.version)#0)
					
					Form:C1466.version+="\r"+($e.version#"DEV" ? "v" : "")+$e.version
					
				End if 
				
			Else 
				
				// Display database name
				Form:C1466.version:=File:C1566(Structure file:C489; fk platform path:K87:2).name
				
			End if 
			
			Form:C1466.colorScheme:=FORM Get color scheme:C1761
			
			// Activation of non-configurable events for the form
			ARRAY LONGINT:C221($events; 0x0000)
			APPEND TO ARRAY:C911($events; On Alternative Click:K2:36)
			APPEND TO ARRAY:C911($events; On Long Click:K2:37)
			OBJECT SET EVENTS:C1239(*; ""; $events; Enable events others unchanged:K42:38)
			
			component.init()
			
			//______________________________________________________
		: ($e.code=On Outside Call:K2:11)
			
			component.close()
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			SET TIMER:C645(0)
			
			If (FORM Get color scheme:C1761#Form:C1466.colorScheme)
				
				Form:C1466.colorScheme:=FORM Get color scheme:C1761
				REDRAW WINDOW:C456(This:C1470.properties.window)
				
			End if 
			
			If (Form:C1466.event=0)
				
				// Periodically seeing if the palette must be hidden or visible
				// According to the origin of the frontmost process
				PROCESS PROPERTIES:C336(Window process:C446(Frontmost window:C447); $t; $l; $l; $visible; $l; $origin)
				
				If ($origin=Design process:K36:9)
					
					If ($visible & Bool:C1537(Form:C1466.hidden))
						
						// Make visible the palette
						Form:C1466.hidden:=False:C215
						SHOW PROCESS:C325(Form:C1466.process)
						
					End if 
					
					If (Form:C1466.mdi)
						
						// Replace in the window MDI, if resized
						GET WINDOW RECT:C443($left; $top; $right; $bottom; Form:C1466.window)
						
						If ($bottom>Screen height:C188)
							
							$height:=$bottom-$top
							$bottom:=Screen height:C188
							$top:=$bottom-$height
							
							SET WINDOW RECT:C444($left; $top; $right; $bottom; Form:C1466.window)
							
						End if 
					End if 
					
				Else 
					
					If ($visible)\
						 & (Not:C34(Bool:C1537(Form:C1466.hidden)))
						
						// Hide the palette
						Form:C1466.hidden:=True:C214
						HIDE PROCESS:C324(Form:C1466.process)
						
						component.collapseExpand(0)
						
					End if 
				End if 
				
				SET TIMER:C645(50)
				
			Else 
				
				$e.event:=Form:C1466.event
				Form:C1466.event:=0
				
				Case of 
						
						//………………………………………………………………………………………………………………
					: ($e.event=1)  // The user is trying to resize the window
						
						SET CURSOR:C469(9010)
						GET MOUSE:C468($x; $y; $mouseButton; *)
						GET WINDOW RECT:C443($left; $top; $right; $bottom; Form:C1466.window)
						$width:=$right-$left
						
						If ($mouseButton#0)  // In progress
							
							If (FORM Get current page:C276=1)
								
								$offset:=$x-$right+5
								$wantedWidth:=$right+$offset
								
								Case of 
										
										//…………………………………………………………………………
									: ($wantedWidth<Form:C1466.offset)
										
										//…………………………………………………………………………
									: ($wantedWidth>Form:C1466.maxWidth)
										
										//…………………………………………………………………………
									Else 
										
										$right:=$right+$offset
										OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
										
										//…………………………………………………………………………
								End case 
								
							Else 
								
								$offset:=$left-$x+5
								$wantedWidth:=$right-$left+$offset
								
								Case of 
										
										//…………………………………………………………………………
									: ($wantedWidth<Form:C1466.offset)
										
										//…………………………………………………………………………
									: ($wantedWidth>Form:C1466.maxWidth)
										
										//…………………………………………………………………………
									Else 
										
										$left:=$left-$offset
										OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
										
										//…………………………………………………………………………
								End case 
							End if 
							
							$visibleTools:=($wantedWidth\Form:C1466.cellWidth)+Num:C11(($width%Form:C1466.cellWidth)>0)
							
							Form:C1466.event:=1  // Continue
							
						Else   // It's all over
							
							$visibleTools:=($width\Form:C1466.cellWidth)+Num:C11(($width%Form:C1466.cellWidth)>50)
							$wantedWidth:=(Form:C1466.cellWidth*$visibleTools)+Form:C1466.offset
							$wantedWidth:=$wantedWidth>Form:C1466.maxWidth ? Form:C1466.maxWidth : $wantedWidth
							
							$offset:=$wantedWidth-$width
							
							If (FORM Get current page:C276=1)
								
								$right:=$right+$offset
								OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
								
							Else 
								
								$left:=$left-$offset
								OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
								
							End if 
						End if 
						
						// Keep visible only the wanted tools {
						OBJECT SET VISIBLE:C603(*; "toolButton_@"; False:C215)
						
						If (Form:C1466.widgets.length>0)
							
							For ($i; 1; $visibleTools; 1)
								
								OBJECT SET VISIBLE:C603(*; "toolButton_"+String:C10($i); True:C214)
								
							End for 
						End if   // }
						
						SET WINDOW RECT:C444($left; $top; $right; $bottom; Form:C1466.window)
						
						//………………………………………………………………………………………………………………
					: ($e.event=99)  // End drag
						
						// NOTHING MORE TO DO
						
						//………………………………………………………………………………………………………………
					: ($e.event=999)  // Automatic collapse/expand
						
						// #12-12-2013 GET WINDOW RECT returns bad coordinates, for this particular window, on Windows only.
						// This causes a flickering effect.
						GET MOUSE:C468($x; $y; $mouseButton)
						OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
						
						If ($x>=0)\
							 & ($x<=$width)\
							 & ($y>=0)\
							 & ($y<=$height)
							
							Form:C1466.event:=Form:C1466.autoClose ? 999 : 0
							
						Else 
							
							component.collapseExpand(0)
							
						End if 
						
						//………………………………………………………………………………………………………………
					: ($e.event=8858)
						
						GET WINDOW RECT:C443($left; $top; $right; $bottom; Form:C1466.window)
						OBJECT GET SUBFORM CONTAINER SIZE:C1148($windowWidth; $height)
						
						$screenNumber:=Count screens:C437
						ARRAY LONGINT:C221($_screenLeft; $screenNumber)
						ARRAY LONGINT:C221($_screenTop; $screenNumber)
						ARRAY LONGINT:C221($_screenRight; $screenNumber)
						ARRAY LONGINT:C221($_screenBottom; $screenNumber)
						
						For ($i; 1; $screenNumber; 1)
							
							SCREEN COORDINATES:C438($_screenLeft{$i}; $_screenTop{$i}; $_screenRight{$i}; $_screenBottom{$i}; $i)
							
						End for 
						
						// Multi-screens management
						For ($i; 1; $screenNumber; 1)
							
							If ($left>=$_screenLeft{$i})\
								 & ($left<=$_screenRight{$i})
								
								$screenIndex:=$i
								break
								
							End if 
						End for 
						
						$screenWidth:=($_screenRight{$screenIndex}-$_screenLeft{$screenIndex})
						
						Case of 
								
								//………………………………………………………
							: ($left=$_screenLeft{$screenIndex})
								
								//………………………………………………………
							: ($left>=(Abs:C99($screenWidth)/3))
								
								SET CURSOR:C469
								Form:C1466.page:=2
								FORM GOTO PAGE:C247(Form:C1466.page)
								
								$offset:=$screenWidth-$right
								$left:=$left+$offset
								$right:=$right+$offset
								SET WINDOW RECT:C444($left; $top; $right; $bottom; Form:C1466.window)
								
								If (FORM Get current page:C276=1)
									
									OBJECT MOVE:C664(*; "toolButton_@"; -10; 0)
									
								End if 
								
								//………………………………………………………
							Else 
								
								SET CURSOR:C469
								
								$left:=$_screenLeft{$screenIndex}
								$right:=$left+$windowWidth
								SET WINDOW RECT:C444($left; $top; $right; $bottom; Form:C1466.window)
								
								//………………………………………………………
						End case 
						
						component.preferences.set("palette"; New object:C1471(\
							"left"; $left; \
							"top"; $top; \
							"right"; $right; \
							"bottom"; $bottom))
						
						//………………………………………………………………………………………………………………
				End case 
				
				If (Form:C1466.event#0)
					
					// 999 = Automatic collapse /expand
					SET TIMER:C645(Form:C1466.event=999 ? 50 : -1)
					
				Else 
					
					If (Form:C1466.mdi)
						
						SET TIMER:C645(10)  // We must track the redimensioning of window MDI
						
					Else 
						
						If ($e.event=99)  // End drag
							
							SET TIMER:C645(20)
							OBJECT SET VISIBLE:C603(*; "hightlight.@"; False:C215)
							
						Else 
							
							SET TIMER:C645(10+(290*Num:C11(Form:C1466.widgets.length=0)))  // Animation
							
						End if 
					End if 
				End if 
			End if 
			
			//______________________________________________________
		: ($e.code=On Unload:K2:2)
			
			// Modified by vdl (04/06/08)
			// Adds the management of the number of tools to display when the palette will be next open
			If (Not:C34(Form:C1466.autoClose))
				
				GET WINDOW RECT:C443($left; $top; $right; $bottom; Form:C1466.window)
				component.preferences.set("viewingNumber"; ($right-$left)\Form:C1466.cellWidth)
				
			End if 
			
			//______________________________________________________
	End case 
	
Else 
	
	// MARK: Widget Methods
	Case of 
			
			//______________________________________________________
		: ($e.objectName="@.Handle.@")
			
			Case of 
					
					//______________________________________________________
				: ($e.code=On Drag Over:K2:13)\
					 | ($e.code=On Mouse Move:K2:35)
					
					// Added by Vincent de Lachaux (18/05/09)
					// Automatic collapse/Expand
					If (Form:C1466.autoClose)
						
						component.collapseExpand(Form:C1466.widgets.length)
						
						Form:C1466.event:=999
						SET TIMER:C645(-1)
						
					Else 
						
						SET CURSOR:C469(9010)
						
					End if 
					
					IDLE:C311
					
					//______________________________________________________
				: (Form:C1466.autoClose)
					
					//
					
					//______________________________________________________
				: ($e.code=On Mouse Leave:K2:34)
					
					SET CURSOR:C469
					
					//______________________________________________________
				: ($e.code=On Clicked:K2:4)
					
					Form:C1466.event:=1
					SET TIMER:C645(-1)
					
					//______________________________________________________
				: ($e.code=On Double Clicked:K2:5)
					
					component.collapseExpand()
					
					//______________________________________________________
			End case 
			
			//______________________________________________________
		: ($e.objectName="@.Title.@")
			
			Case of 
					
					//________________________________________
				: ($e.code=On Drag Over:K2:13)
					
					// Added by Vincent de Lachaux (18/05/09)
					// Automatic collapse/Expand
					If (Form:C1466.autoClose)
						
						component.collapseExpand(Form:C1466.widgets.length)
						
						Form:C1466.event:=999
						SET TIMER:C645(-1)
						
					End if 
					
					IDLE:C311
					
					//________________________________________
				: (Form event code:C388=On Mouse Move:K2:35)
					
					SET CURSOR:C469(Choose:C955(Macintosh control down:C544; 9015; 9013))
					
					//________________________________________
				: ($e.code=On Mouse Leave:K2:34)
					
					SET CURSOR:C469
					
					//________________________________________
				: (Contextual click:C713)
					
					component.doMenu()
					
					//________________________________________
				Else 
					
					SET TIMER:C645(0)
					SET CURSOR:C469(9014)
					
					DRAG WINDOW:C452
					
					// #12-12-2013 - delegate to the timer is more efficient
					Form:C1466.event:=8858
					SET TIMER:C645(-1)
					
					//________________________________________
			End case 
			
			//______________________________________________________
		: ($e.objectName="@.plus@")
			
			If ($e.code=On Clicked:K2:4)
				
				component.doMenu()
				SET TIMER:C645(50)
				
			End if 
			
			//______________________________________________________
		: ($e.objectName="toolButton_@")
			
			var $method : Text
			var $item : Object
			var $menu : cs:C1710.menu
			
			$e.index:=Num:C11($e.objectName)
			$e.widget:=Form:C1466.widgets[$e.index-1]
			
			Case of 
					
					//…………………………………………………………………………………………………………………………
				: ($e.code=On Mouse Move:K2:35)\
					 & (Macintosh option down:C545 | Windows Alt down:C563)
					
					If ($e.widget.help.exists)
						
						SET CURSOR:C469(9018)
						
					End if 
					
					//…………………………………………………………………………………………………………………………
				: ($e.code=On Mouse Leave:K2:34)
					
					SET CURSOR:C469
					SET TIMER:C645(-1)
					
					//…………………………………………………………………………………………………………………………
				: ($e.code=On Alternative Click:K2:36)\
					 | ($e.code=On Long Click:K2:37)
					
					$e.run:=True:C214
					$e.runDefault:=($e.widget.runDefault#Null:C1517) & ($e.widget.tool.length=0)
					$e.runHelp:=(Macintosh option down:C545 | Windows Alt down:C563)
					
					//…………………………………………………………………………………………………………………………
				: ($e.code=On Clicked:K2:4)
					
					$e.runDefault:=(Length:C16($e.widget.default)>0)
					$e.run:=Not:C34($e.runDefault)
					$e.runHelp:=(Macintosh option down:C545 | Windows Alt down:C563)
					
					//…………………………………………………………………………………………………………………………
				: ($e.code=On Drag Over:K2:13)
					
					//FIXME:On Drag Over
					//$0:=Length($e.widget.ondrop)>0 ? 0 : Button_OnDrop
					
					//…………………………………………………………………………………………………………………………
				: ($e.code=On Drop:K2:12)
					
					If (Length:C16(String:C10($e.widget.ondrop))>0)
						
						$e.method:="onDrop"
						$e.success:=component.execute($e)
						ASSERT:C1129($e.success; Replace string:C233(Get localized string:C991("ErrorOccuredDuringExecutionOfTheMethod"); "{methodName}"; $e.widget.ondrop))
						
						//Else
						//Button_OnDrop
						
					End if 
					
					//…………………………………………………………………………………………………………………………
			End case 
			
			Case of 
					
					//…………………………………………………………………………………………………………………………
				: ($e.runHelp)
					
					If ($e.widget.help.exists)
						
						OPEN URL:C673($e.widget.help.platformPath; *)
						
					End if 
					
					//…………………………………………………………………………………………………………………………
				: ($e.runDefault)
					
					$e.method:="default"
					$e.success:=component.execute($e)
					ASSERT:C1129($e.success; Replace string:C233(Get localized string:C991("ErrorOccuredDuringExecutionOfTheMethod"); "{methodName}"; $e.widget.default))
					
					//…………………………………………………………………………………………………………………………
				: ($e.run)
					
					If ($e.widget.tool.length=1)
						
						$e.method:=$e.widget.tool[0].method
						
					Else 
						
						If ($e.widget.tool.length=0)
							
							$e.method:="default"
							
						Else 
							
							$menu:=cs:C1710.menu.new()
							$e.index:=0
							
							For each ($item; $e.widget.tool)
								
								If ($item.name="-")
									
									$menu.line()
									
								Else 
									
									$menu.append($item.name; String:C10($e.index))
									
								End if 
								
								$e.index+=1
								
								If ($item.picture_path#Null:C1517)
									
									$menu.icon("path:"+$item.picture_path)
									
								End if 
							End for each 
							
							$menu.popup()
							
							If ($menu.selected)
								
								$e.method:=String:C10($e.widget.tool[Num:C11($menu.choice)].method)
								
							End if 
						End if 
					End if 
					
					If ($e.method#Null:C1517)
						
						$e.success:=component.execute($e)
						ASSERT:C1129($e.success; Replace string:C233(Get localized string:C991("ErrorOccuredDuringExecutionOfTheMethod"); "{methodName}"; $e.method))
						
					End if 
					
					//…………………………………………………………………………………………………………………………
			End case 
			
			Form:C1466.event:=999
			SET TIMER:C645(-1)
			
			//______________________________________________________
	End case 
	
End if 