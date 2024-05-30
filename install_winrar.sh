#!/bin/bash
echo;echo;echo "  ======================";echo "  == Winrar for Linux =="
echo "  ======================";echo "              by Seb3773";echo;echo
if [ "$EUID" -eq 0 ];then echo " > This script must not be run as root."
echo " > Please run it as normal user, elevated rights will be asked when needed. ";echo;echo " > exiting.";echo;exit;fi
echo " > This script will install Winrar on your computer."
echo " ? Proceed ? (y:yes/enter:quit) ?" && read x
if [ "$x" == "y" ] || [ "$x" == "Y" ]; then
if ! dpkg -l | grep -q winehq-stable; then
echo " > Installing wine and required components...";echo
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key >> ./setup.log 2>&1
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources >> ./setup.log 2>&1
sudo apt update >> ./setup.log 2>&1
sudo apt install -y --install-recommends winehq-stable >> ./setup.log 2>&1
fi

osarch=$(dpkg --print-architecture)
if [ "$osarch" = "amd64" ]; then
prefx=".win64";warch="win64"
setupfile="winrar-x64-623.exe"
else
prefx=".win32";warch="win32"
setupfile="winrar-x32-623.exe"
fi

if [ ! -d "$HOME/$prefx" ]; then
echo " > Creating $prefx prefixe..."
mkdir -p "$HOME/$prefx"
WINEARCH=$warch WINEPREFIX="$HOME/$prefx" winecfg /v win7
while pgrep wine > /dev/null; do sleep 1; done
sleep 2
WINEPREFIX="$HOME/$prefx" wine reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d 0x6e /f
WINEPREFIX="$HOME/$prefx" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f
WINEPREFIX="$HOME/$prefx" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingGamma /t REG_DWORD /d 0x578 /f
WINEPREFIX="$HOME/$prefx" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingOrientation /t REG_DWORD /d 1 /f
WINEPREFIX="$HOME/$prefx" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingType /t REG_DWORD /d 2 /f
fi

echo " > Installing...";echo
WINEPREFIX="$HOME/$prefx" wine "./files/$setupfile"
sudo cp -f ./files/winrar.png /usr/share/icons/hicolor/128x128/apps
sudo cp -f ./files/winrar.desktop "$HOME/.local/share/applications"
sudo cp -f ./files/winrar.sh "$HOME/$prefx"
sudo chmod +x "$HOME/$prefx/winrar.sh"
sudo sed -i "s|\$HOME|$HOME|g" "$HOME/.local/share/applications/winrar.desktop"
sudo sed -i "s|\.win64|$prefx|g" "$HOME/.local/share/applications/winrar.desktop"
sudo sed -i "s|\.win64|$prefx|g" "$HOME/$prefx/winrar.sh"
echo " > script finished.";echo;else echo " > Exited.";echo;fi
