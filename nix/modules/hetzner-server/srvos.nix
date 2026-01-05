{ inputs, ... }:
{
  flake.modules.nixos."hetzner-server".imports = [
    inputs.srvos.nixosModules.hardware-hetzner-cloud-arm
  ];
}
