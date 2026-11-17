let
  scrumplex = builtins.readFile ./keys/users/scrumplex.pub;

  andesite = builtins.readFile ./keys/andesite.pub;
in
{
  "nix/modules/system-andesite/blockgame-meta/prismautomata.key.age".publicKeys = [
    scrumplex
    andesite
  ];
  "nix/modules/system-andesite/letterbox/letterbox.env.age".publicKeys = [
    scrumplex
    andesite
  ];
  "nix/modules/system-andesite/prometheus/alertmanager.env.age".publicKeys = [
    scrumplex
    andesite
  ];
  "nix/modules/system-andesite/refraction/refraction.env.age".publicKeys = [
    scrumplex
    andesite
  ];
}
