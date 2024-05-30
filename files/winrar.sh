#!/bin/bash
if [ -n "$1" ]; then
WINEPREFIX="$HOME/.win64" wine "$HOME/.win64/drive_c/Program Files/WinRAR/WinRAR.exe" "$(winepath -w "$1")" </dev/null >/dev/null 2>&1
else
WINEPREFIX="$HOME/.win64" wine "$HOME/.win64/drive_c/Program Files/WinRAR/WinRAR.exe" </dev/null >/dev/null 2>&1
fi