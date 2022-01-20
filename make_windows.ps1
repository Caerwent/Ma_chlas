
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



$env:PROJECT_PATH=[System.IO.Path]::GetFullPath(".\atalierou")


$env:BUILD_PATH=[System.IO.Path]::GetFullPath(".\build-Atalierou-windows_$env:ARCH_NAME-Release")
New-Item -Force -Path $env:BUILD_PATH -ItemType Directory

$env:DISTRIB_PATH=[System.IO.Path]::GetFullPath(".\distrib\windows_$env:ARCH_NAME")
New-Item -Force -Path $env:DISTRIB_PATH -ItemType Directory

Set-Location -Path $env:BUILD_PATH -PassThru


$env:PATH="$env:PATH;C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Enterprise\\VC\\Tools\\MSVC\\14.25.28610\\bin\\Hostx86\\x64"

Start-Process -FilePath "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" -ArgumentList "x86_x64" -Verbose -NoNewWindow

echo launch qmake
Start-Process -FilePath "$env:QT_DIR\bin\qmake.exe" -ArgumentList "-d -o Makefile $env:PROJECT_PATH\Atalierou.pro -spec win32-msvc CONFIG+=qtquickcompile  -tp vcr" -Verbose -NoNewWindow
# Start-Process -FilePath "$env:QT_DIR\bin\mingw_64\qmake.exe" -ArgumentList "$env:PROJECT_PATH\Atalierou.pro -spec win32-g++ 'CONFIG+=qtquickcompile'" -Verbose -NoNewWindow
echo launch make
Start-Process -FilePath "$env:QT_DIR\bin\jom.exe" -ArgumentList "-f Makefile" -Verbose -NoNewWindow
# Start-Process -FilePath "$env:QT_DIR\Tools\mingw810_64\bin\mingw32-make.exe" -ArgumentList "-f Makefile qmake_all" -Verbose -NoNewWindow
# Start-Process -FilePath "$env:QT_DIR\Tools\mingw810_64\bin\mingw32-make.exe" -ArgumentList "-j4" -Verbose -NoNewWindow

echo launch windeployqt
Start-Process -FilePath "$env:QT_DIR\bin\windeployqt" -ArgumentList "--release --qmldir --qmake $env:QT_DIR\bin\qmake.exe $env:PROJECT_PATH\qml --verbose 2 Atalierou.exe" -Verbose -NoNewWindow

Set-Location -Path $env:ROOT_PATH -PassThru
​copy-item -path $env:BUILD_PATH\Atalierou.exe -destination .\Atalierou_$env:CURRENT_VERSION_$env:ARCH_NAME.exe

