FROM quay.io/toolbx/arch-toolbox AS gamebox

COPY scripts /tmp/scripts

# Pacman init & build user
RUN bash /tmp/scripts/init.sh

# Install yq
# RUN pacman -S git base-devel yq --noconfirm

# Install packages
# COPY packages /tmp/packages

# Install packages from YAML files
#RUN for file in /tmp/packages/*.yml; do \
#        packages=$(yq eval '.packages | join(" ")' "$file"); \
#        pacman -S --needed $packages --noconfirm; \
#    done

# Install packages via packages.sh
RUN bash /tmp/scripts/packages.sh

COPY files /

# Distrobox config
RUN bash /tmp/scripts/distrobox/distrobox-config.sh

# Cleanup
RUN bash /tmp/scripts/cleanup.sh
