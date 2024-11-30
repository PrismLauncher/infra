{ config, lib, ... }:

let
  cfg = config.infra.providers;

  providerSettingsSubmodule = {
    freeformType = lib.types.attrsOf lib.types.anything;
  };

  providerSubmodule =
    { config, name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          defaultText = lib.literalExpression "<Name of the attribute>";
          description = "Name of the provider.";
          example = "tailscale";
        };

        registry = lib.mkOption {
          type = lib.types.str;
          default = cfg.defaultRegistry;
          defaultText = lib.literalExpression "config.infra.providers.registry";
          description = "URL of Terraform provider registry.";
          example = "registry.mydomain.org";
        };

        source = lib.mkOption {
          type = lib.types.str;
          default = "${config.name}/${config.name}";
          defaultText = lib.literalExpression "\${name}/\${name}";
          apply = source: cfg.required.${name}.registry + "/${source}";
          description = ''
            Source of the provider in `<owner>/<provider>` format.

            NOTE: The registry URL is prepended to this value.
          '';
          example = "tailscale/tailscale";
        };

        settings = lib.mkOption {
          type = lib.types.submodule providerSettingsSubmodule;
          default = { };
          description = "Settings for this provider.";
        };
      };
    };
in

{
  options.infra.providers = {
    defaultRegistry = lib.mkOption {
      type = lib.types.str;
      default = "registry.terraform.io";
      description = "URL of Terraform provider registry.";
      example = "registry.mydomain.org";
    };

    required = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule providerSubmodule);
      default = { };
      description = ''
        Attribute set declaring required Terraform providers.

        Definitions with no explicit declarations are used to configure the
        provider -- i.e., defining `tailscale.tailnet = "mydomain.org"` would
        evaluate to `provider.tailscale.tailnet = "mydomain.org"`.
      '';
    };
  };

  config = lib.mkIf (cfg.required != { }) {
    terraform.required_providers = lib.mapAttrs (lib.const (cfg': {
      inherit (cfg') source;
    })) cfg.required;

    provider = lib.mapAttrs' (lib.const (
      cfg': lib.nameValuePair cfg'.name (lib.mkIf (cfg'.settings != { }) cfg'.settings)
    )) cfg.required;
  };
}
