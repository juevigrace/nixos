# Install NixOS on `tear` — whole `/dev/sda`, Btrfs

> **Destroys all data on `/dev/sda`.** Does not touch `/dev/nvme0n1` (Omarchy stays there).
> No swap partition; `zramSwap` is enabled in the flake.

## Layout

| Partition | Size | Use |
|---|---|---|
| `/dev/sda1` | 1 GiB | FAT32 ESP, mounted at `/boot` |
| `/dev/sda2` | rest | Btrfs, mounted at `/` |

Btrfs subvolumes: `@`, `@home`, `@nix`, `@log`, `@snapshots`.

## 1. Wipe and partition

```sh
lsblk -f
sudo swapoff -a
sudo umount /dev/sda?* 2>/dev/null || true

sudo wipefs -a /dev/sda
sudo sgdisk --zap-all /dev/sda

sudo sgdisk -n 1:2048:2099199 -t 1:ef00 -c 1:ESP /dev/sda
sudo sgdisk -n 2:2099200:0 -t 2:8300 -c 2:NIXOS /dev/sda

sudo partprobe /dev/sda
lsblk -f
```

## 2. Format and mount

```sh
sudo mkfs.fat -F 32 -n BOOT /dev/sda1
sudo mkfs.btrfs -f -L NIXOS /dev/sda2

sudo mount /dev/sda2 /mnt
sudo btrfs subvolume create /mnt/@
sudo btrfs subvolume create /mnt/@home
sudo btrfs subvolume create /mnt/@nix
sudo btrfs subvolume create /mnt/@log
sudo btrfs subvolume create /mnt/@snapshots
sudo umount /mnt

sudo mount -o subvol=@,compress=zstd:3,noatime /dev/sda2 /mnt
sudo mkdir -p /mnt/{home,nix,var/log,.snapshots,boot}

sudo mount -o subvol=@home,compress=zstd:3,noatime /dev/sda2 /mnt/home
sudo mount -o subvol=@nix,compress=zstd:3,noatime /dev/sda2 /mnt/nix
sudo mount -o subvol=@log,compress=zstd:3,noatime /dev/sda2 /mnt/var/log
sudo mount -o subvol=@snapshots,compress=zstd:3,noatime /dev/sda2 /mnt/.snapshots
sudo mount -o umask=077 /dev/sda1 /mnt/boot

findmnt -R /mnt
```

## 3. Generate hardware config

```sh
sudo nixos-generate-config --root /mnt
cat /mnt/etc/nixos/hardware-configuration.nix
```

Check:

- `/` uses `fsType = "btrfs"` and `subvol=@`
- `/home` → `subvol=@home`
- `/nix` → `subvol=@nix` and `neededForBoot = true;`
- `/var/log` → `subvol=@log`
- `/.snapshots` → `subvol=@snapshots`
- `/boot` is `vfat` on `/dev/sda1`

If the repo is already available inside the target (for Option B), copy it there:

```sh
cp /mnt/etc/nixos/hardware-configuration.nix \
  /mnt/home/juevigrace/Projects/nixos/hosts/tear/hardware-configuration.nix
```

Otherwise copy it into the repo after first boot (Option A).

## 4. Install

### Option A — minimal install, rebuild afterward

```sh
sudo nixos-install
```

Boot NixOS, copy/clone the repo to `~/Projects/nixos`, copy the real hardware
config into `hosts/tear/`, then:

```sh
cd ~/Projects/nixos
git add -A
sudo ./scripts/rebuild tear
sudo passwd juevigrace   # if the user password is not set yet
```

### Option B — install directly from the flake

Put the repo at the path the config expects:

```sh
sudo mkdir -p /mnt/home/juevigrace/Projects
# copy the repo from USB / Omarchy to:
# /mnt/home/juevigrace/Projects/nixos

sudo cp /mnt/etc/nixos/hardware-configuration.nix \
  /mnt/home/juevigrace/Projects/nixos/hosts/tear/hardware-configuration.nix

cd /mnt/home/juevigrace/Projects/nixos
git add -A

sudo nixos-install --flake .#tear
```

If Nix complains about untracked files, commit them before installing.

## 5. First boot

- Set the user password if needed:

  ```sh
  sudo passwd juevigrace
  ```

- Select **NixOS** from the firmware boot menu.
- Omarchy on `nvme0n1` is not modified; boot it from the firmware menu when
  needed.
- The repo must remain at `/home/juevigrace/Projects/nixos` because
  `modules/home-manager/files.nix` links live configs from that path.
