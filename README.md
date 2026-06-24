# Amalgamated, Bespoke Frosted Flakes

A deeply rooted evil lies here. Something has gone very wrong. 1 like = 1 cup
size up

documentation here is a mess. sorry

## dev & deploy

depending on your system, one or other option may be more available/preferred.
pick your poison

1. **on a nixos system (remote deploy)**

   if you have a nixos system with a capable /nix/store, you can use a local
source, build locally and then deploy it:

   ```sh
   # on your system; relies on nanachi being a defined SSH host in your ~/.ssh/config
   nixos-rebuild --target-host nanachi --sudo switch --flake .#nanachi --impure
   ```

2. **on a nix-capable system (remote build)**

   if you have a *nix system with the capability and will to use Nix, you can
use a local source, build remotely and deploy from there:

   ```sh
   # on your system; relies on nanachi being a defined SSH host in your ~/.ssh/config
   nixos-rebuild --build-host nanachi --target-host nanachi --sudo switch --flake .#nanachi --impure
   ```

3. **on any system (full remote)**

   if you cannot do either of the other ones, you can clone the repo on the
server, then make your changes and run `rebuild.sh`. this is the least preferred
option because it means you have to either commit every change and push&pull, or
edit the config on the server with a modal editor like nano/micro, but is always
available in a pinch

   ```sh
   # on the server, in your home directory (or wherever you feel is appropriate)
   git clone https://git.oat.zone/oat/fi-nix-config && cd fi-nix-config
   # ..if necessary, do your changes, then..
   ./rebuild.sh
   ```

---

generally due to all of the above methods relying on this repo being up-to-date,
**commit and push** any changes that have been deployed immediately to prevent
accidental rollbacks of your changes. this is a policy that has been very poorly
followed over the history of this config but i am setting my foot down and
forcing it early out of the gate. **commit and push your changes**. thanks

### Adding modules

Generally when adding modules (even those pulled from `nixpkgs`) you'd want to:

1. Create a new module under `modules/services/`; `forgejo.nix` and `pds.nix`
   are pretty okay examples of what to do
2. **`git add .`** or else Nix will act clueless about everything you've just
   done
3. Set it to enabled, set port, domain, etc. in `hosts/.../default.nix` or
   wherever else is more appropriate
   - For webapps, follow what's done in `hosts/nanachi/webapps/default.nix`; if
     you're doing something bigger, it may be worth abstracting into a seperate
     file
4. Rebuild/switch to the new system (as described [above](#dev--deploy))