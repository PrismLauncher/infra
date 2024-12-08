{ config, ... }:
{
  imports = [
    ./exporters/node.nix
  ];

  services.prometheus = {
    enable = true;

    extraFlags = [
      "--storage.tsdb.retention.time=${toString (720 * 24)}h"
    ];

    globalConfig.scrape_interval = "15s";

    # TODO: alertmanager
  };

  networking.firewall.allowedTCPPorts = [ config.services.prometheus.port ];

  environment.persistence."/nix/persistence".directories = [
    "/var/lib/prometheus2"
  ];
}
