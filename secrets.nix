let
  scrumplex = builtins.readFile ./keys/users/scrumplex.pub;

  andesite = builtins.readFile ./keys/andesite.pub;
in
{
  "machines/andesite/refraction.env.age".publicKeys = [
    scrumplex
    andesite
  ];
}
