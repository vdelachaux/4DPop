Class constructor
	
	This:C1470.file:=This:C1470.path()
	
	If (This:C1470.file.exists)
		
		This:C1470.root:=DOM Parse XML source:C719(This:C1470.file.platformPath)
		
	Else 
		
		This:C1470.root:=DOM Create XML Ref:C861("preference")
		DOM SET XML DECLARATION:C859(This:C1470.root; "UTF-8"; False:C215)
		XML SET OPTIONS:C1090(This:C1470.root; XML indentation:K45:34; XML with indentation:K45:35)
		
	End if 
	
	If (OK=0)
		
		This:C1470.root:=Null:C1517
		
	End if 
	
	//======================================================================
Function path()->$file : 4D:C1709.File
	
	$file:=File:C1566(4DPop_preferencePath; fk platform path:K87:2)
	
	//======================================================================
Function close()
	
	DOM CLOSE XML:C722(This:C1470.root)
	This:C1470.root:=Null:C1517
	
	//======================================================================
Function get($key : Text)->$value
	
	var $node : Text
	If ($key="version")
		
		$node:=This:C1470.root
		
	Else 
		
		$node:=DOM Find XML element:C864(This:C1470.root; "/preference/"+$key)
		
	End if 
	
	DOM GET XML ATTRIBUTE BY NAME:C728($node; $key; $value)
	
	