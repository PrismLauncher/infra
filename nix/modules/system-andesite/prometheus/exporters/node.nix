{
  flake.modules.nixos."system-andesite" = {
    services.prometheus.exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
    };

    services.prometheus = {
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              labels.role = "andesite";
              targets = [ "localhost:9100" ];
            }
          ];
        }
      ];
      rules = [
        (builtins.toJSON {
          groups = [
            {
              name = "node";
              rules = [
                {
                  alert = "SystemdUnitFailed";
                  expr = ''node_systemd_unit_state{state="failed"} == 1'';
                  for = "5m";
                  keep_firing_for = "15m";
                  labels.severity = "warning";
                  annotations.summary = "systemd unit {{ $labels.name }} on {{ $labels.instance }} has been down for more than 5 minutes.";
                }
                {
                  alert = "RootfsLowSpace";
                  # /nix is the primary filesystem on impermanent installations
                  expr = ''
                    node_filesystem_avail_bytes{mountpoint=~"(/nix|/boot)"} / node_filesystem_size_bytes * 100 <= 10
                  '';
                  for = "10m";
                  labels.severity = "warning";
                  annotations.summary = ''
                    {{ $labels.device }} mounted at {{ $labels.mountpoint }} ({{ $labels.fstype }}) on {{ $labels.instance }} has {{ $value }}% space left.
                  '';
                }
              ];
            }
          ];
        })
      ];
    };
  };
}
