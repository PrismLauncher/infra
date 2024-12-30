{ config, inputs, ... }:
{
  imports = [ inputs.letterbox.nixosModules.letterbox-with-overlay ];

  age.secrets."letterbox.env".file = ./letterbox.env.age;

  services.letterbox = {
    enable = true;
    environmentFile = config.age.secrets."letterbox.env".path;
    settings = {
      server_id = 1031648380885147709;
      staff_roles = [
        1031660519335133225
        1041449261990150255
      ];
      forum_channel = {
        id = 1323366387313279056;
        open_tag_id = 1323375713402884209;
        closed_tag_id = 1323375677151383634;
        mention_role_id = 1061922913839763487;
      };
    };
  };
}
