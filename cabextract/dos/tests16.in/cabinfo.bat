@ECHO OFF
REM
REM  cabextract/dos/test16.in/cabinfo.bat: Unit tests for DOS.
REM

IF "%CABDIR%"==""   GOTO ERROR_CABDIR
IF "%CABINFO%"==""  GOTO ERROR_CABINFO
IF "%TEST_IN%"==""  GOTO ERROR_TEST_IN
IF "%TEST_OUT%"=="" GOTO ERROR_TEST_OUT

SET RESULT=%TEST_OUT%\cabinfo.result
IF EXIST %RESULT% DEL %RESULT%

IF NOT EXIST %TEST_OUT%\NUL MD %TEST_OUT%

:TEST50
SET TEST=test50-cabinfo-cabs
ECHO [33m%TEST%[0m
PUSHD %CABDIR%

REM @NOTE: DOSBox-X fully qualifies %i here, which breaks this loop syntax:
REM FOR %%i IN (*.cab) DO %CABINFO% %%i >%TEST_OUT%\%%i.txt

SET TEST_CAB=case-ascii.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=case-utf8.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=dir.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=dirwalk-vulns.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=encoding-koi8.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=encoding-latin1.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=encoding-sjis.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=large-files-cab.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=mixed.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=search.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=simple.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=split-1.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=split-2.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=split-3.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=split-4.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=split-5.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=utf8-stresstest.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

POPD

:TEST51
SET TEST=test51-cabinfo-bugs
ECHO [33m%TEST%[0m
PUSHD %CABDIR%\..\BUGS

SET TEST_CAB=cve-2010-2800-mszip-infinite-loop.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=cve-2010-2801-qtm-flush.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=cve-2014-9556-qtm-infinite-loop.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=cve-2014-9732-folders-segfault.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=cve-2015-4470-mszip-over-read.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=cve-2015-4471-lzx-under-read.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=filename-read-violation-1.cab 
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=filename-read-violation-2.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=filename-read-violation-3.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=filename-read-violation-4.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=lzx-main-tree-no-lengths.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=lzx-premature-matches.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

SET TEST_CAB=qtm-max-size-block.cab
SET TEST_RESULT=PASS
%CABINFO% %TEST_CAB% >%TEST_OUT%\%TEST_CAB%.txt
FC /L %TEST_IN%\%TEST_CAB%.txt %TEST_OUT%\%TEST_CAB%.txt
IF ERRORLEVEL 1 SET TEST_RESULT=FAIL
ECHO %TEST%:%TEST_CAB%:%TEST_RESULT% >>%RESULT%

POPD

GOTO END

:ERROR_CABDIR
ECHO ERROR: %%CABDIR%% is not set.
GOTO END

:ERROR_CABINFO
ECHO ERROR: %%CABINFO%% is not set.
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
