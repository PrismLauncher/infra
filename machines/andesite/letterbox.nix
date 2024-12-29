{ config, inputs, ... }:
{
  imports = [ inputs.letterbox.nixosModules.letterbox-with-overlay ];

  age.secrets."letterbox.env".file = ./letterbox.env.age;

  services.postgresql.enable = true;

  services.letterbox = {
    enable = true;
    environmentFile = config.age.secrets."letterbox.env".path;
  };
}
