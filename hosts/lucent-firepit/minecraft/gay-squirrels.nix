{ pkgs, lib, enable ? false, server-port, unsup, unsupINI, ... }:

{
  inherit enable;
  autoStart = true;
  openFirewall = true;

  serverProperties = {
    inherit server-port;
    gamemode = 0;
    motd = "§b5G radiation big";
    white-list = true;
    max-players = 16;
    allow-flight = true;
    enable-command-block = false;
    enforce-secure-profile = false;
    snooper-enabled = false;
    spawn-protection = 0;
    view-distance = 16;
    simulation-distance = 8;
    entity-broadcast-range-percentage = 50;
    level-seed = "risingliquid";
    initial-enabled-packs = "bundle";
  };
  
  symlinks = { "unsup.ini" = unsupINI; };

  # this is UGLY as FUCK; but unfortunately https://github.com/Infinidoge/nix-minecraft/issues/15
  package = pkgs.jdk17;
  jvmOpts = "-Xmx8G -javaagent:${unsup} "
    + lib.replaceStrings ["\n"] [" "] (lib.readFile "/srv/minecraft/gay-squirrels/libraries/net/minecraftforge/forge/1.20.1-47.4.0/unix_args.txt");
}
