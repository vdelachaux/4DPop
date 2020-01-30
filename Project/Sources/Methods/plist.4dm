//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : plist
  // ID[8B78E995CFBB4FFA977535953D1835E7]
  // Created 14-8-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($i)
C_TEXT:C284($Dom_dict;$t;$tt;$Txt_key;$Txt_value;$Txt_what)
C_OBJECT:C1216($o;$oo)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tDom_keys;0)

If (False:C215)
	C_OBJECT:C1216(plist ;$0)
	C_TEXT:C284(plist ;$1)
	C_OBJECT:C1216(plist ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)  // Constructor
	
	If (Count parameters:C259>=1)
		
		$t:=String:C10($1)
		
	End if 
	
	$o:=New object:C1471(\
		"_is";"plist";\
		"root";Null:C1517;\
		"autoClose";True:C214;\
		"file";Null:C1517;\
		"object";Null:C1517;\
		"errors";New collection:C1472;\
		"close";Formula:C1597(plist ("close"));\
		"get";Formula:C1597(plist ("get";New object:C1471("key";$1;"keep";Bool:C1537($2)))[$1]);\
		"toObject";Formula:C1597(plist ("toObject";New object:C1471("keep";Bool:C1537($1))).object)\
		)
	
	If (Count parameters:C259>=1)
		
		$c:=Split string:C1554($1;";")  // Optional text enumeration semicolons separated
		
		Case of 
				
				  //______________________________________________________
			: ($c.indexOf("load")#-1)  // Parse a document
				
				If ($2#Null:C1517)  // File to load
					
					$o.file:=$2
					
				Else 
					
					$o.file:=Folder:C1567(fk database folder:K87:14).file("Info.plist")
					
				End if 
				
				  //______________________________________________________
		End case 
		
	Else 
		
		$o.file:=Folder:C1567(fk database folder:K87:14).file("Info.plist")
		
	End if 
	
	If (Bool:C1537($o.file.isFile) & Bool:C1537($o.file.exists))
		
		$t:=DOM Parse XML source:C719($o.file.platformPath)
		$o.success:=Bool:C1537(OK)
		
		If ($o.success)
			
			$o.root:=$t
			
		End if 
		
	Else 
		
		$o.errors.push("File doesn't exists: "+String:C10($o.file.platformPath))
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	If (Asserted:C1132($o#Null:C1517;"OOPS, this method must be called from a member method"))
		
		If ($o.root=Null:C1517)
			
			$o.success:=False:C215
			$o.errors.push("The XML reference is not valid.")
			
		Else 
			
			$o.success:=True:C214
			
			If (Count parameters:C259>=2)
				
				$oo:=$2.options
				$Txt_what:=String:C10($2.what)
				
			End if 
			
			Case of 
					
					  //=================================================================
				: ($1="close")
					
					DOM CLOSE XML:C722($o.root)
					$o.root:=Null:C1517
					
					  //=================================================================
				: ($1="toObject")
					
					$o.object:=New object:C1471
					
					$tDom_keys{0}:=DOM Find XML element:C864(This:C1470.root;"plist/dict/key";$tDom_keys)
					
					$o.success:=Bool:C1537(OK)
					
					If ($o.success)
						
						For ($i;1;Size of array:C274($tDom_keys);1)
							
							DOM GET XML ELEMENT VALUE:C731($tDom_keys{$i};$Txt_key)
							DOM GET XML ELEMENT VALUE:C731(DOM Get next sibling XML element:C724($tDom_keys{$i});$Txt_value)
							$o.object[$Txt_key]:=$Txt_value
							
						End for 
						
						If ($o.autoClose)\
							 & (Not:C34(Bool:C1537($2.keep)))
							
							$o.close()
							
						End if 
					End if 
					
					  //=================================================================
				: ($1="get")
					
					$Dom_dict:=DOM Find XML element:C864(This:C1470.root;"plist/dict/")
					
					If (Bool:C1537(OK))
						
						$Txt_key:=String:C10($2.key)
						
						Repeat 
							
							$i:=$i+1
							$tt:=DOM Get XML element:C725($Dom_dict;"key";$i;$Txt_value)
							
							If ($Txt_value=$Txt_key)
								
								$tt:=DOM Get next sibling XML element:C724($tt)
								DOM GET XML ELEMENT VALUE:C731($tt;$t)
								
								$o.success:=Bool:C1537(OK)
								
								If ($o.success)
									
									$o[$Txt_key]:=$t
									
									If ($o.autoClose)\
										 & (Not:C34(Bool:C1537($2.keep)))
										
										$o.close()
										
									End if 
								End if 
							End if 
						Until ($Txt_value=$Txt_key)\
							 | (OK=0)
						
					End if 
					
					  //=================================================================
				Else 
					
					ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
					
					  //=================================================================
			End case 
			
			If (Not:C34(This:C1470.success))
				
				This:C1470.errors.push($1+" "+String:C10($2.what)+" failed")
				
			End if 
		End if 
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End 