@ECHO OFF
SET Logfile=C:\Users\Prius\Desktop\log.txt
SET SvcName=nxlog
ping -n 5 192.168.13.128 > nul
IF %ERRORLEVEL% EQU 0 (
	SC QUERYEX "%SvcName%" | FIND "STATE" | FIND /v "RUNNING" > nul && (
		ECHO %SvcName% is not running 
   		 ECHO START %SvcName%

    		NET START "%SvcName%" > NUL || (
        			ECHO "%SvcName%" wont start
        			EXIT /B 1
    		)
		for /F "tokens=2 delims=:" %%i in ('"ipconfig | findstr IPv4"') do set LOCAL_IP=%%i
		echo Detected: Local IP = [%LOCAL_IP%]

    		ECHO "%SvcName%" was started at "%date%-%time%"  User logged in as %UserName% Computer name %ComputerName% IP %LOCAL_IP% >> %Logfile%
    		EXIT /B 0
	) || (
    		ECHO "%SvcName%" is already running "%date%-%time%"  User logged in as %UserName% Computer name %ComputerName% IP %LOCAL_IP%>> %Logfile%
    		EXIT /B 0
	)
)   ELSE (
	start %comspec% /c "mode 40,10&title Error &color 1e&echo.&echo. DNIF Adapter unrechable. &echo.&echo. Press a key and contact your system Administrator!&pause>NUL"
	SC QUERYEX "%SvcName%" | FIND "STATE" | FIND /v "RUNNING" > NUL && (
    		ECHO %SvcName% is not running
   		 ECHO START %SvcName%

    		NET START "%SvcName%" > NUL || (
        			ECHO "%SvcName%" wont start 
        			EXIT /B 1
    		)
		for /F "tokens=2 delims=:" %%i in ('"ipconfig | findstr IPv4"') do set LOCAL_IP=%%i
		echo Detected: Local IP = [%LOCAL_IP%]

    		ECHO "%SvcName%" was started but DNIF server is unreachable at "%date%-%time%"  User logged in as %UserName% Computer name %ComputerName% IP %LOCAL_IP% >> %Logfile%
    		EXIT /B 0
	) || (
    		ECHO "%SvcName%" is running but DNIF server is unreachable at "%date%-%time%"  User logged in as %UserName% Computer name %ComputerName% IP %LOCAL_IP% >> %Logfile%
    		EXIT /B 0
	)
)
