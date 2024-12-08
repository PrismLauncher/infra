{ config, inputs, ... }:
{
  imports = [ inputs.comin.nixosModules.comin ];

  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/PrismLauncher/infra.git";
        branches.main.name = "main";
      }
    ];
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "comin";
      static_configs = [
        {
          labels.role = "andesite";
          targets = [ "localhost:${toString config.services.comin.exporter.port}" ];
        }
      ];
    }
  ];
}
