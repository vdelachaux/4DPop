//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : Skin
  // Created 11/10/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($b)
C_LONGINT:C283($i;$l;$Lon_x)
C_POINTER:C301($r)
C_TEXT:C284($Dir_skin;$Dom_element;$Dom_root;$Mnu_main;$t;$Txt_entryPoint)

If (False:C215)
	C_TEXT:C284(Skin ;$0)
	C_TEXT:C284(Skin ;$1)
	C_TEXT:C284(Skin ;$2)
End if 

$Txt_entryPoint:=$1

If (Bool:C1537(Form:C1466.skinEnabled))
	
	Case of 
			
			  //______________________________________________________
		: ($Txt_entryPoint="menu")
			
			_o_PREFERENCES ("Skin.get";->$t)
			
			$Mnu_main:=Create menu:C408
			
			ARRAY TEXT:C222($tTxt_folders;0x0000)
			FOLDER LIST:C473(Form:C1466.skinRoot;$tTxt_folders)
			SORT ARRAY:C229($tTxt_folders)
			
			For ($i;1;Size of array:C274($tTxt_folders);1)
				
				If ($tTxt_folders{$i}#"@(Dark)")
					
					DOCUMENT LIST:C474(Form:C1466.skinRoot+$tTxt_folders{$i};$tTxt_files)
					
					If (Find in array:C230($tTxt_files;"skin.xml")>0)
						
						APPEND MENU ITEM:C411($Mnu_main;$tTxt_folders{$i};*)
						SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"Skin_"+$tTxt_folders{$i})
						
						If ($tTxt_folders{$i}=$t)
							
							SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
							
						End if 
					End if 
				End if 
			End for 
			
			$0:=$Mnu_main
			
			  //______________________________________________________
		: ($Txt_entryPoint="update")
			
			  // Test if dark mode is enabled
			$b:=ui_darkMode   // Ui_darkMode
			
			If (Form:C1466.darkMode=Not:C34($b))
				
				Form:C1466.darkMode:=$b
				
				Skin (Form:C1466.skin)
				
			End if 
			
			  //______________________________________________________
		: (Length:C16($Txt_entryPoint)=0)  // Default skin
			
			  //
			
			  //______________________________________________________
		Else 
			
			If (Bool:C1537(Form:C1466.darkMode))
				
				If (Test path name:C476(Form:C1466.skinRoot+$Txt_entryPoint+" (Dark)")=Is a folder:K24:2)
					
					$Txt_entryPoint:=$Txt_entryPoint+" (Dark)"
					
				End if 
			End if 
			
			$Dir_skin:=Form:C1466.skinRoot+$Txt_entryPoint+Folder separator:K24:12
			
			If (Test path name:C476($Dir_skin)=Is a folder:K24:2)
				
				err_NoERROR ("Init")
				
				ARRAY TEXT:C222($tTxt_files;0x0000)
				DOCUMENT LIST:C474($Dir_skin;$tTxt_files)
				
				  // Background picture
				$r:=OBJECT Get pointer:C1124(Object named:K67:5;"background")
				
				$Lon_x:=Find in array:C230($tTxt_files;"Background@")
				
				If ($Lon_x>0)
					
					READ PICTURE FILE:C678($Dir_skin+$tTxt_files{$Lon_x};$r->)
					
				Else 
					
					$r->:=$r->*0
					
				End if 
				
				RESOLVE POINTER:C394($r;$t;$l;$l)
				OBJECT SET FORMAT:C236(*;"skin.background";"!"+$t)
				
				  // First restore the default values {
				OBJECT SET FORMAT:C236(*;"_background";Char:C90(Scaled to fit:K6:2))
				
				OBJECT SET FORMAT:C236(*;"toolButton_@";obj_Txt_3DButton_Format ("style";Form:C1466.style))
				OBJECT SET FORMAT:C236(*;"toolButton_@";obj_Txt_3DButton_Format ("titleVisible";Form:C1466.title))
				OBJECT SET FORMAT:C236(*;"toolButton_@";obj_Txt_3DButton_Format ("titlePos";"0"))
				OBJECT SET FORMAT:C236(*;"toolButton_@";obj_Txt_3DButton_Format ("iconVisible";Form:C1466.icon))
				
				OBJECT SET RGB COLORS:C628(*;"toolButton_@";-1;-1)
				
				OBJECT SET FONT:C164(*;"toolButton_@";OBJECT Get font:C1069(*;""))
				OBJECT SET FONT SIZE:C165(*;"toolButton_@";11-Num:C11(Is Windows:C1573))
				OBJECT SET FONT STYLE:C166(*;"toolButton_@";Plain:K14:1)
				  //}
				
				$Dom_root:=DOM Parse XML source:C719($Dir_skin+"skin.xml";False:C215)
				
				If (OK=1)
					
					$Dom_element:=DOM Find XML element:C864($Dom_root;"skin/back")
					
					If (OK=1)
						
						  // Mode
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"mode";$t)
						
						If (OK=1)
							
							OBJECT SET FORMAT:C236(*;"_background@";Char:C90(Num:C11($t)))
							
						End if 
					End if 
					
					$Dom_element:=DOM Find XML element:C864($Dom_root;"skin/buttons")
					
					If (OK=1)
						
						  // Style
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"style";$t)
						
						If (OK=1)
							
							OBJECT SET FORMAT:C236(*;"toolButton_@";obj_Txt_3DButton_Format ("style";$t))
							
						End if 
						
						  // TitleVisible
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"titleVisible";$t)
						
						If (OK=1)
							
							OBJECT SET FORMAT:C236(*;"toolButton_@";obj_Txt_3DButton_Format ("titleVisible";$t))
							
						End if 
						
						  // TitlePos
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"titlePos";$t)
						
						If (OK=1)
							
							OBJECT SET FORMAT:C236(*;"toolButton_@";obj_Txt_3DButton_Format ("titlePos";$t))
							
						End if 
						
						  // IconVisible
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"iconVisible";$t)
						
						If (OK=1)
							
							OBJECT SET FORMAT:C236(*;"toolButton_@";obj_Txt_3DButton_Format ("iconVisible";$t))
							
						End if 
					End if 
					
					$Dom_element:=DOM Find XML element:C864($Dom_root;"skin/font")
					
					If (OK=1)
						
						  // Color
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"color";$t)
						
						If (OK=1)
							
							$Lon_x:=str_gLon_Hex_To_Longint ($t)
							OBJECT SET RGB COLORS:C628(*;"toolButton_@";$Lon_x;Background color:K23:2)
							OBJECT SET RGB COLORS:C628(*;"version_@";$Lon_x;Background color:K23:2)
							
						End if 
						
						  // Font
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"name";$t)
						
						If (OK=1)
							
							ARRAY TEXT:C222($tTxt_fonts;0x0000)
							FONT LIST:C460($tTxt_fonts)
							
							If (Find in array:C230($tTxt_fonts;$t)>0)
								
								OBJECT SET FONT:C164(*;"toolButton_@";$t)
								
							End if 
						End if 
						
						  // Size
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"size";$l)
						
						If (OK=1)
							
							OBJECT SET FONT SIZE:C165(*;"toolButton_@";$l)
							
						End if 
						
						  // Style
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"styles";$l)
						
						If (OK=1)
							
							OBJECT SET FONT STYLE:C166(*;"toolButton_@";$l)
							
						End if 
					End if 
					
					DOM CLOSE XML:C722($Dom_root)
					
				End if 
				
				err_NoERROR ("Deinit")
				
			End if 
			
			  //______________________________________________________
	End case 
End if 