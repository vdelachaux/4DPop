//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : Compiler_Variables
  // Created 05/06/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // A lot of variables was removed.
  // The cleanup must be continued
  // ----------------------------------------------------

  // Hierarchical list to store the 4DPop compatible loaded components
  //C_LONGINT(<>tools)

  // Flag for automatic mode. If true, the palette is expanded all the time where the
  // Mouse is dragging over and automatically collapsed if not
  //C_BOOLEAN(<>autoHide)

  // Managing errors
C_TEXT:C284(<>4DPop_CurrentMethodError)
C_LONGINT:C283(<>4DPop_Error)

  //C_LONGINT(<>timerEvent)

  // #12-12-2013
  // Flag autoboot. True if the host database allow "On Host database event"
  //C_BOOLEAN(<>autoBoot)

If (False:C215)  // Public
	
	  //……………………………………………………………………………
	C_TEXT:C284(4DPop_UPDATE_TOOL ;$1)
	C_OBJECT:C1216(4DPop_UPDATE_TOOL ;$2)
	
	  //……………………………………………………………………………
	  //C_BOOLEAN(4DPop_Palette ;$1)
	
	  //……………………………………………………………………………
	C_TEXT:C284(4DPop_applicationFolder ;$0)
	C_LONGINT:C283(4DPop_applicationFolder ;$1)
	
	  //……………………………………………………………………………
	C_TEXT:C284(4DPop_applicationLanguage ;$0)
	
	  //……………………………………………………………………………
	C_TEXT:C284(4DPop_hostDatabaseFolder ;$0)
	C_LONGINT:C283(4DPop_hostDatabaseFolder ;$1)
	C_BOOLEAN:C305(4DPop_hostDatabaseFolder ;$2)
	
	  //……………………………………………………………………………
	C_TEXT:C284(4DPop_hostDatabaseInformation ;$0)
	C_LONGINT:C283(4DPop_hostDatabaseInformation ;$1)
	
	  //……………………………………………………………………………
	C_BOOLEAN:C305(4DPop_preferenceDelete ;$0)
	C_TEXT:C284(4DPop_preferenceDelete ;$1)
	
	  //……………………………………………………………………………
	C_TEXT:C284(4DPop_preferenceLoad ;$0)
	C_TEXT:C284(4DPop_preferenceLoad ;$1)
	
	  //……………………………………………………………………………
	C_TEXT:C284(4DPop_preferencePath ;$0)
	
	  //……………………………………………………………………………
	C_BOOLEAN:C305(4DPop_preferenceStore ;$0)
	C_TEXT:C284(4DPop_preferenceStore ;$1)
	C_TEXT:C284(4DPop_preferenceStore ;$2)
	
	  //……………………………………………………………………………
	C_BOOLEAN:C305(4DPop_RECOVER_WINDOW ;$1)
	
	  //……………………………………………………………………………
End if 

If (False:C215)  // Private
	
	C_TEXT:C284(4DPOP ;$1)
	
	C_OBJECT:C1216(4DPop_INIT ;$0)
	
	C_BOOLEAN:C305(ui_darkMode ;$0)
	
	C_TEXT:C284(update_tool ;$1)
	C_OBJECT:C1216(update_tool ;$2)
	
	  //……………………………………………………………………………
	C_TEXT:C284(ABOUT ;$1)
	
	  //……………………………………………………………………………
	C_TEXT:C284(ASSISTANT ;$1)
	
	  //……………………………………………………………………………
	C_LONGINT:C283(Button_OnDrop ;$0)
	
	  //……………………………………………………………………………
	C_LONGINT:C283(COLLAPSE_EXPAND ;$1)
	
	  //……………………………………………………………………………
	C_TEXT:C284(doc_doPath ;$0)
	C_LONGINT:C283(doc_doPath ;$1)
	C_TEXT:C284(doc_doPath ;${2})
	
	  //……………………………………………………………………………
	C_TEXT:C284(doc_gTxt_Resolve_Alias ;$0)
	C_TEXT:C284(doc_gTxt_Resolve_Alias ;$1)
	
	  //……………………………………………………………………………
	C_TEXT:C284(env_Txt_Localized_Folder_Path ;$0)
	C_TEXT:C284(env_Txt_Localized_Folder_Path ;$1)
	C_TEXT:C284(env_Txt_Localized_Folder_Path ;$2)
	
	  //……………………………………………………………………………
	C_TEXT:C284(err_NoERROR ;$1)
	
	  //……………………………………………………………………………
	C_TEXT:C284(INSTALL ;$1)
	
	  //……………………………………………………………………………
	C_TEXT:C284(obj_Txt_3DButton_Format ;$0)
	C_TEXT:C284(obj_Txt_3DButton_Format ;$1)
	C_TEXT:C284(obj_Txt_3DButton_Format ;$2)
	
	  //……………………………………………………………………………
	C_TEXT:C284(_o_PREFERENCES ;$1)
	C_POINTER:C301(_o_PREFERENCES ;${2})
	
	  //……………………………………………………………………………
	C_TEXT:C284(Preferences_Get_Path ;$0)
	C_TEXT:C284(Preferences_Get_Path ;$1)
	C_LONGINT:C283(Preferences_Get_Path ;$2)
	
	  //……………………………………………………………………………
	C_TEXT:C284(Skin ;$0)
	C_TEXT:C284(Skin ;$1)
	C_TEXT:C284(Skin ;$2)
	
	  //……………………………………………………………………………
	C_LONGINT:C283(str_gLon_Hex_To_Longint ;$0)
	C_TEXT:C284(str_gLon_Hex_To_Longint ;$1)
	
	  //……………………………………………………………………………
	C_BOOLEAN:C305(Tool_Execute_Method ;$0)
	C_TEXT:C284(Tool_Execute_Method ;$1)
	
	  //……………………………………………………………………………
	C_TEXT:C284(Tools_Menu ;$0)
	C_LONGINT:C283(Tools_Menu ;$1)
	
	  //……………………………………………………………………………
	C_LONGINT:C283(win_Lon_Get_Offsets ;$0)
	C_LONGINT:C283(win_Lon_Get_Offsets ;$1)
	C_BOOLEAN:C305(win_Lon_Get_Offsets ;$2)
	
	  //……………………………………………………………………………
	C_TEXT:C284(xliff_Txt_Get_String ;$0)
	C_TEXT:C284(xliff_Txt_Get_String ;$1)
	C_TEXT:C284(xliff_Txt_Get_String ;$2)
	
	  //……………………………………………………………………………
End if 