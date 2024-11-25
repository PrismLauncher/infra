{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.refraction.nixosModules.default];
  nixpkgs.overlays = [inputs.refraction.overlays.default];

  age.secrets."prism-refraction.env".file = ./refraction.env.age;

  services.refraction = {
    enable = true;
    package = pkgs.refraction; # overlay
    environmentFile = config.age.secrets."prism-refraction.env".path;
  };
}

