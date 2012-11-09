all: win32 osx

win32: TestProject.dpr
	dcc32 -$M+ TestProject.dpr

osx: TestProject.dpr
	dccosx -$M+ TestProject.dpr

clean:
	del TestProject
	del TestProject.exe
