# NixOS config for `tear` and `laila`

One flake, one user (`juevigrace`), one shared configuration. Only the
per-host files differ.

## Layout

```
flake.nix                         # inputs + the two hosts
hosts/tear/                       # desktop: hostname, GPU, hardware config
hosts/laila/                      # laptop: hostname, GPU, hardware config
modules/nixos/
  default.nix                     # imports the shared modules below
  nixpkgs.nix                     # stable/unstable overlay, allowUnfree
  common.nix                      # boot, network, user, SSH server, locale
  packages.nix                    # system-wide packages
  services.nix                    # extra system services
  desktop.nix                     # Niri, greetd, audio, Bluetooth, fonts
modules/home-manager/
  common.nix                      # packages, git, SSH client
  programs.nix                    # shell/tools
  desktop.nix                     # bar, notifications, launcher, idle, lock
  files.nix                       # links the real config files into ~/.config
  files/
    niri/config.kdl               # Niri keybinds and layout
    waybar/config.json            # Waybar modules
    waybar/style.css              # Waybar colours
    mako/config                   # notification appearance
    fuzzel/fuzzel.ini             # launcher appearance
    swaylock/config               # lock screen appearance
home/juevigrace.nix               # wires the shared home modules together
scripts/rebuild                   # switch the current host
scripts/update                    # nix flake update
scripts/install.sh                # install either host on a chosen disk
```

## Stable and unstable side by side

- Default package set: **stable** (`nixos-26.05`). Use `pkgs.firefox`.
- Unstable package set: same system, one package at a time. Use
  `pkgs.unstable.firefox`.
- The unstable set gets the same `allowUnfree` and nixpkgs config, but it is
  kept separate from stable so the two cannot break each other.

To move the **whole system** to unstable, change both URLs in `flake.nix`
(`nixos-unstable` and home-manager `master`), then run `./scripts/update`.

## Desktop

Both hosts use the same Niri desktop:

- **Login manager:** greetd + tuigreet. The session command is
  `${pkgs.niri}/bin/niri-session`.
- **Compositor:** Niri, with the GTK file chooser (`useNautilus = false`).
- **Terminal:** Ghostty (`Mod+T`).
- **Launcher:** fuzzel (`Mod+D`).
- **Bar:** Waybar with the native `niri/workspaces` and `niri/window` modules.
- **Notifications:** mako. **Lock:** swaylock (`Super+Alt+L`). **Idle:** swayidle.
- **Wallpaper:** Waypaper (`Mod+Shift+W`), using the `swaybg` backend. It
  restores the last wallpaper at login.
- **Audio:** PipeWire + WirePlumber. `pwvucontrol` is the GUI mixer and
  `wiremix` is the TUI; open Wiremix with `Mod+Shift+A` to select the rear or
  front microphone port. Clicking the volume module in Waybar opens
  `pwvucontrol`.
- **Network:** NetworkManager is enabled in `modules/nixos/common.nix`. The
  Waybar network module opens `nm-connection-editor`; `nm-applet` and
  `blueman-applet` are also running.
- **X11 apps:** `xwayland-satellite`, not `programs.xwayland`.
- **Fonts:** Noto (including CJK and emoji), DejaVu, Liberation, Unifont,
  Cantarell, Inter, Roboto, Font Awesome, Material Icons, and Nerd Fonts.

### Configuration files

The real config files live in `modules/home-manager/files/` and are linked
into `~/.config` as **live** links with
`config.lib.file.mkOutOfStoreSymlink`. Editing either path edits the tracked
file; a rebuild is only needed for package/service changes. If you move the
repo out of `~/Projects/nixos`, update the `liveConfig` path in
`modules/home-manager/files.nix`.

Useful reloads after editing:

```sh
niri validate -c ~/.config/niri/config.kdl
pkill -USR2 waybar
makoctl reload
```

The Niri config is validated by `niri validate`. `~/.config/nvim` is still a
separate manual clone and is not managed here.

### GPU

- `tear`: NVIDIA open kernel modules with modesetting (`hosts/tear/default.nix`).
- `laila`: Intel graphics for the desktop plus NVIDIA PRIME offload. Run a
  single application on the NVIDIA GPU with:
  ```sh
  nvidia-offload <command>
  ```

### Wallpaper and system colours

Aether is an Omarchy-specific tool, not a nixpkgs package, so it cannot simply
be installed here. Waypaper can still use the Aether wallpaper: pick it once
from the Waypaper window, and `spawn-at-startup "waypaper" "--restore"` will
restore it on later logins. Waypaper keeps its own config/state under
`~/.config/waypaper/`; that state is intentionally not managed by Nix.

The current Waybar/mako/fuzzel/swaylock colours are a static Catppuccin-like
palette. For colours that follow the wallpaper, the practical options are:

1. **Stylix** — the Nix-native choice. Add the Stylix flake input and modules,
   give it a base16 scheme or wallpaper, and it themes Waybar, mako, fuzzel,
   Ghostty, swaylock, and GTK. It has no Niri target, so Niri's focus-ring
   colours stay in `niri/config.kdl`.
