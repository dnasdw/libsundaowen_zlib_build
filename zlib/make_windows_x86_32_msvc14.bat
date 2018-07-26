IF DEFINED VS140COMNTOOLS (
  SET GENERATOR="Visual Studio 14"
) ELSE (
  FOR /F "tokens=1,2,*" %%I IN ('REG QUERY HKLM\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\SxS\VS7 /v 15.0 ^| FIND "15.0"') DO SET GENERATOR="Visual Studio 15"
)
SET target_lib_suffix=_msvc14
IF NOT DEFINED GENERATOR (
  ECHO Can not find VC2015 or VC2017 installed!
  GOTO ERROR
)
SET cwdir=%CD%
SET rootdir=%~dp0
SET target=windows_x86_32
SET prefix=%rootdir%%target%
SET /P version=<"%rootdir%version.txt"
RD /S /Q "%rootdir%%version%"
MD "%rootdir%%version%"
XCOPY "%rootdir%..\%version%" "%rootdir%%version%" /S /Y
RD /S /Q "%rootdir%build"
MD "%rootdir%build"
CD /D "%rootdir%build"
cmake -C "%rootdir%CMakeLists-MSVC.txt" -DCMAKE_INSTALL_PREFIX="%prefix%" -G %GENERATOR% "%rootdir%%version%"
cmake "%rootdir%%version%"
cmake --build . --target install --config Release --clean-first
MD "%rootdir%..\target\include\%target%"
XCOPY "%prefix%\include" "%rootdir%..\target\include\%target%" /S /Y
MD "%rootdir%..\target\lib\%target%%target_lib_suffix%"
COPY /Y "%prefix%\lib\zlibstatic.lib" "%rootdir%..\target\lib\%target%%target_lib_suffix%"
CD /D "%cwdir%"
RD /S /Q "%rootdir%%version%"
RD /S /Q "%rootdir%build"
RD /S /Q "%prefix%"
GOTO :EOF

:ERROR
PAUSE
