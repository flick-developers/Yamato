# Stage 1: Downloads the OGC kernel and installs them directly
FROM quay.io/fedora/fedora:44 AS staging

# Install the ORAS CLI (available natively in Fedora repos)
RUN dnf install -y golang-oras

# Create a staging folder and pull the OCI artifact
WORKDIR /kernel-rpms
RUN oras pull ghcr.io/opengamingcollective/kernel-packages-fedora:latest-fc44

# Stage 2: Actual Build Implementation
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM quay.io/fedora/fedora-bootc:44

RUN rm -rf /opt && mkdir /opt
COPY --from=staging /kernel-rpms /tmp/kernel-rpms
RUN dnf install -y --setopt=install_weak_deps=False /tmp/kernel-rpms/kernel*.rpm && \
    rm -rf /tmp/kernel-rpms

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.
RUN dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
RUN dnf install -y --setopt=install_weak_deps=False \
                    plasma-desktop \
                    plasma-workspace-wayland \
                    sddm \
                    sddm-wayland-plasma \
                    plasma-nm \
                    plasma-pa \
                    plasma-systemmonitor \
                    powerdevil \
                    bluedevil \
                    dolphin \
                    konsole \
                    wireplumber \
                    pipewire \
                    pipewire-pulse \
                    pipewire-alsa \
                    pipewire-utils \
                    bootupd \
                    grub2-efi-x64 \
                    grub2-efi-x64-cdboot \
                    grub2-tools \
                    grub2-tools-minimal \
                    shim-x64 \
                    plymouth \
                    plymouth-plugin-two-step \
                    plymouth-system-theme \
                    plymouth-plugin-label\
                    iwd \
                    NetworkManager-wifi \
                    libglvnd-gles \
                    os-prober

RUN plymouth-set-default-theme bgrt
RUN echo 'add_dracutmodules+=" plymouth "' > /etc/dracut.conf.d/plymouth.conf
RUN systemctl enable sddm.service systemd-resolved.service
RUN systemctl --global enable pipewire.socket wireplumber.service pipewire-pulse.socket
RUN systemctl set-default graphical.target

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    /ctx/dracut.sh && \
    /ctx/housekeeper.sh && \
    ostree container commit && \
    bootc container lint

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