2. **Matugen** — Material You colours generated from the current wallpaper.
   Set Waypaper's post-command to run `matugen image <wallpaper>` and use
   Matugen templates for the apps you care about. More moving parts, but the
   closest match to Aether's per-wallpaper behaviour.
3. **Wallust** — similar to Matugen, with a simpler template system.
4. **Static theme** — keep the current files and change the hex values by
   hand, or switch to a packaged theme such as Catppuccin/Nord.

Stylix is the best fit if you want everything declarative; Matugen or Wallust
is better if you want colours to change every time you pick a wallpaper.


## First install

Back up `~/.ssh` first. The private keys cannot be stored in this repo.

The install script is meant to run from the NixOS installer. It erases the
whole target disk, creates the Btrfs layout, copies this repo to
`/home/juevigrace/Projects/nixos`, replaces the host's placeholder hardware
file, and installs the flake.

This flake targets NixOS 26.05. If your installer is a different release,
update the flake inputs and both `stateVersion` values before installing.

```sh
# tear, /dev/sda
sudo ./scripts/install.sh tear /dev/sda

# laila, actual laptop disk
sudo ./scripts/install.sh laila /dev/nvme0n1

# use a repo from somewhere other than the one containing the script
sudo ./scripts/install.sh tear /dev/sda /path/to/nixos
```

The script asks you to type `WIPE` before it touches the disk. The shared
layout is:

| Partition | Size | Use |
|---|---|---|
| `...1` | 1 GiB | FAT32 ESP, mounted at `/boot` |
| `...2` | rest | Btrfs, mounted at `/` |

Btrfs subvolumes: `@`, `@home`, `@nix`, `@log`, `@snapshots`. There is no swap
partition; `zramSwap` is enabled.

`nixos-install` will ask for a **root** password. After it finishes, the
script runs `nixos-enter --root /mnt -c 'passwd juevigrace'` so you set the
`juevigrace` password before rebooting. There is no plaintext initial password
in the config.

### User password

No initial password is configured. Set it during installation when the script
prompts, or later with:

```sh
passwd
```

### Recover an existing install without wiping

First try a local TTY: press `Ctrl+Alt+F2`, log in as `root` with the password
you set during `nixos-install`, then run:

```sh
passwd juevigrace
```

If the root password was mistyped or does not work, boot the NixOS installer,
mount the existing subvolumes, and reset both passwords. Replace `/dev/sda2`
and `/dev/sda1` with laila's devices if needed.

```sh
sudo mount -o subvol=@ /dev/sda2 /mnt
sudo mkdir -p /mnt/{home,nix,var/log,.snapshots,boot}
sudo mount -o subvol=@home /dev/sda2 /mnt/home
sudo mount -o subvol=@nix /dev/sda2 /mnt/nix
sudo mount -o subvol=@log /dev/sda2 /mnt/var/log
sudo mount -o subvol=@snapshots /dev/sda2 /mnt/.snapshots
sudo mount /dev/sda1 /mnt/boot

sudo nixos-enter --root /mnt -c 'passwd juevigrace'
sudo nixos-enter --root /mnt -c 'passwd root'

sync
sudo umount -R /mnt
```

Reboot and log in normally. No reinstall is needed.

### Booting

`systemd-boot` is installed on the new ESP. Omarchy on `/dev/nvme0n1` is not
modified; use the firmware boot menu (F12/F8) to boot it. The old Windows
install on `/dev/sda` is erased by the install script.

### After first login

- Restore the SSH private keys with correct permissions:
  ```sh
  install -d -m 700 ~/.ssh
  install -m 600 /path/to/backup/personal/id_ed25519 ~/.ssh/personal/id_ed25519
  install -m 600 /path/to/backup/lan ~/.ssh/lan
  ```
- Clone the nvim config (it is intentionally not managed by Nix):
  ```sh
  git clone git@github.com:<you>/<nvim-repo>.git ~/.config/nvim
  ```
  The `neovim` program itself is installed by home-manager.

## SSH

`programs.ssh` writes `~/.ssh/config` with:

- `github.com` → `~/.ssh/personal/id_ed25519`
- `laila` → `192.168.1.196`, key `~/.ssh/lan`
- `tear` → `192.168.1.23` (Wi-Fi is `192.168.1.174`), key `~/.ssh/lan`

Both public keys are in `users.users.juevigrace.openssh.authorizedKeys.keys`,
so either machine accepts either key. The SSH server is keys-only
(`PasswordAuthentication = false`).

The git signing key is `~/.ssh/personal/id_ed25519.pub`. Add it to GitHub as a
**signing key** as well as an authentication key.

After reinstalling a host, its host key changes. Remove the stale entry:
```sh
ssh-keygen -R laila
ssh-keygen -R 192.168.1.196
```

## Daily use

```sh
./scripts/update              # nix flake update
./scripts/rebuild             # rebuild the current host
nix flake check --no-build    # evaluate both hosts
```

The hardware files are placeholders until NixOS is installed, so a real
`nix flake check` fails the root-filesystem assertion before that point. After
`nixos-generate-config` has replaced both placeholders, the check works
normally.

