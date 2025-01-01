#!/usr/bin/env bash
pkg update -y
pkg upgrade -y
pkg install -y wget proot-distro
rm ~/../usr/etc/proot-distro/SteamDroidOS.sh
wget -P ~/../usr/etc/proot-distro/ https://raw.githubusercontent.com/TodoWorld/SteamDroidOS/main/SteamDroidOS.sh
pd reset SteamDroidOS
pd i SteamDroidOS
