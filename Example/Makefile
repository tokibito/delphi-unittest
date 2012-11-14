all: win32 osx

win32: TestProject.dpr
	dcc32 -$M+ TestProject.dpr

osx: TestProject.dpr
	dccosx -$M+ TestProject.dpr

nofail: TestProject.dpr
	dcc32 -DNOFAIL -$M+ TestProject.dpr

test: all
	TestProject.exe

clean:
	del TestProject
	del TestProject.exe
	del ..\Nullpobug.Unittest.dcu
