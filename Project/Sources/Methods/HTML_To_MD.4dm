//%attributes = {}
/*
HTML_To_MD ( $html : Text ) -> Text
*/

#DECLARE($html : Text) : Text

var $md:=$html

// --------------------------------------------------
// NORMALISATION HTML WORD (indispensable)
// --------------------------------------------------

// double encodage
$md:=Replace string:C233($md; "&amp;lt;"; "<")
$md:=Replace string:C233($md; "&amp;gt;"; ">")
$md:=Replace string:C233($md; "&amp;quot;"; "\"")

// encodage simple
$md:=Replace string:C233($md; "&lt;"; "<")
$md:=Replace string:C233($md; "&gt;"; ">")
$md:=Replace string:C233($md; "&quot;"; "\"")

// espaces Word
$md:=Replace string:C233($md; "&nbsp;"; " ")
$md:=Replace string:C233($md; "&amp;nbsp;"; " ")

// puces
$md:=Replace string:C233($md; "&#x2022;"; "- ")
$md:=Replace string:C233($md; "&amp;#x2022;"; "- ")

// tabs → espaces
$md:=Replace string:C233($md; Char:C90(Tab:K15:37); " ")

// nettoyer les lignes très longues Word
$md:=Replace string:C233($md; Char:C90(Carriage return:K15:38)+" "; Char:C90(Carriage return:K15:38))

$md:=Replace string:C233($md; Char:C90(Carriage return:K15:38); "")
$md:=Replace string:C233($md; Char:C90(Line feed:K15:40); "")

// Titres
$md:=Replace string:C233($md; "<H1>"; "# ")
$md:=Replace string:C233($md; "</H1>"; Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38))

$md:=Replace string:C233($md; "<H2>"; "## ")
$md:=Replace string:C233($md; "</H2>"; Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38))

// Paragraphes
$md:=Replace string:C233($md; "<P>"; "")
$md:=Replace string:C233($md; "</P>"; Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38))

// Styles
$md:=Replace string:C233($md; "<B>"; "**")
$md:=Replace string:C233($md; "</B>"; "**")

$md:=Replace string:C233($md; "<I>"; "*")
$md:=Replace string:C233($md; "</I>"; "*")

// Sauts ligne
$md:=Replace string:C233($md; "<BR>"; Char:C90(Carriage return:K15:38))
$md:=Replace string:C233($md; "<BR/>"; Char:C90(Carriage return:K15:38))
$md:=Replace string:C233($md; "<BR />"; Char:C90(Carriage return:K15:38))

// --------------------------------------------------
// Images
// --------------------------------------------------
var $start:=Position:C15("<IMG"; $md)

While ($start>0)
	
	var $end:=Position:C15(">"; $md; $start)
	
	If ($end=0)
		
		break
		
	End if 
	
	var $tag:=Substring:C12($md; $start; $end-$start+1)
	
	var $src:=""
	var $posSrc:=Position:C15("SRC=\""; $tag)
	
	If ($posSrc>0)
		
		$posSrc+=5
		var $posEnd:=Position:C15("\""; $tag; $posSrc)
		
		If ($posEnd>0)
			
			$src:=Substring:C12($tag; $posSrc; $posEnd-$posSrc)
			
		End if 
	End if 
	
	$md:=Replace string:C233($md; $tag; $src+Char:C90(Carriage return:K15:38))
	$start:=Position:C15("<IMG"; $md)
	
End while 

// --------------------------------------------------
// TABLES → Markdown
// --------------------------------------------------

var $tableStart:=Position:C15("<TABLE"; $md)

While ($tableStart>0)
	
	var $tableEnd:=Position:C15("</TABLE>"; $md; $tableStart)
	If ($tableEnd=0)
		break
	End if 
	
	var $table:=Substring:C12($md; $tableStart; $tableEnd-$tableStart+8)
	
	var $mdTable:=""
	
	// extraire lignes
	var $rowStart:=Position:C15("<TR"; $table)
	var $firstRow:=True:C214
	
	While ($rowStart>0)
		
		var $rowEnd:=Position:C15("</TR>"; $table; $rowStart)
		If ($rowEnd=0)
			break
		End if 
		
		var $row:=Substring:C12($table; $rowStart; $rowEnd-$rowStart+5)
		
		var $mdRow:="| "
		var $cellStart:=Position:C15("<TD"; $row)
		
		While ($cellStart>0)
			
			var $cellClose:=Position:C15(">"; $row; $cellStart)
			var $cellEnd:=Position:C15("</TD>"; $row; $cellStart)
			
			If (($cellClose=0) | ($cellEnd=0))
				break
			End if 
			
			var $content:=Substring:C12($row; $cellClose+1; $cellEnd-$cellClose-1)
			
			// nettoyer contenu
			$content:=Replace string:C233($content; Char:C90(Carriage return:K15:38); "")
			$content:=Replace string:C233($content; Char:C90(Line feed:K15:40); "")
			
			$mdRow+=$content+" | "
			
			$cellStart:=Position:C15("<TD"; $row; $cellEnd)
			
		End while 
		
		If ($mdRow#"| ")
			$mdTable+=$mdRow+Char:C90(Carriage return:K15:38)
			
			// ligne séparation header
			If ($firstRow)
				
				var $sep:="| "
				var $pipeCount:=Length:C16($mdRow)-Length:C16(Replace string:C233($mdRow; "|"; ""))
				
				For ($i; 1; $pipeCount-1)
					$sep+="--- | "
				End for 
				
				$mdTable+=$sep+Char:C90(Carriage return:K15:38)
				$firstRow:=False:C215
				
			End if 
		End if 
		
		$rowStart:=Position:C15("<TR"; $table; $rowEnd)
		
	End while 
	
	// remplacer la table HTML
	$md:=Replace string:C233($md; $table; Char:C90(Carriage return:K15:38)+$mdTable+Char:C90(Carriage return:K15:38))
	
	$tableStart:=Position:C15("<TABLE"; $md)
	
End while 

// --------------------------------------------------
// Nettoyage balises connues
// --------------------------------------------------
var $tags:=[\
"<DIV>"; \
"</DIV>"; \
"<TABLE>"; \
"</TABLE>"; \
"<TR>"; \
"</TR>"; \
"<TD>"; \
"</TD>"; \
"<HR>"; \
"<HEAD>"; \
"</HEAD>"; \
"<BODY>"; \
"</BODY>"; \
"<HTML>"; \
"</HTML>"]

For each ($tag; $tags)
	
	$md:=Replace string:C233($md; $tag; "")
	
End for each 


// --------------------------------------------------
// Suppression générique des balises
// --------------------------------------------------
Repeat 
	
	var $p1:=Position:C15("<"; $md)
	
	If ($p1=0)
		
		break
		
	End if 
	
	var $p2:=Position:C15(">"; $md; $p1)
	
	If ($p2=0)
		
		break
		
	End if 
	
	$md:=Delete string:C232($md; $p1; $p2-$p1+1)
	
Until (False:C215)

// --------------------------------------------------
// Nettoyage final
// --------------------------------------------------
Repeat 
	
	var $old:=$md
	$md:=Replace string:C233($md; Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38); Char:C90(Carriage return:K15:38)+Char:C90(Carriage return:K15:38))
	$md:=Replace string:C233($md; "  "; " ")
	$md:=Replace string:C233($md; " #"; "#")
	
Until ($old=$md)

// --------------------------------------------------
// ✅ RETOUR DU RESULTAT
// --------------------------------------------------
return $md