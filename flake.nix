{
  description = "Frosted Flakes";

  inputs = {
    # NixOS unstable
    nixpkgs.url = "nixpkgs/nixos-unstable";
#    nixpkgs.url = "nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/master";
#    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # agenix - age-encrypted secrets
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # nixos-hardware
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

/*
    # fzf-hoogle
    fzf-hoogle-vim.url = "github:monkoose/fzf-hoogle.vim";
    fzf-hoogle-vim.flake = false;

    # asyncrun-vim
    asyncrun-vim.url = "github:skywind3000/asyncrun.vim";
    asyncrun-vim.flake = false;
*/
    meson.url = "github:mesonbuild/meson/0.60";
    meson.flake = false;

    sway-borders.url = "github:fluix-dev/sway-borders";
    sway-borders.flake = false;

#    blender-30.url = "github:blender/blender/blender-v3.0-release";
#    blender-30.flake = false;

    polymc.url = "github:PolyMC/PolyMC";
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, ... }:
    let
      system = "x86_64-linux";

      lib = import ./lib { inherit pkgs inputs; lib = nixpkgs.lib; };
      inherit (lib._) mapModules mapModulesRec mkHost;

      mkPkgs = pkgs: overlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = overlays ++ (lib.attrValues self.overlays);
      };

      pkgs = mkPkgs nixpkgs [ self.overlay inputs.polymc.overlay.${system} ];
    in {
      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p {});
      overlay = final: prev: {
        _ = self.packages."${system}";
#        meson = inputs.meson;
#        sway-unwrapped = inputs.sway-borders;
#        blender = inputs.blender-30;
        unstable = mkPkgs nixpkgs-unstable [];
      };
      overlays = mapModules ./overlays import;
      nixosModules = mapModulesRec ./modules import;
      nixosConfigurations = mapModules ./hosts (mkHost system);
      devShell."${system}" =
        import ./shell.nix { inherit pkgs; };
    };
}
