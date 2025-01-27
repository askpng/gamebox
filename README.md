# box

Arch Linux distrobox created on top of [box](https://github.com/askpng/box).

Notable inclusion, not including **box** features:
- Celluloid
- Hatt and Megabasterd
- Steam, AdwGtkSteam, Lutris, SGDBoop, and steamtinkerlaunch
- Wayland-ready Vesktop and linux-discord-rich-presence

distrobox-assemble (installs gamebox & exports GUI apps):

```
distrobox-assemble create --file 'https://raw.githubusercontent.com/askpng/gamebox/refs/heads/main/gamebox.ini'
```

Follow up with

```
mkdir -p $HOME/.steam && \
    distrobox-export --bin /usr/bin/steamcmd --export-path $HOME/.steam/ && \
    mv $HOME/.steam/steamcmd %HOME/.steam/steamcmd.sh
```

For linux-discord-rich-presence, ensure to initially run:
```
linux-discord-rich-presence -c ~/.config/linux-discord-rich-presencerc && \
    disreobox-export --bin linux-discord-rich-preesence --export-path $HOME/.local/bin
```
Then, create and enable the following service on your host:
```
[Unit]
Description=Discord Rich Presence Service

[Service]
Type=simple
[Unit]
Description=Discord Rich Presence Service

[Service]
Type=simple
ExecStart=%h/.local/bin/linux-discord-rich-presence -c %h/.config/linux-discord-rich-presencerc

[Install]
WantedBy=default.target
```