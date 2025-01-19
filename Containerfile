FROM quay.io/toolbx/arch-toolbox AS gamebox

COPY scripts /tmp/scripts

# Pacman init
RUN pacman-key --init

# Append multilib to pacman.conf
RUN sed -i '87i [multilib]\nInclude = /etc/pacman.d/mirrorlist' /etc/pacman.conf

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
        --noconfirm && \
        wget https://raw.githubusercontent.com/Shringe/LatencyFleX-Installer/main/install.sh -O /usr/bin/latencyflex && \
        sed -i 's@"dxvk.conf"@"/usr/share/latencyflex/dxvk.conf"@g' /usr/bin/latencyflex && \
        chmod +x /usr/bin/latencyflex

# Pacman & nano configs
RUN sed -i 's/#Color/Color/g' /etc/pacman.conf && \
        sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf && \
        sudo sed -i 's/# set autoindent/set autoindent/g; s/# set linenumbers/set linenumbers/g; s/# set magic/set magic/g; s/# set softwrap/set softwrap/g; s|# include /usr/share/nano/*.nanorc|include /usr/share/nano/*.nanorc|g' /etc/nanorc

# Clean up temporary files and caches
# RUN rm -rf /tmp/* /var/cache/pacman/pkg/* && \
#         pacman -Rns $(pacman -Qdtq) --noconfirm && \
#         pacman -Scc --noconfirm

# Clean up Steam desktop entry
RUN sed -i 's@ (Runtime)@@g' /usr/share/applications/steam.desktop

# Modify makepkg.conf for architecture optimization
RUN sed -i 's/-march=x86-64 -mtune=generic/-march=native -mtune=native/g' /etc/makepkg.conf

COPY files /

# Clean up any unnecessary files
RUN rm -rf /var/log/* /root/.bash_history /root/.gitconfig /tmp/*
