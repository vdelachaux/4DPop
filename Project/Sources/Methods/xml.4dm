//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : xml
  // ID[C1F59DFEA5654C23942A3C4013F4F826]
  // Created 13-8-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BLOB:C604($x)
C_TEXT:C284($t;$tt;$Txt_what)
C_OBJECT:C1216($o;$oo)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(xml ;$0)
	C_TEXT:C284(xml ;$1)
	C_OBJECT:C1216(xml ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)  // Constructor
	
	$t:=String:C10($1)
	
	$o:=New object:C1471(\
		"_is";"xml";\
		"root";Null:C1517;\
		"latest";Null:C1517;\
		"autoClose";True:C214;\
		"success";False:C215;\
		"errors";New collection:C1472;\
		"xml";Null:C1517;\
		"origin";Null:C1517;\
		"file";Null:C1517;\
		"close";Formula:C1597(xml ("close"));\
		"toObject";Formula:C1597(xml ("toObject";New object:C1471("withReferences";$1)))\
		)
	
	If (Count parameters:C259>=1)
		
		$c:=Split string:C1554($1;";")  // Optional text enumeration semicolons separated
		
		Case of 
				
				  //______________________________________________________
			: ($c.indexOf("parse")#-1)  // Parse a given BLOB or Text type variable
				
				If ($2.variable#Null:C1517)  // Variable to parse
					
					If (Value type:C1509($2.variable)=Is BLOB:K8:12)
						
						$x:=$2.variable
						$t:=DOM Parse XML variable:C720($x)
						
					Else 
						
						$tt:=String:C10($2.variable)
						$t:=DOM Parse XML variable:C720($tt)
						
					End if 
					
					If (Bool:C1537(OK))
						
						$o.root:=$t
						
					End if 
					
				Else 
					
					$o.errors.push("Missing variable to parse.")
					
				End if 
				
				  //______________________________________________________
			: ($c.indexOf("load")#-1)  // Parse a document
				
				If ($2#Null:C1517)  // File to load
					
					If (Bool:C1537($2.isFile) & Bool:C1537($2.exists))  // File to load
						
						$t:=DOM Parse XML source:C719($2.platformPath)
						
						If (Bool:C1537(OK))
							
							$o.root:=$t
							$o.origin:=$2
							
						End if 
						
					Else 
						
						$o.errors.push("File doesn't exists: "+String:C10($2.platformPath))
						
					End if 
					
				Else 
					
					$o.errors.push("Missing object pathname to load.")
					
				End if 
				
				  //______________________________________________________
		End case 
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
					
					If ($o.root#Null:C1517)
						
						DOM CLOSE XML:C722($o.root)
						$o.root:=Null:C1517
						
					End if 
					
					  //=================================================================
				: ($1="toObject")
					
					DOM GET XML ELEMENT NAME:C730(This:C1470.root;$t)
					This:C1470.success:=Bool:C1537(OK)
					
					If (This:C1470.success)
						
						$o:=New object:C1471(\
							$t;xml_elementToObject (This:C1470.root;Bool:C1537($2.withReferences)))
						
						If (This:C1470.autoClose)\
							 & (Not:C34(Bool:C1537($2.keep)))
							
							This:C1470.close()
							
						End if 
						
					Else 
						
						  // push error
						
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