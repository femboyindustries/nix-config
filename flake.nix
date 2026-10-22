{
  description = "Amalgamated, Bespoke Frosted Flakes";

  inputs = {
    nixpkgs.url = "nixpkgs/release-26.05";
    nixpkgs-master.url = "nixpkgs/master";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    post-cohost-blogger.url = "git+https://git.oat.zone/oat/post-cohost-blogger";
    post-cohost-blogger.inputs.nixpkgs.follows = "nixpkgs"; # TODO: remove once nodejs fixes hit nixos-26.05

    nlw-api.url = "git+https://git.oat.zone/oat/nlw-api";
    nlw-api.inputs.nixpkgs.follows = "nixpkgs"; # TODO: remove once nodejs fixes hit nixos-26.05
    cardgen.url = "git+https://git.oat.zone/oat/cardgen";
    cardgen.inputs.nixpkgs.follows = "nixpkgs"; # TODO: remove once nodejs fixes hit nixos-26.05
    gd-icon-renderer-web.url = "github:oatmealine/gd-icon-renderer-web";

    nixpkgs-forgejo-runner.url = "github:emilylange/nixpkgs?ref=nixos/forgejo-runner";

    following-shim.url = "git+https://tangled.org/oat.zone/following-shim";
    following-shim.inputs.nixpkgs.follows = "nixpkgs"; # TODO: remove once nodejs fixes hit nixos-26.05

    ozone.url = "git+https://tangled.org/cool-handle.ebil.club/ozone-nix";
    # it don't fucking work!! oops
    #ozone.inputs.nixpkgs.follows = "nixpkgs"; # TODO: remove once nodejs fixes hit nixos-26.05
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-master, ... }:
    let
      system = "x86_64-linux";

      lib = import ./lib { inherit pkgs inputs; lib = nixpkgs.lib; };
      inherit (lib._) mapModules mapModulesRec mkHost;

      mkPkgs = pkgs: overlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        #overlays = overlays ++ (lib.attrValues self.overlays);
        overlays = overlays;
      };

      pkgs = mkPkgs nixpkgs [ self.overlay ];
    in {
      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p { });
      overlay = final: prev: {
        _ = self.packages."${system}";
        master = mkPkgs nixpkgs-master [];
      };
      #overlays = mapModules ./overlays import;
      nixosModules = mapModulesRec ./modules import;
      nixosConfigurations = mapModules ./hosts (host: mkHost host { inherit system; });
    };
}
