let
  scrumplex = builtins.readFile ./keys/users/scrumplex.pub;

  andesite = builtins.readFile ./keys/andesite.pub;
in
{
  "machines/andesite/blockgame-meta.key.age".publicKeys = [
    scrumplex
    andesite
  ];
  "machines/andesite/letterbox.env.age".publicKeys = [
    scrumplex
    andesite
  ];
  "machines/andesite/refraction.env.age".publicKeys = [
    scrumplex
    andesite
  ];
}
