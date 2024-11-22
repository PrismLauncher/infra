{ nixpkgs, ... }@inputs:
{
  nixosConfigurations.andesite = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";

    modules = [
      ./configuration.nix
      { networking.hostName = "andesite"; }
    ];

    specialArgs = {
      inherit inputs;
    };
  };
}
