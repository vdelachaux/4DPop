//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : Tools_Menu
  // Created 04/06/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // Creates a hierarchical menu with the installed tools
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
  //C_TEXT($0)
  //C_LONGINT($1)

  //C_LONGINT($Lon_actionID;$Lon_actionNumber;$Lon_i;$Lon_j;$Lon_start;$Lon_toolID)
  //C_LONGINT($Lst_actions)
  //C_TEXT($Mnu_actions;$Mnu_main;$Txt_action;$Txt_actionName;$Txt_toolName)

  //If (False)
  //C_TEXT(Tools_Menu ;$0)
  //C_LONGINT(Tools_Menu ;$1)
  //End if 

  //If (Count parameters>=1)

  //$Lon_start:=$1

  //Else 

  //$Lon_start:=1

  //End if 

  //$Mnu_main:=Create menu

  //For ($Lon_i;$Lon_start;Count list items(<>tools);1)

  //GET LIST ITEM(<>tools;$Lon_i;$Lon_toolID;$Txt_toolName)
  //GET LIST ITEM PARAMETER(<>tools;$Lon_toolID;"tools";$Lst_actions)
  //$Lon_actionNumber:=Count list items($Lst_actions)

  //If ($Lon_actionNumber=1)

  //APPEND MENU ITEM($Mnu_main;$Txt_toolName)
  //GET LIST ITEM($Lst_actions;1;$Lon_actionID;$Txt_actionName)
  //GET LIST ITEM PARAMETER($Lst_actions;$Lon_actionID;"method";$Txt_action)
  //SET MENU ITEM PARAMETER($Mnu_main;-1;$Txt_action)

  //Else 

  //$Mnu_actions:=Create menu

  //For ($Lon_j;1;$Lon_actionNumber;1)

  //GET LIST ITEM($Lst_actions;$Lon_j;$Lon_actionID;$Txt_actionName)
  //APPEND MENU ITEM($Mnu_actions;$Txt_actionName)
  //GET LIST ITEM PARAMETER($Lst_actions;$Lon_actionID;"method";$Txt_action)
  //SET MENU ITEM PARAMETER($Mnu_actions;-1;$Txt_action)

  //End for 

  //APPEND MENU ITEM($Mnu_main;$Txt_toolName;$Mnu_actions)

  //End if 
  //End for 

  //$0:=$Mnu_main