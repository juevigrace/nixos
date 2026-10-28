{
  description = "Shared NixOS config for tear (desktop) and laila (laptop)";

  inputs = {
    # Latest stable release.
    #
    # If you ever want the WHOLE system on unstable, change this to
    #   "github:nixos/nixpkgs/nixos-unstable"
    # and change home-manager below to "master", then run:
    #   nix flake update
    #
    # For normal day-to-day use you do NOT need to do that: the overlay in
    # modules/nixos/default.nix gives you `pkgs.unstable.<package>` while the
    # rest of the system stays on stable.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # A second nixpkgs, used only for packages explicitly selected with
    # `pkgs.unstable.<name>`. This does not replace the stable package set.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager tracks the same stable release as nixpkgs above.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wallpaper picker/daemon with a built-in Wallhaven browser and Matugen
    # integration. It ships prebuilt binaries, so this does not compile Rust.
    skwd-wall = {
      url = "github:liixini/skwd-wall/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Prebuilt nix-index database for `command-not-found` / `nix-locate`.
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # Hosts own their hardware and base system, and import the users they
    # need. The users then import the programs and services they want.
    mkHost = host:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};

        modules = [
          # Per-host system + hardware configuration. The host also imports
          # modules/nixos and the users it needs.
          ./hosts/${host}

          # Home Manager as a NixOS module (not standalone).
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = ".bkp";
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      tear = mkHost "tear";
      laila = mkHost "laila";
    };
  };
}
