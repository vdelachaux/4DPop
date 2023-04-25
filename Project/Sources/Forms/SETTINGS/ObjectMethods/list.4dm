#DECLARE() : Integer

var $uri : Text
var $indx : Integer
var $x : Blob
var $data; $e : Object
var $c : Collection

$e:=FORM Event:C1606
$uri:="com.4DPop.widget"

Case of 
		
		//______________________________________________________
	: ($e.code=On Begin Drag Over:K2:44)
		
		$data:=Form:C1466.current
		VARIABLE TO BLOB:C532($data; $x)
		APPEND DATA TO PASTEBOARD:C403($uri; $x)
		
		//______________________________________________________
	: ($e.code=On Drag Over:K2:13)
		
		GET PASTEBOARD DATA:C401($uri; $x)
		
		If (OK=0)
			
			return -1
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Drop:K2:12)
		
		GET PASTEBOARD DATA:C401($uri; $x)
		BLOB TO VARIABLE:C533($x; $data)
		
		$c:=Form:C1466.properties.widgets
		$indx:=$c.indices("name = :1"; $data.name).first()
		$c.remove($indx)
		$c.insert(Drop position:C608-1; $data)
		
		Form:C1466.$modifiedOrder:=True:C214
		
		//______________________________________________________
End case 