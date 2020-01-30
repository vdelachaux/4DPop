//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : 4DPOP
  // ID[F4DB3EE0C24F41DEAADA76B2F5098130]
  // Created 19-8-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($i;$l;$Lon_bottom;$Lon_currentWindow;$Lon_left;$Lon_parameters)
C_LONGINT:C283($Lon_right;$Lon_top)
C_POINTER:C301($Ptr_;$Ptr_nil)
C_TEXT:C284($kTxt_format;$t;$Txt_action;$Txt_format;$Txt_picture;$Txt_widget)
C_OBJECT:C1216($Obj_widget)

If (False:C215)
	C_TEXT:C284(4DPOP ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // <NO PARAMETERS REQUIRED>
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_action:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_action="init")
		
		OBJECT SET VISIBLE:C603(*;"toolButton_@";False:C215)
		
		$kTxt_format:="{title};{picture};{background};{titlePos};{titleVisible};{iconVisible};{style};{horMargin};{vertMargin};{iconOffset};{popupMenu};{underline}"
		
		For each ($Obj_widget;Form:C1466.widgets)
			
			$i:=$i+1
			
			$Txt_widget:="toolButton_"+String:C10($i)
			$Txt_picture:="toolIcon."+String:C10($i)
			
			If ($i>1)
				
				OBJECT DUPLICATE:C1111(*;"toolButton_"+String:C10($i-1);$Txt_widget;$Ptr_nil;"";Form:C1466.cellWidth)
				OBJECT DUPLICATE:C1111(*;"toolIcon."+String:C10($i-1);$Txt_picture;$Ptr_nil;"";Form:C1466.cellWidth)
				
			End if 
			
			$Txt_format:=Replace string:C233($kTxt_format;"{title}";$Obj_widget.name)
			
			$Ptr_:=OBJECT Get pointer:C1124(Object named:K67:5;$Txt_picture)
			$Ptr_->:=$Obj_widget.icon
			
			  // Picture linked to a button that comes from :
			  // a picture library, a picture variable a PICT resource or a picture file
			RESOLVE POINTER:C394($Ptr_;$t;$l;$l)
			$Txt_format:=Replace string:C233($Txt_format;"{picture}";$t)
			
			  // Background picture linked to a button (Custom style)
			  // a picture library, a picture variable a PICT resource or a picture file
			$Txt_format:=Replace string:C233($Txt_format;"{background}";"?0")
			
			  // Position of the button title. Five values are possible:
			  // 0: Middle; 1: Right; 2: Left; 3: Bottom; 4: Top
			$Txt_format:=Replace string:C233($Txt_format;"{titlePos}";"0")
			
			  // Defines whether or not the title is visible. Two values are possible:
			  // 0: the title is hidden; 1: the title is displayed
			$Txt_format:=Replace string:C233($Txt_format;"{titleVisible}";String:C10(Form:C1466.default.title))
			
			  // Defines whether or not the icon is visible. Two values are possible:
			  // 0 : the icon is hidden; 1 : the icon is displayed
			$Txt_format:=Replace string:C233($Txt_format;"{iconVisible}";String:C10(Form:C1466.default.icon))
			
			  // Button style. Ten values are possible:
			  // 0: None; 1: Background offset; 2: Push button; 3: Toolbar button; 4: Custom;
			  // 5: Circle; 6: Small system square; 7: Office XP; 8: Bevel; 9: Rounded bevel
			$Txt_format:=Replace string:C233($Txt_format;"{style}";String:C10(Form:C1466.default.style))
			
			  // Horizontal margin.
			  // Number of pixels delimiting the inside left and right margins of the button (areas that the icon and the text must not encroach upon).
			$Txt_format:=Replace string:C233($Txt_format;"{horMargin}";"8")
			
			  // Vertical margin.
			  // Number of pixels delimiting the inside top and bottom margins of the button (areas that the icon and the text must not encroach upon).
			$Txt_format:=Replace string:C233($Txt_format;"{vertMargin}";"0")
			
			  // Shifting of the icon to the right and down.
			  // This value, expressed in pixels, indicates the shifting of the button icon to the right and down when the button is clicked (the same value is used for both directions).
			$Txt_format:=Replace string:C233($Txt_format;"{iconOffset}";"0")
			
			  // Association of a pop-up menu with the button. Three values are possible:
			  // 0: No pop-up menu; 1: With linked pop-up menu; 2: With separate pop-up menu
			
			$l:=Choose:C955(Bool:C1537($Obj_widget.popup);1+Num:C11($Obj_widget.default#Null:C1517);0)
			
			$Txt_format:=Replace string:C233($Txt_format;"{popupMenu}";String:C10($l))
			
			$t:=String:C10($Obj_widget.helptip)
			OBJECT SET HELP TIP:C1181(*;$Txt_widget;Choose:C955(Length:C16($t)>0;$t;String:C10($Obj_widget.name)))
			
			$Txt_format:=Replace string:C233($Txt_format;"{underline}";"0")
			
			OBJECT SET FORMAT:C236(*;$Txt_widget;$Txt_format)
			
		End for each 
		
		  // Skin
		Form:C1466.skinRoot:=Get 4D folder:C485(Current resources folder:K5:16)+"skins"+Folder separator:K24:12
		Form:C1466.skinEnabled:=(Test path name:C476(Form:C1466.skinRoot)=Is a folder:K24:2)  // False if no skin's folder
		
		_o_PREFERENCES ("Skin.get";->$t)
		Form:C1466.skin:=$t
		
		If (Form:C1466.compatibleDarkMode)
			
			  // Test if dark mode is enabled
			Form:C1466.darkMode:=ui_darkMode 
			
		End if 
		
		Skin (Form:C1466.skin)
		
		  // Activation
		$Lon_currentWindow:=Next window:C448(Form:C1466.window)
		BRING TO FRONT:C326(Window process:C446(Next window:C448($Lon_currentWindow)))
		GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_currentWindow)
		SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_currentWindow)
		
		If (Not:C34(Bool:C1537(Form:C1466.autoClose)))
			
			_o_PREFERENCES ("Viewing.get";->$l)
			
			Form:C1466.viewing:=$l
			
		End if 
		
		  //______________________________________________________
	: ($Txt_action="deinit")
		
		For ($i;1;Count user processes:C343;1)
			
			PROCESS PROPERTIES:C336($i;$t;$l;$l)
			
			If ($t="$4DPop_Palette")
				
				POST OUTSIDE CALL:C329($i)
				$i:=MAXLONG:K35:2-1
				
			End if 
		End for 
		
		  //______________________________________________________
	: ($Txt_action="kill")
		
		SET TIMER:C645(0)
		CANCEL:C270
		
		  //______________________________________________________
	: ($Txt_action="update")  // Update popupmenu
		
		$kTxt_format:=";;;;;;;;;;{popupMenu};"
		
		For each ($Obj_widget;Form:C1466.widgets)
			
			$i:=$i+1
			$Txt_widget:="toolButton_"+String:C10($i)
			
			$Txt_format:=Replace string:C233($kTxt_format;"{popupMenu}";String:C10(Num:C11(Bool:C1537($Obj_widget.popup))))
			OBJECT SET FORMAT:C236(*;$Txt_widget;$Txt_format)
			
		End for each 
		
		Form:C1466.event:=Choose:C955(Form:C1466.autoClose;999;0)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_action+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End 