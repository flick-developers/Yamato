#!/bin/bash

dnf install -y --setopt=install_weak_deps=False --allowerasing readymade-git \
  libblockdev-btrfs libblockdev-lvm libblockdev-dm langpacks-core-en langpacks-fonts-en im-chooser

rm -f /usr/share/applications/liveinst.desktop
sed -i '/NoDisplay=.*/d' /usr/share/applications/com.fyralabs.Readymade.desktop
cp -f /usr/share/applications/com.fyralabs.Readymade.desktop /etc/xdg/autostart
