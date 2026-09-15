# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM quay.io/fedora/fedora-bootc:44
FROM ghcr.io/opengamingcollective/kernel-packages-fedora:latest AS ogc-kernel
COPY --from=ogc-kernel /rpms /tmp/kernel-rpms/

RUN rm /opt && mkdir /opt
RUN dnf install -y /tmp/kernel-rpms/kernel*.rpm && \
    rm -rf /tmp/kernel-rpms

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

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
