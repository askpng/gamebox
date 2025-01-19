#!/bin/bash

set -oue pipefail

# Distrobox setup

git clone --single-branch https://github.com/89luca89/distrobox.git /tmp/distrobox && \
    cp /tmp/distrobox/distrobox-host-exec /usr/bin/ && \
    ln -sf /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    ln -sf /usr/bin/xdg-open /usr/bin/distrobox-xdg-open && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/conmon && \
    ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman

HOST_SPAWN_VERSION=$(grep -oP 'host_spawn_version="\K[^"]+' /tmp/distrobox/distrobox-host-exec)
wget -q https://github.com/1player/host-spawn/releases/download/$HOST_SPAWN_VERSION/host-spawn-$(uname -m) -O /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn

rm -rf /tmp/distrobox/distrobox

# Init pacman keys
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
# Chaotic-AUR
sudo pacman -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
sudo pacman -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
# Append Chaotic-AUR pacman.conf
sudo sed -i '96i [chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' /etc/pacman.conf
# pacman.conf color
# sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
# makepkg.conf makeflags nproc
# sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf
# Update database
sudo pacman -Syy
# Install paru
sudo pacman -S --needed paru --noconfirm
# paru BottomUp
sudo sed -i 's/#BottomUp/BottomUp/g' /etc/paru.conf
# Install packages
paru -S --needed steamcmd vesktop --noconfirm
# nanorc config
# sudo sed -i 's/# set autoindent/set autoindent/g; s/# set linenumbers/set linenumbers/g; s/# set magic/set magic/g; s/# set softwrap/set softwrap/g; s|# include /usr/share/nano/*.nanorc|include /usr/share/nano/*.nanorc|g' /etc/nanorc
# Install steamcmd & Vesktop
paru -S --needed steamcmd vesktop steam --noconfirm

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

