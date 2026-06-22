{ pkgs, config, options, lib, ... }:

with lib;
let
  cfg = config.modules.services.conduit;
  fullDomain = "${cfg.subdomain}.${cfg.hostDomain}";
  coturnRealm = "turn.${cfg.hostDomain}";
  minPort = 49000;
  maxPort = 50000;
in {
  options.modules.services.conduit = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    hostDomain = mkOption {
      type = types.str;
      default = null;
    };

    subdomain = mkOption {
      type = types.str;
      default = "matrix";
    };

    user = mkOption {
      type = types.str;
      default = "conduit";
      description = "User account under which Conduit runs.";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/conduit";
    };

    port = mkOption {
      type = types.port;
      default = 6167;
    };

    disableRegistration = mkOption {
      type = types.bool;
      default = true;
    };

    disableFederation = mkOption {
      type = types.bool;
      default = true;
    };

    maxRequestMegabytes = mkOption {
      type = types.int;
      default = 500;
    };

    trustedServers = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "matrix.org" ];
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.hostDomain != null;
        description = "@config.modules.services.dendrite.hostDomain@ must not equal null";
      }
    ];

    services.matrix-conduit.enable = true;
    services.matrix-conduit.settings.global = {
      server_name = cfg.hostDomain;
      address = "127.0.0.1";
      database_dir = cfg.dataDir;
      port = cfg.port;
      enable_lightning_bolt = false;
      enable_registration = !cfg.disableRegistration;
      max_concurrent_requests = 64;
      conduit_cleanup = 300;
      enable_federation = !cfg.disableFederation;
      max_request_size = cfg.maxRequestMegabytes * 1048576;
      trusted_servers = cfg.trustedServers;
      turn_uris = ["turn:${coturnRealm}?transport=udp" "turn:${coturnRealm}?transport=tcp"];
      turn_secret = "9Wbdn5W57uKKnELLCIbnVLF9plGUSDRQ";
    };

    services.nginx.virtualHosts."${fullDomain}" = {
      forceSSL = true;
      enableACME = true;

      locations."/_matrix".proxyPass = "http://127.0.0.1:${toString cfg.port}";
      #locations."/_matrix".proxyPass = "https://localhost:${toString cfg.port}";

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-RealIP $remote_addr;
        proxy_read_timeout 600;
        client_max_body_size ${toString cfg.maxRequestMegabytes}M;
      '';
    };

    services.nginx.virtualHosts."${cfg.hostDomain}" = {
      forceSSL = true;
      enableACME = true;

      locations."/.well-known/matrix/server".return = "200 '{ \"m.server\": \"${fullDomain}:443\"}'";

	    # locations."/.well-known/matrix/client".return = "200 '{ \"m.homserver\": { \"base_url\": \"https://${cfg.hostDomain}\"} }'";
      locations."/.well-known/matrix/client".extraConfig = ''
        return 200 '{ \"m.homeserver\": { \"base_url\": \"https://${fullDomain}\"} }';
        add_header Access-Control-Allow-Origin '*';
      '';
    };

    services.coturn = {
      enable = true;
      no-cli = true;
      no-tcp-relay = true;
      min-port = minPort;
      max-port = maxPort;
      use-auth-secret = true;
      static-auth-secret = "9Wbdn5W57uKKnELLCIbnVLF9plGUSDRQ";
      realm = coturnRealm;
      cert = "${config.security.acme.certs.${coturnRealm}.directory}/full.pem";
      pkey = "${config.security.acme.certs.${coturnRealm}.directory}/key.pem";
      extraConfig = ''
        # for debugging
        verbose
        # ban private IP ranges
        no-multicast-peers
        denied-peer-ip=0.0.0.0-0.255.255.255
        denied-peer-ip=10.0.0.0-10.255.255.255
        denied-peer-ip=100.64.0.0-100.127.255.255
        denied-peer-ip=127.0.0.0-127.255.255.255
        denied-peer-ip=169.254.0.0-169.254.255.255
        denied-peer-ip=172.16.0.0-172.31.255.255
        denied-peer-ip=192.0.0.0-192.0.0.255
        denied-peer-ip=192.0.2.0-192.0.2.255
        denied-peer-ip=192.88.99.0-192.88.99.255
        denied-peer-ip=192.168.0.0-192.168.255.255
        denied-peer-ip=198.18.0.0-198.19.255.255
        denied-peer-ip=198.51.100.0-198.51.100.255
        denied-peer-ip=203.0.113.0-203.0.113.255
        denied-peer-ip=240.0.0.0-255.255.255.255
        denied-peer-ip=::1
        denied-peer-ip=64:ff9b::-64:ff9b::ffff:ffff
        denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
        denied-peer-ip=100::-100::ffff:ffff:ffff:ffff
        denied-peer-ip=2001::-2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=2002::-2002:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      '';
    };

/*
    security.acme.certs.${coturnRealm} = {
      # insert here the right configuration to obtain a certificate
      postRun = "systemctl restart coturn.service";
      group = "turnserver";

      dnsProvider = "porkbun";
    };
*/
    services.nginx.virtualHosts."${coturnRealm}" = {
      forceSSL = true;
      enableACME = true;

      # locations."/.well-known/matrix/server".return = "200 '{ \"m.server\": \"${fullDomain}:443\"}'";

	    # locations."/.well-known/matrix/client".return = "200 '{ \"m.homserver\": { \"base_url\": \"https://${cfg.hostDomain}\"} }'";
      # locations."/.well-known/matrix/client".extraConfig = ''
      #   return 200 '{ \"m.homeserver\": { \"base_url\": \"https://${fullDomain}\"} }';
      #   add_header Access-Control-Allow-Origin '*';
      # '';
    };

    networking.firewall.allowedTCPPorts = [ 80 443 3478 5349 ];
    networking.firewall.allowedUDPPorts = [ 80 443 3478 5349 ];
    networking.firewall.allowedUDPPortRanges = [ { from = minPort; to = maxPort; } ];
  };
}
