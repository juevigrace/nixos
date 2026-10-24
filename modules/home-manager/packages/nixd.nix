{ pkgs, ... }: {
  # Nix language server. Mason only ships `nil`, so nixd comes from nixpkgs.
  home.packages = [ pkgs.unstable.nixd ];
}
