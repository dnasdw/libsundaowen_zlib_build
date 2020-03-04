IF DEFINED VS90COMNTOOLS (
  SET GENERATOR="Visual Studio 9 2008 Win64"
) ELSE IF DEFINED VS120COMNTOOLS (
  SET GENERATOR="Visual Studio 12 Win64"
) ELSE IF DEFINED VS110COMNTOOLS (
  SET GENERATOR="Visual Studio 11 Win64"
) ELSE IF DEFINED VS100COMNTOOLS (
  SET GENERATOR="Visual Studio 10 Win64"
)
SET target_lib_suffix=
IF NOT DEFINED GENERATOR (
  ECHO Can not find VC2008 or VC2010 or VC2012 or VC2013 installed!
  GOTO ERROR
)
PUSHD "%~dp0"
SET rootdir=%~dp0
SET rootdir=%rootdir:~0,-1%
SET tmpdir=%~d0\tmp_libsundaowen_zlib
SET target=windows_x86_64
SET prefix=%tmpdir%\%target%
SET /P version=<version.txt
RD /S /Q "%tmpdir%\%version%"
MD "%tmpdir%\%version%"
XCOPY "..\%version%" "%tmpdir%\%version%" /S /Y
PUSHD "%tmpdir%\%version%"
RD /S /Q build
MD build
CD build
cmake -C "%rootdir%\CMakeLists-MSVC.txt" -DCMAKE_INSTALL_PREFIX="%prefix%" -G %GENERATOR% ..
cmake --build . --target install --config Release --clean-first
POPD
MD "..\target\include\%target%"
XCOPY "%prefix%\include" "..\target\include\%target%" /S /Y
MD "..\target\lib\%target%%target_lib_suffix%"
COPY /Y "%prefix%\lib\*static*.lib" "..\target\lib\%target%%target_lib_suffix%"
POPD
RD /S /Q "%tmpdir%"
GOTO :EOF

:ERROR
PAUSE
