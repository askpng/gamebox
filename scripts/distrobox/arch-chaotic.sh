#!/bin/bash

set -oue pipefail

# Init pacman keys
# sudo pacman-key --init
# sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
# sudo pacman-key --lsign-key 3056513887B78AEB
# Chaotic-AUR
sudo pacman -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
sudo pacman -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
# Append multilib to pacman.conf
sudo sed -i '87i [multilib]\nInclude = /etc/pacman.d/mirrorlist' /etc/pacman.conf
# Append Chaotic-AUR pacman.conf
# sudo sed -i '96i [chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' /etc/pacman.conf
sed -i '96i [chaotic-aur]\nSigLevel = Never\nInclude = /etc/pacman.d/chaotic-mirrorlist' /etc/pacman.conf
# pacman.conf color
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
# makepkg.conf makeflags nproc
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf
sudo pacman -Syy
# Install paru
sudo pacman -S --needed paru --noconfirm
# paru BottomUp
sudo sed -i 's/#BottomUp/BottomUp/g' /etc/paru.conf
# Install packages
paru -S --needed adw-gtk-theme atuin base-devel bat bat-extras btop cage celluloid eza fastfetch ffmpeg fish fisher glow gstreamer gstreamer-vaapi intel-media-driver libva-mesa-driver libnotify mesa mpv-mpris nano pipewire-jack python-mutagen starship tealdeer ueberzug vulkan-headers vulkan-icd-loader vulkan-intel vulkan-mesa-layers vulkan-radeon wlroots wireplumber xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk xdg-user-dirs xdg-utils xdotool xorg-xeyes xorg-xwayland yt-dlp --noconfirm
# nanorc config
sudo sed -i 's/# set autoindent/set autoindent/g; s/# set linenumbers/set linenumbers/g; s/# set magic/set magic/g; s/# set softwrap/set softwrap/g; s|# include /usr/share/nano/*.nanorc|include /usr/share/nano/*.nanorc|g' /etc/nanorc
# Install steamcmd & Vesktop
paru -S --needed steamcmd vesktop steam --noconfirm