//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : xliff_getString
  // Created 11/01/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description
  //
  // ----------------------------------------------------
  // Syntax
  // xliff_getString (resname{;Path}) -> String
  // ----------------------------------------------------
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_i;$Lon_Parameters)
C_TEXT:C284($Dom_group;$Dom_root;$Dom_source;$Dom_transUnit;$Txt_Buffer;$Txt_Localized_Folder_Path;$Txt_Path;$Txt_Resname;$Txt_Value)

ARRAY TEXT:C222($tTxt_Documents;0)

If (False:C215)
	C_TEXT:C284(xliff_getString ;$0)
	C_TEXT:C284(xliff_getString ;$1)
	C_TEXT:C284(xliff_getString ;$2)
End if 

$Txt_Resname:=$1

$Lon_Parameters:=Count parameters:C259

If ($Lon_Parameters>1)
	
	If (Test path name:C476($2)=Is a folder:K24:2)
		
		$Txt_Localized_Folder_Path:=$2
		$Lon_Parameters:=1
		
	End if 
End if 

If ($Lon_Parameters>1)
	
	$Txt_Path:=$2
	
Else 
	
	If (Length:C16($Txt_Localized_Folder_Path)=0)
		
		$Txt_Localized_Folder_Path:=env_Txt_Localized_Folder_Path 
		
	End if 
	
	If (Length:C16($Txt_Localized_Folder_Path)>0)
		
		DOCUMENT LIST:C474($Txt_Localized_Folder_Path;$tTxt_Documents)
		
		For ($Lon_i;1;Size of array:C274($tTxt_Documents);1)
			
			If ($tTxt_Documents{$Lon_i}="@.xlf")
				
				$Txt_Value:=xliff_getString ($Txt_Resname;$Txt_Localized_Folder_Path+$tTxt_Documents{$Lon_i})
				
				If (Length:C16($Txt_Value)>0)  // Finded
					
					$Lon_i:=Size of array:C274($tTxt_Documents)+1
					
				End if 
			End if 
		End for 
	End if 
End if 

If (Length:C16($Txt_Path)>0)
	
	err_NoERROR ("Init")
	$Dom_root:=DOM Parse XML source:C719($Txt_Path;False:C215)
	
	If (OK=1)
		
		  // Get the first group
		$Dom_group:=DOM Find XML element:C864($Dom_root;"/xliff/file/body/group")
		
		If (OK=1)
			
			Repeat 
				
				  // Find : Get the first Unit
				$Dom_transUnit:=DOM Get first child XML element:C723($Dom_group)
				
				If (OK=1)
					
					Repeat 
						
						  // Get the Unit resname
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_transUnit;"resname";$Txt_Buffer)
						
						If ($Txt_Buffer#$Txt_Resname)
							
							  // See next one
							$Dom_transUnit:=DOM Get next sibling XML element:C724($Dom_transUnit)
							
						End if 
					Until ($Txt_Buffer=$Txt_Resname)\
						 | (OK=0)
					
					If (OK=1)
						
						  // Get the target
						$Dom_source:=DOM Get first child XML element:C723($Dom_transUnit)
						
						  // Is the string translatable ? …
						DOM GET XML ATTRIBUTE BY NAME:C728($Dom_transUnit;"translate";$Txt_Buffer)
						
						If ($Txt_Buffer="no")
							
							  //… no : Get the source string
							DOM GET XML ELEMENT VALUE:C731($Dom_source;$Txt_Value)
							
						Else 
							
							  //… yes : Get the target string
							$Dom_source:=DOM Get next sibling XML element:C724($Dom_source)
							DOM GET XML ELEMENT VALUE:C731($Dom_source;$Txt_Value)
							
						End if 
					End if 
				End if 
				
				If (Length:C16($Txt_Value)=0)
					
					  // See next one
					$Dom_group:=DOM Get next sibling XML element:C724($Dom_group)
					
				End if 
			Until (Length:C16($Txt_Value)>0)\
				 | (OK=0)
		End if 
		
		DOM CLOSE XML:C722($Dom_root)
		
	End if 
	
	err_NoERROR ("Deinit")
	
End if 

$0:=$Txt_Value