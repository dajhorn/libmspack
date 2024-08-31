@ECHO OFF
REM
REM  cabextract/dos/test.in/symlinks.bat: Unit tests for DOS.
REM

IF "%CABDIR%"==""   GOTO ERROR_CABDIR
IF "%CABEXT%"==""   GOTO ERROR_CABEXT
IF "%TEST_IN%"==""  GOTO ERROR_TEST_IN
IF "%TEST_OUT%"=="" GOTO ERROR_TEST_OUT

SET TEST_CAB=%CABDIR%\dir.cab
SET RESULT=%TEST_OUT%\symlinks.result

IF EXIST %RESULT% DEL %RESULT%

:TEST49
REM  DOS does not implement links.
REM
REM  set up a symlinked file and symlinked directory
REM  extract $tmpdir/plain.c and $tmpdir/1/2/3/4.c
REM  check they did NOT get written to $tmpdir/other.c and $tmpdir/other/4.c

:TEST50
REM  DOS does not implement links.
REM
REM  restore the symlinked file/dir
REM  extract again with -k option
REM  check they DID get written to $tmpdir/other.c and $tmpdir/other/3/4.c

:TEST51
REM  DOS does not implement links.
REM
REM  extract to a user-selected directory path that has symlinks in it.
REM  check that those symlinks are preserved, but symlinks in the parts
REM  of the path that are archive-controlled are removed

:TEST52
SET TEST=test52-no-overwrite
ECHO [33m%TEST%[0m
MD %TEST%
MD %TEST%\1
MD %TEST%\1\2
MD %TEST%\1\2\3
ECHO TEST52 >%TEST%\PLAIN.C
COPY %TEST%\PLAIN.C %TEST%\1\2\3\4.C
%CABEXT% --no-overwrite --directory %TEST% %TEST_CAB%
SET TEST_RESULT=PASS
FC /L %TEST%\PLAIN.C %TEST%\1\2\3\4.C
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
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
SET TEST_CAB=
SET TEST=
SET TEST_RESULT=
SET RESULT=
