{
  flake-utils,
  nixpkgs,
  terranix,
  ...
}:

flake-utils.lib.eachDefaultSystem (
  system:

  let
    pkgs = nixpkgs.legacyPackages.${system};

    opentofu = pkgs.opentofu.withPlugins (plugins: [
      plugins.hcloud
      plugins.netlify
    ]);

    terranixConfiguration = terranix.lib.terranixConfiguration {
      inherit system;
      modules = [
        ./modules
        ./main.nix
        ./provider.nix
      ];
    };
  in

  {
    apps.tf = flake-utils.lib.mkApp {
      drv = pkgs.writeShellApplication {
        name = "tf";

        runtimeInputs = [ opentofu ];

        text = ''
          ln -sf ${terranixConfiguration} config.tf.json
          exec tofu "$@"
        '';
      };
    };
  }
)
