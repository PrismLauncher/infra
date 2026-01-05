{ inputs, ... }:
{
  flake.modules.nixos."base".imports = [
    inputs.agenix.nixosModules.age
  ];
}
