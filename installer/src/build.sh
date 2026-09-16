#!/usr/bin/bash
set -exo pipefail
{ export PS4='+( ${BASH_SOURCE}:${LINENO} ): '; } 2>/dev/null

INSTALL_IMAGE="${INSTALL_IMAGE:-ghcr.io/why-context/inver:latest}"

# /root is a symlink on these images; make sure its target exists.
mkdir -p "$(realpath /root)"
# bwrap (flatpak/dnf scriptlets) needs /proc/sys writable during the build.
mount -o remount,rw /proc/sys || true

# Embed the image to install so the live ISO can install fully offline.
podman pull "${INSTALL_IMAGE}"

bash /src/titanboa_hook_preinitramfs.sh

dnf install -y dracut-live
kernel="$(kernel-install list --json pretty | jq -r '.[] | select(.has_kernel == true) | .version')"
DRACUT_NO_XATTR=1 dracut -v --force --zstd --reproducible --no-hostonly \
    --add "dmsquash-live dmsquash-live-autooverlay" \
    "/usr/lib/modules/${kernel}/initramfs.img" "${kernel}"

dnf install -y livesys-scripts
sed -i "s/^livesys_session=.*/livesys_session=kde/" /etc/sysconfig/livesys
systemctl enable livesys.service livesys-late.service

# dnf install -y --enable-repo=fedora-cisco-openh264 --allowerasing \
#     anaconda-live firefox libblockdev-btrfs libblockdev-lvm libblockdev-dm

# Readymade installer replaces anaconda-live
dnf install -y dnf5-plugins

for script in /src/live_cd/*.sh; do
  echo -e "\033[1;34m::\033[0m $script"
  bash "$script"
done

# UTC clock for the live session.
systemd-firstboot --timezone UTC || true
