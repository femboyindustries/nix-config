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
          settings = {
            # https://forgejo.org/docs/latest/admin/config-cheat-sheet/
            DEFAULT = {
              APP_NAME = "Forgejo: femboy.industries hosted Git";
            };
            "repository" = {
              DEFAULT_BRANCH = "main";
              PREFERRED_LICENSES = "Anyone But Richard M Stallman license,Be Gay Do Crimes License,This is not a place of honour";
            };
            "ui" = {
              DEFAULT_THEME = "forgejo-auto";
              #THEMES = "forgejo-auto,forgejo-light,forgejo-dark";
              CUSTOM_EMOJIS = concatStringsSep "," [
                # default
                "forgejo" "gitea" "codeberg" "gitlab" "git" "github" "gogs"
                # custom
                "pencil" "twinktime" "osaka" "Screenshot_20221211_121407" "emoji_9" "chart_with_neutral_trend" "devoid" "Grin" "hard" "GRINN" "emoji9EPIC" "guh" "Extreme" "theb" "unstar" "CamEdgeTrigger" "caterpillar" "Normal" "youdidwhatnow" "spongebob" "omega" "spungebob" "ppcat" "bwabwabwa" "OsakaTrue" "oska" "thescreamsofthedamned" "orang" "yeah" "ohmygah" "slug" "goldensigma" "colonthree" "yiikingout" "yay" "okheart" "colonthree" "blue_eating" "jonkler" "neurodiversion" "funsurprise" "skill_check" "catjump" "e3c" "bookmove" "fanowar" "easternlion" "jerma" "jopeful" "missing"
              ];
            };
            "ui.meta" = {
              AUTHOR = "femboy.industries";
              DESCRIPTION = "femboy.industries's shared git instance";
            };
            "server" = {
              DOMAIN = cfg.domain;
              HTTP_PORT = cfg.port;
              ROOT_URL = "https://${cfg.domain}/";
              DISABLE_SSH = true; # as long as we're behind cloudflare, ssh don't work
            };
            "security" = {
              INSTALL_LOCK = true;
              PASSWORD_HASH_ALGO = "argon2";
              PASSWORD_CHECK_PWN = true;
            };
            "openid" = {
              ENABLE_OPENID_SIGNIN = false;
              ENABLE_OPENID_SIGNUP = false;
            };
            "oauth2_client" = {
              UPDATE_AVATAR = true;
            };
            "service" = {
              REGISTER_EMAIL_CONFIRM = false;
              ENABLE_NOTIFY_MAIL = false;
              ALLOW_ONLY_EXTERNAL_REGISTRATION = false;
              ENABLE_CAPTCHA = false;
              REQUIRE_SIGNIN_VIEW = false;
              DEFAULT_KEEP_EMAIL_PRIVATE = true;
              ENABLE_TIMETRACKING = false;
              DISABLE_REGISTRATION = true;
            };
            "session" = {
              PROVIDER = "file";
              COOKIE_SECURE = true;
            };
            "picture" = {
              ENABLE_FEDERATED_AVATAR = true;
            };
            "attachment" = {
              ALLOWED_TYPES = "*/*";
            };
            "cron" = {
              ENABLED = true;
            };
            "federation" = {
              ENABLED = true;
            };
            "git" = {
              PULL_REQUEST_PUSH_MESSAGE = false;
            };
            "actions" = {
              ENABLED = cfg.enableActions;
            };
            "other" = {
              SHOW_FOOTER_POWERED_BY = false;
              SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
            };
          };
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
