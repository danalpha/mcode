@echo off
:main_work
	rem call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\Tools\VsDevCmd.bat"
	cd /d %~dp0
	win_bison -d mcode.y
	win_flex -o mcode.c --wincompat mcode.l
	cl *.c
	del /s /q *.obj
	echo PRESS ENTER KEY GO AHEAD OR QUIT
	call :get_key
	if "%key%"=="" (
		cls
		mcode.exe
	) else (
		echo "QUIT"
		cls
	)
GOTO:EOF

:get_key
  set "key="
  for /f "delims=" %%a in ('xcopy /w "%~f0" "%~f0" 2^>nul') do if not defined key set "key=%%a"
  set "key=%key:~-1%"
  echo %key%
GOTO:EOF
rem mcode.exe
rem pause
