#!/bin/bash

set -oue pipefail

# Init pacman
pacman-key --init

# Chaotic-AUR
# pacman -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
# pacman -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm

# Append multilib to pacman.conf
sed -i '87i [multilib]\nInclude = /etc/pacman.d/mirrorlist' /etc/pacman.conf

# Append Chaotic-AUR pacman.conf
# sed -i '96i [chaotic-aur]\nSigLevel = Never\nInclude = /etc/pacman.d/chaotic-mirrorlist' /etc/pacman.conf

# Color in pacman.conf
sed -i 's/#Color/Color/g' /etc/pacman.conf

# MAKEFLAGS processor instructions
sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf

# Update pacman database
pacman -Syy

# Install paru
# pacman -S paru --noconfirm

# Exports

# Steam
# sed -i 's@ (Runtime)@@g' /usr/share/applications/steam.desktop
## Vesktop
# VESKTOP_DESKTOP_FILE="/usr/share/applications/vesktop.desktop"
# if [[ -f "$VESKTOP_DESKTOP_FILE" ]]; then
#    sed -i '/^Exec=/s/$/ --ozone-platform-hint=auto --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,WebRTCPipeWireCapturer --enable-gpu-rasterization --ignore-gpu-blocklist --enable-zero-copy/' "$VESKTOP_DESKTOP_FILE"
# fi
# Directories and exports
# distrobox-export --app steam
# mkdir -p ~/.steam
# distrobox-export --bin /usr/bin/steamcmd --export-path ~/.steam
# mv ~/.steam/steamcmd ~/.steam/steamcmd.sh