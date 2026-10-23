{ pkgs, ... }: {
  # Broad fallback coverage plus Nerd Fonts for Waybar/Ghostty icons.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    dejavu_fonts
    liberation_ttf
    unifont
    cantarell-fonts
    inter
    roboto
    font-awesome
    material-icons
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = ["Noto Sans" "DejaVu Sans"];
    serif = ["Noto Serif" "DejaVu Serif"];
    monospace = ["JetBrainsMono Nerd Font" "DejaVu Sans Mono"];
    emoji = ["Noto Color Emoji"];
  };
}
