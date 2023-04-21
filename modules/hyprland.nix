{ config, pkgs, options, lib, inputs, ... }:

with lib;
let
  cfg = config.modules.hyprland;
in {
  options.modules.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

/*
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
    };
    # this was failing to build so i removed it. sorry!!!!!!
    # -oat
    # look outside your window!!!
    # -aether
    # ok done              (i removed it again)
    # -oat
    # Do not trust the [Flower].
    # -aether

    user.packages = with pkgs; [
      grim
      slurp
      wl-clipboard
      brightnessctl
      gammastep
      wdisplays
    ];

    home._.wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        monitor=,preferred,auto,1

        input {
          kb_layout = us
          follow_mouse = 1
          touchpad {
            natural_scroll = yes
          }
          sensitivity = -0.2
        }

        general {
          main_mod = SUPER
          gaps_in = 4
          gaps_out = 4
          border_size = 2
          col.active_border = rgba(f7cd23ff)
          col.inactive_border = rbga(0f0f0fff)
          cursor_inactive_timeout = 5
          damage_tracking = full
          layout = dwindle
        }

        decoration {
          multisample_edges = true
          rounding = 4
          active_opacity = 1.0
          inactive_opacity = 0.8
          fullscreen_opacity = 1.9
          blur = true
          blur_size = 6
          blur_passes = 2
          blur_new_optimizations = on
          drop_shadow = true
          shadow_range = 4
          shadow_render_
          col.shadow = rgba(0f0f0f33)
          col.shadow_inactive = rgba(0f0f0f1e)
        }

        gestures {
          workspace_swipe = on
        }

        animations {
          enable = true

          bezier = workspacesBezier, 0.1, 0.9, 0.1, 0.9
          bezier = fadeBezier, 0, 0, 0.6, 1

          animation = fade, 1, 8, fadeBezier
          animation = windows, 1, 8, fadeBezier, popin 60%
          animation = workspaces, 1, 4, workspacesbezier, slide
        }

        $mainMod = SUPER

        bind = $mainMod, enter, exec, alacritty
        bind = $mainMod, C, killactive,
        bind = $mainMod, P, exec, nwggrid

        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod, 0, workspace, 10

        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10

        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow
      '';
    };
  };
*/
}