{
  flake.modules.nixos."system-andesite" = {
    services.caddy = {
      enable = true;
    };

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 443 ];
    };
  };
}
