"dark-firepit" = {
  enable = false;
  #autoStart = false;
  openFirewall = true;
  serverProperties = {
    server-port = 25565;
    gamemode = 0;
    motd = "dark-firepit, 1.19.2 Fabric";
    white-list = true;
    max-players = 8;
    allow-flight = true;
    enable-command-block = true;
    enforce-secure-profile = false;
    level-type = "terra:overworld/overworld";
    snooper-enabled = false;
    spawn-protection = 0;
  };
  whitelist = darkFirepitWhitelist;
  package = pkgs.minecraftServers.fabric-1_19_2;
  jvmOpts = "-Xmx6G";
};
