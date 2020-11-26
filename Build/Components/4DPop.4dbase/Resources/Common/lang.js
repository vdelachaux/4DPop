<!--

// Display the localized help file according to the browser lang
// Uncomment or add a "else if" clause

if (navigator.browserLanguage)
	var language = navigator.browserLanguage;
else
	var language = navigator.language;
		
if (language.indexOf('fr') > -1) document.location.href = 'Resources/fr.lproj/Help.html';
		
	else if (language.indexOf('en') > -1) document.location.href = 'Resources/en.lproj/Help.html';
		
	else if (language.indexOf('ja') > -1) document.location.href = 'Resources/ja.lproj/Help.html';
		
	else if (language.indexOf('es') > -1) document.location.href = 'Resources/es.lproj/Help.html';
		
	else if (language.indexOf('de') > -1) document.location.href = 'Resources/de.lproj/Help.html';
		
//	else if (language.indexOf('it') > -1) document.location.href = 'Resources/it.lproj/Help.html';
		
else
		
	document.location.href = 'Resources/en.lproj/Help.html';

// -->		