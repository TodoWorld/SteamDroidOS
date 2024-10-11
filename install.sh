#!/usr/bin/env bash
pkg install proot-distro
rm ~/../usr/etc/proot-distro/SteamDroidOS.sh
wget -P ~/../usr/etc/proot-distro/ https://raw.githubusercontent.com/TodoWorld/SteamDroidOS/main/SteamDroidOS.sh
pd reset SteamDroidOS
pd i SteamDroidOS
