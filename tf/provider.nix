{ lib, ... }:

{
  infra.providers.required = {
    hcloud = {
      source = "hetznercloud/hcloud";

      token = lib.tfRef "var.hcloud_token";
    };

    netlify = {
      token = lib.tfRef "var.netlify_token";
      default_team_slug = "prismlauncher";
    };
  };

  variable = {
    hcloud_token = {
      sensitive = true;
    };

    netlify_token = {
      type = lib.literalExpression "string";
    };
  };
}
