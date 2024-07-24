{ pkgs, lib, enable ? false, server-port, ... }:

{
  inherit enable;
  autoStart = true;
  openFirewall = true;

  serverProperties = {
    inherit server-port;
    gamemode = "survival";
    motd = "The Minehattan Project, Forge 1.19.2";
    max-players = 8;
    allow-flight = true;
    enable-command-block = false;
    enforce-secure-profile = false;
    snooper-enabled = false;
    spawn-protection = 0;
    #white-list = true;
    white-list = false;
    view-distance = 16;
    level-type = "terra:overworld/overworld";
  };

  #whitelist = {
  #  oatmealine =     "241d7103-4c9d-4c45-9464-83b5365ce48e";
  #  numpad_7 =       "44e6e6d7-770d-4afc-96b1-9999b61ced1d";
  #  Jollysivie =     "0303c83f-d260-48de-a19c-feb4cc67d99f";
  #};

  # this is UGLY as FUCK; but unfortunately https://github.com/Infinidoge/nix-minecraft/issues/15
  package = pkgs.jdk17;
  jvmOpts = "-Xmx8G "
    + lib.replaceStrings ["\n"] [" "] (lib.readFile "/srv/minecraft/minehattan/libraries/net/minecraftforge/forge/1.19.2-43.3.0/unix_args.txt");
}
