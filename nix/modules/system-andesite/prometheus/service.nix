let
  fqdn = "prometheus.andesite.prismlauncher.org";
in
{
  flake.modules.nixos."system-andesite" =
    { config, ... }:
    {
      age.secrets."alertmanager.env".file = ./alertmanager.env.age;

      services.prometheus = {
        enable = true;

        extraFlags = [
          "--storage.tsdb.retention.time=${toString (720 * 24)}h"
        ];

        globalConfig.scrape_interval = "15s";
        webExternalUrl = "https://${fqdn}/";

        alertmanagers = [
          {
            scheme = "http";
            static_configs = [
              { targets = [ "localhost:${toString config.services.prometheus.alertmanager.port}" ]; }
            ];
          }
        ];

        alertmanager = {
          enable = true;

          extraFlags = [ "--cluster.listen-address=''" ];

          environmentFile = config.age.secrets."alertmanager.env".path;
          configuration = {
            receivers = [
              {
                name = "discord";
                discord_configs = [
                  { webhook_url = "https://discord.com/api/webhooks/1315429375981781003/$DISCORD_WEBHOOK_SUFFIX"; }
                ];
              }
            ];
            route = {
              receiver = "discord";
              group_wait = "30s";
              group_interval = "5m";
              repeat_interval = "24h";
              group_by = [ "alertname" ];
            };
          };
        };
      };

      # TODO: reverse proxy
      networking.firewall.allowedTCPPorts = [
        config.services.prometheus.port
      ];

      services.caddy.virtualHosts.${fqdn}.extraConfig = ''
        reverse_proxy localhost:${toString config.services.prometheus.port}
      '';

      environment.persistence."/nix/persistence".directories = [
        "/var/lib/prometheus2"
      ];
    };
}
