let
  keys = import ../authorizedKeys.nix;

  "subsurface.aether" = keys."aether@subsurface".ssh;
in
  {}
