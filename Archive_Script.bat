REM	Clears the UNC path not supported warning
CLS


@echo off
REM	Append both standard output and standard error of command to the LOg file
REM	Custom Error Message will be returned to the log file
REM     Function sub is called twice with parameters as Inbound Test Archive and Us Test Online 


echo ------------------------------------------ >>%~pd0%Log.txt
echo Inbound Data Dropbox-Archived on  %date% %time% >>%~pd0%Log.txt
CALL :sub "Inbound Data Dropbox">>%~pd0%Log.txt 2>&1
if %ERRORLEVEl% EQU 9 echo "ERROR-9:Inbound Data Dropbox not found" >>%~pd0%Log.txt


echo ------------------------------------------ >>%~pd0%Log.txt
echo US Online Data Dropbox- Archived on  %date% %time% >>%~pd0%Log.txt
CALL :sub "US Online Data Dropbox">>%~pd0%Log.txt 2>&1
if %ERRORLEVEl% EQU 9 echo "ERROR-9:US Online Data Dropbox Directory not found " >>%~pd0%Log.txt



REM Function sub is called with parameter as Target folder in US Onlibne Datadropbox and the output and error will be
REM written to a seperate log file log_Target.txt.


echo ------------------------------------------ >>%~pd0%Log_Target.txt
echo US Online Data Dropbox\TARGET- Archived on  %date% %time% >>%~pd0%Log_Target.txt
CALL :sub "US Online Data Dropbox\TARGET">>%~pd0%Log_Target.txt 2>&1
if %ERRORLEVEl% EQU 9 echo "ERROR-9:TARGET Directory not found " >>%~pd0%Log_Target.txt
exit /b %ERRORLEVEL%


exit /b %ERRORLEVEL%




:sub

GOTO EndComment
	This bat-file Archives all the files 90 days old from Inbound Data Dropbox 
	and US Online Data Dropbox to Archive_CurrentYear folder.
	If there is a duplicate file in Archive Folder,Renames the Files and move 
	to Archive Folder

	@Author Simmy Payyappilly Varghese
	@Date   07/27/2017
	@Modified  02/07/2018
:EndComment


::	PUSHD -removes the UNC path supported error.Creates a temperory drive map

		PUSHD \\sclbonas02\neoscp\

::	mainDir-set the main folder name to a variable.
:: 	~1 Fetches the first parameter passed during the function- sub call


		set mainDir=%~1
	
		
::	EXIT with custom error code '9' if the main directory doesnt exist

		IF NOT EXIST "%mainDir%" exit /b 9

::	If main Directory exist change current dirrectory to it.Quotes are needed for folders with space name

		cd "%mainDir%"


::	:~ start,end - fetch specific character from a value to fetch year from current date
::	Creates Archive Folder if it doesnt exist
		
		IF NOT EXIST Archive_%date:~10% MD Archive_%date:~10%
		
		

::	First FORFILe Loops through the files in the path specified in /P whose modified date is 90 days and older than the current date and perform the renaming-append moving/current date
::	Second FORFILES moves all the old files including renamed to the Archive Folder
::	~position1,-position2 -Fetches the value from position1 from start to position2 from the end(right to left)


		
		set Archive=Archive_%date:~10%

		FORFILES /P "%cd%" /D -90  /C "cmd /c IF @isDir==FALSE cmd /c IF EXIST %Archive%\@file REN @file @fname0x5F%date:~4,-8%_%date:~7,-5%_%date:~10%__%time:~0,-9%.%time:~3,-6%.%time:~6%.@ext "
		FORFILES /P "%cd%" /D -90  /C "cmd /c IF @isDir==FALSE cmd /c move @file %Archive% & echo @fname is Moved" 



REM POPD remove the temperory Drive Map

POPD
