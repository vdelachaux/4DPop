  // ----------------------------------------------------
  // Method : Button_Method
  // Created 01/12/06 by Vincent de Lachaux
  // ----------------------------------------------------
  // Modified by vdl (21/05/07)
  // On drop
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_LONGINT:C283($0)

C_BOOLEAN:C305($Boo_Default;$Boo_Help;$Boo_Run)
C_LONGINT:C283($i;$l;$Lon_event)
C_TEXT:C284($Mnu_tools;$t;$Txt_object)
C_OBJECT:C1216($o;$o_widget)

$0:=-1

$Lon_event:=Form event code:C388

$Txt_object:=OBJECT Get name:C1087(Object current:K67:2)
$l:=Num:C11($Txt_object)

SET ASSERT ENABLED:C1131(True:C214;*)

$o_widget:=Form:C1466.widgets[$l-1]

Case of 
		
		  //______________________________________________________
	: ($Lon_event=On Mouse Enter:K2:33)
		
		  //LIRE PARAMETRE ELEMENT(<>Lst_tools;$Lon_toolID;"helptip";$Txt_buffer)
		  //$Txt_buffer:=Choisir(Longueur($Txt_buffer)>0;$Txt_buffer;$Txt_toolName)
		  //OBJET FIXER MESSAGE AIDE(*;$Txt_object;$Txt_buffer)
		
		  //______________________________________________________
	: ($Lon_event=On Mouse Move:K2:35)\
		 & (Macintosh option down:C545 | Windows Alt down:C563)
		
		  //GET LIST ITEM PARAMETER(<>tools;$Lon_toolID;"helpfile";$t)
		
		If (Length:C16($t)>0)
			
			SET CURSOR:C469(261)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_event=On Mouse Leave:K2:34)
		
		SET CURSOR:C469
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_event=On Alternative Click:K2:36)\
		 | ($Lon_event=On Long Click:K2:37)
		
		$Boo_Run:=True:C214
		$Boo_Help:=(Macintosh option down:C545 | Windows Alt down:C563)
		
		  //______________________________________________________
	: ($Lon_event=On Clicked:K2:4)
		
		$t:=String:C10($o_widget.default)
		
		$Boo_Default:=(Length:C16($t)>0)
		$Boo_Run:=Not:C34($Boo_Default)
		$Boo_Help:=(Macintosh option down:C545 | Windows Alt down:C563)
		
		  //______________________________________________________
	: ($Lon_event=On Drag Over:K2:13)
		
		$t:=String:C10($o_widget.ondrop)
		
		$0:=Choose:C955(Length:C16($t)>0;0;Button_OnDrop )
		
		  //______________________________________________________
	: ($Lon_event=On Drop:K2:12)
		
		$t:=String:C10($o_widget.ondrop)
		
		If (Length:C16($t)>0)
			
			ASSERT:C1129(Tool_Execute_Method ($t);Replace string:C233(Get localized string:C991("ErrorOccuredDuringExecutionOfTheMethod");"{methodName}";$t))
			
		Else 
			
			Button_OnDrop 
			
		End if 
		
		  //______________________________________________________
End case 

Case of 
		
		  //______________________________________________________
	: ($Boo_Default)
		
		$t:=String:C10($o_widget.default)
		ASSERT:C1129(Tool_Execute_Method ($t);Replace string:C233(Get localized string:C991("ErrorOccuredDuringExecutionOfTheMethod");"{methodName}";$t))
		
		  //______________________________________________________
	: ($Boo_Help)
		
		  //GET LIST ITEM PARAMETER(<>tools;$Lon_toolID;"helpfile";$t)
		
		If (Length:C16($t)>0)
			
			OPEN URL:C673($t;*)
			
		Else 
			
			BEEP:C151  // No Help file
			
		End if 
		
		  //______________________________________________________
	: ($Boo_Run)
		
		If ($o_widget.tool.length=1)
			
			$t:=$o_widget.tool[0].method
			
		Else 
			
			$Mnu_tools:=Create menu:C408
			
			For each ($o;$o_widget.tool)
				
				APPEND MENU ITEM:C411($Mnu_tools;$o.name)
				SET MENU ITEM PARAMETER:C1004($Mnu_tools;-1;String:C10($i))
				$i:=$i+1
				
				If ($o.picture_path#Null:C1517)
					
					SET MENU ITEM ICON:C984($Mnu_tools;-1;String:C10($o.picture_path))
					
				End if 
			End for each 
			
			$l:=Num:C11(Dynamic pop up menu:C1006($Mnu_tools))
			RELEASE MENU:C978($Mnu_tools)
			
			If ($l#0)
				
				$t:=$o_widget.tool[$l].method
				
			End if 
		End if 
		
		If (Length:C16($t)>0)
			
			ASSERT:C1129(Tool_Execute_Method ($t);Replace string:C233(Get localized string:C991("ErrorOccuredDuringExecutionOfTheMethod");"{methodName}";$t))
			
		End if 
		
		  //______________________________________________________
End case 

Form:C1466.event:=999
SET TIMER:C645(-1)