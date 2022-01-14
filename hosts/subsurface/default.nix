{ pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  user = {
    packages = with pkgs; [
      curl
      dolphin
      discord
      wl-clipboard
      firefox-wayland
      inkscape
      blender
      polymc
    ];
  };

  defaultUsers = {
    aether = {
      packages = [ ];
      uid = 1024;
      isNormalUser = true;
      shell = "zsh";
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
      isLocalMachine = true;
    };
    desktop = {
      sway = {
        enable = true;
        term = "alacritty";
      };
      apps = {
        mpc.enable = true;
        alacritty.enable = true;
        obs.enable = true;
        firefox.enable = true;
        menus = {
          nwggrid.enable = true;
        };
      };
      editors = {
         neovim.enable = true;
         codium.enable = true;
      };
      gaming = {
        minecraft.enable = true;
      };
    };
    dev = {
      llvm.enable = true;
      haskell.enable = true;
      c.enable = true;
    };
    services = {
      ssh.enable = true;
      mpd = {
        enable = true;
        # TODO: Make this more dynamic?
        musicDir = "/home/aether/Music";
      };
    };
  };

  # Doxxing live stream
  time.timeZone = "Europe/Dublin";

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # Fuck sudo all my homies hate sudo
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [
      { users = [ "aether" ]; keepEnv = true; }
    ];
  };

  # Weird hack to get GDM to not explode on startup
  # TODO: This might not be needed anymore
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  networking = {
    hostName = "subsurface";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlp1s0.useDHCP = true;
  };
}
