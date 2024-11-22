{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules.openssh-pregenerated
    inputs.srvos.nixosModules.server
    inputs.srvos.nixosModules.hardware-hetzner-cloud-arm
    inputs.srvos.nixosModules.mixins-terminfo
    inputs.nixos-facter-modules.nixosModules.facter
    inputs.agenix.nixosModules.age

    ./disks.nix
  ];

  facter.reportPath = ./facter.json;

  # this gets enabled by srvos
  services.cloud-init.enable = false;

  networking = {
    interfaces."enp1s0" = {
      useDHCP = true;
      ipv6.addresses = [
        {
          address = "2a01:4f8:c013:8496::";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keyFiles = [
    ../../keys/users/scrumplex.pub
  ];

  system.stateVersion = "24.11";
}
