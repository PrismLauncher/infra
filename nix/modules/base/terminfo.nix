{ inputs, ... }:
{
  flake.modules.nixos."base" =
    { pkgs, ... }:
    {
      imports = [
        inputs.srvos.nixosModules.mixins-terminfo
      ];
      environment.systemPackages = [
        pkgs.kitty.terminfo
      ];
    };
}
