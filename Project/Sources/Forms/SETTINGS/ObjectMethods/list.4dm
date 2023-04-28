#DECLARE() : Integer

var $uri : Text
var $button; $column; $i; $indx; $row; $x : Integer
var $y : Integer
var $blb : Blob
var $data; $e; $o : Object
var $c : Collection

$e:=FORM Event:C1606
$uri:="com.4DPop.widget"

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		For each ($o; Form:C1466.properties.widgets)
			
			$o.$handle:=""
			
		End for each 
		
		//______________________________________________________
	: ($e.code=On Unload:K2:2)
		
		For each ($o; Form:C1466.properties.widgets)
			
			OB REMOVE:C1226($o; "$handle")
			
		End for each 
		
		//______________________________________________________
	: ($e.code=On Mouse Move:K2:35)
		
		GET MOUSE:C468($x; $y; $button)
		LISTBOX GET CELL POSITION:C971(*; "list"; $x; $y; $column; $row)
		
		For each ($o; Form:C1466.properties.widgets)
			
			$i+=1
			$o.$handle:="≣"*Num:C11($i=$row)
			
		End for each 
		
		Form:C1466.properties.widgets:=Form:C1466.properties.widgets
		
		//______________________________________________________
	: ($e.code=On Mouse Leave:K2:34)
		
		For each ($o; Form:C1466.properties.widgets)
			
			$o.$handle:=""
			
		End for each 
		
		//______________________________________________________
	: ($e.code=On Begin Drag Over:K2:44)
		
		$data:=Form:C1466.current
		VARIABLE TO BLOB:C532($data; $blb)
		APPEND DATA TO PASTEBOARD:C403($uri; $blb)
		
		//______________________________________________________
	: ($e.code=On Drag Over:K2:13)
		
		GET PASTEBOARD DATA:C401($uri; $blb)
		
		If (OK=0)
			
			return -1
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Drop:K2:12)
		
		GET PASTEBOARD DATA:C401($uri; $blb)
		BLOB TO VARIABLE:C533($blb; $data)
		
		$c:=Form:C1466.properties.widgets
		$c.remove($c.indices("name = :1"; $data.name).first())
		$c.insert(Drop position:C608-1; $data)
		
		Form:C1466.$modifiedOrder:=True:C214
		
		//______________________________________________________
End case 