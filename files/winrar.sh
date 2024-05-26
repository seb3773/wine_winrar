#!/bin/bash
WINEPREFIX="$HOME/.win64" wine "$HOME/.win64/drive_c/Program Files/WinRAR/WinRAR.exe" "$(winepath -w "$1")" </dev/null >/dev/null 2>&1