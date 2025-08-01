
if ($null -eq $env:QT_DIR) {
    echo QT_DIR is NOT defined, used default value
    
    $env:QT_DIR = ..\Qt\6.9.1\gcc_64
}
$env:QT_DIR=[System.IO.Path]::GetFullPath($env:QT_DIR)
echo QT_DIR $Env:QT_DIR
$env:Qt6_DIR=$Env:QT_DIR

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

# Set-Location -Path $env:PROJECT_PATH -PassThru

$env:PATH="$env:QT_DIR\bin\;$env:PATH"

echo "============================================="
echo "           display path"
echo "============================================="
echo PATH $env:PATH

echo "============================================="
echo "            launch cmake"
echo "============================================="
Start-Process -FilePath "qt-cmake.bat" -ArgumentList "-S $env:PROJECT_PATH -B $env:BUILD_PATH" -Verbose -NoNewWindow -Wait
Start-Process -FilePath "cmake" -ArgumentList "--build $env:BUILD_PATH" -Verbose -NoNewWindow -Wait


Get-ChildItem -Path "$env:BUILD_PATH\x64"
Copy-Item "$env:BUILD_PATH\x64\Atalierou.exe" -Destination $env:DISTRIB_PATH

echo "============================================="
echo "            launch windeployqt"
echo "============================================="
echo launch windeployqt
Start-Process -FilePath "windeployqt" -ArgumentList "--release --qmake $env:QT_DIR\bin\qmake.exe --qmldir $env:PROJECT_PATH\qml --verbose 2 $env:DISTRIB_PATH\Atalierou.exe" -Verbose -NoNewWindow -Wait

Set-Location -Path $env:ROOT_PATH -PassThru
Get-ChildItem -Path "$env:DISTRIB_PATH"
Compress-Archive -Path $env:DISTRIB_PATH\* -DestinationPath $(".\Atalierou_" + $env:CURRENT_VERSION + "_" + $env:ARCH_NAME+ ".zip")
Get-ChildItem -Path "."
