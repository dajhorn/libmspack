@ECHO OFF
REM
REM  cabextract/dos/test.in/large-files.bat: Unit tests for DOS.
REM

IF "%CABDIR%"==""   GOTO ERROR_CABDIR
IF "%CABEXT%"==""   GOTO ERROR_CABEXT
IF "%TEST_IN%"==""  GOTO ERROR_TEST_IN
IF "%TEST_OUT%"=="" GOTO ERROR_TEST_OUT

SET RESULT=%TEST_OUT%\large-files.result
IF EXIST %RESULT% DEL %RESULT%

:TEST32
SET TEST=test32-large-files
ECHO [33m%TEST%[35m
CHOICE /T:Y,10 "This test is slow. Run %TEST%"
ECHO [0m
IF ERRORLEVEL 2 GOTO TEST33
MD %TEST_OUT%\%TEST%
PUSHD %TEST_OUT%\%TEST%
%CABEXT% %CABDIR%\large-files-cab.cab
%CABEXT% --test large-files.cab >%TEST_OUT%\%TEST%.out
SET TEST_RESULT=PASS
FC /L %TEST_IN%\%TEST%.in %TEST_OUT%\%TEST%.out
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
POPD
ECHO %TEST%:%TEST_RESULT% >>%RESULT%

:TEST33
REM  This test does not really apply to DOS builds because FAT16 has a
REM  maximum file size of 2GB and FAT32 has a maximum file size of 4GB.
REM
REM  @TODO: Determine why 7-Zip fails this test.
REM
REM  large-search.cab must be locally generated because it is not in repo.
IF NOT EXIST %CABDIR%\large-search.cab GOTO END
SET TEST=test33-large-search
ECHO [33m%TEST%[0m
PUSHD %CABDIR%
%CABEXT% --test large-search.cab >%TEST_OUT%\%TEST%.out
SET TEST_RESULT=PASS
FC /L %TEST_IN%\%TEST%.in %TEST_OUT%\%TEST%.out
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_RESULT% >>%RESULT%
POPD

GOTO END

:ERROR_CABDIR
ECHO ERROR: %%CABDIR%% is not set.

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
SET TEST_RESULT=
SET RESULT=
