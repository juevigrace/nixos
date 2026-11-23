{ pkgs, ... }: {
  # Tools for turning stream VODs into short vertical clips.
  home.packages = with pkgs; [
    # Timeline editor with vertical project support and Whisper captions.
    kdePackages.kdenlive

    # Command-line cutting, cropping, and re-encoding.
    ffmpeg

    # Fast lossless trimming before importing into Kdenlive.
    losslesscut-bin

    # Lightweight player for reviewing footage frame by frame.
    mpv
  ];
}
