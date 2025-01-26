# FROM quay.io/toolbx/arch-toolbox AS gamebox
FROM ghcr.io/ublue-os/arch-distrobox AS gamebox

COPY scripts /tmp/scripts

# Pacman init
RUN pacman-key --init

# Append multilib to pacman.conf
# RUN sed -i '87i [multilib]\nInclude = /etc/pacman.d/mirrorlist' /etc/pacman.conf

# Update pacman database
RUN pacman -Syy

# Install packages
RUN pacman -S --needed \
        git \
        base-devel \
        --noconfirm
             
RUN pacman -S --needed \
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
        libnotify \
        xdg-desktop-portal-gtk \
        xdg-desktop-portal-gnome \
        xdg-user-dirs \
        xdg-utils \
        nano \
        fish \
        fastfetch \
        yad \
        xorg-xeyes \
        xdotool \
        xorg-xwininfo \
        wmctrl \
        wxwidgets-gtk3 \
        libbsd \
        noto-fonts-cjk \
        glibc-locales \
        atuin \
        starship \
        tealdeer \
        rust \
        zenity \
        electron \
        --noconfirm && \
    pacman -S --needed \
        mesa \
        vulkan-intel \
        intel-media-driver \
        vulkan-radeon \
        vulkan-tools \
        mesa-demos \
        --noconfirm && \
    pacman -S --needed \
        steam \
        lutris \
        mangohud \
        lib32-mangohud \
        gamescope \
        goverlay \
        --noconfirm

# Pacman & nano configs
RUN sed -i 's/#Color/Color/g' /etc/pacman.conf && \
        sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf && \
        sudo sed -i 's/# set autoindent/set autoindent/g; s/# set linenumbers/set linenumbers/g; s/# set magic/set magic/g; s/# set softwrap/set softwrap/g; s|# include /usr/share/nano/*.nanorc|include /usr/share/nano/*.nanorc|g' /etc/nanorc

# Create build user
RUN useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install AUR packages
USER build
WORKDIR /home/build
RUN paru -S \
        aur/steamcmd \
        aur/linux-discord-rich-presence \
        aur/vesktop-bin \
        aur/hatt-bin \
        --noconfirm

# Clean up temporary files and caches
# RUN rm -rf /tmp/* /var/cache/pacman/pkg/* && \
#         pacman -Rns $(pacman -Qdtq) --noconfirm && \
#         pacman -Scc --noconfirm

# Clean up Steam desktop entry
RUN sed -i 's@ (Runtime)@@g' /usr/share/applications/steam.desktop

# Modify makepkg.conf for architecture optimization

COPY files /

# Clean up any unnecessary files
RUN sed -i 's/-march=x86-64 -mtune=generic/-march=native -mtune=native/g' /etc/makepkg.conf && \
        userdel -r build && \
        rm -drf /home/build && \
        sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
        sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
        rm -rf /home/build/.cache/* && \
        rm -rf \
            /tmp/* \
            /var/cache/pacman/pkg/* \
            /var/log/* \
            /root/.bash_history \
            /root/.gitconfig \
            /tmp/*