{ pkgs, ... }: {
  # Video and audio downloader.
  home.packages = [ pkgs.unstable.yt-dlp ];
}
