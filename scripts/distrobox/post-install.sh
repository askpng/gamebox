#!/bin/bash

set -oue pipefail

# Steam preps

if ! rm -drf ~/.config/steamtinkerlaunch; then
  echo "Error: Failed to remove steamtinkerlaunch files/directories"
  exit 1
fi

if ! rm -drf ~/.wine; then
  echo "Error: Failed to remove .wine files/directories"
  exit 1
fi

if ! rm -drf ~/.steam .steampath .steampid; then
  echo "Error: Failed to remove Steam files/directories"
  exit 1
fi

if ! mkdir -p ~/.steam/; then
  echo "Error: Failed to create ~/.steam/ directory"
  exit 1
fi

if ! distrobox-export --bin /usr/bin/steamcmd --export-path ~/.steam/; then
  echo "Error: Failed to export steamcmd"
  exit 1
fi

if ! mv ~/.steam/steamcmd ~/.steam/steamcmd.sh; then
  echo "Error: Failed to rename steamcmd"
  exit 1
fi

echo "Successfully purged and recreated Steam files/directories!"

# Exports

distrobox-export --app blackbox

distrobox-export --app celluloid

distrobox-export --app hatt

distrobox-export --app lutris

distrobox-export --app megabasterd

distrobox-export --app "steam"

distrobox-export --app vesktop

distrobox-export --app SGDBoop

distrobox-export --app protonplus

distrobox-export --bin /bin/glow --export-path $HOME/.local/bin

distrobox-export --bin /bin/tldr --export-path $HOME/.local/bin

distrobox-export --bin /bin/pingu --export-path $HOME/.local/bin

distrobox-export --bin /bin/eza --export-path $HOME/.local/bin