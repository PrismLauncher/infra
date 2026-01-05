{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { ... }:
    {
      treefmt = {
        programs.actionlint.enable = true;
        programs.hclfmt.enable = true;
        programs.just.enable = true;
        programs.mdformat.enable = true;
        programs.nixfmt.enable = true;
        programs.shfmt.enable = true;
        programs.terraform.enable = true;
        programs.yamlfmt.enable = true;

        settings.global.excludes = [
          "**.age"
          "keys/**.pub"
          "machines/*/facter.json"
          "machines/*/facts.json"
        ];
      };
    };
}
