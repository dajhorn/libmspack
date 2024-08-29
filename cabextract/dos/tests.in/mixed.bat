@ECHO OFF
REM
REM  cabextract/dos/test.in/mixed.bat: Unit tests for DOS.
REM
REM  @NOTE:  The text files in mixed.cab are in unix newline format, so the
REM          *.in files here must be cloned without CRLF translation, or the
REM          FC /W switch must be used to ignore whitespace.
REM
REM  @NOTE:  The -F parameter must be unquoted because command.com is not
REM          a posix shell.

IF "%CABDIR%"==""   GOTO ERROR_CABDIR
IF "%CABEXT%"==""   GOTO ERROR_CABEXT
IF "%TEST_IN%"==""  GOTO ERROR_TEST_IN
IF "%TEST_OUT%"=="" GOTO ERROR_TEST_OUT

SET TEST_CAB=%CABDIR%\mixed.cab
SET RESULT=%TEST_OUT%\mixed.result
IF EXIST %RESULT% DEL %RESULT%

PUSHD %CABDIR%

:TEST34
SET TEST=test34-mixed
ECHO [33m%TEST%[0m
%CABEXT% --pipe %TEST_CAB% >%TEST_OUT%\%TEST%.out
SET TEST_RESULT=PASS
FC /L %TEST_IN%\%TEST%.in %TEST_OUT%\%TEST%.out
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_RESULT% >>%RESULT%

:TEST35
SET TEST=test35-mixed
ECHO [33m%TEST%[0m
%CABEXT% --pipe -F mszip.* %TEST_CAB% >%TEST_OUT%\%TEST%.out
SET TEST_RESULT=PASS
FC /L %TEST_IN%\%TEST%.in %TEST_OUT%\%TEST%.out
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_RESULT% >>%RESULT%

:TEST36
SET TEST=test36-mixed
ECHO [33m%TEST%[0m
%CABEXT% --pipe -F *zx* %TEST_CAB% >%TEST_OUT%\%TEST%.out
SET TEST_RESULT=PASS
FC /L %TEST_IN%\%TEST%.in %TEST_OUT%\%TEST%.out
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_RESULT% >>%RESULT%

:TEST37
SET TEST=test37-mixed
ECHO [33m%TEST%[0m
%CABEXT% --pipe -F *m.txt %TEST_CAB% >%TEST_OUT%\%TEST%.out
SET TEST_RESULT=PASS
FC /L %TEST_IN%\%TEST%.in %TEST_OUT%\%TEST%.out
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_RESULT% >>%RESULT%

:TEST38
SET TEST=test38-mixed
ECHO [33m%TEST%[0m
%CABEXT% --pipe -F qtm.txt -F lzx.txt -F mszip.txt %TEST_CAB% >%TEST_OUT%\%TEST%.out
SET TEST_RESULT=PASS
FC /L %TEST_IN%\%TEST%.in %TEST_OUT%\%TEST%.out
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_RESULT% >>%RESULT%

:TEST39
SET TEST=test39-mixed
ECHO [33m%TEST%[0m
%CABEXT% --pipe -F ???.txt -F mszip.txt %TEST_CAB% >%TEST_OUT%\%TEST%.out
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
SET TEST_CAB=
SET TEST=
SET TEST_RESULT=
SET RESULT=
