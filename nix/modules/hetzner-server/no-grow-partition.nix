{ lib, ... }:
{
  flake.modules.nixos."hetzner-server".boot.growPartition = lib.mkForce false;
}
