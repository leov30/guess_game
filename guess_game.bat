@echo off
set _lives=3

if not exist riddles.csv curl -O "https://raw.githubusercontent.com/crawsome/riddles/main/riddles.csv"

set _point=0
set _lines=0
for /f "delims=" %%g in (riddles.csv) do set /a _lines+=1
set /a _lines-=1

title Points: %_point% Lives: %_lives%
:loop
call :get_question

if "%_answ%"=="" (
	goto :loop
)else (
	set "_answ=%_answ:~1%"
)

echo:
set /p "_guess=Guess? "

if /i "%_guess%"=="%_answ%" (
	echo You got it right!!!&set /a _point+=1
)else (
	echo That's wrong!&set /a _lives-=1
)
timeout 2 >nul

title Points: %_point% Lives: %_lives%

if %_lives% gtr 0 (
	goto :loop
)else (
	cls&echo GAME OVER
	pause&exit /b
)

:get_question
cls
set "_answ="
set /a _rand=(%random%%%(%_lines%-1+1))+1

for /f skip^=%_rand%^ tokens^=1^,2^ delims^=^" %%g in (riddles.csv) do (
	echo %%g
	set "_answ=%%h"
	exit /b
)
