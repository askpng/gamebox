#!/bin/bash
set -oue pipefail

# Install vesktop
pacman -S --noconfirm vesktop

# Clean up temporary files and caches
rm -rf /tmp/* /var/cache/pacman/pkg/* /home/build/paru

# Remove unused dependencies and clean pacman cache
pacman -Rns $(pacman -Qdtq) --noconfirm

# Clean up pacman database and logs
pacman -Scc --noconfirm

# Clean up Steam desktop entry (if needed)
sed -i 's@ (Runtime)@@g' /usr/share/applications/steam.desktop

# Modify makepkg.conf for architecture optimization (if needed)
sed -i 's/-march=x86-64 -mtune=generic/-march=native -mtune=native/g' /etc/makepkg.conf

# Remove passwordless sudo entries for security
sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers

# Append flags to vesktop .desktop file
VESKTOP_DESKTOP_FILE="/usr/share/applications/vesktop.desktop"
if [[ -f "$VESKTOP_DESKTOP_FILE" ]]; then
    sed -i '/^Exec=/s/$/ --ozone-platform-hint=auto --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,WebRTCPipeWireCapturer --enable-gpu-rasterization --ignore-gpu-blocklist --enable-zero-copy/' "$VESKTOP_DESKTOP_FILE"
fi

# Clean up any unnecessary files
rm -rf /var/log/* /root/.bash_history /root/.gitconfig

# Clean up /tmp/scripts
rm -rf /tmp/scripts