# FROM quay.io/toolbx/arch-toolbox AS gamebox
FROM ghcr.io/askpng/box AS gamebox

COPY scripts /tmp/scripts
             
RUN pacman -S --needed \
        glibc-locales \
        intel-media-driver \
        libbsd \
        noto-fonts-cjk \
        rust \
        wmctrl \
        wxwidgets-gtk3 \
        xorg-xwininfo \
        zenity \
        --noconfirm && \
    pacman -S --needed \
        steam \
        lutris \
        lib32-mangohud \
        mangohud \
        gamescope \
        goverlay \
        vulkan-tools \
        mesa-demos \
        --noconfirm

# Create build user
RUN useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# Install AUR packages
USER build
WORKDIR /home/build
RUN paru -S \
        aur/hatt-bin \
        aur/linux-discord-rich-presence \
        aur/steamcmd \
        aur/steamtinkerlaunch \
        aur/vesktop-bin \
        --noconfirm
USER root
WORKDIR /

COPY files /

# Clean up Steam desktop entry
RUN sed -i 's@ (Runtime)@@g' /usr/share/applications/steam.desktop && \
        sed -i '/^Exec=/s/$/ --ozone-platform-hint=auto --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,WebRTCPipeWireCapturer --enable-gpu-rasterization --ignore-gpu-blocklist --enable-zero-copy/' "/usr/share/applications/vesktop.desktop"

# Clean up any unnecessary files
RUN userdel -r build && \
        rm -drf /home/build && \
        sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
        sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
        rm -rf /home/build/.cache/* && \
        pacman -Rns $(pacman -Qdtq) --noconfirm && \
        pacman -Scc --noconfirm && \
        rm -rf \
            /tmp/* \
            /var/cache/pacman/pkg/* \
            /var/log/* \
            /root/.bash_history \
            /root/.gitconfig \
            /tmp/*