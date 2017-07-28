GOTO EndComment

This bat-file Archives all the files 90 days old to Archive_CurrentYear folder
@Author Simmy Payyappilly Varghese
@Date   07/27/2017

:EndComment


@echo off
REM :~ start,end - fetch specific character from a value to fetch year from current date

	set dir =  C:\Users\svarg00\Desktop\testSclnas1\
	set newFolder = %dir%Archive_%date:~10%


REM :Creates the ARchive Folder if it doesnt exist
	IF NOT EXIST %newFolder% MD %newFolder%

REM :Loops through the files in the path and based on search criteria in /D perform teh action in /C
REM :/D -days fetches the files with modified date that many days less than the current date

	FORFILES /p %dir% /D -2 /C "cmd /c MOVE %dir%@file   %newFolder%


