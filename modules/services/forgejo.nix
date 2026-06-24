{ inputs, config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.forgejo;
in {
  imports = [
    "${inputs.nixpkgs-forgejo-runner}/nixos/modules/services/continuous-integration/forgejo-runner.nix"
  ];

  options.modules.services.forgejo = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    domain = mkOption {
      type = types.str;
      default = "git.oat.zone";
    };
    port = mkOption {
      type = types.int;
      default = 3000;
    };
    package = mkOption {
      type = types.package;
      default = pkgs.forgejo;
    };
    runnerPackage = mkOption {
      type = types.package;
      default = pkgs.forgejo-runner;
    };
    enableActions = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services = {
        forgejo = {
          enable = true;
          package = cfg.package;
          stateDir = "/var/lib/${cfg.domain}";
          lfs.enable = true;
          database = {
            type = "postgres";
            # leaving this blank intentionally
          };
          settings = mkMerge [ (builtins.fromTOML (builtins.readFile ../../config/forgejo/app.toml)) {
            "ui.meta" = {
              AUTHOR = "femboy.industries";
              DESCRIPTION = "femboy.industries's shared git instance";
            };
            "server" = {
              DOMAIN = cfg.domain;
              HTTP_PORT = cfg.port;
              ROOT_URL = "https://${cfg.domain}/";
            };
            "actions" = {
              ENABLED = cfg.enableActions;
            };
          }];
        };

        nginx.virtualHosts."${cfg.domain}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            extraConfig = ''
              client_max_body_size 600M;
            '';
          };
        };
      };
    }
    (mkIf cfg.enableActions {
      services.forgejo-runner = mkIf cfg.enableActions {
        instances.default = {
          enable = true;
          settings = {
            runner = {
              labels = [
                "ubuntu-24.04:docker://ubuntu:24.04"
                "ubuntu-22.04:docker://ubuntu:22.04"
                "nix-latest:docker://nixos/nix:latest"
              ];
            };
            server = {
              connections.default = {
                url = "https://${cfg.domain}/";
                uuid = "f0b6dc7b-5f7f-4c47-bca7-1105224464eb";
                token_url = "file:/etc/forgejo-runner-token";
              };
            };
            container = {
              enable_ipv6 = true;
            };
          };
        };
      };

      virtualisation.docker = {
        enable = true;
        daemon.settings = {
          fixed-cidr-v6 = "fd00::/80";
          ipv6 = true;
        };
      };
      #virtualisation.podman.enable = true;

      networking.firewall.trustedInterfaces = [ "br-+" ];
    })
  ]);
}
