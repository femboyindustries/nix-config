{
  description = "Frosted Flakes";

  inputs = {
    # temporary forgejo workaround
    # TODO: remove when https://github.com/NixOS/nixpkgs/pull/218269 gets pushed to stable
    nixpkgs.url = "nixpkgs/nixos-22.11";
    #nixpkgs.url = "nixpkgs/nixos-unstable";

    # WARNING: Where possible, prefer the stable branch of nixpkgs as nixpkgs-unstable may have incompatable or vulnerable software.
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # agenix - age-encrypted secrets
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:msteen/nixos-vscode-server";
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, vscode-server, nix-minecraft, /* hyprland, hyprpaper, hyprpicker, */ ... }:
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
      };
      overlays = mapModules ./overlays import;
      nixosModules = (mapModulesRec ./modules import) ++ [
#        hyprland.nixosModules.default
        vscode-server.nixosModule
      ];
      nixosConfigurations = mapModules ./hosts (host: mkHost host { inherit system; });
      devShell."${system}" = import ./shell.nix { inherit pkgs; };
    };
}
