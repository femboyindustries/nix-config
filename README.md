# Frosted Flakes

Nix Flake dotfiles shared across a [few hosts](./hosts/). Most development here will go into the [`lucent-firepit`](https://dark-firepit.cloud/) host, however.

## Development

_Commands here will use `lucent-firepit`-based paths and names as an example_

- To build the system (doesn't apply changes):
    ```sh
    nixos-rebuild build --upgrade --impure --flake /etc/dotfiles#lucent-firepit
    ```
- To build & switch to a new system (applies changes):
    ```sh
    doas nixos-rebuild switch --impure --upgrade --flake /etc/dotfiles#lucent-firepit
    ```

### `lucent-firepit`

Things here mostly only apply to the [`lucent-firepit`](https://dark-firepit.cloud/) host.

#### Adding modules

Generally when adding modules (even those pulled from `nixpkgs`) you'd want to:

1. Create a new module under `modules/services/`; `gitea.nix` and `nitter.nix` are pretty okay examples of what to do
2. **`git add .`** or else Nix will act clueless about everything you've just done
3. Set it to enabled, set port, domain, etc. in `hosts/.../default.nix` or wherever else is more appropriate
  - For webapps, follow what's done in `hosts/lucent-firepit/webapps/default.nix`; if you're doing something bigger, it may be worth abstracting into a seperate file
4. Rebuild/switch to the new system (as described [above](#development))

#### `yugoslavia-best.nix`

God fucking help us lmao

You're on your own if you try to edit this file. Please be ready to yell at Jill the moment you open it and to continue doing that for the entire time it is open

#### Editing code

**For now**, you can simply edit `/etc/dotfiles`; in the future it's planned to give every user their own seperate repository sandbox before pulling the changes into the main config at `/etc/dotfiles`.

This can be done directly on the server (as long as you have the `dotfiles` group) through your favorite modal editor (`micro`, `nvim`, `hx`, `nano`, ...) or at [https://dev-firepit.oat.zone/](https://dev-firepit.oat.zone/) (authorization and further details are pinned in the Discord).

If you encounter permission funnies, don't hesitate to `doas` your way into `chmod`dding/`chown`ing files as necessary; directories should be `775` and files should be `664`, however we've yet to figure out how to consistently enforce this across the directory.

Be sure to commit regularly to prevent [tons of](https://git.oat.zone/dark-firepit/dotfiles/commit/021fab40f7f815708d4cf918ec0ac0bd16c0bc8f) [densely packed](https://git.oat.zone/dark-firepit/dotfiles/commit/07f9ac6a9ee53f6689a5f8ee87b94b96a409c375) [undocumented commits](https://git.oat.zone/dark-firepit/dotfiles/commit/9da0a143ae392ec7f8abc731e8c245f29b55e685) building up after noone bothers to commit anything.
