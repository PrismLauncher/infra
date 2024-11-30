{ lib, ... }:

{
  infra.providers.required = {
    hcloud = {
      source = "hetznercloud/hcloud";

      settings = {
        token = lib.tfRef "var.hcloud_token";
      };
    };

    netlify = {
      settings = {
        token = lib.tfRef "var.netlify_token";
        default_team_slug = "prismlauncher";
      };
    };
  };

  terraform.cloud = {
    hostname = "app.terraform.io";
    organization = "prismlauncher";

    workspaces = {
      name = "infrastructure";
    };
  };

  variable = {
    hcloud_token = {
      sensitive = true;
    };

    netlify_token = {
      type = "string";
    };
  };
}
