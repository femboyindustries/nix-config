{ stdenv, lib, fetchpijul
, pijul
, rustc
, cargo
, rustfmt
, postgresql
, sqlx-cli
, libiconv
, xxHash
, zstd
, ... }:

stdenv.mkDerivation rec {
  pname = "nidobyte";

  src = fetchpijul {
    url = "https://nest.pijul.com/zj/nidobyte";
    hash = "YZAHAQRQHK24QY2H3AXKCPPDIE2F53H35C5CNYUSXRDSNCWOUJVQC";
  };

  nativeBuildInputs = [
    pijul

    rustc
    cargo
    rustfmt

    postgresql
    sqlx-cli

    libiconv

    xxHash
    zstd
  ];
}
