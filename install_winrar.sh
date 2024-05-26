#!/bin/bash
echo;echo;echo "  ======================";echo "  == Winrar for Linux =="
echo "  ======================";echo "              by Seb3773";echo;echo
if [ "$EUID" -eq 0 ];then echo " > This script must not be run as root."
echo " > Please run it as normal user, elevated rights will be asked when needed. ";echo;echo " > exiting.";echo;exit;fi
echo " > This script will install Winrar x64 on your computer."
echo " ? Proceed ? (y:yes/enter:quit) ?" && read x
if [ "$x" == "y" ] || [ "$x" == "Y" ]; then
if ! dpkg -l | grep -q winehq-stable; then
echo " > Installing wine and required components...";echo
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key >> ./setup.log 2>&1
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources >> ./setup.log 2>&1
sudo apt update >> ./setup.log 2>&1
sudo apt install -y --install-recommends winehq-stable >> ./setup.log 2>&1
fi
if [ ! -d "$HOME/.win64" ]; then
echo " > Creating .win64 prefixe..."
mkdir -p "$HOME/.win64"
WINEARCH=win64 WINEPREFIX="$HOME/.win64" winecfg /v win7
while pgrep wine > /dev/null; do sleep 1; done
sleep 2
WINEPREFIX="$HOME/.win64" wine reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d 0x6e /f
WINEPREFIX="$HOME/.win64" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f
WINEPREFIX="$HOME/.win64" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingGamma /t REG_DWORD /d 0x578 /f
WINEPREFIX="$HOME/.win64" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingOrientation /t REG_DWORD /d 1 /f
WINEPREFIX="$HOME/.win64" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingType /t REG_DWORD /d 2 /f
fi
echo " > Installing...";echo
WINEPREFIX="$HOME/.win64" wine "./files/winrar-x64-623.exe"
sudo cp -f ./files/winrar.png /usr/share/icons/hicolor/128x128/apps
sudo cp -f ./files/winrar.desktop "$HOME/.local/share/applications"
sudo cp -f ./files/winrar.sh "$HOME/.win64"
sudo chmod +x "$HOME/.win64/winrar.sh"
sudo sed -i "s|\$HOME|$HOME|g" "$HOME/.local/share/applications/winrar.desktop"

echo " > script finished.";echo;else echo " > Exited.";echo;fi
