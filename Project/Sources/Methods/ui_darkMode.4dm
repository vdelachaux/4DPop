//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_darkMode
  // ID[D3B9FB0808EE47E79518C159B704340F]
  // Created #17-1-2019 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Get information about OS color scheme
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)

C_BOOLEAN:C305($b)
C_TEXT:C284($Txt_in;$Txt_out)

If (False:C215)
	C_BOOLEAN:C305(ui_darkMode ;$0)
End if 

If (Is macOS:C1572)
	
	  // Get global apple interface style
	LAUNCH EXTERNAL PROCESS:C811("defaults read -g AppleInterfaceStyle";$Txt_in;$Txt_out)
	$b:=($Txt_out="Dark\n")
	
	If (($Txt_out="Dark\n"))
		
		  // Check if app override style (same as defaults read <bundle id>)
		LAUNCH EXTERNAL PROCESS:C811("defaults read -app '"+Convert path system to POSIX:C1106(Application file:C491)+"' NSRequiresAquaSystemAppearance";$Txt_in;$Txt_out)
		
		If ($Txt_out#"1\n")
			
			  // Check plist file
			LAUNCH EXTERNAL PROCESS:C811("defaults read '"+Convert path system to POSIX:C1106(Application file:C491)+"/Contents/Info.plist' NSRequiresAquaSystemAppearance";$Txt_in;$Txt_out)
			
			If ($Txt_out#"1\n")
				
				$0:=True:C214
				
			End if 
		End if 
	End if 
End if 