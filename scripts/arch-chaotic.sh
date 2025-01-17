#!/bin/bash

set -oue pipefail

# Init pacman keys
sudo pacman-key --init
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
# Chaotic-AUR
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
# Append multilib to pacman.conf
sudo sed -i '87i [multilib]\nInclude = /etc/pacman.d/mirrorlist' /etc/pacman.conf
# Append Chaotic-AUR pacman.conf
sudo sed -i '96i [chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' /etc/pacman.conf
# pacman.conf color
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
# makepkg.conf makeflags nproc
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf
sudo pacman -Syy
# Install paru 
sudo pacman -S paru --noconfirm
# Install steamcmd & Vesktop
paru -S steamcmd vesktop --noconfirm
## Steam
sed -i 's@ (Runtime)@@g' /usr/share/applications/steam.desktop
## Vesktop
VESKTOP_DESKTOP_FILE="/usr/share/applications/vesktop.desktop"
if [[ -f "$VESKTOP_DESKTOP_FILE" ]]; then
   sed -i '/^Exec=/s/$/ --ozone-platform-hint=auto --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,WebRTCPipeWireCapturer --enable-gpu-rasterization --ignore-gpu-blocklist --enable-zero-copy/' "$VESKTOP_DESKTOP_FILE"
fi
# Directories and exports
distrobox-export --app steam
mkdir -p ~/.steam
distrobox-export --bin /usr/bin/steamcmd --export-path ~/.steam
mv ~/.steam/steamcmd ~/.steam/steamcmd.sh