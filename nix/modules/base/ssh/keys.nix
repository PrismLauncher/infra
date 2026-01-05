{ lib, ... }:
let
  keysPath = ../../../../keys/users;
in
{
  flake.modules.nixos."base".users.users.root.openssh.authorizedKeys.keyFiles = lib.mapAttrsToList (
    name: _: builtins.toPath "${keysPath}/${name}"
  ) (builtins.readDir keysPath);
}
