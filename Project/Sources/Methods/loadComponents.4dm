//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : loadComponents
  // ID[D25572B0D5E74AFBBC3BAE4625CDC6B9]
  // Created 11-10-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_COLLECTION:C1488($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($folder;$o)
C_COLLECTION:C1488($c)

If (False:C215)
	C_COLLECTION:C1488(loadComponents ;$0)
	C_OBJECT:C1216(loadComponents ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$folder:=$1
	
	  // Default values
	$c:=New collection:C1472
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($folder.exists)
	
	  // Get databases
	$c:=$folder.folders().query("extension = :1";".4dbase")
	
	  // Add alias if any
	For each ($o;$folder.files())
		
		If ($o.original#Null:C1517)
			
			If ($o.original.exists)
				
				If (($o.original.isFolder) & ($o.original.extension=".4dbase"))\
					 | (($o.original.isFile) & ($o.original.extension=".4DProject"))
					
					$c.push($o)
					
				Else 
					
					  // <NOTHING MORE TO DO>
					
				End if 
				
			Else 
				
				  // <NOTHING MORE TO DO>
				
			End if 
			
		Else 
			
			  // Broken Alias
			
		End if 
	End for each 
End if 

  // ----------------------------------------------------
  // Return
$0:=$c

  // ----------------------------------------------------
  // End