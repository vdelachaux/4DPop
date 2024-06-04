//%attributes = {"invisible":true}

EXECUTE METHOD:C1007("quickOpenPushAction"; *; {\
name: "Make symbolic link"; \
shortcut: "link"; \
formula: Formula:C1597(makeSymbolicLink)})

EXECUTE METHOD:C1007("quickOpenPushAction"; *; {\
name: "Recover the window"; \
shortcut: "window"; \
formula: Formula:C1597(recoverWindow)})