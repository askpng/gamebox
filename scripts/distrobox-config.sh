#!/bin/bash


set -oue pipefail

# Clone Distrobox repository and set up executables
git clone --single-branch https://github.com/89luca89/distrobox.git /tmp/distrobox && \
    cp /tmp/distrobox/distrobox-host-exec /usr/bin/ && \
    ln -sf /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    ln -sf /usr/bin/xdg-open /usr/bin/distrobox-xdg-open

# Download and set up host-spawn
HOST_SPAWN_VERSION=$(grep -oP 'host_spawn_version="\K[^"]+' /tmp/distrobox/distrobox-host-exec)
wget -q https://github.com/1player/host-spawn/releases/download/$HOST_SPAWN_VERSION/host-spawn-$(uname -m) -O /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn

# Clean up
rm -rf /tmp/distrobox
