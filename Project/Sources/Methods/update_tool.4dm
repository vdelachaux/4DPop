//%attributes = {"invisible":true}
  //  // ----------------------------------------------------
  //  // Project method: update_tool
  //  // Database: 4DPop
  //  // ID[210FB63DBCC44F7692F7774272DC4D21]
  //  // Created #6-6-2014 by Vincent de Lachaux
  //  // ----------------------------------------------------
  //  // Description
  //  //
  //  // ----------------------------------------------------
  //  // Declarations
  //C_TEXT($1)
  //C_OBJECT($2)

  //C_LONGINT($Lon_count;$Lon_i;$Lon_itemID;$Lon_parameters;$Lon_process;$Lon_toolID;$Lst_items)
  //C_TEXT($Txt_action;$Txt_language;$Txt_methodName;$Txt_path;$Txt_toolID;$Txt_toolPath)
  //C_OBJECT($Obj_message)

  //ARRAY TEXT($tDom_nodes;0)
  //ARRAY TEXT($tTxt_items;0)
  //ARRAY TEXT($tTxt_methods;0)

  //If (False)
  //C_TEXT(update_tool ;$1)
  //C_OBJECT(update_tool ;$2)
  //End if 

  //  // ----------------------------------------------------
  //  // Initialisations
  //$Lon_parameters:=Count parameters

  //If (Asserted($Lon_parameters>=2;"Missing parameter"))

  //  //Required parameters
  //$Txt_toolID:=$1
  //$Obj_message:=$2

  //  //Optional parameters
  //If ($Lon_parameters>=3)

  //End if 

  //$Txt_methodName:=Current method name
  //$Lon_process:=Process number("$"+$Txt_methodName)

  //Else 

  //ABORT

  //End if 

  //  // ----------------------------------------------------
  //If ($Lon_process=0)

  //$Lon_process:=New process($Txt_methodName;0;"$"+$Txt_methodName;$Txt_toolID;$Obj_message;*)

  //Else 

  //  //wait for palette

  //Repeat 

  //$Lon_process:=Current process

  //For ($Lon_i;1;20;1)

  //DELAY PROCESS($Lon_process;1)

  //End for 

  //$Lon_process:=Process number("$4DPop_Palette")

  //Until ($Lon_process#0)

  //  //wait for initialisation

  //Repeat 

  //$Lon_process:=Current process

  //For ($Lon_i;1;20;1)

  //DELAY PROCESS($Lon_process;1)

  //End for 
  //Until (<>timerEvent=0)\
 | (<>timerEvent=999)

  //  //do
  //$Lon_toolID:=Find in list(<>tools;$Txt_toolID;0;*)

  //If ($Lon_toolID#0)

  //$Txt_language:=Get database localization

  //$Txt_action:=OB Get($Obj_message;"action")

  //Case of 
  //  //______________________________________________________
  //: ($Txt_action="menu.add")

  //GET LIST ITEM PARAMETER(<>tools;$Lon_toolID;"tools";$Lst_items)
  //GET LIST ITEM PARAMETER(<>tools;$Lon_toolID;"path";$Txt_toolPath)

  //OB GET ARRAY($Obj_message;"items";$tTxt_items)
  //OB GET ARRAY($Obj_message;"methods";$tTxt_methods)

  //$Lon_count:=Size of array($tTxt_items)
  //$Lon_itemID:=$Lon_count

  //For ($Lon_i;1;$Lon_count;1)

  //$Lon_itemID:=$Lon_itemID+1

  //APPEND TO LIST($Lst_items;"Tool "+String($Lon_itemID);$Lon_itemID)

  //  //name
  //If ($tTxt_items{$Lon_i}=":xliff:@")  //localised

  //$Txt_path:=env_Txt_Localized_Folder_Path ($Txt_toolPath+Folder separator+"Resources"+Folder separator;$Txt_language)
  //$tTxt_items{$Lon_i}:=xliff_Txt_Get_String (Replace string($tTxt_items{$Lon_i};":xliff:";"");$Txt_path)

  //End if 

  //SET LIST ITEM($Lst_items;$Lon_itemID;$tTxt_items{$Lon_i};$Lon_itemID)

  //  //method
  //SET LIST ITEM PARAMETER($Lst_items;$Lon_itemID;"method";$tTxt_methods{$Lon_i})

  //End for 

  //SET LIST ITEM PARAMETER(<>tools;$Lon_toolID;"tools";$Lst_items)

  //If (Count list items($Lst_items)>0)

  //  //update the button
  //  //<>timerEvent:=-2

  //End if 

  //  //______________________________________________________
  //: (False)

  //  //______________________________________________________
  //Else 

  //  //______________________________________________________
  //End case 

  //CLEAR VARIABLE($Obj_message)

  //Else 

  //  //tool not found
  //ALERT("The tool \""+$Txt_toolID+"\" was not found")

  //End if 
  //End if 