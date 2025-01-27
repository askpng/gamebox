#!/bin/bash

set -oue pipefail

# Distrobox setup

ln -sf /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    ln -sf /usr/bin/xdg-open /usr/bin/distrobox-xdg-open && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/conmon && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman

# Directories and exports
distrobox-export --app steam
mkdir -p ~/.steam
distrobox-export --bin /usr/bin/steamcmd --export-path ~/.steam
mv ~/.steam/steamcmd ~/.steam/steamcmd.sh
distrobox-export --app vesktop
distrobox-export --app celluloid

