{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption types;

  cfg = config.from-facts;

in
{
  options.from-facts = {
    file = mkOption {
      type = with types; nullOr path;
      default = null;
    };

    interface = mkOption {
      type = types.str;
      default = "enp1s0";
    };

    data = mkOption {
      type = with types; attrsOf str;
      default = lib.importJSON cfg.file;
      internal = true;
    };
  };

  config = mkIf (cfg.file != null) {
    networking = {
      hostName = cfg.data.hostname;
      inherit (cfg.data) domain;
      interfaces.${cfg.interface} = {
        useDHCP = true;
        ipv6.addresses = [
          {
            address = cfg.data.ipv6_address;
            prefixLength = 64; # TODO: get this from facts
          }
        ];
      };
      defaultGateway6 = {
        address = "fe80::1";
        inherit (cfg) interface;
      };
    };
  };
}
