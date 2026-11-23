{...}: {
  # Support Windows-compatible removable media:
  #   ntfs  -> ntfs3g (mkntfs, ntfsfix, ntfsresize, ntfsclone, ...)
  #   exfat -> exfatprogs (mkfs.exfat)
  # These packages are added to the system PATH, where udisks2 and mount
  # can find them. FAT32 support comes from dosfstools by default.
  boot.supportedFilesystems = ["ntfs" "exfat"];
}
