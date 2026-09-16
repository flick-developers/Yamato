#!/bin/bash

mkdir -p /boot/efi
mkdir -p /usr/lib/bootc-image-builder
mkdir -p /etc/bootcwholedisk
mkdir -p /etc/wholedisk

cp -av /usr/lib/efi/*/*/EFI /boot/efi/ || true
cp -v /boot/efi/EFI/fedora/grubx64.efi /boot/efi/EFI/BOOT/fbx64.efi || true
cp /src/iso.yaml /usr/lib/bootc-image-builder/iso.yaml
cp /src/readymade.toml /etc/readymade.toml
cp -r /src/wholedisk /etc/bootcwholedisk/
cp -r /src/wholedisk /etc/wholedisk/
