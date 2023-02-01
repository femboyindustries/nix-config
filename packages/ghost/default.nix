{ pkgs }:

let
  pname = "ghost";
  version = "5.33.2";
in pkgs.stdenv.mkDerivation {
  inherit pname version;
  buildInputs = with pkgs; [ nodejs yarn vips ];
  ghostCliVersion = "1.24.0";
  builder = ./builder.sh;
}
