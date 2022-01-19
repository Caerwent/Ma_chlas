
if ($null -eq $env:QT_DIR) {
    echo QT_DIR is NOT defined, used default value
    
    $env:QT_DIR = ..\Qt\6.2.2\gcc_64 
}
$env:QT_DIR=[System.IO.Path]::GetFullPath($env:QT_DIR)
echo QT_DIR $Env:QT_DIR


if ($null -eq $env:CURRENT_VERSION) {
    echo CURRENT_VERSION is NOT defined, used default value
    
    $env:CURRENT_VERSION=1.0.0
}


echo CURRENT_VERSION $env:CURRENT_VERSION

if ($null -eq $env:ARCH_NAME) {
    echo ARCH_NAME is NOT defined, used default value
    
    $env:ARCH_NAME=x86_64
}



set $env:PROJECT_PATH=[System.IO.Path]::GetFullPath(".\atalierou")


set $env:BUILD_PATH=[System.IO.Path]::GetFullPath(".\build-Atalierou-windows_$env:ARCH_NAME-Release")
New-Item -Force -Path $env:BUILD_PATH -ItemType Directory

set $env:DISTRIB_PATH=[System.IO.Path]::GetFullPath(".\distrib\windows_$env:ARCH_NAME")
New-Item -Force -Path $env:DISTRIB_PATH -ItemType Directory

Set-Location -Path $env:BUILD_PATH -PassThru


Start-Process -Verb RunAs $env:QT_DIR\bin\qmake -Args -o Makefile $env:PROJECT_PATH\Atalierou.pro -spec win32-msvc CONFIG+=qtquickcompiler

Start-Process -Verb RunAs $env:QT_DIR\bin\nmake -Args -f Makefile


Start-Process -Verb RunAs $env:QT_DIR\bin\windeployqt -Args  --release --qmldir --qmake $env:QT_DIR\bin\qmake $env:PROJECT_PATH\qml --verbose 2 Atalierou.exe 

Set-Location -Path $env:ROOT_PATH -PassThru
​copy-item -path $env:BUILD_PATH\Atalierou.exe -destination .\Atalierou_$env:CURRENT_VERSION_$env:ARCH_NAME.exe

