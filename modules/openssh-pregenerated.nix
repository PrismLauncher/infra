let
  keyFile = "/etc/ssh/ssh_host_ed25519_key";
  persistentKeyFile = "/nix/persistence/${keyFile}";
in
{
  services.openssh = {
    hostKeys = [ ];
    settings.HostKey = keyFile;
  };

  # age will be activated, before impermanence mounts persistent files and directories. A workaround is to specify the persistent path for the key file
  age.identityPaths = [
    persistentKeyFile
  ];
}
