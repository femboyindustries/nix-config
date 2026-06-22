{ pkgs, enable ? false, server-port, whitelist, unsup, unsupINI, ... }:

{
  inherit enable;
  autoStart = true;
  openFirewall = true;

  inherit whitelist;
  serverProperties = {
    inherit server-port;
    gamemode = 1;
    motd = "dark-firepit, 1.21.1 NeoForge";
    white-list = true;
    max-players = 8;
    allow-flight = true;
    enable-command-block = true;
    enforce-secure-profile = false;
    snooper-enabled = false;
    spawn-protection = 0;
  };

  symlinks = { "unsup.ini" = unsupINI; };

  package = pkgs.neoforgeServers."neoforge-1_21_1".override { loaderVersion = "0.14.17"; };

  jvmOpts = "-Xmx6G -javaagent:${unsup}";
}
