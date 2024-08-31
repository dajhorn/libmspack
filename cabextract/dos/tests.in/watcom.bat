@ECHO OFF
REM
REM  cabextract/dos/test.in/watcom.bat: Unit tests for DOS.
REM

IF "%CABDIR%"==""   GOTO ERROR_CABDIR
IF "%CABEXT%"==""   GOTO ERROR_CABEXT
IF "%TEST_IN%"==""  GOTO ERROR_TEST_IN
IF "%TEST_OUT%"=="" GOTO ERROR_TEST_OUT

SET TEST_CAB=%CABDIR%\split-1.cab
SET RESULT=%TEST_OUT%\watcom.result

IF EXIST %RESULT% DEL %RESULT%

:TEST53
REM  Check for corruption caused by automatic CRLF translation.
SET TEST=test53-pipe
ECHO [33m%TEST%[0m
MD %TEST_OUT%\%TEST%
PUSHD %CABDIR%
%CABEXT% -F medium2.bin -d %TEST_OUT%\%TEST% %TEST_CAB%
%CABEXT% -F medium2.bin --pipe %TEST_CAB% >%TEST_OUT%\%TEST%\pipe2.bin
SET TEST_RESULT=PASS
FC /B %TEST_OUT%\%TEST%\medium2.bin %TEST_OUT%\%TEST%\pipe2.bin
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
POPD
ECHO %TEST%:%TEST_RESULT% >>%RESULT%

GOTO END

:ERROR_CABDIR
ECHO ERROR: %%CABDIR%% is not set.
GOTO END

:ERROR_CABEXT
ECHO ERROR: %%CABEXT%% is not set.
GOTO END

:ERROR_TEST_IN
ECHO ERROR: %%TEST_IN%% is not set.
GOTO END

:ERROR_TEST_OUT
ECHO ERROR: %%TEST_OUT%% is not set.
GOTO END

:END
SET TEST=
SET TEST_CAB=
SET TEST_RESULT=
SET RESULT=
