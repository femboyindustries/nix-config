{ options, config, pkgs, lib, ... }:

with lib;
{
  config = {
    environment.systemPackages = with pkgs; [
      valgrind
#      nix-linter
    ];
  };
}
