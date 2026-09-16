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
dnf install -y --setopt=install_weak_deps=False --allowerasing readymade firefox \
  libblockdev-btrfs libblockdev-lvm libblockdev-dm glibc-langpack-all


# ISO builder bits + the EFI layout titanoboa's build_iso.sh expects.
dnf install -y grub2-efi-x64-cdboot xorriso isomd5sum
mkdir -p /boot/efi
cp -av /usr/lib/efi/*/*/EFI /boot/efi/ || true
cp -v /boot/efi/EFI/fedora/grubx64.efi /boot/efi/EFI/BOOT/fbx64.efi || true

# UTC clock for the live session.
systemd-firstboot --timezone UTC || true

# The live root is a small tmpfs overlay; ostree install needs room in /var/tmp.
# `|| :` because the dnf build cache is bind-mounted at /var/tmp/libdnf5 during
# this build, so the mountpoint itself can't be removed (and need not be — the
# cache mount isn't committed to the image, and var-tmp.mount overlays it at boot).
rm -rf /var/tmp || :
mkdir -p /var/tmp
cat >/etc/systemd/system/var-tmp.mount <<'EOF'
[Unit]
Description=Larger tmpfs for /var/tmp on the live system
[Mount]
What=tmpfs
Where=/var/tmp
Type=tmpfs
Options=size=50%,nr_inodes=1m
[Install]
WantedBy=local-fs.target
EOF
systemctl enable var-tmp.mount

# The ISO config titanoboa requires at this exact path.
mkdir -p /usr/lib/bootc-image-builder
cp /src/iso.yaml /usr/lib/bootc-image-builder/iso.yaml
cp /src/readymade.toml /etc/readymade.toml

dnf clean all || true
