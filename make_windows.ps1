
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

$env:ROOT_PATH=[System.IO.Path]::GetFullPath(".")

$env:PROJECT_PATH=[System.IO.Path]::GetFullPath(".\atalierou")


$env:BUILD_PATH=[System.IO.Path]::GetFullPath(".\build-Atalierou-windows_$env:ARCH_NAME-Release")
New-Item -Force -Path $env:BUILD_PATH -ItemType Directory

$env:DISTRIB_PATH=[System.IO.Path]::GetFullPath(".\distrib\windows_$env:ARCH_NAME")
New-Item -Force -Path $env:DISTRIB_PATH -ItemType Directory

Set-Location -Path $env:BUILD_PATH -PassThru

$env:PATH="$env:QT_DIR\bin\;$env:QT_DIR\Tools\mingw1120_64\bin;$env:QT_DIR\Tools\mingw1120_64\x86_64-w64-mingw32\bin;$env:PATH"

# echo PATH $env:PATH
Get-ChildItem -Path "$env:QT_DIR\Tools\"
# Get-ChildItem -Path "$env:QT_DIR\Tools\mingw1120_64\bin"
# Get-ChildItem -Path "$env:QT_DIR\Tools\mingw1120_64\x86_64-w64-mingw32\bin"

echo "============================================="
echo "            launch qmake"
echo "============================================="
# Start-Process -FilePath "qmake.exe" -ArgumentList "-d -o Makefile $env:PROJECT_PATH\Atalierou.pro -spec win32-msvc CONFIG+=qtquickcompile  -tp vcr" -Verbose -NoNewWindow -Wait
Start-Process -FilePath "$env:QT_DIR\bin\qmake.exe" -ArgumentList "-makefile -o Makefile $env:PROJECT_PATH\Atalierou.pro -spec win32-g++ 'CONFIG+=qtquickcompile'" -Verbose -NoNewWindow -Wait

echo "============================================="
echo "            launch make"
echo "============================================="
# Start-Process -FilePath "nmake.exe" -ArgumentList "-f Makefile" -Verbose -NoNewWindow -Wait
Start-Process -FilePath "$env:QT_DIR\Tools\mingw1120_64\bin\mingw32-make.exe" -ArgumentList "-f Makefile qmake_all" -Verbose -NoNewWindow -Wait
Start-Process -FilePath "$env:QT_DIR\Tools\mingw1120_64\bin\mingw32-make.exe" -ArgumentList "-j4" -Verbose -NoNewWindow -Wait


Copy-Item "$env:BUILD_PATH\release\Atalierou.exe" -Destination $env:DISTRIB_PATH

echo "============================================="
echo "            launch windeployqt"
echo "============================================="
echo launch windeployqt
Start-Process -FilePath "$env:QT_DIR\bin\windeployqt" -ArgumentList "--release --qmake $env:QT_DIR\bin\qmake.exe --qmldir $env:PROJECT_PATH\qml --verbose 2 $env:DISTRIB_PATH\Atalierou.exe" -Verbose -NoNewWindow -Wait

Set-Location -Path $env:ROOT_PATH -PassThru
Get-ChildItem -Path "$env:DISTRIB_PATH"
Compress-Archive -Path $env:DISTRIB_PATH\* -DestinationPath $(".\Atalierou_" + $env:CURRENT_VERSION + "_" + $env:ARCH_NAME+ ".zip")
Get-ChildItem -Path "."
