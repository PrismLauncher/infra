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

    terranixConfiguration = terranix.lib.terranixConfiguration {
      inherit system;
      modules = [
        ./modules
        ./main.nix
        ./provider.nix
      ];
    };

    opentofu = pkgs.opentofu.withPlugins (plugins: [
      plugins.hcloud

      # netlify/netlify
      (plugins.mkProvider {
        owner = "netlify";
        repo = "terraform-provider-netlify";
        rev = "v0.2.0";
        hash = "sha256-QfthllLxJvlXKYvsq54+ETY15cwY7QXFpCTdW3PZnsE=";

        vendorHash = "sha256-R+10PeyU6attKT+Y5TbRBXLYS6Xdx8RHJUzEAxatf10=";

        homepage = "https://registry.terraform.io/providers/netlify/netlify";
        spdx = "MIT";
      })
    ]);
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
