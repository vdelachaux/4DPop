//%attributes = {"preemptive":"incapable"}
#DECLARE($destination : 4D:C1709.Folder)

var $fullName : Text
$fullName:=Select document:C905(8858; ""; "Select the symbolic link target:"; 0)

If (Bool:C1537(OK))
	
	var $file : 4D:C1709.File
	$file:=File:C1566(DOCUMENT; fk platform path:K87:2)
	$file.createAlias($destination || Folder:C1567(fk desktop folder:K87:19); $file.fullName; fk symbolic link:K87:4)
	
End if 