# This is a default distribution plug-in.
# Do not modify this file as your changes will be overwritten on next update.
# If you want customize installation, please make a copy.
DISTRO_NAME="SteamDroid OS"
DISTRO_COMMENT="Stable release."

TARBALL_URL['aarch64']="https://downloads.raspberrypi.org/raspios_lite_arm64/root.tar.xz"
TARBALL_SHA256['aarch64']="db1b538171f40bc5f8980e3ce8153cf840627351e9c5dc2e5862f1284bc36c4b"
#TARBALL_URL['aarch64']="http://downloads.raspberrypi.org/raspbian_lite/root.tar.xz"
#TARBALL_SHA256['aarch64']="e8fd091305558e1f8c1ff44c905e28618cac159afbaa9513420427fe98362256"
#TARBALL_URL['aarch64']="https://github.com/termux/proot-distro/releases/download/v4.11.0/ubuntu-noble-aarch64-pd-v4.11.0.tar.xz"
#TARBALL_SHA256['aarch64']="a8883244a7031559a2bd8dc16b7d8afc947930b611819d8a28a09545097a6ba5"
#TARBALL_URL['arm']="https://github.com/termux/proot-distro/releases/download/v4.11.0/ubuntu-noble-arm-pd-v4.11.0.tar.xz"
#TARBALL_SHA256['arm']="dc5478e96f648e868d68c15c400338460088255d5d964bdfa33e5456ceea54ae"

distro_setup() {
        # Configure en_US.UTF-8 locale.
        sed -i -E 's/#[[:space:]]?(en_US.UTF-8[[:space:]]+UTF-8)/\1/g' ./etc/locale.gen
        run_proot_cmd DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
        # Fix issue where come CA certificates links may not be created.
        run_proot_cmd apt update -y
#       run_proot_cmd apt full-upgrade -y
        run_proot_cmd apt install git wget fish sudo software-properties-common build-essential mono-runtime cmake libgtk2.0-0 gstreamer1.0-tools libgstreamer1.0-0 libice6 libsm6 kde-standard dbus-x11 tigervnc-standalone-server tigervnc-xorg-extension -y #xfce4
        echo "Install Steam"
        #run_proot_cmd wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb
        #run_proot_cmd apt install ./steam.deb -y
        echo "Enable ARMHF i386 AMD64 Lib"
        #run_proot_cmd dpkg --add-architecture armhf 
        #run_proot_cmd dpkg --add-architecture i386
        #run_proot_cmd dpkg --add-architecture amd64
        #run_proot_cmd apt update -y
        echo "Install BOX64"
        run_proot_cmd git clone https://github.com/ptitSeb/box64 #efd103004c770e8ec4646c11c24b92a5d8d49e54
        run_proot_cmd mkdir box64/build
        run_proot_cmd cmake -DBOX32=1 -DBOX32_BINFMT=1 -STEAMOS=1 -DARM_DYNAREC=1 -DBAD_SIGNAL=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBOX64_DEBUG=1 -DBOX64_USE_DYNAREC=1 -DBOX64_USE_FFMPEG=1 -DBOX64_ENABLE_VULKAN=1 -B box64/build -S box64 #-DCMAKE_BUILD_TYPE=Release
        run_proot_cmd make -C box64/build/ install
#       run_proot_cmd box64/install_steam.sh
        echo "Init User"
        run_proot_cmd sed -i '/^# User privilege specification/a steamdroidos ALL=(ALL:ALL) ALL' /etc/sudoers
        run_proot_cmd adduser --gecos '' --disabled-password steamdroidos
        run_proot_cmd passwd -d steamdroidos
        echo "Install pi-apps"
#       run_proot_cmd su - steamdroidos -c "git clone https://github.com/Botspot/pi-apps"
#       run_proot_cmd su - steamdroidos -c "pi-apps/install"
#       run_proot_cmd su - steamdroidos -c "~/pi-apps/manage install Steam"

#       run_proot_cmd su - steamdroidos -c "wget -qO- https://raw.githubusercontent.com/Botspot/pi-apps/master/install | bash;exit"
#       run_proot_cmd setpriv --reuid=steamdroidos wget -qO- https://raw.githubusercontent.com/Botspot/pi-apps/master/install | bash
#       run_proot_cmd curl --silent https://raw.githubusercontent.com/FEX-Emu/FEX/main/Scripts/InstallFEX.py --output /tmp/InstallFEX.py
#       run_proot_cmd python3 /tmp/InstallFEX.py
#       run_proot_cmd rm /tmp/InstallFEX.py
#       run_proot_cmd su - steamdroidos -c "curl -L https://raw.githubusercontent.com/Botspot/pi-apps/master/install | sh"
#       run_proot_cmd su - steamdroidos -c "~/pi-apps/manage install Steam"
        echo "Init VNC"
        run_proot_cmd su - steamdroidos -c "printf \"steamdroidos\nsteamdroidos\n\n\" | vncpasswd"
        run_proot_cmd su - steamdroidos -c "echo -e \"#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADRESS\n\n# 啟動PulseAudio音效伺服器，音訊會從Termux傳出來\nexport PULSE_SERVER=127.0.0.1 && pulseaudio --start --disable-shm=1 --exit-idle-time=-1\n\n# 執行桌面環境，此處為XFCE\nexec startplasma-x11\" >> ~/.vnc/xstartup" #startxfce4
        run_proot_cmd su - steamdroidos -c "chmod +x ~/.vnc/xstartup"
        run_proot_cmd su - steamdroidos -c "echo -e \"# 目前的工作階段XFCE\nsession=xfce\n# 解析度，越高佔用頻寬越多\ngeometry=2560x1080\n# 位元深度，數值為8/16/24/32，數字越大畫面越好但越耗頻寬\ndepth=32\n# 讓外部網路可以連線\nlocalhost=no\" >> ~/.vnc/config"
        run_proot_cmd su - steamdroidos -c "echo \"tigervncserver\" >> ~/.profile"
        echo "Set default shell to fish."
        run_proot_cmd usermod --shell /bin/fish root
        run_proot_cmd usermod --shell /bin/fish steamdroidos

#       run_proot_cmd su - steamdroidos
}






