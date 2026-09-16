#!/bin/bash

dnf install -y --setopt=install_weak_deps=False --allowerasing readymade \
  libblockdev-btrfs libblockdev-lvm libblockdev-dm langpacks-core-en langpacks-fonts-en im-chooser
