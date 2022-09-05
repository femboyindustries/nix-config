{ lib, stdenv, fetchFromGitLab, rustc, cargo, openssl, rustPlatform, ... }: {}

/*
rustPlatform.buildRustPackage rec {
  pname = "matrix-conduit";
  ver = "v0.4.0";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "conduit";
    rev = "0b926c2a31deff57a3526dd75d8c08775b02241a";
    sha256 = lib.fakeSha256;
  };

  meta = {
    name = "conduit";
    description = "A Matrix homeserver written in Rust";
    license = "Apache-2.0";
    homepage = "https://conduit.rs";
  };

  cargoSha256 = lib.fakeSha256;

  buildInputs = [ openssl ];
}
*/
