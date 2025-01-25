{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
  };

  environment.persistence."/nix/persistence".directories = [
    "/var/lib/postgresql"
  ];
}
