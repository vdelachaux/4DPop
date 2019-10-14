  // ----------------------------------------------------
  // Method : Méthode formulaire : 4DPop_ButtonPalette
  // Created 01/12/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by vdl  (04/06/08)
  // Adds the management of the number of tools to display when the palette is open
  // ----------------------------------------------------
  // Modified by vdl (01/07/08)
  // workaround for ACI0058409, ACI0058410 & ACI0058411
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (18/05/09)
  // Add Automatic Collapse/Expand
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
  // Modified #9-6-2014 by Vincent de Lachaux
  // management id
  // ----------------------------------------------------
C_BOOLEAN:C305($Boo_visible)
C_LONGINT:C283($i;$l;$Lon_bottom;$Lon_formEvent;$Lon_height;$Lon_left)
C_LONGINT:C283($Lon_mouseButton;$Lon_offset;$Lon_origin;$Lon_page;$Lon_right;$Lon_screenIndex)
C_LONGINT:C283($Lon_screenNumber;$Lon_screenWidth;$Lon_timerEvent;$Lon_top;$Lon_visibleTools;$Lon_wantedWidth)
C_LONGINT:C283($Lon_width;$Lon_windowWidth;$Lon_x;$Lon_y)
C_TEXT:C284($t)
C_OBJECT:C1216($o)

$Lon_formEvent:=Form event code:C388
$Lon_page:=FORM Get current page:C276

