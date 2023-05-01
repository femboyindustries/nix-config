{ pkgs, enable ? false, server-port, ... }:

{
  inherit enable;
  autoStart = true;
  openFirewall = true;
  serverProperties = {
    inherit server-port;
    gamemode = 1;
    motd = "N3KO SMP Testing server";
    white-list = true;
    max-players = 8;
    allow-flight = true;
    enable-command-block = true;
    enforce-secure-profile = false;
    #level-type = "terra:overworld/overworld";
    snooper-enabled = false;
    spawn-protection = 0;
  };
  whitelist = {
    oatmealine  = "241d7103-4c9d-4c45-9464-83b5365ce48e";
    Cardboxneko = "3d406152-008c-4ec9-bf49-44c883baca6d";
  };
  package = pkgs.fabricServers.fabric-1_18_2;
  jvmOpts = "-Xmx4G";
}

