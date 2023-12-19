//%attributes = {"invisible":true}
#DECLARE($folderURL : Text) : 4D:C1709.Folder

var $posix : Text
$posix:=Replace string:C233($folderURL; (Is Windows:C1573 ? "file:///" : "file://"); "")

If (Length:C16($posix)=0)
	
	return Is Windows:C1573 ? Folder:C1567("c:/"; fk posix path:K87:1) : Folder:C1567("/"; fk posix path:K87:1)
	
End if 

If (Not:C34($posix[[Length:C16($posix)]]="/"))  // Try file
	
	If (File:C1566($posix; fk posix path:K87:1).exists)
		
		return File:C1566($posix; fk posix path:K87:1)
		
	End if 
End if 