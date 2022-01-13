final: prev: {
  wofi = (prev.wofi.override {
    stdenv = prev.clang12Stdenv;
  }).overrideAttrs (old: {
    "NIX_CFLAGS_COMPILE" = "-Os -march=native";
  });
}
