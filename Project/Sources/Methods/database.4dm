//%attributes = {"invisible":true}
  //%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($l)
C_TEXT:C284($t)
C_OBJECT:C1216($o)

ARRAY LONGINT:C221($tLon_number;0)
ARRAY TEXT:C222($tTxt_components;0)
ARRAY TEXT:C222($tTxt_plugins;0)
ARRAY TEXT:C222($tTxt_values;0)

If (False:C215)
	C_OBJECT:C1216(database ;$0)
	C_TEXT:C284(database ;$1)
	C_OBJECT:C1216(database ;$2)
End if 

If (This:C1470[""]=Null:C1517)
	
	$o:=New object:C1471(\
		"";"database";\
		"structure";Null:C1517;\
		"root";Null:C1517;\
		"isCompiled";Is compiled mode:C492(*);\
		"isInterpreted";Not:C34(Is compiled mode:C492(*));\
		"data";Null:C1517;\
		"locked";Is data file locked:C716;\
		"isDatabase";False:C215;\
		"isProject";False:C215;\
		"isMatrix";Structure file:C489=Structure file:C489(*);\
		"isRemote";Application type:C494=4D Remote mode:K5:5;\
		"parameters";Null:C1517;\
		"components";New collection:C1472;\
		"plugins";New collection:C1472;\
		"enableDebugLog";Formula:C1597(SET DATABASE PARAMETER:C642(Debug log recording:K37:34;1));\
		"disableDebugLog";Formula:C1597(SET DATABASE PARAMETER:C642(Debug log recording:K37:34;0));\
		"method";Formula:C1597(database ("methodExists";New object:C1471("method";$1)));\
		"clearCompiledCode";Formula:C1597(This:C1470.structure.parent.folder("DerivedData/CompiledCode").delete(Delete with contents:K24:24));\
		"componentAvailable";Formula:C1597(This:C1470.components.indexOf($1)#-1);\
		"pluginAvailable";Formula:C1597(This:C1470.plugins.indexOf($1)#-1)\
		)
	
	If ($o.isRemote)
		
		$o.name:=Structure file:C489(*)
		
	Else 
		
		$o.structure:=File:C1566(Structure file:C489(*);fk platform path:K87:2)
		$o.data:=File:C1566(Data file:C490;fk platform path:K87:2)
		$o.name:=$o.structure.name
		
		If ($o.isProject)
			
			If ($o.structure.parent.name="Project")
				
				  // Up two levels
				$o.root:=$o.structure.parent.parent
				
			Else 
				
				  // Old hierarchy
				If (Application type:C494#4D Server:K5:6)
					
					  // Up one level
					$o.root:=$o.structure.parent
					
				Else 
					
					$o.root:=$o.structure
					
				End if 
			End if 
			
		Else 
			
			$o.root:=$o.structure.parent.parent.parent
			
		End if 
	End if 
	
	$o.isProject:=Bool:C1537(Get database parameter:C643(113))
	$o.isDatabase:=Not:C34($o.isProject)
	
	$l:=Get database parameter:C643(User param value:K37:94;$t)
	
	Case of 
			
			  //______________________________________________________
		: ($t="{@")\
			 & ($t="@}")  // json object
			
			$o.parameters:=JSON Parse:C1218($t)
			
			  //______________________________________________________
		: ($t="[@")\
			 & ($t="@]")  // json array
			
			JSON PARSE ARRAY:C1219($t;$tTxt_values)
			$o.parameters:=New collection:C1472
			ARRAY TO COLLECTION:C1563(This:C1470.parameters;$tTxt_values)
			
			  //______________________________________________________
		Else 
			
			$o.parameters:=$t
			
			  //______________________________________________________
	End case 
	
	COMPONENT LIST:C1001($tTxt_components)
	ARRAY TO COLLECTION:C1563($o.components;$tTxt_components)
	
	PLUGIN LIST:C847($tLon_number;$tTxt_plugins)
	ARRAY TO COLLECTION:C1563($o.plugins;$tTxt_plugins)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($1="methodExists")
			
			$o.exists:=False:C215
			
			If (Asserted:C1132($2.method#Null:C1517;"missing name"))
				
				ARRAY TEXT:C222($tTxt_methods;0x0000)
				METHOD GET NAMES:C1166($tTxt_methods;*)
				
				$o.exists:=(Find in array:C230($tTxt_methods;String:C10($2.method))>0)
				
			End if 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

$0:=$o