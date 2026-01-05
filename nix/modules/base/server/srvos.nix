{ inputs, ... }:
{
  flake.modules.nixos."base".imports = [
    inputs.srvos.nixosModules.server
  ];
}
