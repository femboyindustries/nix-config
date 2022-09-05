{ config, inputs, lib, pkgs, ... }:

let
  inherit (lib) filterAttrs _;
in {
  imports =
    [ inputs.home-manager.nixosModules.home-manager ]
    ++ _.mapModulesRec' ./modules import;

  # ‹nix flake check› bypasses, can be changed in the actual hosts
  # config, useful for testing
  fileSystems."/".device = lib.mkDefault "/dev/disk/by-label/nixos";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  nix = let
    registry = lib.mapAttrs (name: value: { flake = value; }) (filterAttrs (name: value: name != "attrs") inputs);
  in {
    package = pkgs.nixFlakes;
    registry = registry // { dotfiles.flake = inputs.self; };
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "nix-command" "flakes"];
    settings.substituters = [
      "https://nix-community.cachix.org"
    ];
    settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  environment.systemPackages = with pkgs; [
    curl git wget neovim
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  
  system.stateVersion = lib.mkDefault "21.05";
}
