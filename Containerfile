FROM ghcr.io/ublue-os/arch-distrobox AS gamebox

COPY tmp /

# Install reflector & update mirrors
RUN pacman -S reflector --noconfirm

RUN reflector --verbose --protocol https --sort rate --latest 5 --download-timeout 5 --save /etc/pacman.d/mirrorlist

# Install needed packages
RUN pacman -S \
        lib32-vulkan-radeon \
        libva-mesa-driver \
        vulkan-mesa-layers \
        lib32-vulkan-mesa-layers \
        lib32-libnm \
        openal \
        pipewire \
        pipewire-pulse \
        pipewire-alsa \
        pipewire-jack \
        wireplumber \
        lib32-pipewire \
        lib32-pipewire-jack \
        lib32-libpulse \
        lib32-openal \
        xdg-desktop-portal-gtk \
        xdg-desktop-portal-gnome \
        xdg-utils \
        nano \
        fish \
        fastfetch \
        yad \
        xdg-user-dirs \
        xdotool \
        xorg-xwininfo \
        wmctrl \
        wxwidgets-gtk3 \
        rocm-opencl-runtime \
        rocm-hip-runtime \
        libbsd \
        noto-fonts-cjk \
        glibc-locales \
        atuin \
        starship \
        --noconfirm && \
    pacman -S \
        deluge \
        steam \
        lutris \
        mangohud \
        lib32-mangohud \
        gamescope \
        goverlay \
        mesa-demos \
        vulkan-tools \
        --noconfirm && \
        wget https://raw.githubusercontent.com/Shringe/LatencyFleX-Installer/main/install.sh -O /usr/bin/latencyflex && \
        sed -i 's@"dxvk.conf"@"/usr/share/latencyflex/dxvk.conf"@g' /usr/bin/latencyflex && \
        chmod +x /usr/bin/latencyflex
        # Steam/Lutris/Wine installed separately so they use the dependencies above and don't try to install their own.

# Create build user
RUN useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install AUR packages
USER build
WORKDIR /home/build
RUN paru -S \
        aur/protontricks \
        aur/vkbasalt \
        aur/lib32-vkbasalt \
        aur/obs-vkcapture-git \
        aur/lib32-obs-vkcapture-git \
        aur/lib32-gperftools \
        aur/steamcmd \
        aur/hatt-bin \
        aur/megabasterd-bin \
        --noconfirm
USER root
WORKDIR /

# Cleanup
# Native march & tune. This is a gaming image and not something a user is going to compile things in with the intent to share.
# We do this last because it'll only apply to updates the user makes going forward. We don't want to optimize for the build host's environment.
RUN sed -i 's@ (Runtime)@@g' /usr/share/applications/steam.desktop && \
    sed -i 's/-march=x86-64 -mtune=generic/-march=native -mtune=native/g' /etc/makepkg.conf && \
    userdel -r build && \
    rm -drf /home/build && \
    sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    rm -rf \
        /tmp/* \
        /var/cache/pacman/pkg/*

# Cleanup
RUN sed -i 's/-march=x86-64 -mtune=generic/-march=native -mtune=native/g' /etc/makepkg.conf && \
    rm -rf \
        /tmp/* \
        /var/cache/pacman/pkg/*