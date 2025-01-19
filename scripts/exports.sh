#!/bin/bash

set -oue pipefail

## Steam
sudo sed -i 's@ (Runtime)@@g' /usr/share/applications/steam.desktop
## Vesktop
VESKTOP_DESKTOP_FILE="/usr/share/applications/vesktop.desktop"
if [[ -f "$VESKTOP_DESKTOP_FILE" ]]; then
   sudo sed -i '/^Exec=/s/$/ --ozone-platform-hint=auto --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,WebRTCPipeWireCapturer --enable-gpu-rasterization --ignore-gpu-blocklist --enable-zero-copy/' "$VESKTOP_DESKTOP_FILE"
fi
# Directories and exports
distrobox-export --app steam
mkdir -p ~/.steam
distrobox-export --bin /usr/bin/steamcmd --export-path ~/.steam
mv ~/.steam/steamcmd ~/.steam/steamcmd.sh
distrobox-export --app vesktop
distrobox-export --app celluloid
