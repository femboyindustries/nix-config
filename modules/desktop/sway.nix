{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.sway;
  audioSupport = config.modules.hardware.audio.enable;
in {
  options.modules.desktop.sway = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables the sway window manager for Wayland.";
    };
    menu = mkOption {
      type = types.str;
      default = "nwggrid";
      description = "";
    };
    term = mkOption {
      type = types.str;
      default = "alacritty";
      description = "Which terminal sway should default to.";
    };
  };

  config = mkIf cfg.enable {
    modules.hardware.graphics.enable = true;

    programs.sway = {
      enable = true;
      extraPackages = with pkgs; [ xwayland ];
    };

    user.packages = with pkgs; [
      grim
      slurp
      wl-clipboard
      swaybg
      autotiling
      brightnessctl
      wdisplays
    ] ++ (mkIf audioSupport (with pkgs; [
      playerctl
    ]));

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };

    services.xserver = {
      enable = true;
      autorun = true;

      displayManager = {
        sddm.enable = true;
        defaultSession = "sway";
      };

      wacom.enable = true;
    };

    modules.desktop.apps."${cfg.term}".enable = true;
    modules.desktop.apps.menus.${cfg.menu}.enable = true;

#    modules.desktop.services.swaylock.enable = true;
    modules.desktop.services.swayidle.enable = true;
#    modules.desktop.services.mako.enable = true;
    modules.desktop.services.waybar.enable = true;

    home._.wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;

      config = {
        bars = [{ command = "waybar"; }];
        modifier = "Mod4";
        input."type:keyboard" = let kbcfg = config.keyboard; in {
          xkb_layout = toLower (substring 3 2 kbcfg.locale);
          xkb_variant = "," + kbcfg.variant;
        };
        input."type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          scroll_method = "two_finger";
        };
        startup = [
#          { command = "lock"; }
          { command = "autotiling"; }
#          { command = "mako"; }
        ];
        terminal = config.modules.desktop.apps.${cfg.term}.executable;
        menu = config.modules.desktop.apps.menus.${cfg.menu}.executable;
        output."eDP-1" = {
          bg = "${config.modules.theme.wallpaper} fill";
          scale = "1.5";
        };
        keybindings = let mod = config.home._.wayland.windowManager.sway.config.modifier; scProc = "wl-copy -t image/png && notify-send \"Screenshot Taken\""; in {
#          "${mod}+l" = "exec lock";
          "${mod}+q" = "reload";
          "${mod}+Shift+c" = "kill";
          "${mod}+p" = "exec ${config.home._.wayland.windowManager.sway.config.menu}";
          "${mod}+Shift+Return" = "exec ${config.home._.wayland.windowManager.sway.config.terminal}";
          "${mod}+Shift+e" = "exit";

          "${mod}+1" = "workspace 1";
          "${mod}+2" = "workspace 2";
          "${mod}+3" = "workspace 3";
          "${mod}+4" = "workspace 4";
          "${mod}+5" = "workspace 5";
          "${mod}+6" = "workspace 6";
          "${mod}+7" = "workspace 7";
          "${mod}+8" = "workspace 8";
          "${mod}+9" = "workspace 9";
          "${mod}+0" = "workspace 10";

          "${mod}+Shift+1" = "move container to workspace 1";
          "${mod}+Shift+2" = "move container to workspace 2";
          "${mod}+Shift+3" = "move container to workspace 3";
          "${mod}+Shift+4" = "move container to workspace 4";
          "${mod}+Shift+5" = "move container to workspace 5";
          "${mod}+Shift+6" = "move container to workspace 6";
          "${mod}+Shift+7" = "move container to workspace 7";
          "${mod}+Shift+8" = "move container to workspace 8";
          "${mod}+Shift+9" = "move container to workspace 9";
          "${mod}+Shift+0" = "move container to workspace 10";
        };
      };
      extraSessionCommands = ''
        export XDG_SESSION_TYPE=wayland
        export QT_QPA_PLATFORM=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
      '';
      extraConfig = builtins.readFile "${config.home.configFile.sway.source}/config";
    };
  };
}
