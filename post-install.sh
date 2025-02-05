#!/bin/bash

set -oue pipefail

# Chaotic AUR

sudo pacman-key --init
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
sudo pacman -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
sudo sed -i '96i [chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' /etc/pacman.conf
sudo sed -i '4s/^/# /' /etc/pacman.d/chaotic-mirrorlist
sed '2s/Name=Discord (linux-discord-rich-presence)/Name=Discord (RPC)/' /usr/share/applications/linux-discord-rich-presence.desktop
sudo pacman -Syyu --noconfirm

# Steam preps
if ! rm -drf ~/.config/steamtinkerlaunch; then
  echo "Error: Failed to remove steamtinkerlaunch files/directories"
  exit 1
fi

if ! rm -drf ~/.wine; then
  echo "Error: Failed to remove .wine files/directories"
  exit 1
fi

if ! rm -drf ~/.steam .steampath .steampid; then
  echo "Error: Failed to remove Steam files/directories"
  exit 1
fi

if ! mkdir -p ~/.steam/; then
  echo "Error: Failed to create ~/.steam/ directory"
  exit 1
fi

if ! distrobox-export --bin /usr/bin/steamcmd --export-path ~/.steam/; then
  echo "Error: Failed to export steamcmd"
  exit 1
fi

if ! mv ~/.steam/steamcmd ~/.steam/steamcmd.sh; then
  echo "Error: Failed to rename steamcmd"
  exit 1
fi

echo "Successfully purged and recreated Steam files/directories!"

# Box exports
distrobox-export --app celluloid -el none
distrobox-export --app hatt -el none
distrobox-export --app "/usr/share/applications/jdownloader.desktop" -el none
distrobox-export --app megabasterd -el none
distrobox-export --app vesktop -el none
distrobox-export --bin /usr/bin/btop
distrobox-export --bin /usr/bin/blackbox
distrobox-export --bin /usr/bin/glow
distrobox-export --bin /usr/bin/tldr
distrobox-export --bin /usr/bin/pingu
# Gamebox exports
distrobox-export --app "/usr/share/applications/linux-discord-rich-presence.desktop" -el none
distrobox-export --app steam -el none
distrobox-export --app SGDBoop -el none
distrobox-export --app lutris -el none
distrobox-export --app protonplus -el none
echo "Exports successful!"
