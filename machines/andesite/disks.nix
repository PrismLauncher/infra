{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=512M"
          "mode=755"
          "noexec"
        ];
      };
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=128M"
          "mode=755"
          "noexec"
        ];
      };
    };

    disk.andesite = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "umask=0077"
                "dmask=0077"
                "fmask=0077"
              ];
            };
          };

          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
            };
          };
        };
      };
    };
  };

  virtualisation.vmVariantWithDisko.fileSystems."/nix".neededForBoot = true;
  fileSystems."/nix".neededForBoot = true;

  disko.tests.bootCommands = "";

  environment.persistence."/nix/persistence" = {
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}
