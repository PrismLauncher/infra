{ lib, ... }:
let
  data = lib.importJSON ./networking.json;
in
{
  flake.modules.nixos."system-andesite" = {
    networking = {
      hostName = data.hostname;
      inherit (data) domain;
      interfaces.enp1s0 = {
        useDHCP = true;
        ipv6.addresses = [
          {
            address = data.ipv6_address;
            prefixLength = 64; # TODO: get this from facts
          }
        ];
      };
      defaultGateway6 = {
        address = "fe80::1";
        interface = "enp1s0";
      };
    };
  };
}
