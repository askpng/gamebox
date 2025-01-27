# FROM quay.io/toolbx/arch-toolbox AS gamebox
FROM ghcr.io/askpng/box AS gamebox

COPY scripts /tmp/scripts
             
RUN pacman -S --needed \
        libbsd \
        wmctrl \
        wxwidgets-gtk3 \
        xorg-xwininfo \
        --noconfirm && \
    pacman -S --needed \
        celluloid \
        gamescope \
        goverlay \
        lutris \
        lib32-mangohud \
        mangohud \
        mesa-demos \
        steam \
        vulkan-tools \
        --noconfirm

# Create build user
RUN useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# Install AUR packages
USER build
WORKDIR /home/build
RUN paru -S \
        aur/adwsteamgtk \
        aur/hatt-bin \
        aur/linux-discord-rich-presence \
        aur/megabasterd-bin \
        aur/sgdboop-bin \
        aur/steamcmd \
        aur/steamtinkerlaunch \
        aur/vesktop-electron \
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
    rm -rf /tmp/*