//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : 4DPop_hostDatabaseInformation
  // ID[6B97861A11514D18A0460316AA92500D]
  // Created 01/02/12 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //result := 4DPop_hostDatabaseInformation( {selector} )
  // Provides some useful informations for the host database according to the parameter selector.
  //
  // In selector, you can pass one of the following constants, which are located in the "4DPop Host Database Informations" theme:
  //           - kDatabase Name (0) or omitted = Database name without extension
  //           - kDatabase full Name (1) =  Database name with extension (4DB or 4DC)
  //           - kDatabase Path (2) =  The path of the host database in system format
  //           - kDatabase POSIX Path (3) =  The POSIX path of the host database
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_LONGINT:C283($1)

C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_type)
C_TEXT:C284($Txt_name;$Txt_path;$Txt_return)

If (False:C215)
	C_TEXT:C284(4DPop_hostDatabaseInformation ;$0)
	C_LONGINT:C283(4DPop_hostDatabaseInformation ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	If ($Lon_parameters>=1)
		
		$Lon_type:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

$Txt_path:=Structure file:C489(*)

For ($Lon_i;Length:C16($Txt_path);1;-1)
	
	If ($Txt_path[[$Lon_i]]=Folder separator:K24:12)
		
		$Txt_name:=Delete string:C232($Txt_path;1;$Lon_i)
		$Lon_i:=0
		
	End if 
	
End for 

Case of 
		
		  //______________________________________________________
	: ($Lon_type=kDatabase full Name)
		
		  //Nothing more to do
		$Txt_return:=$Txt_name
		
		  //______________________________________________________
	: ($Lon_type=kDatabase Name)
		
		For ($Lon_i;Length:C16($Txt_name);1;-1)
			
			If ($Txt_name[[$Lon_i]]=".")
				
				$Txt_return:=Delete string:C232($Txt_name;$Lon_i;Length:C16($Txt_name)-$Lon_i+1)
				$Lon_i:=0
				
			End if 
			
		End for 
		
		  //______________________________________________________
	: ($Lon_type=kDatabase Path)
		
		  //Nothing more to do
		$Txt_return:=$Txt_path
		
		  //______________________________________________________
	: ($Lon_type=kDatabase POSIX Path)
		
		  //Nothing more to do
		$Txt_return:=Convert path system to POSIX:C1106($Txt_path)
		
		  //______________________________________________________
	Else 
		
		  //______________________________________________________
End case 

$0:=$Txt_return

  // ----------------------------------------------------
  // End