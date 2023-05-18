let
  userKeys = builtins.catAttrs "ssh" (import ../authorizedKeys.nix);
  systemKeys = [
    # /etc/ssh/ssh_host_ed25519_key.pub
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHp0gLv1FiavpvnXinySlZsWrNkAzo4c8GWvN2WRhQqn root@lucent-firepit"
  ];
in {
  "huge-furry-cock.age".publicKeys = userKeys ++ systemKeys;
}
