{ config, inputs, ... }:
{
  flake.nixosConfigurations.andesite = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";

    modules = [
      config.flake.modules.nixos.base
      config.flake.modules.nixos.hetzner-server
      config.flake.modules.nixos.system-andesite
    ];
  };
}
