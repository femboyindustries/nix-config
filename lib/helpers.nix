{ lib, ... }:

with lib;
rec {
  indexFrom = origin: name: item: list: foldr
  (h: t:
    if h.${origin} == name && hasAttr item h
    then h.${item}
    else t)
  (throw ''
    No item at the origin point ${origin} with element ${name} found.
    Please make sure that the item with that origin exists, and,
    failing that, that it also has the requested item defined.
  '')
  list;

  getSSH = name: keys: indexFrom "hostname" name "ssh" keys;
}
