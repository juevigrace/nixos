{pkgs, lib, ...}: {
  # Used by Niri's `useNautilus` file chooser and as the GUI file manager.
  home.packages = [pkgs.nautilus];

  # Show the dedicated Btrfs storage disk in the Nautilus sidebar without
  # requiring the user to type /mnt/storage. Preserve any bookmarks Nautilus
  # adds later by appending only when the entry is missing.
  home.activation.nautilusStorageBookmark = lib.hm.dag.entryAfter ["writeBoundary"] ''
    bookmark="$HOME/.config/gtk-3.0/bookmarks"
    mkdir -p "$(dirname "$bookmark")"
    touch "$bookmark"
    grep -qxF 'file:///mnt/storage Storage' "$bookmark" 2>/dev/null ||
      printf '%s\n' 'file:///mnt/storage Storage' >> "$bookmark"
  '';
}
