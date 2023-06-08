self: super: {
  nitter = super.nitter.overrideAttrs (old: {
    # https://github.com/zedeus/nitter/pull/830
    version = "unstable-2023-05-31";
    src = super.fetchFromGitHub {
      owner = "zedeus";
      repo = "nitter";
      rev = "38985af6ed30f050201b15425cdac0dc2e286b6d";
      hash = "sha256-YPwApMCsra/T5EzCup28/4FaOrhEuw3MBiitv+LTbi0=";
    };
  });
}
