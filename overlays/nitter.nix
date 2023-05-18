self: super: {
  nitter = super.nitter.overrideAttrs (old: {
    # https://github.com/zedeus/nitter/pull/830
    version = "unstable-2023-04-16";
    src = super.fetchFromGitHub {
      owner = "PrivacyDevel";
      repo = "nitter";
      rev = "11279e2b4ff612f523380c2ff4678a056eb5c03c";
      hash = "sha256-GSBtyrrQTYRO9+XNXZsXOtnQ5QrLqmKE81RkuX/btUs=";
    };
  });
}
