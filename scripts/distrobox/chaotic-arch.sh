#!/bin/bash

set -oue pipefail

sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
sudo pacman -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
sudo sed -i '96i [chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' /etc/pacman.conf
sudo pacman -Syy --noconfirm
sudo pacman -S paru --noconfirm
sudo paru -S --needed \
    adwsteamgtk \
    blackbox-terminal \
    downgrade \
    morewaita-icon-theme \
    steamcmd \
    steamtinkerlaunch \
    aur/vesktop-electron \
#    aur/pingu \
#    aur/hatt-bin \
    --noconfirm