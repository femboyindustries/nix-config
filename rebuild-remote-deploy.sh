#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
[ -f build-hook.sh ] && ./build-hook.sh

nixos-rebuild --target-host nanachi --sudo switch --flake .#nanachi --impure
