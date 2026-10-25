{
  stylix = {
    enable = true;

    # Stylix's overlays only theme gtksourceview/nixos-icons. They would put
    # `nixpkgs.overlays` inside the Home Manager profile, which conflicts with
    # `home-manager.useGlobalPkgs = true` (and is deprecated). The global
    # NixOS package set already handles everything else.
    overlays.enable = false;
  };
}
