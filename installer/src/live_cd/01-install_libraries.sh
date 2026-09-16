#!/bin/bash

dnf install -y --setopt=install_weak_deps=False cairo \
    cairo-gobject efibootmgr gdk-pixbuf2 glib2 glibc \
    gtk4 libacl libgcc libhelium libselinux openssl-libs \
    pango grub2-efi-x64-cdboot xorriso isomd5sum
