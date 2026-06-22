#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
doas chmod o+x /srv/minecraft -R # god help me
deriv=$(NIXPKGS_ALLOW_UNFREE=1 nix build -v --no-link --print-out-paths path:.#nixosConfigurations."$(hostname)".config.system.build.toplevel --impure)
doas nix-env -p /nix/var/nix/profiles/system --set $deriv
doas $deriv/bin/switch-to-configuration switch
