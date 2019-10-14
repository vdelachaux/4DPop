//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : Button_OnDrop
  // Created 24/09/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  // Drag & drop in the palette to install a new component
  // ----------------------------------------------------
  // Modified by vdl (22/04/08)
  // v11.2 -> It is not possible to install new component in remote mode
  // ----------------------------------------------------
  // Modified by Vincent de Lachaux (05/01/12)
  // v13 refactoring
  // ----------------------------------------------------
C_LONGINT:C283($0)

C_LONGINT:C283($Lon_dialWindow;$Lon_formEvent)
C_TEXT:C284($Txt_file)

If (False:C215)
	C_LONGINT:C283(Button_OnDrop ;$0)
End if 

$Txt_file:=Get file from pasteboard:C976(1)

If (Length:C16($Txt_file)>0)
	
	If ($Txt_file[[Length:C16($Txt_file)]]=Folder separator:K24:12)
		
		$Txt_file:=Substring:C12($Txt_file;1;Length:C16($Txt_file)-1)
		
	End if 
End if 

$0:=-1  // Default = Refuse the drop

$Lon_formEvent:=Form event code:C388

Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Leave:K2:34)
		
		  //______________________________________________________
	: (Application type:C494=4D Remote mode:K5:5)
		
		  //Installing a new component is not possible, for the moment,  in remote mode
		
		  //______________________________________________________
	: (Test path name:C476($Txt_file)#Is a folder:K24:2)
		
		  //Only folders are allowed for installation by drag & drop
		
		  //______________________________________________________
	: ($Txt_file#"@.4dbase")
		
		  //Only ".4dbase" are allowed for installation by drag & drop
		
		  //______________________________________________________
	: (Test path name:C476($Txt_file+Folder separator:K24:12+"Resources"+Folder separator:K24:12+"4DPop.xml")#Is a document:K24:1) & (Test path name:C476($Txt_file+Folder separator:K24:12+"Extras"+Folder separator:K24:12+"4DPop.xml")#Is a document:K24:1)
		
		
		  //This component is not compatible with 4DPop
		
		  //______________________________________________________
	: ($Lon_formEvent=On Drag Over:K2:13)
		
		  //Accept the drop
		SET CURSOR:C469(555)
		$0:=0
		
		  //______________________________________________________
	Else   //On drop
		
		  //Display the installation wizard
		$Lon_dialWindow:=Open form window:C675("ASSISTANT";Movable form dialog box:K39:8;Horizontally centered:K39:1;Vertically centered:K39:4)
		DIALOG:C40("ASSISTANT")
		CLOSE WINDOW:C154
		
		  //______________________________________________________
End case 

  //Show or hide the visual effect of drag & drop.
  //OBJET FIXER VISIBLE(*;"hightlight";$0=0)

  //Set the timer for hide the visual effect if user chooses to don't drop the dragged elements
Form:C1466.event:=99
SET TIMER:C645(20)