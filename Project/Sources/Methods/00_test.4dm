//%attributes = {}

Case of 
		
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