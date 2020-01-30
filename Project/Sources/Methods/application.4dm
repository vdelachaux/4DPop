//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : application
  // Database: 4D unitTest
  // ID[B5CCD1E2042E4A46A7550EB3B633B59B]
  // Created #30-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_build;$Lon_parameters)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$oo;$ooo)

If (False:C215)
	C_OBJECT:C1216(application ;$0)
	C_TEXT:C284(application ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // <NO PARAMETERS REQUIRED>
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (This:C1470=Null:C1517)
	
	$o:=New shared object:C1526(\
		"exe";Folder:C1567(Application file:C491;fk platform path:K87:2);\
		"infos";New shared object:C1526;\
		"type";Application type:C494;\
		"isServer";False:C215;\
		"isRemote";False:C215;\
		"isLocal";False:C215;\
		"isDebug";False:C215;\
		"demo";(Version type:C495 ?? Demo version:K5:9);\
		"merged";(Version type:C495 ?? Merged application:K5:28);\
		"64-bit";(Version type:C495 ?? 64 bit version:K5:25);\
		"OS";Get system info:C1571.osVersion)
	
	Use ($o)
		
		$o.isServer:=$o.type=4D Server:K5:6
		$o.isRemote:=$o.type=4D Remote mode:K5:5
		$o.isLocal:=$o.type=4D Local mode:K5:1
		
		Use ($o.infos)
			
			$oo:=Get application info:C1599
			$o.infos.launchedAsService:=$oo.launchedAsService
			
			If (Is Windows:C1573)
				
				$o.infos.volumeShadowCopyStatus:=$oo.volumeShadowCopyStatus
				
			End if 
			
			If ($o.isServer)
				
				$o.infos.portID:=$oo.portID
				$o.infos.newConnectionsAllowed:=$oo.newConnectionsAllowed
				$o.infos.useLegacyNetworkLayer:=$oo.useLegacyNetworkLayer
				
				$o.IPAddressToListen:=New shared collection:C1527
				
				Use ($o.IPAddressToListen)
					
					For each ($t;$oo.IPAddressToListen)
						
						$o.IPAddressToListen.push($t)
						
					End for each 
				End use 
				
				$o.IPAddressAllowDeny:=New shared collection:C1527
				
				Use ($o.IPAddressAllowDeny)
					
					For each ($ooo;$oo.IPAddressAllowDeny)
						
						$o.IPAddressAllowDeny.push($ooo)
						
					End for each 
				End use 
				
				$o.rejectConnections:=Formula:C1597(REJECT NEW REMOTE CONNECTIONS:C1635(True:C214))
				$o.allowConnections:=Formula:C1597(REJECT NEW REMOTE CONNECTIONS:C1635(False:C215))
				
			Else 
				
				If (Not:C34($o.isLocal))
					
					$o.infos.portID:=$oo.portID
					$o.infos.useLegacyNetworkLayer:=$oo.useLegacyNetworkLayer
					$o.infos.TLSEnabled:=$oo.TLSEnabled
					
				End if 
			End if 
		End use 
		
		$o.getInfos:=Formula:C1597(Get application info:C1599)
		$o.quit:=Formula:C1597(QUIT 4D:C291(Num:C11($1)))
		$o.restart:=Formula:C1597(RESTART 4D:C1292(Num:C11($1);String:C10($2)))
		
		$t:=Application version:C493($Lon_build)
		
		$o.build:=String:C10($Lon_build)
		
		  // The Application version command returns an encoded string value that expresses
		  // The version number of the 4D environment you are running.
		  // - If you do not pass the optional * parameter, a 4-character string is returned,
		  //  formatted as follows:
		  //     1-2   Version number
		  //     3     "R" number
		  //     4     Revision number
		
		If (Num:C11($t[[3]])=0)
			
			  // 4D v14.x
			$o.branch:=$t[[1]]+$t[[2]]+Choose:C955($t[[4]]#"0";"."+$t[[4]];"")
			
		Else 
			
			  // 4D v14 Rx
			$o.branch:=$t[[1]]+$t[[2]]+"R"+$t[[3]]
			
		End if 
		
		  // "1420" for v14 R2
		  // "1430" for v14 R3
		  // "1401" for v14.1 (first fix release of v14)
		  // "1402" for v14.2 (second fix release of v14)
		
		  // The current product name ie. 4D v14
		$o.version:="4D v"+$t[[1]]+$t[[2]]
		
		If (Num:C11($t[[3]])=0)
			
			  // 4D v14.1 build 14.128437
			$o.version:=$o.version+" build "+$t[[1]]+$t[[2]]+"."+String:C10($Lon_build)
			
		Else 
			
			  // 4D v14 R2 build 14R2.128437
			$o.version:=$o.version+" build "+$t[[1]]+$t[[2]]+"R"+$t[[3]]+"."+String:C10($Lon_build)
			
		End if 
		
		  // - If you pass the optional * parameter, an 8-character string is returned,
		  //  formatted as follows:
		  //     1      "F" denotes a final version
		  //            "B" denotes a beta version
		  //            Other characters denote an 4D internal version
		  //     2-3-4  Internal 4D compilation number
		  //     5-6    Version number
		  //     7      "R" number
		  //     8      Revision number
		$t:=Application version:C493(*)
		
		$o.isDebug:=(Position:C15("debug";$t)>0)
		
		Case of 
				
				  //………………………………………………………
			: ($t[[1]]="F")
				
				  // NOTHING MORE TO DO
				
				  //………………………………………………………
			: ($t[[1]]="B")
				
				$o.version:=$o.version+" (beta "+String:C10(Num:C11(Substring:C12($t;2;3)))+")"
				
				  //………………………………………………………
			Else 
				
				$o.version:=$o.version+" ("+$t[[1]]+String:C10(Num:C11(Substring:C12($t;2;3)))+")"
				
				  //………………………………………………………
		End case 
	End use 
	
Else 
	
	$o:=This:C1470
	
	Use (This:C1470)
		
		Case of 
				
				  //______________________________________________________
			: ($1="xxx")
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
				
				  //______________________________________________________
		End case 
	End use 
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End 