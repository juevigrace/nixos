# NixOS config for `tear` and `laila`

One flake, one user (`juevigrace`), one shared configuration. Only the
per-host files differ.

## Layout

```
flake.nix                         # inputs + the two hosts
hosts/tear/                       # desktop: hostname, GPU, hardware config
hosts/laila/                      # laptop: hostname, GPU, hardware config
modules/nixos/
  default.nix                     # imports every shared system module
  nixpkgs.nix                     # stable/unstable overlay, allowUnfree
  packages.nix                    # system-wide packages
  nix.nix                         # flakes, channels
  state.nix                       # stateVersion
  locale.nix                      # locale + timezone
  environment.nix                 # EDITOR, shell notes
  boot/
    systemd-boot.nix
    zram.nix
  networking/networkmanager.nix
  users/juevigrace.nix
  hardware/
    bluetooth.nix
    graphics.nix
    fonts.nix
  programs/
    niri.nix                      # system-level Niri
    skwd-wall.nix                 # Wallhaven wallpaper picker + daemon
    ssh-agent.nix                 # system SSH agent
    xwayland-satellite.nix
  services/
    openssh.nix                   # SSH server
    pipewire.nix                  # audio
    greetd.nix                    # login manager
    blueman.nix
    gnome-keyring.nix
    gvfs.nix
    udisks2.nix
    upower.nix
modules/home-manager/
  default.nix                     # imports every shared user module
  packages/                       # one file per package-only tool
    brightnessctl.nix
    caligula.nix
    fd.nix
    fzf.nix
    grim.nix
    nautilus.nix
    neovim.nix
    opencode.nix
    playerctl.nix
    pwvucontrol.nix
    ripgrep.nix
    satty.nix
    slurp.nix
    swaybg.nix
    tree.nix
    wiremix.nix
    wireplumber.nix
    wl-clipboard.nix
  programs/
    git.nix
    ssh.nix                       # SSH client
    ghostty.nix
    waypaper.nix
    zen.nix                       # Zen Browser
    waybar/
      default.nix
      config.json
      style.css
    niri/
      default.nix
      config.kdl
    fuzzel/
      default.nix
      fuzzel.ini
    skwd-wall/
      default.nix
      config.json
      matugen/templates/
      wallpapers/
    swaylock/
      default.nix
      config
      colors.conf
  services/
    mako/
      default.nix
      config
    swayidle.nix
    cliphist.nix
    polkit-gnome.nix
    network-manager-applet.nix
    blueman-applet.nix
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
- **Compositor:** Niri, with the Nautilus file chooser (`useNautilus = true`).
- **Terminal:** Ghostty (`Mod+T`).
- **Launcher:** fuzzel (`Mod+D`).
- **Bar:** Waybar with the native `niri/workspaces` and `niri/window` modules,
  a centred clock, and CPU, memory, temperature, volume, network, battery, and
  tray modules on the right.
- **Notifications:** mako. **Lock:** swaylock-effects, using the current
  skwd-wall wallpaper blurred with `effect-blur` (`Super+Alt+L`). **Idle:**
  swayidle locks after 1 hour and turns the displays off after 1 hour 15
  minutes.
- **Wallpaper:** skwd-wall (`Mod+Shift+W`). Its built-in picker has a Wallhaven
  browser, and `skwd-walld` restores the last wallpaper at login. Waypaper and
  swaybg are still installed as a fallback but are no longer started.
- **Audio:** PipeWire + WirePlumber. `pwvucontrol` is the GUI mixer and
  `wiremix` is the TUI; open Wiremix with `Mod+Shift+A` to select the rear or
  front microphone port. Clicking the volume module in Waybar opens
  `pwvucontrol`.
- **Network:** NetworkManager is enabled in
  `modules/nixos/networking/networkmanager.nix`. The Waybar network module
  opens `nm-connection-editor`; `nm-applet` and `blueman-applet` are also
  running.
- **X11 apps:** `xwayland-satellite`, not `programs.xwayland`.
- **Fonts:** Noto (including CJK and emoji), DejaVu, Liberation, Unifont,
  Cantarell, Inter, Roboto, Font Awesome, Material Icons, and Nerd Fonts.

### Configuration files

The real config files live next to their app module, for example
`modules/home-manager/programs/waybar/config.json`, and are linked into
`~/.config` as **live** links with
`config.lib.file.mkOutOfStoreSymlink`. Editing either path edits the tracked
file; a rebuild is only needed for package/service changes. If you move the
repo out of `~/Projects/nixos`, update the `liveConfig` path at the top of the
app modules that link config files (Waybar, Niri, Fuzzel, Mako, and skwd-wall).
Swaylock is the exception: its config is seeded as a writable copy so
skwd-wall can add the current wallpaper without writing through a Nix symlink.

Useful reloads after editing:

```sh
niri validate -c ~/.config/niri/config.kdl
pkill -USR2 waybar
makoctl reload
```

The Niri config is validated by `niri validate`. `~/.config/nvim` is still a
separate manual clone and is not managed here.

### Zen Browser

Zen is installed by `modules/home-manager/programs/zen.nix` using the
`0xc000022070/zen-browser-flake` home-manager module. Extensions are installed
declaratively through Firefox enterprise policies:

- uBlock Origin
- Malwarebytes Browser Guard
- Return YouTube Dislike
- Proton VPN

Tabs, pinned tabs, essentials, and Spaces are synced through Firefox Sync:
sign in to the same Mozilla account on each machine and enable "Sync your
Spaces across devices" in Zen's settings.
`zen.workspaces.continue-where-left-off` restores the previous session on
launch.

The module manages a profile named `default` under `~/.config/zen/default`.
The existing Zen profile is left untouched; sign in to Sync in the managed
profile to pull tabs/Spaces across. If the old profile was not already signed
in to Sync, sign in there first and let it upload before switching.

Do **not** commit Zen/Firefox backup files. They contain bookmarks, history,
settings, passwords, payment methods, extensions, and other browsing data. The
repo ignores `*.zenbackup`, `zen-backup-*`, and `backup-*.json`; keep backups
outside the repo, optionally on an encrypted drive.

If Firefox Sync does not restore your Spaces/pins, the same module supports
declarative `profiles.default.spaces` and `.pins` in `zen.nix`. Close Zen
before rebuilding.

### GPU

- `tear`: NVIDIA open kernel modules with modesetting (`hosts/tear/default.nix`).
- `laila`: Intel graphics for the desktop plus NVIDIA PRIME offload. Run a
  single application on the NVIDIA GPU with:
  ```sh
  nvidia-offload <command>
  ```

### Wallpaper and system colours

Wallpaper selection is handled by skwd-wall. It has a built-in Wallhaven
browser and derives a Material You palette from the selected image with
Matugen.

The picker config and all Matugen templates are tracked under
`modules/home-manager/programs/skwd-wall/` and linked live into
`~/.config/skwd-wall-v2/`. The currently selected wallpaper is kept in the
repo at `wallpapers/wallhaven-r735gq.png` and linked to
`~/Pictures/Wallpapers/wallhaven-r735gq.png`; Home Manager also seeds the
skwd cache so the wallpaper is restored on a fresh install.

Matugen writes colours into separate generated files, so it never overwrites
the repo-managed layout files:

- Waybar: `~/.config/waybar/colors.css`
- Niri: `~/.config/niri/colors.kdl`
- Ghostty: `~/.config/ghostty/colors.conf`
- btop: `~/.config/btop/themes/skwd.theme`
- Fuzzel: `~/.config/fuzzel/colors.ini`
- mako: `~/.config/mako/colors`
- Swaylock: `~/.config/swaylock/colors.conf`

Each generated file has a Catppuccin fallback in the repo that is copied only
when the generated file does not exist yet. `swaylock-themed` merges the
generated palette with skwd-wall's exported current wallpaper, and
swaylock-effects applies `effect-blur=20x3` so it is obvious the session is
locked. The greetd greeter is still the text-only `tuigreet`, so it does not
have a wallpaper.

### Docker

Docker uses the standard rootful daemon. The user is in the `docker` group, so
`docker` commands work without `sudo`, but membership in that group is
effectively root-equivalent. This is not rootless Docker.

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

| Partition | Size  | Use                           |
| --------- | ----- | ----------------------------- |
| `...1`    | 1 GiB | FAT32 ESP, mounted at `/boot` |
| `...2`    | rest  | Btrfs, mounted at `/`         |

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
