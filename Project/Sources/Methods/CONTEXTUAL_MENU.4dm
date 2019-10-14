//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : CONTEXTUAL_MENU
  // Created 05/06/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (18/05/09)
  // Add Automatic Collapse/Expand
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_BOOLEAN:C305($b)
C_LONGINT:C283($Lon_bottom;$Lon_height;$Lon_left;$Lon_right;$Lon_top;$Lon_width)
C_TEXT:C284($Mnu_choice;$Mnu_main;$Mnu_position)

$Mnu_main:=Create menu:C408

INSERT MENU ITEM:C412($Mnu_main;0;":xliff:About")
SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"About")

APPEND MENU ITEM:C411($Mnu_main;"-")
APPEND MENU ITEM:C411($Mnu_main;":xliff:Appearance";Skin ("menu"))

$Mnu_position:=Create menu:C408

APPEND MENU ITEM:C411($Mnu_position;":xliff:TopLeft")
SET MENU ITEM PARAMETER:C1004($Mnu_position;-1;"Pos_TopLeft")

APPEND MENU ITEM:C411($Mnu_position;":xliff:BottomLeft")
SET MENU ITEM PARAMETER:C1004($Mnu_position;-1;"Pos_BottomLeft")

APPEND MENU ITEM:C411($Mnu_position;":xliff:TopRight")
SET MENU ITEM PARAMETER:C1004($Mnu_position;-1;"Pos_TopRight")

APPEND MENU ITEM:C411($Mnu_position;":xliff:BottomRight")
SET MENU ITEM PARAMETER:C1004($Mnu_position;-1;"Pos_BottomRight")

APPEND MENU ITEM:C411($Mnu_main;":xliff:Position";$Mnu_position)
RELEASE MENU:C978($Mnu_position)

  // Append Toolbar commands
APPEND MENU ITEM:C411($Mnu_main;"-")
APPEND MENU ITEM:C411($Mnu_main;":xliff:Collapse")
SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"Collapse")

If (Form:C1466.autoClose)
	
	DISABLE MENU ITEM:C150($Mnu_main;-1)
	
End if 

APPEND MENU ITEM:C411($Mnu_main;":xliff:Expand")
SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"Expand")

If (Form:C1466.autoClose)
	
	DISABLE MENU ITEM:C150($Mnu_main;-1)
	
End if 

APPEND MENU ITEM:C411($Mnu_main;":xliff:automaticMode")
SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"automatic")

If (Form:C1466.autoClose)
	
	SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
	
End if 

  //APPEND MENU ITEM($Mnu_main;"-")
  //APPEND MENU ITEM($Mnu_main;"Tools";Tools_Menu )

APPEND MENU ITEM:C411($Mnu_main;"-")
APPEND MENU ITEM:C411($Mnu_main;":xliff:closePalette")
SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"end")

$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
RELEASE MENU:C978($Mnu_main)

Case of 
		
		  //______________________________________________________
	: (Length:C16($Mnu_choice)=0)
		
		  //______________________________________________________
	: ($Mnu_choice="end")
		
		CANCEL:C270
		
		  //______________________________________________________
	: ($Mnu_choice="About")
		
		ABOUT ("";New object:C1471("widgets";Form:C1466.widgets))
		
		  //______________________________________________________
	: ($Mnu_choice="Collapse")\
		 | ($Mnu_choice="Expand")
		
		COLLAPSE_EXPAND 
		
		  //______________________________________________________
	: ($Mnu_choice="automatic")
		
		Form:C1466.autoClose:=Not:C34(Form:C1466.autoClose)
		$b:=Form:C1466.autoClose
		_o_PREFERENCES ("auto_hide.set";->$b)
		
		If (Form:C1466.autoClose)
			
			Form:C1466.event:=999
			SET TIMER:C645(-1)
			
		End if 
		
		  //______________________________________________________
	: ($Mnu_choice="Skin_@")
		
		$Mnu_choice:=Replace string:C233($Mnu_choice;"Skin_";"";1)
		Skin ($Mnu_choice)
		_o_PREFERENCES ("Skin.set";->$Mnu_choice)
		
		  //______________________________________________________
	: ($Mnu_choice="Pos_@")
		
		$Mnu_choice:=Replace string:C233($Mnu_choice;"Pos_";"")
		
		GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
		
		$Lon_height:=$Lon_bottom-$Lon_top
		$Lon_width:=$Lon_right-$Lon_left
		
		If ($Mnu_choice="Top@")
			
			$Lon_top:=Menu bar height:C440+(60*Tool bar height:C1016)
			$Lon_bottom:=$Lon_top+$Lon_height
			
		End if 
		
		If ($Mnu_choice="Bottom@")
			
			$Lon_bottom:=Screen height:C188
			$Lon_top:=$Lon_bottom-$Lon_height
			
		End if 
		
		If ($Mnu_choice="@Left")
			
			$Lon_left:=0
			$Lon_right:=$Lon_width
			
			Form:C1466.page:=1
			FORM GOTO PAGE:C247(Form:C1466.page)
			
		End if 
		
		If ($Mnu_choice="@Right")
			
			$Lon_right:=Screen width:C187
			$Lon_left:=$Lon_right-$Lon_width
			
			Form:C1466.page:=2
			FORM GOTO PAGE:C247(Form:C1466.page)
			
		End if 
		
		SET WINDOW RECT:C444($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;Form:C1466.window)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(Tool_Execute_Method ($Mnu_choice);Replace string:C233(Get localized string:C991("ErrorOccuredDuringExecutionOfTheMethod");"{methodName}";$Mnu_choice))
		
		  //______________________________________________________
End case 