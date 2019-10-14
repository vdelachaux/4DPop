//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : svg
  // Created 11-6-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Manipulate SVG as objects
  // #THREAD-SAFE
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BLOB:C604($x)
C_LONGINT:C283($i)
C_PICTURE:C286($p)
C_REAL:C285($Num_height;$Num_width)
C_TEXT:C284($Dom_;$Dom_target;$t;$tt;$Txt_object)
C_OBJECT:C1216($file;$o;$oo;$signal)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(svg ;$0)
	C_TEXT:C284(svg ;$1)
	C_OBJECT:C1216(svg ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470._is=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"_is";"svg";\
		"root";Null:C1517;\
		"latest";Null:C1517;\
		"autoClose";True:C214;\
		"success";False:C215;\
		"errors";New collection:C1472;\
		"picture";Null:C1517;\
		"xml";Null:C1517;\
		"origin";Null:C1517;\
		"file";Null:C1517;\
		"close";Formula:C1597(svg ("close"));\
		"styleSheet";Formula:C1597(svg ("styleSheet";$1));\
		"group";Formula:C1597(svg ("new";New object:C1471("what";"group";"id";$1;"options";$2)));\
		"rect";Formula:C1597(svg ("new";Choose:C955(Count parameters:C259=3;New object:C1471("what";"rect";"x";$1;"y";$2;"options";$3);New object:C1471("what";"rect";"x";$1;"y";$2;"width";$3;"height";$4;"options";$5))));\
		"roundedRect";Formula:C1597(svg ("new";Choose:C955(Count parameters:C259=3;New object:C1471("what";"rect";"rx";10;"x";$1;"y";$2;"options";$3);New object:C1471("what";"rect";"rx";10;"x";$1;"y";$2;"width";$3;"height";$4;"options";$5))));\
		"image";Formula:C1597(svg ("new";New object:C1471("what";"image";"url";$1;"options";$2)));\
		"textArea";Formula:C1597(svg ("new";New object:C1471("what";"textArea";"text";$1;"x";Num:C11($2);"y";Num:C11($3);"options";$4)));\
		"embedPicture";Formula:C1597(svg ("new";New object:C1471("what";"embedPicture";"image";$1;"x";Num:C11($2);"y";Num:C11($3);"options";$4)));\
		"setPosition";Formula:C1597(svg ("set";New object:C1471("what";"position";"x";$1;"y";$2;"unit";$3)));\
		"setDimensions";Formula:C1597(svg ("set";New object:C1471("what";"dimensions";"width";$1;"height";$2;"unit";$3)));\
		"setFill";Formula:C1597(svg ("set";New object:C1471("what";"fill";"color";$1;"opacity";$2)));\
		"setStroke";Formula:C1597(svg (Choose:C955(Value type:C1509($1)=Is object:K8:27;"stroke";"set");Choose:C955(Value type:C1509($1)=Is object:K8:27;$1;New object:C1471("what";"stroke";"color";$1;"opacity";$2))));\
		"setFont";Formula:C1597(svg (Choose:C955(Value type:C1509($1)=Is object:K8:27;"font";"set");Choose:C955(Value type:C1509($1)=Is object:K8:27;$1;New object:C1471("what";"font";"font";$1;"size";$2))));\
		"setVisible";Formula:C1597(svg ("set";New object:C1471("what";"visible";"visibility";$1;"options";Choose:C955(Value type:C1509($2)=Is text:K8:3;New object:C1471("target";$2);$2))));\
		"setAttribute";Formula:C1597(svg ("set";New object:C1471("what";"attribute";"key";$1;"value";$2;"options";Choose:C955(Value type:C1509($3)=Is text:K8:3;New object:C1471("target";$3);$3))));\
		"setAttributes";Formula:C1597(svg ("set";New object:C1471("what";"attributes";"options";$1)));\
		"getPicture";Formula:C1597(svg ("get";Choose:C955(Value type:C1509($1)=Is boolean:K8:9;New object:C1471("what";"picture";"keep";Bool:C1537($1);"options";$2);New object:C1471("what";"picture";"options";$1))).picture);\
		"getText";Formula:C1597(svg ("get";Choose:C955(Value type:C1509($1)=Is boolean:K8:9;New object:C1471("what";"xml";"keep";Bool:C1537($1);"options";$2);New object:C1471("what";"xml";"options";$1))).xml);\
		"get";Formula:C1597(svg ("get";Choose:C955(Value type:C1509($2)=Is boolean:K8:9;New object:C1471("what";String:C10($1);"keep";Bool:C1537($2);"options";$3);New object:C1471("what";String:C10($1);"options";$2)))[$1]);\
		"savePicture";Formula:C1597(svg ("save";Choose:C955(Value type:C1509($1)=Is object:K8:27;New object:C1471("file";$1;"keep";$2);New object:C1471("what";"picture";"file";$1;Choose:C955(Value type:C1509($2)=Is boolean:K8:9;"keep";"codec");$2;Choose:C955(Value type:C1509($3)=Is boolean:K8:9;"keep";"ghost");$3))));\
		"saveText";Formula:C1597(svg ("save";Choose:C955(Value type:C1509($1)=Is object:K8:27;New object:C1471("file";$1;"keep";$2);New object:C1471("what";"text";"file";$1;Choose:C955(Value type:C1509($2)=Is boolean:K8:9;"keep";"codec");$2;Choose:C955(Value type:C1509($3)=Is boolean:K8:9;"keep";"ghost");$3))));\
		"save";Formula:C1597(svg ("save";Choose:C955(Value type:C1509($1)=Is object:K8:27;New object:C1471("file";$1;"keep";$2);New object:C1471("what";$1;"file";$2;Choose:C955(Value type:C1509($3)=Is boolean:K8:9;"keep";"codec");$3;Choose:C955(Value type:C1509($4)=Is boolean:K8:9;"keep";"ghost");$4))));\
		"findByPath";Formula:C1597(svg ("findByPath";New object:C1471("xPath";$1;"option";$2)).value);\
		"findById";Formula:C1597(svg ("findById";New object:C1471("id";$1)).value);\
		"showInViewer";Formula:C1597(svg ("showInViewer"))\
		)
	
	If (Count parameters:C259>=1)
		
		$c:=Split string:C1554($1;";")  // Optional text enumeration semicolons separated
		
		Case of 
				
				  //______________________________________________________
			: ($c.indexOf("parse")#-1)  // Parse a given BLOB or Text type variable containing an SVG structure
				
				If ($2.variable#Null:C1517)  // Variable to parse
					
					If (Value type:C1509($2.variable)=Is BLOB:K8:12)
						
						$x:=$2.variable
						$t:=DOM Parse XML variable:C720($x)
						
					Else 
						
						$tt:=String:C10($2.variable)
						$t:=DOM Parse XML variable:C720($tt)
						
					End if 
					
					If (Bool:C1537(OK))
						
						$o.root:=$t
						
					End if 
					
				Else 
					
					$o.errors.push("Missing variable to parse.")
					
				End if 
				
				  //______________________________________________________
			: ($c.indexOf("load")#-1)  // Parse a document containing an SVG structure
				
				If ($2#Null:C1517)  // File to load
					
					If (Bool:C1537($2.isFile) & Bool:C1537($2.exists))  // File to load
						
						$t:=DOM Parse XML source:C719($2.platformPath)
						
						If (Bool:C1537(OK))
							
							$o.root:=$t
							$o.origin:=$2
							
						End if 
						
					Else 
						
						$o.errors.push("File doesn't exists: "+String:C10($2.platformPath))
						
					End if 
					
				Else 
					
					$o.errors.push("Missing object pathname to load.")
					
				End if 
				
				  //______________________________________________________
		End case 
	End if 
	
	If ($o.root=Null:C1517)\
		 & ($o.errors.length=0)  // Create a default SVG structure
		
		$t:=DOM Create XML Ref:C861("svg";"http://www.w3.org/2000/svg")
		
		If (Bool:C1537(OK))
			
			$o.root:=$t
			
			DOM SET XML ATTRIBUTE:C866($t;\
				"xmlns:xlink";"http://www.w3.org/1999/xlink")
			
			DOM SET XML DECLARATION:C859($t;"UTF-8";True:C214)
			XML SET OPTIONS:C1090($t;XML indentation:K45:34;Choose:C955(Is compiled mode:C492;XML no indentation:K45:36;XML with indentation:K45:35))
			
			$t:=DOM Create XML element:C865($o.root;"def")
			
			If (Bool:C1537(OK))
				
				  // Default values
				DOM SET XML ATTRIBUTE:C866($o.root;\
					"viewport-fill";"none";\
					"fill";"none";\
					"stroke";"black";\
					"font-family";"'lucida grande','segoe UI',sans-serif";\
					"font-size";12;\
					"text-rendering";"geometricPrecision";\
					"shape-rendering";"crispEdges";\
					"preserveAspectRatio";"none")
				
			End if 
		End if 
	End if 
	
	$o.success:=Bool:C1537(OK) & ($o.root#Null:C1517)
	
	If ($o.success)
		
		If ($c.length>0)
			
			For each ($t;$c)
				
				Case of 
						
						  //______________________________________________________
					: ($t="{@}")
						
						$oo:=JSON Parse:C1218($t)
						
						For each ($tt;$oo)
							
							DOM SET XML ATTRIBUTE:C866($o.root;\
								$tt;$oo[$tt])
							
						End for each 
						
						  //______________________________________________________
					: ($t="keepReference")
						
						$o.autoClose:=False:C215
						
						  //______________________________________________________
					: ($t="solid@")
						
						If (Split string:C1554($t;":").length>1)
							
							DOM SET XML ATTRIBUTE:C866($o.root;\
								"viewport-fill";Split string:C1554($t;":")[1];\
								"viewport-fill-opacity";1)
							
						Else 
							
							DOM SET XML ATTRIBUTE:C866($o.root;\
								"viewport-fill";"white";\
								"viewport-fill-opacity";1)
							
						End if 
						
						  //______________________________________________________
				End case 
			End for each 
		End if 
		
	Else 
		
		$o.errors.push("Failed to create SVG structure.")
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	If (Asserted:C1132($o#Null:C1517;"OOPS, this method must be called from a member method"))
		
		If ($o.root=Null:C1517)
			
			$o.success:=False:C215
			$o.errors.push("The SVG structure is not valid.")
			
		Else 
			
			$o.success:=True:C214
			$oo:=$2.options
			$Txt_object:=String:C10($2.what)
			
			  // Find the target
			Case of 
					
					  //______________________________________________________
				: (New collection:C1472("new";"findByPath").indexOf($1)#-1)
					
					$Dom_target:=Choose:C955($oo.target#Null:C1517;String:C10($oo.target);$o.root)
					
					  //______________________________________________________
				: ($1="set")
					
					If ($oo.target=Null:C1517)
						
						If ($o.latest=Null:C1517)
							
							  // Target is the canvas
							$Dom_target:=$o.root
							
						Else 
							
							$Dom_target:=$o.latest
							
						End if 
						
					Else 
						
						$Dom_target:=$oo.target
						
					End if 
					
					  //______________________________________________________
				: ($1="save")
					
					If ($2.file#Null:C1517)  // Given
						
						$file:=$2.file
						
					Else 
						
						If ($o.file#Null:C1517)  // Last saved
							
							$file:=$o.file
							
						Else 
							
							If ($o.origin#Null:C1517)  // Original
								
								$file:=$o.origin
								
							End if 
						End if 
					End if 
					
					  //______________________________________________________
				: (New collection:C1472("stroke";"font").indexOf($1)#-1)
					
					If ($2.target=Null:C1517)
						
						If ($o.latest=Null:C1517)
							
							  // Target is the canvas
							$Dom_target:=$o.root
							
						Else 
							
							$Dom_target:=$o.latest
							
						End if 
						
					Else 
						
						$Dom_target:=$2.target
						
					End if 
					
					  //______________________________________________________
			End case 
			
			Case of 
					
					  //=================================================================
				: ($1="findByPath")
					
					$o:=New object:C1471(\
						"value";"0"*32)
					
					ARRAY TEXT:C222($aT;0x0000)
					$aT{0}:=DOM Find XML element:C864($Dom_target;$2.xPath;$aT)
					This:C1470.success:=Bool:C1537(OK)
					
					If (This:C1470.success)
						
						This:C1470.success:=True:C214
						
						If (Size of array:C274($aT)>0)
							
							If (Size of array:C274($aT)>1)
								
								$o.value:=New collection:C1472
								ARRAY TO COLLECTION:C1563($o.value;$aT)
								
							Else 
								
								$o.value:=$aT{0}
								
							End if 
						End if 
						
					Else 
						
						This:C1470.errors.push("xPath \""+String:C10($2.xPath)+"\" not found.")
						
					End if 
					
					  //=================================================================
				: ($1="findById")
					
					$o:=New object:C1471(\
						"value";"0"*32)
					
					This:C1470.success:=False:C215
					
					If ($2.id#Null:C1517)\
						 & (Length:C16(String:C10($2.id))>0)
						
						$t:=DOM Find XML element by ID:C1010(This:C1470.root;String:C10($2.id))
						
						If (Bool:C1537(OK))
							
							This:C1470.success:=True:C214
							$o.value:=$t
							
						Else 
							
							This:C1470.errors.push("id \""+String:C10($2.id)+"\" not found.")
							
						End if 
						
					Else 
						
						This:C1470.errors.push("id to search is missing.")
						
					End if 
					
					  //=================================================================
				: ($1="get")
					
					Case of 
							
							  //______________________________________________________
						: ($Txt_object="picture")
							
							  // Own XML data source
							SVG EXPORT TO PICTURE:C1017($o.root;$p;Choose:C955($oo.exportType#Null:C1517;Num:C11($oo.exportType);Copy XML data source:K45:17))
							$o.success:=(Picture size:C356($p)>0)
							
							If ($o.success)
								
								$o.picture:=$p
								
								If ($o.autoClose)\
									 & (Not:C34(Bool:C1537($2.keep)))
									
									DOM CLOSE XML:C722($o.root)
									$o.root:=Null:C1517
									
								End if 
								
							Else 
								
								$o.picture:=Null:C1517
								$o.errors.push("Failed to convert SVG structure as picture.")
								
							End if 
							
							  //______________________________________________________
						: ($Txt_object="xml")
							
							DOM EXPORT TO VAR:C863($o.root;$t)
							$o.success:=Bool:C1537(OK)
							
							If ($o.success)
								
								$o.xml:=$t
								
								If ($o.autoClose)\
									 & (Not:C34(Bool:C1537($2.keep)))
									
									DOM CLOSE XML:C722($o.root)
									$o.root:=Null:C1517
									
								End if 
								
							Else 
								
								$o.xml:=Null:C1517
								$o.errors.push("Failed to export SVG structure as XML.")
								
							End if 
							
							  //______________________________________________________
					End case 
					
					  //=================================================================
				: ($1="save")
					
					Case of 
							
							  //______________________________________________________
						: ($file=Null:C1517)
							
							$o.success:=False:C215
							$o.errors.push("Null object pathname")
							
							  //______________________________________________________
						: ($2.what=Null:C1517)  // Into the original or the latest saved file
							
							$2.what:=Choose:C955(New collection:C1472(".svg";".xml";".txt").indexOf($file.extension)#-1;"text";"picture")
							$o:=svg ("save";$2)
							
							  //______________________________________________________
						: ($Txt_object="picture")
							
							  // Turn_around #ACI0093875
							  //SVG EXPORT TO PICTURE($o.root;$p)
							DOM EXPORT TO VAR:C863($o.root;$t)
							$t:=Replace string:C233($t;" xmlns=\"\"";"")
							$t:=DOM Parse XML variable:C720($t)
							SVG EXPORT TO PICTURE:C1017($t;$p)
							DOM CLOSE XML:C722($t)
							  //}
							
							$o.success:=(Picture size:C356($p)>0)
							
							If ($o.success)
								
								WRITE PICTURE FILE:C680($file.platformPath;$p;Choose:C955($2.codec#Null:C1517;String:C10($2.codec);$file.extension))
								$o.success:=Bool:C1537(OK)
								
							End if 
							
							If ($o.success)
								
								$o.picture:=$p
								
							End if 
							
							  //______________________________________________________
						: ($Txt_object="text")
							
							  // Turn_around #ACI0093875
							  //DOM EXPORT TO FILE($o.root;$file.platformPath)
							DOM EXPORT TO VAR:C863($o.root;$t)
							$t:=Replace string:C233($t;" xmlns=\"\"";"")
							$o.success:=Bool:C1537(OK)
							
							If ($o.success)
								
								$file.setText($t)
								
								$o.xml:=$t
								
							End if 
							
							  //______________________________________________________
					End case 
					
					If ($o.success)
						
						If ($o.root#Null:C1517)\
							 & ($o.autoClose)\
							 & (Not:C34(Bool:C1537($2.keep)))
							
							DOM CLOSE XML:C722($o.root)
							$o.root:=Null:C1517
							
						End if 
						
					Else 
						
						$o.errors.push("Failed to save SVG structure as "+$Txt_object+".")
						
					End if 
					
					  //=================================================================
				: ($1="showInViewer")
					
					$signal:=New signal:C1641("CALL_MAIN_PROCESS")
					CALL WORKER:C1389(1;"CALL_MAIN_PROCESS";$signal;"listOfLoadedComponents")
					
					$o.success:=False:C215
					
					If ($signal.wait(1))
						
						If ($signal.value.indexOf("4D SVG")#-1)
							
							$o.success:=True:C214
							EXECUTE METHOD:C1007("SVGTool_SHOW_IN_VIEWER";*;$o.root)
							
						Else 
							
							$o.errors.push("The component \"4D SVG\" is not avaiable.")
							
						End if 
					End if 
					
					  //=================================================================
				: ($1="styleSheet")
					
					$o.success:=$2.exists
					
					If ($o.success)
						
						$t:=Convert path system to POSIX:C1106($2.platformPath;*)
						$t:="xml-stylesheet type=\"text/css\" href=\"file://localhost"+$t+"\""
						$t:=DOM Append XML child node:C1080(DOM Get XML document ref:C1088($o.root);XML processing instruction:K45:9;$t)
						$o.success:=Bool:C1537(OK)
						
					End if 
					
					  //=================================================================
				: ($1="close")
					
					DOM CLOSE XML:C722($o.root)
					$o.root:=Null:C1517
					
					  //=================================================================
				: ($1="new")
					
					OK:=0
					
					Case of 
							
							  //______________________________________________________
						: ($Txt_object="group")
							
							$o.latest:=DOM Create XML element:C865($Dom_target;"g")
							
							If (OK=1)\
								 & ($2.id#Null:C1517)
								
								DOM SET XML ATTRIBUTE:C866($o.latest;\
									"id";String:C10($2.id))
								
							End if 
							
							  //______________________________________________________
						: ($Txt_object="rect")
							
							$o.latest:=DOM Create XML element:C865($Dom_target;"rect";\
								"x";Num:C11($2.x);\
								"y";Num:C11($2.y);\
								"width";Num:C11($2.width);\
								"height";Num:C11($2.height))
							
							If (OK=1)\
								 & ($2.rx#Null:C1517)  // roundedRect
								
								DOM SET XML ATTRIBUTE:C866($o.latest;\
									"rx";Num:C11($2.rx))
								
							End if 
							
							  //______________________________________________________
						: ($Txt_object="image")
							
							OK:=Num:C11(Value type:C1509($2.url)=Is object:K8:27)  // File object
							
							If (OK=1)
								
								$file:=$2.url
								
								OK:=Num:C11($file.exists)
								
								If (OK=1)
									
									  // Get width & height of the picture if any
									If ($oo.width=Null:C1517)\
										 | ($oo.height=Null:C1517)
										
										READ PICTURE FILE:C678($file.platformPath;$p)
										
										If (OK=1)
											
											PICTURE PROPERTIES:C457($p;$Num_width;$Num_height)
											CLEAR VARIABLE:C89($p)
											
											If ($oo.width=Null:C1517)
												
												$oo.width:=$Num_width
												
											End if 
											
											If ($oo.height=Null:C1517)
												
												$oo.height:=$Num_height
												
											End if 
										End if 
									End if 
									
									If (OK=1)
										
										$t:="file:/"+"/"\
											+Choose:C955(Is Windows:C1573;"/";"")\
											+Replace string:C233($file.path;" ";"%20")
										
										$o.latest:=DOM Create XML element:C865($Dom_target;"image";\
											"xlink:href";$t;\
											"x";Num:C11($oo.left);\
											"y";Num:C11($oo.top);\
											"width";Num:C11($oo.width);\
											"height";Num:C11($oo.height))
										
									End if 
									
								Else 
									
									$o.errors.push("File not found ("+$file.platformPath+").")
									
								End if 
								
							Else 
								
								$o.errors.push("Missing valid image file.")
								
							End if 
							
							  //______________________________________________________
						: ($Txt_object="embedPicture")
							
							$p:=$2.image
							
							If (Picture size:C356($p)>0)
								
								  // Encode in base64
								PICTURE TO BLOB:C692($p;$x;Choose:C955($oo.codec#Null:C1517;String:C10($oo.codec);".png"))
								
								If (OK=1)
									
									BASE64 ENCODE:C895($x;$t)
									CLEAR VARIABLE:C89($x)
									
									If (OK=1)
										
										  // Put the encoded image
										PICTURE PROPERTIES:C457($p;$Num_width;$Num_height)
										
										$o.latest:=DOM Create XML element:C865($Dom_target;"image";\
											"xlink:href";"data:;base64,"+$t;\
											"x";$2.x;\
											"y";$2.y;\
											"width";$Num_width;\
											"height";$Num_height)
										
									End if 
								End if 
								
							Else 
								
								$o.errors.push("Given picture is empty")
								
							End if 
							
							  //______________________________________________________
						: ($Txt_object="textArea")
							
							$t:=Replace string:C233(String:C10($2.text);"\r\n";"\r")
							
							$o.latest:=DOM Create XML element:C865($Dom_target;"textArea";\
								"x";$2.x;\
								"y";$2.y;\
								"width";Choose:C955($oo.width=Null:C1517;"auto";Num:C11($oo.width));\
								"height";Choose:C955($oo.height=Null:C1517;"auto";Num:C11($oo.height)))
							
							If (OK=1)\
								 & (Length:C16($t)>0)
								
								Repeat 
									
									$i:=Position:C15("\r";$t)
									
									If ($i=0)
										
										$i:=Position:C15("\n";$t)
										
									End if 
									
									If ($i>0)
										
										$tt:=Substring:C12($t;1;$i-1)
										
										If (Length:C16($tt)>0)
											
											$Dom_:=DOM Append XML child node:C1080($o.latest;XML DATA:K45:12;$tt)
											
										End if 
										
										$Dom_:=DOM Append XML child node:C1080($o.latest;XML ELEMENT:K45:20;"tbreak")
										
										$t:=Delete string:C232($t;1;Length:C16($tt)+1)
										
									Else 
										
										If (Length:C16($t)>0)
											
											$Dom_:=DOM Append XML child node:C1080($o.latest;XML DATA:K45:12;$t)
											
										End if 
									End if 
								Until ($i=0)\
									 | (OK=0)
								
							End if 
							
							  //______________________________________________________
						Else 
							
							$o.errors.push("Unknown object: \""+$Txt_object+"\"")
							
							  //______________________________________________________
					End case 
					
					$o.success:=Bool:C1537(OK)
					
					If ($o.success)  // Additional attributes
						
						If ($oo#Null:C1517)
							
							$c:=New collection:C1472("target";"left";"top";"width";"height";"codec")
							
							For each ($t;$oo)
								
								If ($c.indexOf($t)=-1)
									
									If (Length:C16($t)#0)\
										 & ($oo[$t]#Null:C1517)
										
										DOM SET XML ATTRIBUTE:C866($o.latest;\
											$t;$oo[$t])
										
									Else 
										
										$o.success:=False:C215
										$o.errors.push("Invalid values pair for an attribute.")
										
									End if 
								End if 
							End for each 
						End if 
					End if 
					
					  //=================================================================
				: ($1="stroke")
					
					If ($2.color#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"stroke";String:C10($2.color))
						
					End if 
					
					If (OK=1)\
						 & ($2.opacity#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"stroke-opacity";Num:C11($2.opacity)/100)
						
					End if 
					
					If (OK=1)\
						 & ($2.width#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"stroke-width";Num:C11($2.width))
						
					End if 
					
					If (OK=1)\
						 & ($2.dasharray#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"stroke-dasharray";String:C10($2.dasharray))
						
					End if 
					
					$o.success:=Bool:C1537(OK)
					
					  //=================================================================
				: ($1="font")
					
					If ($2.font#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"font-family";String:C10($2.font))
						
					End if 
					
					If (OK=1)\
						 & ($2.size#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"font-size";Num:C11($2.size))
						
					End if 
					
					If (OK=1)\
						 & ($2.color#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"fill";String:C10($2.color))
						
					End if 
					
					If (OK=1)\
						 & ($2.opacity#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($Dom_target;\
							"fill-opacity";Num:C11($2.opacity)/100)
						
					End if 
					
					If (OK=1)\
						 & ($2.style#Null:C1517)
						
						$i:=Num:C11($2.style)
						
						If ($i=0)  // Plain
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"text-decoration";"none";\
								"font-style";"normal";\
								"font-weight";"normal")
							
						Else 
							
							If ($i>=8)  // Line-through
								
								DOM SET XML ATTRIBUTE:C866($Dom_target;\
									"text-decoration";"line-through")
								$i:=$i-8
								
							End if 
							
							If (OK=1)\
								 & ($i>=4)  // Underline
								
								DOM SET XML ATTRIBUTE:C866($Dom_target;\
									"text-decoration";"underline")
								$i:=$i-4
								
							End if 
							
							If (OK=1)\
								 & ($i>=2)  // Italic
								
								DOM SET XML ATTRIBUTE:C866($Dom_target;\
									"font-style";"italic")
								$i:=$i-2
								
							End if 
							
							If (OK=1)\
								 & ($i=1)  // Bold
								
								DOM SET XML ATTRIBUTE:C866($Dom_target;\
									"font-weight";"bold")
								
							End if 
						End if 
					End if 
					
					If (OK=1)\
						 & ($2.alignment#Null:C1517)
						
						DOM GET XML ELEMENT NAME:C730($Dom_target;$t)
						
						If (OK=1)
							
							$i:=Num:C11($2.alignment)
							
							Case of 
									
									  //…………………………………………………………………………………………
								: ($i=Align center:K42:3)
									
									If ($t="textArea")
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"text-align";"center")
										
									Else 
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"text-anchor";"middle")
										
									End if 
									
									  //…………………………………………………………………………………………
								: ($i=Align right:K42:4)
									
									If ($t="textArea")
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"text-align";"end")
										
									Else 
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"text-anchor";"end")
										
									End if 
									
									  //…………………………………………………………………………………………
								: ($i=Align left:K42:2)\
									 | ($i=Align default:K42:1)
									
									If ($t="textArea")
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"text-align";"start")
										
									Else 
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"text-anchor";"start")
										
									End if 
									
									  //…………………………………………………………………………………………
								: ($i=5)\
									 & ($t="textArea")
									
									DOM SET XML ATTRIBUTE:C866($Dom_target;\
										"text-align";"justify")
									
									  //…………………………………………………………………………………………
								Else 
									
									If ($t="textArea")
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"text-align";"inherit")
										
									Else 
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"text-anchor";"inherit")
										
									End if 
									
									  //…………………………………………………………………………………………
							End case 
						End if 
					End if 
					
					If (OK=1)\
						 & ($2.rendering#Null:C1517)
						
						$t:=String:C10($2.rendering)
						OK:=Num:C11(New collection:C1472("auto";"optimizeSpeed";"optimizeLegibility";"geometricPrecision";"inherit").indexOf($t)#-1)
						
						If (OK=1)
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"text-rendering";$t)
							
						Else 
							
							$o.errors.push("Unknown value ("+$t+") for text-rendering.")
							
						End if 
					End if 
					
					$o.success:=Bool:C1537(OK)
					
					  //=================================================================
				: ($1="set")
					
					Case of 
							
							  //______________________________________________________
						: ($2.what="visible")
							
							DOM SET XML ATTRIBUTE:C866($Dom_target;\
								"visibility";Choose:C955(Bool:C1537($2.visibility);"visible";"hidden"))
							
							$o.success:=Bool:C1537(OK)
							
							  //______________________________________________________
						: ($2.what="attribute")
							
							If ($2.key#Null:C1517)
								
								If ($2.value#Null:C1517)
									
									DOM SET XML ATTRIBUTE:C866($Dom_target;\
										String:C10($2.key);$2.value)
									
								Else 
									
									DOM REMOVE XML ATTRIBUTE:C1084($Dom_target;$2.key)
									
								End if 
								
								$o.success:=Bool:C1537(OK)
								
							Else 
								
								$o.success:=False:C215
								$o.errors.push("Missing attribute name.")
								
							End if 
							
							  //______________________________________________________
						: ($2.what="attributes")
							
							For each ($t;$oo) Until (OK=0)
								
								If ($t#"target")
									
									If (Length:C16($t)#0)
										
										If ($oo[$t]#Null:C1517)
											
											DOM SET XML ATTRIBUTE:C866($Dom_target;\
												$t;$oo[$t])
											
										Else 
											
											DOM REMOVE XML ATTRIBUTE:C1084($Dom_target;$t)
											
										End if 
										
									Else 
										
										$o.success:=False:C215
										$o.errors.push("Invalid values pair for an attribute.")
										
									End if 
								End if 
							End for each 
							
							$o.success:=Bool:C1537(OK)
							
							  //______________________________________________________
						: ($2.what="position")
							
							If ($Dom_target=$o.root)
								
								$o.success:=False:C215
								$o.errors.push("You can't set position for the canvas!")
								
							Else 
								
								OK:=1
								
								If ($2.x#Null:C1517)
									
									DOM SET XML ATTRIBUTE:C866($Dom_target;\
										"x";String:C10($2.x;"&xml")+String:C10($2.unit))
									
									If (OK=1)
										
										If ($2.y#Null:C1517)
											
											DOM SET XML ATTRIBUTE:C866($Dom_target;\
												"y";String:C10($2.y;"&xml")+String:C10($2.unit))
											
										Else 
											
											DOM SET XML ATTRIBUTE:C866($Dom_target;\
												"y";String:C10($2.x;"&xml")+String:C10($2.unit))
											
										End if 
									End if 
								End if 
								
								$o.success:=Bool:C1537(OK)
								
							End if 
							
							  //______________________________________________________
						: ($2.what="dimensions")
							
							DOM GET XML ELEMENT NAME:C730($Dom_target;$t)
							
							If (OK=1)
								
								If ($t="textArea")
									
									If ($2.width=Null:C1517)
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"width";"auto")
										
									Else 
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"width";String:C10($2.width;"&xml")+String:C10($2.unit))
										
									End if 
									
									If ($2.height=Null:C1517)
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"height";"auto")
										
									Else 
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"height";String:C10($2.height;"&xml")+String:C10($2.unit))
										
									End if 
									
								Else 
									
									If ($2.width#Null:C1517)
										
										DOM SET XML ATTRIBUTE:C866($Dom_target;\
											"width";String:C10($2.width;"&xml")+String:C10($2.unit))
										
										If (OK=1)
											
											If ($2.height#Null:C1517)
												
												DOM SET XML ATTRIBUTE:C866($Dom_target;\
													"height";String:C10($2.height;"&xml")+String:C10($2.unit))
												
											Else 
												
												DOM SET XML ATTRIBUTE:C866($Dom_target;\
													"height";String:C10($2.width;"&xml")+String:C10($2.unit))
												
											End if 
										End if 
									End if 
								End if 
							End if 
							
							$o.success:=Bool:C1537(OK)
							
							  //______________________________________________________
						: ($2.what="fill")
							
							If ($Dom_target=$o.root)
								
								If ($2.color#Null:C1517)
									
									DOM SET XML ATTRIBUTE:C866($Dom_target;\
										"viewport-fill";String:C10($2.color))
									
								End if 
								
								If (OK=1)\
									 & ($2.opacity#Null:C1517)
									
									DOM SET XML ATTRIBUTE:C866($Dom_target;\
										"viewport-fill-opacity";Num:C11($2.opacity)/100)
									
								End if 
								
							Else 
								
								If ($2.color#Null:C1517)
									
									DOM SET XML ATTRIBUTE:C866($Dom_target;\
										"fill";String:C10($2.color))
									
								End if 
								
								If (OK=1)\
									 & ($2.opacity#Null:C1517)
									
									DOM SET XML ATTRIBUTE:C866($Dom_target;\
										"fill-opacity";Num:C11($2.opacity)/100)
									
								End if 
							End if 
							
							$o.success:=Bool:C1537(OK)
							
							  //______________________________________________________
						: ($2.what="stroke")
							
							$2.target:=$Dom_target
							$o:=svg ("stroke";$2)
							
							  //______________________________________________________
						: ($2.what="font")
							
							$2.target:=$Dom_target
							$o:=svg ("font";$2)
							
							  //______________________________________________________
						Else 
							
							TRACE:C157
							
							  //______________________________________________________
					End case 
					
					  //=================================================================
				Else 
					
					ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
					
					  //=================================================================
			End case 
		End if 
	End if 
	
	If (Not:C34(This:C1470.success))
		
		This:C1470.errors.push($1+" "+String:C10($2.what)+" failed")
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End