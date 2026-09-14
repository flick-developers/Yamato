#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# SETUP REPOS
sed -i 's/^enabled=0/enabled=1/' /etc/yum.repos.d/terra.repo
sed -i 's/^enabled=0/enabled=1/' /etc/yum.repos.d/terra-extras.repo
dnf5 install terra-release-mesa terra-release-nvidia 
dnf5 remove -y waydroid waydroid-selinux lutris qemu qemu-* spice-server akonadi-server

# INSTALL
dnf5 install -y tuned tuned-ppd terra-release terra-gpg-keys --skip-unavailable

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
