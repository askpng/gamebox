#!/bin/bash

set -oue pipefail

# Clone Distrobox repository and set up executables
git clone --single-branch https://github.com/89luca89/distrobox.git /tmp/distrobox && \
    cp /tmp/distrobox/distrobox-host-exec /usr/bin/ && \
    ln -sf /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    ln -sf /usr/bin/xdg-open /usr/bin/distrobox-xdg-open && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/conmon && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman