//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : xml_elementToObject
  // Database: 4D Mobile Express
  // ID[EE35EDAF20D24025877FA9FC15284E38]
  // Created 1-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns an XML element as an object
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_BOOLEAN:C305($2)

C_BOOLEAN:C305($Boo_references)
C_LONGINT:C283($Lon_count;$Lon_i;$Lon_parameters)
C_TEXT:C284($Dom_child;$Dom_elementRef;$Txt_key;$Txt_name;$Txt_value)
C_OBJECT:C1216($Obj_result)

If (False:C215)
	C_OBJECT:C1216(xml_elementToObject ;$0)
	C_TEXT:C284(xml_elementToObject ;$1)
	C_BOOLEAN:C305(xml_elementToObject ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Dom_elementRef:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Boo_references:=$2
		
	End if 
	
	$Obj_result:=New object:C1471
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // DOM reference
If ($Boo_references)
	
	$Obj_result["@"]:=$Dom_elementRef
	
End if 

  // For all attributes {
For ($Lon_i;1;DOM Count XML attributes:C727($Dom_elementRef);1)
	
	DOM GET XML ATTRIBUTE BY INDEX:C729($Dom_elementRef;$Lon_i;$Txt_key;$Txt_value)
	
	Case of   // Value types
			
			  //______________________________________________________
		: (Length:C16($Txt_key)=0)
			  // skip malformed node
			
			  //______________________________________________________
		: (Match regex:C1019("(?m-si)^\\d+\\.*\\d*$";$Txt_value;1))  // Numeric
			
			$Obj_result[$Txt_key]:=Num:C11($Txt_value;".")
			
			  //______________________________________________________
		: (Match regex:C1019("(?mi-s)^true|false$";$Txt_value;1))  // Boolean
			
			$Obj_result[$Txt_key]:=($Txt_value="true")
			
			  //______________________________________________________
		Else   // Text
			
			$Obj_result[$Txt_key]:=$Txt_value
			
			  //______________________________________________________
	End case 
End for 
  //}

  // Value if any {
DOM GET XML ELEMENT VALUE:C731($Dom_elementRef;$Txt_value)

If (Match regex:C1019("[^\\s]+";$Txt_value;1))
	
	$Obj_result["$"]:=$Txt_value
	
End if 
  //}

  // Childs if any {
$Dom_child:=DOM Get first child XML element:C723($Dom_elementRef;$Txt_name)

If (OK=1)
	
	  // Many one? [
	$Lon_count:=DOM Count XML elements:C726($Dom_elementRef;$Txt_name)
	
	If ($Lon_count>1)  // Yes
		
		$Obj_result[$Txt_name]:=New collection:C1472
		
		For ($Lon_i;1;$Lon_count;1)
			
			$Obj_result[$Txt_name].push(xml_elementToObject (DOM Get XML element:C725($Dom_elementRef;$Txt_name;$Lon_i);$Boo_references))
			
		End for 
		
	Else   // No
		
		$Obj_result[$Txt_name]:=xml_elementToObject ($Dom_child;$Boo_references)
		
	End if 
	  //]
	
	  // Next one, if any
	$Dom_child:=DOM Get next sibling XML element:C724($Dom_child;$Txt_name)
	
	While (OK=1)
		
		  // Already treated?
		If ($Obj_result[$Txt_name]=Null:C1517)
			
			  // Many one? [
			$Lon_count:=DOM Count XML elements:C726($Dom_elementRef;$Txt_name)
			
			If ($Lon_count>1)  // Yes
				
				$Obj_result[$Txt_name]:=New collection:C1472
				
				For ($Lon_i;1;$Lon_count;1)
					
					$Obj_result[$Txt_name].push(xml_elementToObject (DOM Get XML element:C725($Dom_elementRef;$Txt_name;$Lon_i);$Boo_references))
					
				End for 
				
			Else   // No
				
				$Obj_result[$Txt_name]:=xml_elementToObject ($Dom_child;$Boo_references)
				
			End if 
		End if 
		
		  // Next one, if any
		$Dom_child:=DOM Get next sibling XML element:C724($Dom_child;$Txt_name)
		
	End while 
End if 
  //}

  // ----------------------------------------------------
  // Return
$0:=$Obj_result

  // ----------------------------------------------------
  // End