{ config, lib, options, pkgs, ... }:

with lib;
let
  cfg = config.modules.security;
in {
  options.modules.security = {
    isLocalMachine = mkOption {
      type = types.bool;
      default = null;
      description = "We can make some security tweaks depending on whether or not the machine is local.";
    };
    tmpOnTmpfs = mkOption {
      type = types.bool;
      default = true;
    };
    cleanTmpDir = mkOption {
      type = types.bool;
      default = !cfg.tmpOnTmpfs;
    };
    allowedUDPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
    };
    allowedTCPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
    };
  };

  config = {
    assertions = [
      { assertion = cfg.isLocalMachine != null;
        description = "The isLocalMachine property *must* be explicitly specified.";
      }
    ];

    security.rtkit.enable = true;

    boot.loader.systemd-boot.editor = false;

    networking.firewall = {
      enable = true;
      allowedUDPPorts = cfg.allowedUDPPorts;
      allowedTCPPorts = cfg.allowedTCPPorts;
    };

    security.sudo.enable = false;
    security.doas = {
      enable = true;
      extraRules = if cfg.isLocalMachine then [{ users = builtins.attrNames config.defaultUsers; }] else [];
    };

    boot.kernel.sysctl = {
      "kernel.sysrq" = 0;

#      "net.ipv4.conf.default.rp_filter" = 1;
#      "net.ipv4.conf.all.rp_filter" = 1;

      "net.ipv4.conf.all.accept_source_code" = 0;
      "net.ipv6.conf.all.accept_source_code" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_conjestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };

    user = {
      initialPassword = "nixos";
    };

    users.users.root = {
      packages = [ pkgs.nologin ];
      shell = pkgs.nologin;
      hashedPassword = "!";
    };
  };
}
