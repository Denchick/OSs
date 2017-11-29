@echo off 

::exit if iconv is not found or error accured
where iconv > nul 2>&1
if errorlevel 1 (
	:: iconv is not found
    echo iconv.exe is not found. Download this from mingw.org
    echo Errorcode 1
    goto :eof
) 
if errorlevel 2 (
	::runtime error
	echo An error occurred while searching for iconv.exe. Please try again.
	echo Errorcode 2
	set %errorlevel%=2
	goto :eof
)  


if "%1" == "/?" (
	::help message
	echo Usage: %~n0 [/?] [directory] 
	echo Converting all .txt files in [directory] from cp866 to utf-8 encoding.
	echo The directory structure does not change. 
	echo Errorcodes:
	echo 	returns errorcode 1 if iconv.exe is not find.
	echo 	returns errorcode 2 if error occured while searching for iconv.exe
	echo 	returns errorcode 3 if [directory] does not exist 
	goto :eof
)


set directory=%1
if not exist %directory% (
	::invalid argument or directory not exists
	echo There is no directory named %directory%
	echo To view help type /?
	echo Errorcode 3
	set errorlevel=3
	goto :eof 
)


:main
for /r %directory% %%f in (*.txt) do (
    iconv -c -f cp866 -t utf-8  "%%~f" > "%TEMP%\%%~nf.temp"
    echo converted "%%~f"
    move "%TEMP%\%%~nf.temp" "%%~f" > nul
)