Case of 
		
		  //________________________________________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
		Form:C1466.page:=1+Num:C11($Lon_left#0)
		
		FORM GOTO PAGE:C247(Form:C1466.page)
		
		If (Form:C1466.widgets.length>0)
			
			OBJECT SET VISIBLE:C603(*;"Animated@";False:C215)
			Form:C1466.maxWidth:=((Form:C1466.cellWidth*Form:C1466.widgets.length)+Form:C1466.offset)
			
			SET TIMER:C645(-1)
			
		Else 
			
			OBJECT SET VISIBLE:C603(*;"Animated@";True:C214)
			Form:C1466.maxWidth:=Form:C1466.cellWidth+Form:C1466.offset
			
			SET TIMER:C645(100)
			
		End if 
		
		$o:=plist .toObject()
		
		If ($o.CFBundleDisplayName#Null:C1517)
			
			Form:C1466.version:=String:C10($o.CFBundleDisplayName)
			$t:=String:C10($o.CFBundleShortVersionString)
			
			If (Length:C16($t)#0)
				
				Form:C1466.version:=Form:C1466.version+"\r"+Choose:C955($t#"DEV";"v";"")+$t
				
			End if 
			
		Else 
			
			  // Display database name
			Form:C1466.version:=File:C1566(Structure file:C489;fk platform path:K87:2).name
			
		End if 
		
		  // Test dark mode compatibility
		Form:C1466.compatibleDarkMode:=ui_darkMode 
		
		CALL FORM:C1391(Form:C1466.window;"4DPOP";"init")
		
		  //________________________________________________________________________________
	: ($Lon_formEvent=On Outside Call:K2:11)
		
		CALL FORM:C1391(Form:C1466.window;"4DPOP";"kill")
		
		  //________________________________________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		If (Form:C1466.event=0)
			
			SET TIMER:C645(0)
			
			  // Periodically seeing if the palette must be hidden or visible
			  // According to the origin of the frontmost process
			PROCESS PROPERTIES:C336(Window process:C446(Frontmost window:C447);$t;$l;$l;$Boo_visible;$l;$Lon_origin)
			
			If ($Lon_origin=Design process:K36:9)
				
				If ($Boo_visible & Bool:C1537(Form:C1466.hidden))
					
					  // Make visible the palette
					Form:C1466.hidden:=False:C215
					SHOW PROCESS:C325(Form:C1466.process)
					
				End if 
				
				If (Form:C1466.mdi)
					
					  // Replace in the window MDI, if resized
					GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
					
					If ($Lon_bottom>Screen height:C188)
						
						$Lon_height:=$Lon_bottom-$Lon_top
						$Lon_bottom:=Screen height:C188
						$Lon_top:=$Lon_bottom-$Lon_height
						
						SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
						
					End if 
				End if 
				
			Else 
				
				If ($Boo_visible)\
					 & (Not:C34(Bool:C1537(Form:C1466.hidden)))
					
					  // Hide the palette
					Form:C1466.hidden:=True:C214
					HIDE PROCESS:C324(Form:C1466.process)
					
					COLLAPSE_EXPAND (0)
					
				End if 
			End if 
			
			If (Form:C1466.compatibleDarkMode)
				
				CALL FORM:C1391(Current form window:C827;"Skin";"update")
				
			End if 
			
			SET TIMER:C645(50)
			
		Else 
			
			SET TIMER:C645(0)
			$Lon_timerEvent:=Form:C1466.event
			Form:C1466.event:=0
			
			Case of 
					
					  //………………………………………………………………………………………………………………
					  //: ($Lon_timerEvent=-1)  // Init
					
					  //………………………………………………………………………………………………………………
					  //#06/06/2014
					  //………………………………………………………………………………………………………………
					  //: ($Lon_timerEvent=-2)  // Update popupmenu
					
					  //………………………………………………………………………………………………………………
				: ($Lon_timerEvent=1)  // The user is trying to resize the window
					
					SET CURSOR:C469(9010)
					GET MOUSE:C468($Lon_x;$Lon_y;$Lon_mouseButton;*)
					GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
					$Lon_width:=$Lon_right-$Lon_left
					
					If ($Lon_mouseButton#0)  // In progress
						
						If (FORM Get current page:C276=1)
							
							$Lon_offset:=$Lon_x-$Lon_right+5
							$Lon_wantedWidth:=$Lon_right+$Lon_offset
							
							Case of 
									
									  //…………………………………………………………………………
								: ($Lon_wantedWidth<Form:C1466.offset)
									
									  //…………………………………………………………………………
								: ($Lon_wantedWidth>Form:C1466.maxWidth)
									
									  //…………………………………………………………………………
								Else 
									
									$Lon_right:=$Lon_right+$Lon_offset
									OBJECT MOVE:C664(*;"@.Movable";$Lon_offset;0)
									
									  //…………………………………………………………………………
							End case 
							
						Else 
							
							$Lon_offset:=$Lon_left-$Lon_x+5
							$Lon_wantedWidth:=$Lon_right-$Lon_left+$Lon_offset
							
							Case of 
									
									  //…………………………………………………………………………
								: ($Lon_wantedWidth<Form:C1466.offset)
									
									  //…………………………………………………………………………
								: ($Lon_wantedWidth>Form:C1466.maxWidth)
									
									  //…………………………………………………………………………
								Else 
									
									$Lon_left:=$Lon_left-$Lon_offset
									OBJECT MOVE:C664(*;"@.Movable";$Lon_offset;0)
									
									  //…………………………………………………………………………
							End case 
						End if 
						
						$Lon_visibleTools:=($Lon_wantedWidth\Form:C1466.cellWidth)+Num:C11(($Lon_width%Form:C1466.cellWidth)>0)
						
						Form:C1466.event:=1  // Continue
						
					Else   // It's all over
						
						$Lon_visibleTools:=($Lon_width\Form:C1466.cellWidth)+Num:C11(($Lon_width%Form:C1466.cellWidth)>50)
						$Lon_wantedWidth:=(Form:C1466.cellWidth*$Lon_visibleTools)+Form:C1466.offset
						$Lon_wantedWidth:=Choose:C955($Lon_wantedWidth>Form:C1466.maxWidth;Form:C1466.maxWidth;$Lon_wantedWidth)
						
						$Lon_offset:=$Lon_wantedWidth-$Lon_width
						
						If (FORM Get current page:C276=1)
							
							$Lon_right:=$Lon_right+$Lon_offset
							OBJECT MOVE:C664(*;"@.Movable";$Lon_offset;0)
							
						Else 
							
							$Lon_left:=$Lon_left-$Lon_offset
							OBJECT MOVE:C664(*;"@.Movable";$Lon_offset;0)
							
						End if 
					End if 
					
					  // Keep visible only the wanted tools {
					OBJECT SET VISIBLE:C603(*;"toolButton_@";False:C215)
					
					If (Form:C1466.widgets.length>0)
						
						For ($i;1;$Lon_visibleTools;1)
							
							OBJECT SET VISIBLE:C603(*;"toolButton_"+String:C10($i);True:C214)
							
						End for 
					End if   //}
					
					SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
					
					  //………………………………………………………………………………………………………………
				: ($Lon_timerEvent=99)  // End drag
					
					  // NOTHING MORE TO DO
					
					  //………………………………………………………………………………………………………………
				: ($Lon_timerEvent=999)  // Automatic collapse/expand
					
					  // #12-12-2013 GET WINDOW RECT returns bad coordinates, for this particular window, on Windows only.
					  // This causes a flickering effect.
					GET MOUSE:C468($Lon_x;$Lon_y;$Lon_mouseButton)
					OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_width;$Lon_height)
					
					If ($Lon_x>=0)\
						 & ($Lon_x<=$Lon_width)\
						 & ($Lon_y>=0)\
						 & ($Lon_y<=$Lon_height)
						
						Form:C1466.event:=Choose:C955(Form:C1466.autoClose;999;0)
						
					Else 
						
						COLLAPSE_EXPAND (0)
						
					End if 
					
					  //………………………………………………………………………………………………………………
				: ($Lon_timerEvent=8858)
					
					GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
					OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_windowWidth;$Lon_height)
					
					$Lon_screenNumber:=Count screens:C437
					ARRAY LONGINT:C221($tLon_screenLeft;$Lon_screenNumber)
					ARRAY LONGINT:C221($tLon_screenTop;$Lon_screenNumber)
					ARRAY LONGINT:C221($tLon_screenRight;$Lon_screenNumber)
					ARRAY LONGINT:C221($tLon_screenBottom;$Lon_screenNumber)
					
					For ($i;1;$Lon_screenNumber;1)
						
						SCREEN COORDINATES:C438($tLon_screenLeft{$i};$tLon_screenTop{$i};$tLon_screenRight{$i};$tLon_screenBottom{$i};$i)
						
					End for 
					
					  // Multi-screens management
					For ($i;1;$Lon_screenNumber;1)
						
						If ($Lon_left>=$tLon_screenLeft{$i})\
							 & ($Lon_left<=$tLon_screenRight{$i})
							
							$Lon_screenIndex:=$i
							$i:=MAXLONG:K35:2-1
							
						End if 
					End for 
					
					$Lon_screenWidth:=($tLon_screenRight{$Lon_screenIndex}-$tLon_screenLeft{$Lon_screenIndex})
					
					Case of 
							
							  //………………………………………………………
						: ($Lon_left=$tLon_screenLeft{$Lon_screenIndex})
							
							  //………………………………………………………
						: ($Lon_left>=(Abs:C99($Lon_screenWidth)/3))
							
							SET CURSOR:C469
							Form:C1466.page:=2
							FORM GOTO PAGE:C247(Form:C1466.page)
							
							$Lon_offset:=$Lon_screenWidth-$Lon_right
							$Lon_left:=$Lon_left+$Lon_offset
							$Lon_right:=$Lon_right+$Lon_offset
							SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
							
							If (FORM Get current page:C276=1)
								
								OBJECT MOVE:C664(*;"toolButton_@";-10;0)
								
							End if 
							
							  //………………………………………………………
						Else 
							
							SET CURSOR:C469
							
							$Lon_left:=$tLon_screenLeft{$Lon_screenIndex}
							$Lon_right:=$Lon_left+$Lon_windowWidth
							SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
							
							  //………………………………………………………
					End case 
					
					_o_PREFERENCES ("palette.set";->$Lon_left;->$Lon_top;->$Lon_right;->$Lon_bottom)
					
					  //………………………………………………………………………………………………………………
			End case 
			
			If (Form:C1466.event#0)
				
				  // 999 = Automatic collapse /expand
				SET TIMER:C645(Choose:C955(Form:C1466.event=999;50;-1))
				
			Else 
				
				If (Form:C1466.mdi)
					
					SET TIMER:C645(10)  // We must track the redimensioning of window MDI
					
				Else 
					
					If ($Lon_timerEvent=99)  // End drag
						
						SET TIMER:C645(20)
						OBJECT SET VISIBLE:C603(*;"hightlight.@";False:C215)
						
					Else 
						
						SET TIMER:C645(10+(290*Num:C11(Form:C1466.widgets.length=0)))  // Animation
						
					End if 
				End if 
			End if 
		End if 
		
		  //________________________________________________________________________________
End case 