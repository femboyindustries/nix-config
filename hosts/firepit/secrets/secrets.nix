let
  userAether = "<...>";
  userOatmealine = "<...>";
in {
  "aether" = {
    "userAether.age".publicKeys = [ userAether ];
  };
  "oatmealine" = {
    "userOatmealine.age".publicKeys = [ userOatmealine ];
  };
}
