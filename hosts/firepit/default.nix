{ pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  user = {
    packages = with pkgs; [
      curl
    ];
  };

  defaultUsers = {
    aether = {
      packages = [ ];
      shell = "fish";
      extraGroups = [ "wheel" ];
    };
    oatmealine = {
      packages = [ ];
      shell = "zsh";
      extraGroups = [ "wheel" ];
    };
    skye = {
      packages = [ ];
      shell = "fish";
      extraGroups = [ "wheel" ];
    };
  };

  keyboard = {
    locale = "en_US.UTF-8";
    variant = "qwerty";
  };

  modules = {
#    theme.active = "still";
    shell.zsh.enable = true;
    security = {
      isLocalMachine = false;
    };
    desktop = {
      editors = {
        neovim.enable = true;
      };
    };
    dev = {
    };
    services = {
      ssh.enable = true;
      postgres.enable = true;
      gitea = {
        enable = true;
        site = "git.oat.zone";
      };
      wireguard = {
        enable = true;
        server = true;
        interfaces = mkMerge (import ./interfaces);
      };
    };
  };

  time.timeZone = "Europe/Frankfurt";

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking = {
    hostName = "firepit";
  };
}
