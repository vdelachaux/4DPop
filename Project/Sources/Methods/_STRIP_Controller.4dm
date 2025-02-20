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
// V20 refactoring
// ----------------------------------------------------
// Modified #02-06-2023 by Vincent de Lachaux
// Management of widgets
// ----------------------------------------------------
var $t : Text
var $visible : Boolean
var $bottom; $height; $l; $left; $mouseButton; $offset : Integer
var $origin; $right; $top; $visibleTools; $wantedWidth; $width : Integer
var $x; $y : Integer
var $e; $item; $screen : Object
var $widget : cs:C1710._widget
var $coord : cs:C1710.coord
var $menu : cs:C1710.menu

$e:=FORM Event:C1606

// MARK:-Form Method
Case of 
		
		//______________________________________________________
	: ($e.objectName#Null:C1517)
		
		// Widget Methods
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.colorScheme:=FORM Get color scheme:C1761
		
		GET WINDOW RECT:C443($left; $top; $right; $bottom; Form:C1466.window)
		Form:C1466.page:=1+Num:C11($left#0)
		
		FORM GOTO PAGE:C247(Form:C1466.page)
		
		OBJECT SET VISIBLE:C603(*; "cartoons"; Form:C1466.widgets.length=0)
		SET TIMER:C645(Form:C1466.widgets.length=0 ? 100 : -1)
		
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
		
		// Constants
		Form:C1466.INIT:=-1
		Form:C1466.RESIZE:=1
		Form:C1466.DROP:=99
		Form:C1466.AUTO:=999
		Form:C1466.MOVED:=8858
		
		Form:C1466.HANDLE:="@.Handle.@"
		Form:C1466.TITLE:="@.Title.@"
		Form:C1466.ACTION:="@.plus@"
		Form:C1466.TOOL:="tool_@"
		
		// Activation of non-configurable events for the form
		ARRAY LONGINT:C221($events; 0x0000)
		APPEND TO ARRAY:C911($events; On Alternative Click:K2:36)
		APPEND TO ARRAY:C911($events; On Long Click:K2:37)
		OBJECT SET EVENTS:C1239(*; ""; $events; Enable events others unchanged:K42:38)
		
		strip.init()
		Form:C1466.event:=Form:C1466.autoClose ? 0 : Form:C1466.INIT
		
		return 
		
		//______________________________________________________
	: ($e.code=On Page Change:K2:54)
		
		Form:C1466.page:=FORM Get current page:C276
		
		// A slight shift of the buttons when the strip is on the right
		OBJECT MOVE:C664(*; "tool_@"; Form:C1466.page=1 ? 10 : -10; 0)
		
		return 
		
		//______________________________________________________
	: ($e.code=On Outside Call:K2:11)
		
		strip.close()
		
		return 
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		If (FORM Get color scheme:C1761#Form:C1466.colorScheme)
			
			Form:C1466.colorScheme:=FORM Get color scheme:C1761
			
		End if 
		
		REDRAW WINDOW:C456(Form:C1466.window)
		
		$e.event:=Form:C1466.event
		Form:C1466.event:=0
		
		If ($e.event=0)
			
/*
Control whether the pallet should be visible or not
depending on the origin of the most upstream process
*/
			
			_O_PROCESS PROPERTIES:C336(Window process:C446(Frontmost window:C447); $t; $l; $l; $visible; $l; $origin)
			
			If ($origin=Design process:K36:9)
				
				If ($visible & Bool:C1537(Form:C1466.hidden))  // Show
					
					Form:C1466.hidden:=False:C215
					SHOW PROCESS:C325(Form:C1466.process)
					
					// Generate an update event for widgets
					For each ($widget; Form:C1466.widgets.query("form != null"))
						
						EXECUTE METHOD IN SUBFORM:C1085($widget.tool; Formula:C1597(SET TIMER:C645(-1)))
						
					End for each 
					
				End if 
				
				If (Form:C1466.mdi)
					
					// Replace in the window MDI, if resized
					GET WINDOW RECT:C443($left; $top; $right; $bottom; Form:C1466.window)
					
					If ($bottom>Screen height:C188)
						
						$coord:=cs:C1710.coord.new($left; $top; $right; $bottom)
						$height:=$coord.height
						$coord.bottom:=Screen height:C188
						$coord.top:=$coord.bottom-$height
						$coord.applyToWindow(Form:C1466.window)
						
					End if 
				End if 
				
			Else 
				
				If ($visible)\
					 & (Not:C34(Bool:C1537(Form:C1466.hidden)))  // Hide
					
					Form:C1466.hidden:=True:C214
					HIDE PROCESS:C324(Form:C1466.process)
					
					If (Form:C1466.autoClose)
						
						strip.collapseExpand(-1)
						
					End if 
				End if 
			End if 
			
			SET TIMER:C645(50)
			return 
			
		End if 
		
		Case of 
				
				//………………………………………………………………………………………………………………
			: ($e.event=Form:C1466.INIT)
				
				// MARK: ▶︎ Restore the visible tools
				strip.collapseExpand(Form:C1466.displayedTools)
				
				SET TIMER:C645(-1)
				return 
				
				//………………………………………………………………………………………………………………
			: ($e.event=Form:C1466.RESIZE)
				
				// MARK: ▶︎ User resizes the window
				SET CURSOR:C469(9010)
				MOUSE POSITION:C468($x; $y; $mouseButton; *)
				GET WINDOW RECT:C443($left; $top; $right; $bottom; Form:C1466.window)
				
				$coord:=cs:C1710.coord.new($left; $top; $right; $bottom)
				
				If (Bool:C1537($mouseButton))  // In progress
					
					If (Form:C1466.page=1)
						
						$offset:=$x-$coord.right+5
						$wantedWidth:=$coord.right+$offset
						
						Case of 
								
								//…………………………………………………………………………
							: ($wantedWidth<Form:C1466.offset)
								
								//…………………………………………………………………………
							: ($wantedWidth>Form:C1466.maxWidth)
								
								//…………………………………………………………………………
							Else 
								
								$coord.right+=$offset
								OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
								
								//…………………………………………………………………………
						End case 
						
					Else 
						
						$wantedWidth:=$coord.width
						$offset:=$coord.left-$x+5
						$wantedWidth+=$offset
						
						Case of 
								
								//…………………………………………………………………………
							: ($wantedWidth<Form:C1466.offset)
								
								//…………………………………………………………………………
							: ($wantedWidth>Form:C1466.maxWidth)
								
								//…………………………………………………………………………
							Else 
								
								$coord.left-=$offset
								OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
								
								//…………………………………………………………………………
						End case 
					End if 
					
					$visibleTools:=($wantedWidth\Form:C1466.cellWidth)+Num:C11(($wantedWidth%Form:C1466.cellWidth)>80)
					Form:C1466.event:=Form:C1466.RESIZE  // Continue
					
				Else   // It's over
					
					For each ($widget; Form:C1466.widgets)
						
						$wantedWidth+=$widget.width
						
						If ($wantedWidth<=$coord.width)
							
							$visibleTools+=1
							
						Else 
							
							$wantedWidth-=$widget.width
							break
							
						End if 
						
					End for each 
					
					$wantedWidth+=Form:C1466.offset
					$wantedWidth:=$wantedWidth>Form:C1466.maxWidth ? Form:C1466.maxWidth : $wantedWidth
					$wantedWidth:=$wantedWidth<36 ? 36 : $wantedWidth
					
					$offset:=$wantedWidth-$coord.width
					
					If (Form:C1466.page=1)
						
						$coord.right+=$offset
						OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
						
					Else 
						
						$coord.left-=$offset
						OBJECT MOVE:C664(*; "@.Movable"; $offset; 0)
						
					End if 
					
					// Store the number of tools to display when the palette will be next open
					strip.preferences.set("viewingNumber"; $visibleTools)
					
				End if 
				
				// Keep visible only the tools included in the window
				For each ($widget; Form:C1466.widgets)
					
					OBJECT SET VISIBLE:C603(*; $widget.tool; $widget.index<=$visibleTools)
					
				End for each 
				
				// Fix the window rect
				$coord.applyToWindow(Form:C1466.window)
				
				// Adjust the background positions
				$coord.left:=0
				$coord.top:=0
				$coord.applyToWidget("_background")
				$coord.applyToWidget("hightlight")
				
				//………………………………………………………………………………………………………………
			: ($e.event=Form:C1466.AUTO)
				
				// MARK: ▶︎ Automatic collapse/expand
				// #12-12-2013 GET WINDOW RECT returns bad coordinates, for this particular window, on Windows only.
				// This causes a flickering effect.
				MOUSE POSITION:C468($x; $y; $mouseButton)
				OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
				
				If ($x>=0) && ($x<=$width)\
					 && ($y>=0) && ($y<=$height)
					
					Form:C1466.event:=Form:C1466.autoClose ? Form:C1466.AUTO : 0
					
				Else 
					
					strip.collapseExpand(-1)
					
				End if 
				
				//………………………………………………………………………………………………………………
			: ($e.event=Form:C1466.MOVED)
				
				// MARK: ▶︎ User has moved the strip
				GET WINDOW RECT:C443($left; $top; $right; $bottom; Form:C1466.window)
				$coord:=cs:C1710.coord.new($left; $top; $right; $bottom)
				
				// Multi-screens management
				For each ($screen; strip.env.screens)
					
					If ($coord.left>=$screen.coordinates.left)\
						 & ($coord.left<=$screen.coordinates.right)
						
						break
						
					End if 
				End for each 
				
				If ($coord.left>=(Abs:C99($screen.dimensions.width)/3))
					
					// Hang on the right
					$offset:=$screen.dimensions.width-$coord.right
					$coord.left+=$offset
					$coord.right+=$offset
					SET WINDOW RECT:C444($coord.left; $coord.top; $coord.right; $coord.bottom; Form:C1466.window)
					Form:C1466.page:=2
					
				Else 
					
					// Hang on the left
					$width:=$coord.width
					$coord.left:=$screen.coordinates.left
					$coord.right:=$coord.left+$width
					SET WINDOW RECT:C444($coord.left; $coord.top; $coord.right; $coord.bottom; Form:C1466.window)
					Form:C1466.page:=1
					
				End if 
				
				SET CURSOR:C469
				FORM GOTO PAGE:C247(Form:C1466.page)
				
				strip.preferences.set("palette"; $coord)
				
				//………………………………………………………………………………………………………………
			: ($e.event=Form:C1466.DROP)
				
				// MARK: ▶︎ End of drag and drop on the strip
				// TODO: Install component
				
				//………………………………………………………………………………………………………………
		End case 
		
		If (Form:C1466.event#0)
			
			SET TIMER:C645(Form:C1466.event=Form:C1466.AUTO ? 50 : -1)
			return 
			
		End if 
		
		If (Form:C1466.mdi)
			
			SET TIMER:C645(10)  // We must track the redimensioning of window MDI
			
			return 
			
		End if 
		
		If ($e.event=Form:C1466.DROP)  // End drag & drop
			
			SET TIMER:C645(20)
			OBJECT SET VISIBLE:C603(*; "hightlight.@"; False:C215)
			
			return 
			
		End if 
		
		SET TIMER:C645(10+(290*Num:C11(Form:C1466.widgets.length=0)))  // Animation
		
		return 
		
		//______________________________________________________
End case 

// MARK: -Widget Methods
Case of 
		
		//______________________________________________________
	: ($e.objectName=Form:C1466.HANDLE)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Drag Over:K2:13)\
				 | ($e.code=On Mouse Move:K2:35)
				
				// Added by Vincent de Lachaux (18/05/09)
				// Automatic collapse/Expand
				If (Form:C1466.autoClose)
					
					strip.collapseExpand(Form:C1466.widgets.length)
					Form:C1466.event:=Form:C1466.AUTO
					SET TIMER:C645(-1)
					
				Else 
					
					SET CURSOR:C469(9010)
					
				End if 
				
				IDLE:C311
				
				//______________________________________________________
			: (Form:C1466.autoClose)
				
				// ALL OTHER EVENTS ARE IGNORED
				
				//______________________________________________________
			: ($e.code=On Mouse Leave:K2:34)
				
				SET CURSOR:C469
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				Form:C1466.event:=Form:C1466.RESIZE
				SET TIMER:C645(-1)
				
				//______________________________________________________
			: ($e.code=On Double Clicked:K2:5)
				
				strip.collapseExpand()
				
				//______________________________________________________
		End case 
		
		//______________________________________________________
	: ($e.objectName=Form:C1466.TITLE)
		
		Case of 
				
				//________________________________________
			: ($e.code=On Drag Over:K2:13)
				
				// Added by Vincent de Lachaux (18/05/09)
				// Automatic collapse/Expand
				If (Form:C1466.autoClose)
					
					strip.collapseExpand(Form:C1466.widgets.length)
					Form:C1466.event:=Form:C1466.AUTO
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
				
				strip.doMenu()
				
				//________________________________________
			Else 
				
				SET TIMER:C645(0)
				SET CURSOR:C469(9014)
				
				DRAG WINDOW:C452
				
				// #12-12-2013 - delegate to the timer is more efficient
				Form:C1466.event:=Form:C1466.MOVED
				SET TIMER:C645(-1)
				
				//________________________________________
		End case 
		
		//______________________________________________________
	: ($e.objectName=Form:C1466.ACTION)
		
		If ($e.code=On Clicked:K2:4)
			
			strip.doMenu()
			SET TIMER:C645(50)
			
		End if 
		
		//______________________________________________________
	: ($e.objectName=Form:C1466.TOOL)
		
		$e.index:=Num:C11($e.objectName)
		$e.widget:=Form:C1466.widgets[$e.index-1]
		
		Case of 
				
				//…………………………………………………………………………………………………………………………
			: ($e.code=On Alternative Click:K2:36)\
				 | ($e.code=On Long Click:K2:37)
				
				$e.run:=True:C214
				$e.runDefault:=($e.widget.runDefault#Null:C1517) & ($e.widget.tools.length=0)
				$e.runHelp:=(Macintosh option down:C545 | Windows Alt down:C563)
				
				//…………………………………………………………………………………………………………………………
			: ($e.code=On Clicked:K2:4)
				
				$e.runDefault:=(Length:C16($e.widget.default)>0)
				$e.run:=Not:C34($e.runDefault)
				$e.runHelp:=(Macintosh option down:C545 | Windows Alt down:C563)
				
				//…………………………………………………………………………………………………………………………
			: ($e.code=On Drag Over:K2:13)
				
				// FIXME:On Drag Over
				//$0:=Length($e.widget.ondrop)>0 ? 0 : Button_OnDrop
				
				//…………………………………………………………………………………………………………………………
			: ($e.code=On Drop:K2:12)
				
				If (Length:C16(String:C10($e.widget.ondrop))>0)
					
					$e.method:="onDrop"
					$e.success:=strip.execute($e)
					
				Else 
					
					// FIXME:On Drop
					// Button_OnDrop
					
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
				$e.success:=strip.execute($e)
				
				//…………………………………………………………………………………………………………………………
			: ($e.run)
				
				If ($e.widget.tools.length=1)
					
					$e.method:=$e.widget.tools[0].method
					
				Else 
					
					If ($e.widget.tools.length=0)
						
						$e.method:="default"
						
					Else 
						
						$menu:=cs:C1710.menu.new()
						$e.index:=0
						
						For each ($item; $e.widget.tools)
							
							If ($item.name="-") || ($item.name="(-")
								
								$menu.line()
								
							Else 
								
								$menu.append($item.name; String:C10($e.index))
								
							End if 
							
							$e.index+=1
							
							If ($item.picture_path#Null:C1517)
								
								$menu.icon("path:"+$item.picture_path)
								
							End if 
						End for each 
						
						If (Not:C34($menu.popup().selected))
							
							return 
							
						End if 
						
						$e.method:=String:C10($e.widget.tools[Num:C11($menu.choice)].method)
						
					End if 
				End if 
				
				If ($e.method=Null:C1517)
					
					return 
					
				End if 
				
				$e.success:=strip.execute($e)
				
				//…………………………………………………………………………………………………………………………
		End case 
		
		Form:C1466.event:=Form:C1466.autoClose ? Form:C1466.AUTO : 0
		SET TIMER:C645(-1)
		
		//______________________________________________________
End case 