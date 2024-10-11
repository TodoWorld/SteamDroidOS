# This is a default distribution plug-in.
# Do not modify this file as your changes will be overwritten on next update.
# If you want customize installation, please make a copy.
DISTRO_NAME="SteamDroid OS"
DISTRO_COMMENT="Stable release."

TARBALL_URL['aarch64']="http://downloads.raspberrypi.org/raspbian_lite/root.tar.xz"
TARBALL_SHA256['aarch64']="e8fd091305558e1f8c1ff44c905e28618cac159afbaa9513420427fe98362256"

distro_setup() {
        # Configure en_US.UTF-8 locale.
        sed -i -E 's/#[[:space:]]?(en_US.UTF-8[[:space:]]+UTF-8)/\1/g' ./etc/locale.gen
        run_proot_cmd DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
        # Set default shell to bash.
	run_proot_cmd usermod --shell /bin/bash root
	# Fix issue where come CA certificates links may not be created.
	run_proot_cmd update-ca-certificates --fresh
}

