{
  description = "Infrastructure configuration for Prism Launcher";

  nixConfig = {
    extra-substituters = [
      "https://infra-cache.prismlauncher.org"
    ];
    extra-trusted-public-keys = [
      "infra-cache.prismlauncher.org-1:4U7OYwBrZnq4KfTVXRPArA+YwWbPlT83ZGVbP7HXkKk="
    ];
  };

  inputs = {
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    blockgame-meta.inputs.flake-parts.follows = "flake-parts";
    blockgame-meta.inputs.nixpkgs.follows = "nixpkgs";
    blockgame-meta.url = "github:PrismLauncher/meta";
    comin.inputs.nixpkgs.follows = "nixpkgs";
    comin.url = "github:nlewo/comin";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    flake-parts.url = "github:hercules-ci/flake-parts";
    impermanence.url = "github:nix-community/impermanence";
    import-tree.url = "github:vic/import-tree";
    letterbox.inputs.nixpkgs.follows = "nixpkgs";
    letterbox.url = "github:TheKodeToad/Letterbox";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    refraction.inputs.nixpkgs.follows = "nixpkgs";
    refraction.url = "github:PrismLauncher/refraction";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "github:nix-community/srvos";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./nix);
}
