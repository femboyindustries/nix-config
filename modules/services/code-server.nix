{ config, lib, pkgs, options, ... }:

with lib;
let
  cfg = config.modules.services.code-server;
in {
  options.modules.services.code-server = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    domain = mkOption {
      type = types.str;
      default = "dev-firepit.oat.zone";
    };
    port = mkOption {
      type = types.int;
      default = 4444;
    };
  };

  config = mkIf cfg.enable {
    services = {
      code-server = {
        enable = true;
        port = cfg.port;
        # temporary
        auth = "password";
        # temporary; be sure to remove trailing newline
        hashedPassword = builtins.readFile /etc/code-server-password;

        extraPackages = with pkgs; [ git nix ];
      };

      nginx.virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "Upgrade";
            proxy_set_header Host $host;
          '';
        };
        locations."= /robots.txt" = {
          extraConfig = ''
            add_header Content-Type text/plain;
            return 200 "User-agent: *\nDisallow: /\n";
          '';
        };
      };
    };
    
    users.users.code-server = {
      extraGroups = [ "nix-users" "dotfiles" ];
      shell = pkgs.unstable.fish;
    };
  };
}
