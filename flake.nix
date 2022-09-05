{
  description = "Frosted Flakes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";

    # WARNING: Where possible, prefer the stable branch of nixpkgs as nixpkgs-unstable may have incompatable or vulnerable software.
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # WARNING: The master branch of nixpkgs is unsafe to use and software may break or contain various security vulnerabilities. Use at your own discretion.
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # agenix - age-encrypted secrets
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    jillo.url = "/home/oatmealine/jillo";
    watch-party.url = "/home/oatmealine/watch-party";
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, nix-minecraft, ... }:
    let
      system = "x86_64-linux";

      lib = import ./lib { inherit pkgs inputs; lib = nixpkgs.lib; };
      inherit (lib._) mapModules mapModulesRec mkHost;

      mkPkgs = pkgs: overlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = overlays ++ (lib.attrValues self.overlays);
      };

      pkgs = mkPkgs nixpkgs [ self.overlay nix-minecraft.overlay ];
    in {
      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p {});
      overlay = final: prev: {
        _ = self.packages."${system}";
        unstable = mkPkgs nixpkgs-unstable [];
        master = mkPkgs nixpkgs-master [];
      };
      overlays = mapModules ./overlays import;
      nixosModules = mapModulesRec ./modules import;
      nixosConfigurations = mapModules ./hosts (host: mkHost host { inherit system; });
      devShell."${system}" = import ./shell.nix { inherit pkgs; };
    };
}


