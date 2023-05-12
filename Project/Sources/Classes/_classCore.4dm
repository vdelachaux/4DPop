Class constructor
	
	This:C1470[""]:=New shared object:C1526(\
		"uid"; Generate UUID:C1066; \
		"errors"; New shared collection:C1527; \
		"success"; True:C214; \
		"ready"; False:C215)
	
	This:C1470.__CLASS__:=OB Class:C1730(This:C1470)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get success() : Boolean
	
	return This:C1470._.success
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set success($success : Boolean)
	
	Use (This:C1470._)
		
		This:C1470._.success:=Count parameters:C259=0 ? True:C214 : $success
		
	End use 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get ready() : Boolean
	
	return This:C1470._.ready
	
	// ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==> ==>
Function set ready()
	
	Use (This:C1470._)
		
		This:C1470._.ready:=True:C214
		
	End use 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get fail() : Boolean
	
	return Not:C34(This:C1470._.success)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get notReady() : Boolean
	
	return Not:C34(This:C1470._.ready)
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get lastError() : Text
	
	var $errors : Collection
	$errors:=This:C1470.errors
	
	return $errors.length=0 ? "" : $errors[$errors.length-1]
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get errors() : Collection
	
	return This:C1470._.errors
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get uid() : Text
	
	return This:C1470._.uid
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get singleton() : Boolean  // Return True if it's a refernce to the class
	
	return This:C1470.__CLASS__#Null:C1517
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get matrix() : Boolean  // Return True if it's the fisrt inastance of the class
	
	return This:C1470.__LockerID=Null:C1517
	
	// Mark:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function singletonize($instance : Object)  // Make the class a singleton
	
	// Get the class of the object passed in parameter
	This:C1470.__CLASS__:=OB Class:C1730($instance)
	
	If (This:C1470.__CLASS__.instance=Null:C1517)
		
		// Create the instance
		Use (This:C1470.__CLASS__)
			
			// As shareable
			This:C1470.__CLASS__.instance:=OB Copy:C1225($instance; ck shared:K85:29; This:C1470.__CLASS__)
			
			// Save the new function…
			This:C1470.__CLASS__._new:=This:C1470.new
			
			// And replace it
			This:C1470.__CLASS__.new:=Formula:C1597(This:C1470.instance)
			
		End use 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function succeed($success : Boolean) : cs:C1710._classCore
	
	Use (This:C1470._)
		
		This:C1470._.success:=Count parameters:C259=0 ? True:C214 : $success
		
	End use 
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function failure($failure : Boolean) : cs:C1710._classCore
	
	Use (This:C1470._)
		
		This:C1470._.success:=Count parameters:C259=0 ? False:C215 : Not:C34($failure)
		
	End use 
	
	return This:C1470
	
	// Mark:-
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isNum($value) : Boolean
	
	return (Value type:C1509($value)=Is longint:K8:6) | (Value type:C1509($value)=Is real:K8:4)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isText($value) : Boolean
	
	return Value type:C1509($value)=Is text:K8:3
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isFile($value) : Boolean
	
	return (Value type:C1509($value)=Is object:K8:27) && (OB Instance of:C1731($value; 4D:C1709.File))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isFolder($value) : Boolean
	
	return (Value type:C1509($value)=Is object:K8:27) && (OB Instance of:C1731($value; 4D:C1709.Folder))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isPlatformPath($value) : Boolean
	
	return Match regex:C1019("(?mi-s)^(?:(?:\\\\{2})|(?:[a-zA-Z]:\\\\?)|(?:[^:]+:)|(?:[^.:/\\n\\\\]+)).*$"; $value; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isJson($value) : Boolean
	
	return Match regex:C1019("\"(?si-m)^(?:\\\\{.*\\\\}$)|(?:^\\\\[.*\\\\]$)\""; $value; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isJsonObject($value) : Boolean
	
	return Match regex:C1019("(?m-si)^\\{.*\\}$"; $value; 1)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isJsonArray($value) : Boolean
	
	return Match regex:C1019("(?m-si)^\\[.*\\]$"; $value; 1)
	
	// Mark:-
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <==
Function get _() : Object
	
	return This:C1470.__CLASS__.instance=Null:C1517 ? This:C1470[""] : This:C1470.__CLASS__.instance[""]
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _pushError($message : Text)
	
	var $current; $o : Object
	var $c : Collection
	$c:=Get call chain:C1662
	
	For each ($o; $c) While ($current=Null:C1517)
		
		If (Position:C15("_classCore."; $o.name)#1)
			
			$current:=$o
			
		End if 
	End for each 
	
	If ($current#Null:C1517)
		
		$message:=$current.name+" - "+(Length:C16($message)>0 ? $message : "Unknown error at line "+String:C10($current.line))
		
	Else 
		
		If ($c.length>0)
			
			$message:=$c[1].name+" - "+(Length:C16($message)>0 ? $message : "Unknown error at line "+String:C10($c[1].line))
			
		Else 
			
			$message:=Length:C16($message)>0 ? $message : "Unknown but irritating error!"
			
		End if 
	End if 
	
	var $meta : Object
	$meta:=This:C1470._
	
	Use ($meta)
		
		Use ($meta.errors)
			
			$meta.errors.push($message)
			
		End use 
		
		$meta.success:=False:C215
		
	End use 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _map($value : Text) : Variant
	
	Case of 
			
			//______________________________________________________ Boolean
		: (Match regex:C1019("(?mi-s)^(?:true|false|0|1)?$"; $value; 1))
			
			var $b : Boolean
			XML DECODE:C1091($value; $b)
			return $b
			
			//______________________________________________________ Numeric
		: (Match regex:C1019("(?m-si)^(?:\\+|-)?\\d+(?:\\.|"+$value+"\\d+)?$"; $value; 1))
			
			var $r : Real
			XML DECODE:C1091($value; $r)
			return $r
			
			//______________________________________________________ Date
		: (Match regex:C1019("(?m-si)^\\d+-\\d+-\\d+$"; $value; 1))
			
			var $d : Date
			XML DECODE:C1091($value; $d)
			return $d
			
			//______________________________________________________ Hour
		: (Match regex:C1019("(?mi-s)^(?:(?:\\d{1,2}:*){2,3})\\s?(?:[AP]M)?$"; $value; 1))
			
			var $t : Time
			XML DECODE:C1091($value; $t)
			
			// TODO:Manage AM/PM
			//var $sep : Text
			//var $seconds : Integer
			//var $c : Collection
			//GET SYSTEM FORMAT(Time separator; $sep)
			//$c:=Split string($value; $sep)
			//$seconds:=0
			//If ($c.length>=1)
			//$seconds+=Num($c[0])*3600
			// End if
			//If ($c.length>=2)
			//$seconds+=Num($c[1])*60
			// End if
			//If ($c.length=3)
			//$seconds+=Num($c[2])
			// End if
			//return Time($seconds)
			
		: (False:C215)
			
			// TODO:Object ? Collection ?
			
			//______________________________________________________
		Else 
			
			return $value
			
			//______________________________________________________
	End case 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _debugerSafe($that : Object; $method; $type : Integer) : Variant
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.ready)
			
			If (Value type:C1509($method)=Is object:K8:27)
				
				return $method.call(Null:C1517)
				
			Else 
				
				return $that[$method]()
				
			End if 
			//return $that[$method]()
			
			//______________________________________________________
		: ($type=Is boolean:K8:9)
			
			return False:C215
			
			//______________________________________________________
		: ($type=Is text:K8:3)
			
			return ""
			
			//______________________________________________________
		: ($type=Is integer:K8:5)
			
			return 0
			
			//______________________________________________________
		: ($type=Is object:K8:27)
			
			return Null:C1517
			
			//______________________________________________________
		: ($type=Is collection:K8:32)
			
			return Null:C1517
			
			//______________________________________________________
		: ($type=Is BLOB:K8:12)
			
			var $blob : Blob
			return $blob
			
			//______________________________________________________
		: ($type=Is picture:K8:10)
			
			var $pict : Picture
			return $pict
			
			//______________________________________________________
		Else 
			
			return 
			
			//______________________________________________________
	End case 
	