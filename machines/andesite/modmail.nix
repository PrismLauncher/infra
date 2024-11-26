{config, ...}: {
  assertions = [
    {
      assertion = config.services.postgresql.enable;
      message = "PostgreSQL must be enabled and configured.";
    }
  ];

  services.postgresql = {
    ensureUsers = [
      {
        name = "ferretdb";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "ferretdb" ];
  };

  systemd.services.ferretdb.serviceConfig.RuntimeDirectory = "ferretdb";
  services.ferretdb = {
    enable = true;
    settings = {
      FERRETDB_HANDLER = "pg";
      FERRETDB_POSTGRESQL_URL = "postgres:///ferretdb?user=ferretdb";
      FERRETDB_LISTEN_ADDR = "";
      FERRETDB_LISTEN_UNIX = "/run/ferretdb/ferretdb.sock";
    };
  };
}
