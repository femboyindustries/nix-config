{ pkgs, enable ? false, server-port, whitelist, unsup, unsupINI, ... }:

{
  inherit enable;
  autoStart = true;
  openFirewall = true;

  inherit whitelist;
  serverProperties = {
    inherit server-port;
    gamemode = 1;
    motd = "dark-firepit, 1.19.2 Fabric";
    white-list = true;
    max-players = 8;
    allow-flight = true;
    enable-command-block = true;
    enforce-secure-profile = false;
    snooper-enabled = false;
    spawn-protection = 0;
  };

  symlinks = { "unsup.ini" = unsupINI; };

  package = pkgs.fabricServers."fabric-1_19_2".override { loaderVersion = "0.14.17"; };

  jvmOpts = "-Xmx6G -javaagent:${unsup}";
}
