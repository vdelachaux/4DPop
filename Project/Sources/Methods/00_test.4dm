//%attributes = {}

Case of 
		//https://github.com/vdelachaux/4DPop-Git/releases/latest
		
		//______________________________________________________
	: (True:C214)
		
		var $url; $version : Text
		var $statusCode : Integer
		var $x : Blob
		var $file : 4D:C1709.File
		
		ARRAY TEXT:C222($headerNames; 0)
		ARRAY TEXT:C222($headerValues; 0)
		
		$version:="20"
		
		APPEND TO ARRAY:C911($headerNames; "raw")
		APPEND TO ARRAY:C911($headerValues; "true")
		
		$url:="https://github.com/vdelachaux/4DPop-Family/blob/main/4DPop-Family-"+$version+"/4DPop-Family-"+$version+".dmg"
		
		$statusCode:=HTTP Get:C1157($url; $x; $headerNames; $headerValues)
		
		If ($statusCode=200)
			
			$file:=Folder:C1567(fk desktop folder:K87:19).file("4DPop-Family-"+$version+".dmg")
			$file.delete()
			$file.setContent($x)
			
		End if 
		
		//______________________________________________________
	: (True:C214)
		
		var $env : cs:C1710.env
		$env:=cs:C1710.env.new(True:C214)
		
		
		//______________________________________________________
	: (True:C214)
		
		var $data : Object
		var $pref : cs:C1710.Preferences
		
		$pref:=cs:C1710.Preferences.new()
		$data:=$pref.get()
		
		$pref:=cs:C1710.Preferences.new("Color_Chart")
		$data:=$pref.get()
		
		
		$pref:=cs:C1710.Preferences.new("hello")
		$pref.default(New object:C1471("test"; "hello world"))
		var $t : Text
		$t:=$pref.get("test")
		$data:=$pref.get()
		
		
		//______________________________________________________
End case 