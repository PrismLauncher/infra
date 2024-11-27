{
  projectRootFile = "flake.nix";

  programs = {
    actionlint.enable = true;
    hclfmt.enable = true;
    just.enable = true;
    mdformat.enable = true;
    nixfmt.enable = true;
    shfmt.enable = true;
    terraform.enable = true;
    yamlfmt.enable = true;
  };

  settings.global.excludes = [
    "**.age"
    "keys/**.pub"
    "machines/*/facter.json"
    "machines/*/facts.json"
  ];
}
