@ECHO OFF

FOR /F "tokens=3 delims=,[]" %%a IN ('findstr "AC_INIT" ..\cabextract\configure.ac') DO SET VERSION=%%a

SET GIT_FORMAT=format:
SET GIT_FORMAT=%GIT_FORMAT%#define COMMIT_HASH         0x%%h%%n
SET GIT_FORMAT=%GIT_FORMAT%#define COMMIT_AUTHOR_EMAIL """"%%ae""""%%n
SET GIT_FORMAT=%GIT_FORMAT%#define COMMIT_AUTHOR_NAME  """"%%an""""%%n
SET GIT_FORMAT=%GIT_FORMAT%#define VERSION             """"%VERSION%""""%%n

git log -1 --pretty="%GIT_FORMAT%" --output=version.h
