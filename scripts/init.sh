#!/bin/bash


set -oue pipefail

# Update pacman configuration and install essential packages
sed -i 's/#Color/Color/g' /etc/pacman.conf && \
    printf "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" | tee -a /etc/pacman.conf && \
    sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf

# Initialize pacman keyring and populate with Arch Linux keys
pacman-key --init && pacman-key --populate archlinux

# Install Chaotic-AUR keyring and mirrorlist
curl -fsSL https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst -o /tmp/chaotic-keyring.pkg.tar.zst && \
    pacman -U --noconfirm /tmp/chaotic-keyring.pkg.tar.zst && \
    curl -fsSL https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst -o /tmp/chaotic-mirrorlist.pkg.tar.zst && \
    pacman -U --noconfirm /tmp/chaotic-mirrorlist.pkg.tar.zst && \
    rm -f /tmp/chaotic-keyring.pkg.tar.zst /tmp/chaotic-mirrorlist.pkg.tar.zst

# Initialize and populate pacman keyring with Chaotic-AUR keys
pacman-key --populate chaotic-aur

# Add Chaotic-AUR repository to pacman.conf with signature checking enabled
echo -e "[chaotic-aur]\nSigLevel = Required DatabaseOptional\nServer = https://mirror.rackspace.com/chaotic-aur/\$arch" >> /etc/pacman.conf

# Add user and configure sudo permissions
useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
