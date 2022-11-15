#!/usr/bin/env nix-shell
#! nix-shell -p jq -p bundix -p nix-prefetch-git -i bash
./update-remote.sh --url https://github.com/glitch-soc/mastodon.git  --rev 5db3a14388cf780364b213c63aaf97b6f444ca17 --ver v3.5.1

