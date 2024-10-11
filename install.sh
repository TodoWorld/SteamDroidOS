#!/usr/bin/env bash
pkg install proot-distro
wget -P ~/../usr/etc/proot-distro/ --no-cacahe https://raw.githubusercontent.com/TodoWorld/SteamDroidOS/main/SteamDroidOS.sh
pd reset SteamDroidOS
