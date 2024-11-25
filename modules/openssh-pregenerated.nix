let
  keyFile = "/etc/ssh/ssh_host_ed25519_key";
in
{
  services.openssh = {
    hostKeys = [ ];
    settings.HostKey = keyFile;
  };

  age.identityPaths = [
    keyFile
  ];
}
