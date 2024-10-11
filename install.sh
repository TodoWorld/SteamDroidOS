#!/usr/bin/env bash
pkg install proot-distro
wget -P ~/../usr/etc/proot-distro/ https://raw.githubusercontent.com/TodoWorld/SteamDroidOS/main/SteamDroidOS.sh
pd reset SteamDroidOS
