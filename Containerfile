FROM quay.io/toolbx/arch-toolbox AS gamebox

COPY scripts /tmp/scripts

# Pacman init & build user
RUN bash /tmp/scripts/init.sh

# Install needed packages
RUN pacman -S --needed \
        git \
        base-devel \
        --noconfirm
        
RUN pacman -S \
        lib32-vulkan-radeon \
        libva-mesa-driver \
        intel-media-driver \
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
        xdg-user-dirs \
        xdg-utils \
        nano \
        fish \
        fastfetch \
        yad \
        xeyes \
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
        mesa \
        vulkan-intel \
        intel-media-driver \
        vulkan-radeon \
        vulkan-tools \
        mesa-demos \
        --noconfirm && \
    pacman -S \
        steam \
        lutris \
        # Steam/Lutris installed separately so they use the dependencies above and don't try to install their own.
        mangohud \
        lib32-mangohud \
        gamescope \
        goverlay \
        --noconfirm && \
        wget https://raw.githubusercontent.com/Shringe/LatencyFleX-Installer/main/install.sh -O /usr/bin/latencyflex && \
        sed -i 's@"dxvk.conf"@"/usr/share/latencyflex/dxvk.conf"@g' /usr/bin/latencyflex && \
        chmod +x /usr/bin/latencyflex
    pacman -S \
        paru \
        protontricks \
        vkbasalt \
        lib32-vkbasalt \
        obs-vkcapture-git \
        lib32-obs-vkcapture-git \
        lib32-gperftools \
        steamcmd \
        vesktop \
        --noconfirm

COPY files /

# Cleanup
RUN bash /tmp/scripts/cleanup.sh
