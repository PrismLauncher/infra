{ inputs, pkgs, ... }:
{
  imports = [
    inputs.self.nixosModules.from-facts
    inputs.self.nixosModules.openssh-pregenerated
    inputs.srvos.nixosModules.server
    inputs.srvos.nixosModules.hardware-hetzner-cloud-arm
    inputs.srvos.nixosModules.mixins-terminfo
    inputs.nixos-facter-modules.nixosModules.facter
    inputs.agenix.nixosModules.age

    ./blockgame-meta.nix
    ./comin.nix
    ./disks.nix
    ./letterbox.nix
    ./postgres.nix
    ./refraction.nix
  ];

  facter.reportPath = ./facter.json;
  from-facts.file = ./facts.json;
  from-facts.interface = "enp1s0";

  # this gets enabled by srvos
  services.cloud-init.enable = false;

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keyFiles = [
    ../../keys/users/scrumplex.pub
  ];

  environment.systemPackages = [
    pkgs.kitty.terminfo
  ];

  system.stateVersion = "24.11";
}
