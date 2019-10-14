//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : obj_Txt_3DButton_Format
  // Created 05/06/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // Calculate the displayFormat character string to format 3D buttons with SET FORMAT command
  // title;picture;background;titlePos;titleVisible;iconVisible;style;horMargin;vertMargin;iconOffset;popupMenu
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_TEXT:C284($Txt_EntryPoint;$Txt_Format;$Txt_Value)

If (False:C215)
	C_TEXT:C284(obj_Txt_3DButton_Format ;$0)
	C_TEXT:C284(obj_Txt_3DButton_Format ;$1)
	C_TEXT:C284(obj_Txt_3DButton_Format ;$2)
End if 

$Txt_EntryPoint:=$1
$Txt_Value:=$2

Case of 
		
		  //______________________________________________________
	: ($Txt_EntryPoint="title")  //Button title.
		
		  //This value can be expressed as text or a resource number (ex.: ":16800,1")
		$Txt_Format:=$Txt_Value
		
		  //______________________________________________________
	: ($Txt_EntryPoint="picture")  //Picture linked to a button that comes from :
		
		  //a picture library, a picture variable a PICT resource or a picture file
		$Txt_Format:=";"+$Txt_Value
		
		  //______________________________________________________
	: ($Txt_EntryPoint="background")  //Background picture linked to a button (Custom style)
		
		$Txt_Format:=";;"+$Txt_Value
		
		  //______________________________________________________
	: ($Txt_EntryPoint="titlePos")  //Position of the button title. Five values are possible:
		
		  //0: Middle; 1: Right; 2: Left; 3: Bottom; 4: Top
		$Txt_Format:=";;;"+$Txt_Value
		
		  //______________________________________________________
	: ($Txt_EntryPoint="titleVisible")  //Defines whether or not the title is visible. Two values are possible:
		
		  //0: the title is hidden; 1: the title is displayed
		$Txt_Format:=";;;;"+$Txt_Value
		
		  //______________________________________________________
	: ($Txt_EntryPoint="iconVisible")  //Defines whether or not the icon is visible. Two values are possible:
		
		  //0 : the icon is hidden; 1 : the icon is displayed
		$Txt_Format:=";;;;;"+$Txt_Value
		
		  //______________________________________________________
	: ($Txt_EntryPoint="style")  //Button style. Ten values are possible:
		
		  //0: None; 1: Background offset; 2: Push button; 3: Toolbar button; 4: Custom;
		  //5: Circle; 6: Small system square; 7: Office XP; 8: Bevel; 9: Rounded bevel
		$Txt_Format:=";;;;;;"+$Txt_Value
		
		  //______________________________________________________
	: ($Txt_EntryPoint="horMargin")  //Horizontal margin.
		
		  //Number of pixels delimiting the inside left and right margins of the button (areas that the icon and the text must not encroach upon).
		$Txt_Format:=";;;;;;;"+$Txt_Value
		
		  //______________________________________________________
	: ($Txt_EntryPoint="vertMargin")  //Vertical margin.
		
		  //Number of pixels delimiting the inside top and bottom margins of the button (areas that the icon and the text must not encroach upon).
		$Txt_Format:=";;;;;;;;"+$Txt_Value
		
		  //______________________________________________________
	: ($Txt_EntryPoint="iconOffset")  //Shifting of the icon to the right and down.
		
		  //This value, expressed in pixels, indicates the shifting of the button icon to the right and down when the button is clicked (the same value is used for both directions).
		$Txt_Format:=";;;;;;;;;"+$Txt_Value
		
		  //______________________________________________________
	: ($Txt_EntryPoint="popupMenu")  //Association of a pop-up menu with the button. Three values are possible:
		
		  //0: No pop-up menu; 1: With linked pop-up menu; 2: With separate pop-up menu
		$Txt_Format:=";;;;;;;;;;"+$Txt_Value
		
		  //______________________________________________________
End case 

$0:=$Txt_Format