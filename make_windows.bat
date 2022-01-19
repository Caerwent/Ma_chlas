
if not defined QT_DIR (
  echo QT_DIR is NOT defined, used default value
  set QT_DIR=../Qt/6.2.2/gcc_64
)

rem // find absolute path, save current directory and change to target directory
pushd %QT_DIR%
rem // Save value of CD variable (current directory)
set QT_DIR=%CD%
rem // Restore original directory
popd

echo QT_DIR: %QT_DIR%


if not defined CURRENT_VERSION (
  echo CURRENT_VERSION is NOT defined, used default value
  set CURRENT_VERSION=1.0.0
)

echo CURRENT_VERSION: %CURRENT_VERSION%

if not defined ARCH_NAME (
  echo ARCH_NAME is NOT defined, used default value
  set ARCH_NAME=x86_64
)

  
set ROOT_PATH=%CD%
set PROJECT_PATH=./atalierou
pushd %PROJECT_PATH%
set PROJECT_PATH=%CD%
popd

set BUILD_PATH=./build-Atalierou-windows_$ARCH_NAME-Release
RMDIR /S /Q %BUILD_PATH%
mkdir  %BUILD_PATH%
pushd %BUILD_PATH%
set BUILD_PATH=%CD%
popd

set DISTRIB_PATH=./distrib/windows_$ARCH_NAME
RMDIR /S /Q %DISTRIB_PATH%
mkdir %DISTRIB_PATH%
pushd %DISTRIB_PATH%
set DISTRIB_PATH=%CD%
popd

cd %BUILD_PATH%


%QT_DIR%/bin/qmake -o Makefile %PROJECT_PATH%/Atalierou.pro -spec win32-msvc CONFIG+=qtquickcompiler

nmake -f Makefile


%QT_DIR%/bin/windeployqt --release --qmldir --qmake %QT_DIR%/bin/qmake %PROJECT_PATH%/qml --verbose 2 Atalierou.exe 
cd %ROOT_PATH%
mv %BUILD_PATH%/Atalierou.exe Atalierou_${CURRENT_VERSION}_${ARCH_NAME}.exe

