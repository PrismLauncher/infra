{ ... }:
{
  projectRootFile = "flake.nix";

  programs.hclfmt.enable = true;
  programs.just.enable = true;
  programs.mdformat.enable = true;
  programs.nixfmt.enable = true;
  programs.shfmt.enable = true;
  programs.terraform.enable = true;

  settings.global.excludes = [
    "keys/**.pub"
    "machines/*/facter.json"
    "machines/*/facts.json"
  ];
}
