//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : PREFERENCES
  // ID[7BDC08A81A144EA5B5C12E2EFB652938]
  // Created 21/05/07 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_POINTER:C301(${2})

C_BOOLEAN:C305($Boo_set)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_element;$Dom_root;$Txt_entryPoint;$Txt_errorHandler;$Txt_path;$Txt_Xpath)

If (False:C215)
	C_TEXT:C284(_o_PREFERENCES ;$1)
	C_POINTER:C301(_o_PREFERENCES ;${2})
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Txt_entryPoint:=$1
	
	$Boo_set:=($Txt_entryPoint="@.set")
	
	$Txt_entryPoint:=Replace string:C233($Txt_entryPoint;Choose:C955($Boo_set;".set";".get");"")
	
	$Txt_path:=4DPop_preferencePath 
	
	If (Test path name:C476($Txt_path)=Is a document:K24:1)
		
		$Dom_root:=DOM Parse XML source:C719($Txt_path)
		
	Else 
		
		$Dom_root:=DOM Create XML Ref:C861("preference")
		DOM SET XML DECLARATION:C859($Dom_root;"UTF-8";False:C215)
		XML SET OPTIONS:C1090($Dom_root;XML indentation:K45:34;XML with indentation:K45:35)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (OK=1)
	
	If ($Txt_entryPoint="version")
		
		$Dom_element:=$Dom_root
		
	Else 
		
		$Txt_Xpath:="preference/"+$Txt_entryPoint
		$Dom_element:=DOM Find XML element:C864($Dom_root;$Txt_Xpath)
		
	End if 
	
	$Txt_errorHandler:=Method called on error:C704
	ON ERR CALL:C155("noError")
	
	Case of 
			
			  //_________________________________________________________
		: ($Txt_entryPoint="version")\
			 & (Asserted:C1132($Lon_parameters>=2))
			
			If ($Boo_set)
				
				DOM SET XML ATTRIBUTE:C866($Dom_element;\
					$Txt_entryPoint;$2->)
				
			Else 
				
				DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;$Txt_entryPoint;$2->)
				
			End if 
			
			  //_________________________________________________________
		: ($Txt_entryPoint="digest")\
			 & (Asserted:C1132($Lon_parameters>=2))
			
			If ($Boo_set)
				
				If (OK=0)
					
					$Dom_element:=DOM Create XML element:C865($Dom_root;$Txt_Xpath;\
						"value";$2->)
					
				Else 
					
					DOM SET XML ATTRIBUTE:C866($Dom_element;\
						"value";$2->)
					
				End if 
				
			Else 
				
				If (OK=1)
					
					DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"value";$2->)
					
				End if 
				
				If (OK=0)
					
					$2->:=""
					
				End if 
			End if 
			
			  //_________________________________________________________
		: ($Txt_entryPoint="auto_hide")\
			 & (Asserted:C1132($Lon_parameters>=2))
			
			If ($Boo_set)
				
				If (OK=0)
					
					$Dom_element:=DOM Create XML element:C865($Dom_root;$Txt_Xpath;\
						"value";$2->)
					
				Else 
					
					DOM SET XML ATTRIBUTE:C866($Dom_element;\
						"value";$2->)
					
				End if 
				
			Else 
				
				If (OK=1)
					
					DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"value";$2->)
					
				End if 
				
				If (OK=0)
					
					$2->:=True:C214
					
				End if 
			End if 
			
			  //_________________________________________________________
		: ($Txt_entryPoint="Viewing")\
			 & (Asserted:C1132($Lon_parameters>=2))
			
			If ($Boo_set)
				
				If (OK=0)
					
					$Dom_element:=DOM Create XML element:C865($Dom_root;$Txt_Xpath;\
						"number";$2->)
					
				Else 
					
					DOM SET XML ATTRIBUTE:C866($Dom_element;\
						"number";$2->)
					
				End if 
				
			Else 
				
				If (OK=1)
					
					DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"number";$2->)
					
				End if 
				
				If (OK=0)
					
					$2->:=MAXLONG:K35:2  //Count list items(<>tools)
					
				End if 
			End if 
			
			  //_________________________________________________________
		: ($Txt_entryPoint="Skin")\
			 & (Asserted:C1132($Lon_parameters>=2))
			
			If ($Boo_set)
				
				If (OK=0)
					
					$Dom_element:=DOM Create XML element:C865($Dom_root;$Txt_Xpath;\
						"name";$2->)
					
				Else 
					
					DOM SET XML ATTRIBUTE:C866($Dom_element;\
						"name";$2->)
					
				End if 
				
			Else 
				
				If (OK=1)
					
					DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"name";$2->)
					
				End if 
				
				If (OK=0)
					
					$2->:="Default"
					
				End if 
			End if 
			
			  //_________________________________________________________
		: ($Txt_entryPoint="Palette")\
			 & (Asserted:C1132($Lon_parameters>=5))
			
			If ($Boo_set)
				
				If (OK=0)
					
					$Dom_element:=DOM Create XML element:C865($Dom_root;$Txt_Xpath;\
						"left";String:C10($2->);\
						"top";String:C10($3->);\
						"right";String:C10($4->);\
						"bottom";String:C10($5->))
					
				Else 
					
					DOM SET XML ATTRIBUTE:C866($Dom_element;\
						"left";String:C10($2->);\
						"top";String:C10($3->);\
						"right";String:C10($4->);\
						"bottom";String:C10($5->))
					
				End if 
				
			Else 
				
				If (OK=1)
					
					DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"left";$2->)
					DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"top";$3->)
					DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"right";$4->)
					DOM GET XML ATTRIBUTE BY NAME:C728($Dom_element;"bottom";$5->)
					
				End if 
				
				If (OK=0)
					
					$2->:=-1
					$3->:=-1
					$4->:=-1
					$5->:=-1
					
				End if 
			End if 
			
			  //__________________________________________________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_entryPoint+"\"")
			
			  //_________________________________________________________
	End case 
	
	ON ERR CALL:C155($Txt_errorHandler)
	
	If ($Boo_set)
		
		DOM EXPORT TO FILE:C862($Dom_root;$Txt_path)
		
	End if 
	
	DOM CLOSE XML:C722($Dom_root)
	
End if 

  // ----------------------------------------------------
  // End